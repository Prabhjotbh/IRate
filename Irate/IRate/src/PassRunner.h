#pragma once
#include <string>
#include <llvm/IR/Module.h>

struct PassEntry {
  std::string name;
  std::string before_path;
  std::string after_path;

  size_t before_instr;
  size_t after_instr;
  size_t before_funcs;
  size_t after_funcs;
  size_t before_bbs;
  size_t after_bbs;
  size_t before_size;
  size_t after_size;
};

class PassRunner {
public:
  PassRunner(llvm::Module &M, const std::string &outdir);
  bool runPass(const std::string &passName, PassEntry &entry);
private:
  llvm::Module &Mod;
  std::string OutDir;
};
