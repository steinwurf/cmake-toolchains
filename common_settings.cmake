# Common settings for CMake projects

if(${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME})
    # We just do this once for the top-level project
    set(CMAKE_CXX_EXTENSIONS OFF)
endif()

if(MSVC)
  # Enforce static runtime on Windows/MSVC
  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
endif()