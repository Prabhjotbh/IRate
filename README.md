# IRate

**Irate** is a lightweight tool that makes LLVM’s optimization pipeline transparent.  
It runs each pass individually, captures the intermediate representation (IR) before and after, and logs metrics like code size and instruction counts.  
This lets developers understand exactly how each compiler pass affects their code.

---

## Features
- Runs LLVM optimization passes one by one.
- Captures **before/after** IR snapshots automatically.
- Logs code size, instruction count, and other metrics per pass.
- Simple timeline view of how your program evolves across passes.

