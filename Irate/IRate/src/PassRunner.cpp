#include "PassRunner.h"
#include "Utils.h"

#include <llvm/Passes/PassBuilder.h>
#include <llvm/Support/raw_ostream.h>
#include <filesystem>

using namespace llvm;
namespace fs = std::filesystem;

PassRunner::PassRunner(Module &M, const std::string &outdir)
  : Mod(M), OutDir(outdir) {
  fs::create_directories(fs::path(OutDir));
}

bool PassRunner::runPass(const std::string &passName,PassEntry &entry) {

  int index = 0;
  std::string idx = std::to_string(index);

  entry.before_instr = countInstructions(Mod);
  entry.before_funcs = countFunctions(Mod);
  entry.before_bbs   = countBasicBlocks(Mod);
  entry.before_size  = estimateIRSize(Mod);

  std::string beforePath = OutDir + "/" + idx + "_before_" + passName + ".ll";
  writeModuleToFile(Mod, beforePath);
  entry.before_path = beforePath;

  LoopAnalysisManager LAM;
  FunctionAnalysisManager FAM;
  CGSCCAnalysisManager CGAM;
  ModuleAnalysisManager MAM;
  PassBuilder PB;

  PB.registerModuleAnalyses(MAM);
  PB.registerFunctionAnalyses(FAM);
  PB.registerCGSCCAnalyses(CGAM);
  PB.registerLoopAnalyses(LAM);
  PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

  ModulePassManager MPM;
  if (auto Err = PB.parsePassPipeline(MPM, passName)) {
    errs() << "Failed to parse pass pipeline for: " << passName << "\n";
    consumeError(std::move(Err));
    return false;
  }

  MPM.run(Mod, MAM);
  entry.after_instr = countInstructions(Mod);
  entry.after_funcs = countFunctions(Mod);
  entry.after_bbs   = countBasicBlocks(Mod);
  entry.after_size  = estimateIRSize(Mod);

  std::string afterPath = OutDir + "/" + idx + "_after_" + passName + ".ll";
  writeModuleToFile(Mod, afterPath);
  entry.after_path = afterPath;

  return true;
}

