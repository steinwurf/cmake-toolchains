# clang-toolchain.cmake

# Set the C and C++ compilers to clang
set(CMAKE_C_COMPILER clang CACHE STRING "C compiler" FORCE)
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "C++ compiler" FORCE)

# set standard lib to libc++
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++" CACHE STRING "C++ flags" FORCE)
