// src/Utils.cpp
#include "Utils.h"
#include <llvm/IR/Function.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/raw_ostream.h>
#include <fstream>

using namespace llvm;

size_t countInstructions(Module &M) {
  size_t cnt = 0;
  for (Function &F : M) {
    if (F.isDeclaration()) continue;
    for (auto &BB : F) cnt += BB.size();
  }
  return cnt;
}

size_t countFunctions(Module &M) {
  size_t cnt = 0;
  for (Function &F : M) if (!F.isDeclaration()) ++cnt;
  return cnt;
}

size_t countBasicBlocks(Module &M) {
  size_t cnt = 0;
  for (Function &F : M) if (!F.isDeclaration()) cnt += F.size();
  return cnt;
}

size_t estimateIRSize(Module &M) {
  std::string s;
  llvm::raw_string_ostream rso(s);
  M.print(rso, nullptr);
  rso.flush();
  return s.size();
}

void writeModuleToFile(Module &M, const std::string &path) {
  std::error_code EC;
  // Use the two-arg constructor for portability across LLVM versions
  llvm::raw_fd_ostream OS(path, EC);
  if (EC) {
    errs() << "Error opening " << path << " : " << EC.message() << "\n";
    return;
  }
  M.print(OS, nullptr);
}
