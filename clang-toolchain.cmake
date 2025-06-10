# clang-toolchain.cmake

# Set the C and C++ compilers to clang
set(CMAKE_C_COMPILER clang CACHE STRING "C compiler" FORCE)
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "C++ compiler" FORCE)

# Use LLVM's lld linker
set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "Use lld as the linker" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "Use lld as the shared linker" FORCE)
set(CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "Use lld as the module linker" FORCE)