include("${CMAKE_CURRENT_LIST_DIR}/zig-toolchain-common.cmake")

set(ZIG_LIBC "none")
set(ZIG_OS "macos")
set(ZIG_ARCH "x86_64")
set(ZIG_TARGET "${ZIG_ARCH}-${ZIG_OS}-${ZIG_LIBC}")

set(CMAKE_SYSTEM_NAME "Darwin")
set(CMAKE_SYSTEM_PROCESSOR "AMD64")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -UNDEBUG")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -UNDEBUG")