#pragma once
#include <string>
#include <llvm/IR/Module.h>

size_t countInstructions(llvm::Module &M);
size_t countFunctions(llvm::Module &M);
size_t countBasicBlocks(llvm::Module &M);
size_t estimateIRSize(llvm::Module &M);
void writeModuleToFile(llvm::Module &M, const std::string &path);
