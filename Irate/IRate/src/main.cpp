#include <iostream>
#include <vector>
#include <fstream>
#include <filesystem>
#include <sstream>
#include <iomanip> // for setw and alignment

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/CommandLine.h>
#include "PassRunner.h"

using namespace llvm;
namespace fs = std::filesystem;

static cl::opt<std::string> InputIR("input", cl::desc("input LLVM IR (.ll/.bc)"), cl::Required);
static cl::opt<std::string> OutDir("outdir", cl::desc("output directory"), cl::init("opt_out"));
static cl::opt<std::string> PassList("passes", cl::desc("comma-separated pass names"), cl::init("mem2reg,instcombine,gvn"));

int main(int argc, char **argv) {
  cl::ParseCommandLineOptions(argc, argv, "opt_ledger - per-pass recorder\n");

  LLVMContext Ctx;
  SMDiagnostic Err;
  std::unique_ptr<Module> M = parseIRFile(InputIR, Err, Ctx);
  if (!M) {
    Err.print(argv[0], errs());
    return 1;
  }

  // ensure output directory exists
  fs::create_directories(fs::path(OutDir.getValue()));

  PassRunner runner(*M, OutDir.getValue());

  std::vector<std::string> passes;
  std::istringstream ss(PassList.getValue());
  std::string tok;
  while (std::getline(ss, tok, ',')) {
    if (!tok.empty()) passes.push_back(tok);
  }

  std::vector<PassEntry> entries;
  for (auto &p : passes) {
    PassEntry e;
    e.name = p;
    e.before_path = e.after_path = "";
    e.before_instr = e.after_instr = e.before_funcs = e.after_funcs = 0;
    e.before_bbs = e.after_bbs = e.before_size = e.after_size = 0;

    if (!runner.runPass(p, e)) {
      errs() << "Skipping pass: " << p << "\n";
      continue;
    }
    entries.push_back(e);
  }

  // JSON ledger
  std::string ledgerPath = OutDir.getValue() + "/ledger.json";
  std::ofstream out(ledgerPath);
  out << "[\n";
  for (size_t i = 0; i < entries.size(); ++i) {
    auto &E = entries[i];
    out << "  {\n";
    out << "    \"pass\": \"" << E.name << "\",\n";
    out << "    \"before_path\": \"" << E.before_path << "\",\n";
    out << "    \"after_path\": \"" << E.after_path << "\",\n";
    out << "    \"before_instr\": " << E.before_instr << ",\n";
    out << "    \"after_instr\": " << E.after_instr << ",\n";
    out << "    \"before_funcs\": " << E.before_funcs << ",\n";
    out << "    \"after_funcs\": " << E.after_funcs << ",\n";
    out << "    \"before_bbs\": " << E.before_bbs << ",\n";
    out << "    \"after_bbs\": " << E.after_bbs << ",\n";
    out << "    \"before_size\": " << E.before_size << ",\n";
    out << "    \"after_size\": " << E.after_size << "\n";
    out << "  }" << (i + 1 < entries.size() ? "," : "") << "\n";
  }
  out << "]\n";
  out.close();

  // Table ledger with clean formatting
  std::string tablePath = OutDir.getValue() + "/ledger_table.txt";
  std::ofstream tout(tablePath);

  const int wName = 18;
  const int wCol  = 12;

  // header
  tout << std::left
       << std::setw(wName) << "Pass"
       << std::setw(wCol)  << "InstrBefore"
       << std::setw(wCol)  << "InstrAfter"
       << std::setw(wCol)  << "ΔInstr"
       << std::setw(wCol)  << "FuncsBefore"
       << std::setw(wCol)  << "FuncsAfter"
       << std::setw(wCol)  << "ΔFuncs"
       << std::setw(wCol)  << "BBBefore"
       << std::setw(wCol)  << "BBAfter"
       << std::setw(wCol)  << "ΔBB"
       << std::setw(wCol)  << "SizeBefore"
       << std::setw(wCol)  << "SizeAfter"
       << std::setw(wCol)  << "ΔSize"
       << "\n";
  tout << std::string(wName + wCol * 12, '-') << "\n";

  // rows
  for (auto &E : entries) {
    long dInstr = static_cast<long>(E.after_instr) - static_cast<long>(E.before_instr);
    long dFuncs = static_cast<long>(E.after_funcs) - static_cast<long>(E.before_funcs);
    long dBB    = static_cast<long>(E.after_bbs) - static_cast<long>(E.before_bbs);
    long dSize  = static_cast<long>(E.after_size) - static_cast<long>(E.before_size);

    tout << std::left
         << std::setw(wName) << E.name
         << std::setw(wCol)  << E.before_instr
         << std::setw(wCol)  << E.after_instr
         << std::setw(wCol)  << dInstr
         << std::setw(wCol)  << E.before_funcs
         << std::setw(wCol)  << E.after_funcs
         << std::setw(wCol)  << dFuncs
         << std::setw(wCol)  << E.before_bbs
         << std::setw(wCol)  << E.after_bbs
         << std::setw(wCol)  << dBB
         << std::setw(wCol)  << E.before_size
         << std::setw(wCol)  << E.after_size
         << std::setw(wCol)  << dSize
         << "\n";
  }
  tout.close();

  outs() << "Ledger written to: " << ledgerPath << "\n";
  outs() << "Table written to: " << tablePath << "\n";
  return 0;
}
