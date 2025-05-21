# clang-tsan-toolchain.cmake

set(CMAKE_C_COMPILER clang CACHE STRING "C compiler" FORCE)
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "C++ compiler" FORCE)

set(TSAN_FLAGS "-fsanitize=thread -fno-omit-frame-pointer")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${TSAN_FLAGS}" CACHE STRING "C flags" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TSAN_FLAGS}" CACHE STRING "C++ flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${TSAN_FLAGS}" CACHE STRING "Executable linker flags" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${TSAN_FLAGS}" CACHE STRING "Shared linker flags" FORCE)
