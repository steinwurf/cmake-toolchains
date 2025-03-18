# clang-asan-toolchain.cmake

# Set the C and C++ compilers to clang
set(CMAKE_C_COMPILER clang CACHE STRING "C compiler" FORCE)
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "C++ compiler" FORCE)

# Enable AddressSanitizer flags
set(ASAN_FLAGS "-fsanitize=address -fno-omit-frame-pointer")

# Apply ASan flags to C/C++ compiler
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${ASAN_FLAGS}" CACHE STRING "C flags" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ASAN_FLAGS}" CACHE STRING "C++ flags" FORCE)

# Set linker flags to include ASan runtime
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ASAN_FLAGS}" CACHE STRING "Executable linker flags" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ASAN_FLAGS}" CACHE STRING "Shared linker flags" FORCE)

# Optional: enable debug info for better ASan reports
set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
