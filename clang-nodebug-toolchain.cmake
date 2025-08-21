# clang-nodebug-toolchain.cmake

# Set the C and C++ compilers to clang
set(CMAKE_C_COMPILER clang CACHE STRING "C compiler" FORCE)
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "C++ compiler" FORCE)

# Turn "unused variable" into an error (GCC/Clang flags)
# Use *_INIT so CMake seeds the normal flags when the project configures.
set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} -Wunused-variable -Werror=unused-variable")

# Ensure assert() is compiled out in Release builds (adds to whatever CMake sets)
set(CMAKE_CXX_FLAGS_RELEASE_INIT "${CMAKE_CXX_FLAGS_RELEASE_INIT} -DNDEBUG")