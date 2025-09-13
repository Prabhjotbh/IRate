// src/PassRunner.cpp
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

bool PassRunner::runPass(const std::string &passName, PassEntry &entry) {
  // Record before metrics
  entry.before_instr = countInstructions(Mod);
  entry.before_funcs = countFunctions(Mod);
  entry.before_bbs   = countBasicBlocks(Mod);
  entry.before_size  = estimateIRSize(Mod);
  std::string beforePath = OutDir + "/before_" + passName + ".ll";
  writeModuleToFile(Mod, beforePath);
  entry.before_path = beforePath;

  // Setup analysis managers and PassBuilder (order matters)
  LoopAnalysisManager LAM;
  FunctionAnalysisManager FAM;
  CGSCCAnalysisManager CGAM;
  ModuleAnalysisManager MAM;
  PassBuilder PB;

  // Register analyses with PB (registerModuleAnalyses etc)
  PB.registerModuleAnalyses(MAM);
  PB.registerFunctionAnalyses(FAM);
  PB.registerCGSCCAnalyses(CGAM);
  PB.registerLoopAnalyses(LAM);
  // cross-register proxies in the correct order (LAM, FAM, CGAM, MAM)
  PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

  ModulePassManager MPM;
  // parsePassPipeline is a PassBuilder method that fills MPM
  if (auto Err = PB.parsePassPipeline(MPM, passName)) {
    errs() << "Failed to parse pass pipeline for: " << passName << "\n";
    // consume the error to avoid leak (safe usage)
    consumeError(std::move(Err));
    return false;
  }

  // Run the module pass manager (this mutates Mod)
  MPM.run(Mod, MAM);

  // Record after metrics
  entry.after_instr = countInstructions(Mod);
  entry.after_funcs = countFunctions(Mod);
  entry.after_bbs   = countBasicBlocks(Mod);
  entry.after_size  = estimateIRSize(Mod);
  std::string afterPath = OutDir + "/after_" + passName + ".ll";
  writeModuleToFile(Mod, afterPath);
  entry.after_path = afterPath;

  return true;
}
