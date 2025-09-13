cmake_minimum_required(VERSION 3.15)
project(opt_ledger LANGUAGES C CXX)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig: ${LLVM_DIR}")

set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard to use")
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

llvm_map_components_to_libnames(llvm_libs support core irreader passes)

add_executable(opt_ledger
  src/main.cpp
  src/PassRunner.cpp
  src/Utils.cpp
)

target_include_directories(opt_ledger PRIVATE include ${LLVM_INCLUDE_DIRS})
target_link_libraries(opt_ledger PRIVATE ${llvm_libs})
