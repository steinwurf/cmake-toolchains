# Common settings for CMake projects

if(${CMAKE_CURRENT_SOURCE_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    # We just do this once for the top-level project
    set(CMAKE_CXX_EXTENSIONS OFF)

  if(MSVC)
    # Enforce static runtime on Windows/MSVC
    #
    # @todo MVP: Not clear why we do this
    # - probably try to remove at some point to see if it does anything
     set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
  endif()


  # Define the WurfRelease build type / configuration.
  #
  # -O2 optimization level
  # -g include debug information
  # -UNDEBUG disable NDEBUG which is set in Release mode (ensure that asserts are
  #  active)
  #
  # Use it by passing -DCMAKE_BUILD_TYPE=WurfRelease to cmake or via
  # ./waf configure --cmake_build_type=WurfRelease

  set(CMAKE_CXX_FLAGS_WURFRELEASE "-O2 -g -UNDEBUG")
  set(CMAKE_C_FLAGS_WURFRELEASE "-O2 -g -UNDEBUG")
  

  # Define the WurfFlameGraph build type / configuration.
  # -O2 optimization level as flame graphs are typically used for performance analysis and we want to optimize the code
  # -g include debug information
  # -UNDEBUG disable NDEBUG which is set in Release mode (ensure that asserts are active)
  # -fno-omit-frame-pointer ensure that the frame pointer is not omitted, which is crucial for accurate stack traces in flame graphs
  set(CMAKE_CXX_FLAGS_WURFFLAMEGRAPH "-O2 -g -UNDEBUG -fno-omit-frame-pointer")
  set(CMAKE_C_FLAGS_WURFFLAMEGRAPH "-O2 -g -UNDEBUG -fno-omit-frame-pointer")



  # Check that a build type is set and that it is one of the supported ones
  set(allowed_build_types Debug WurfRelease WurfFlameGraph)
  if(NOT CMAKE_BUILD_TYPE)
    message(FATAL_ERROR "CMAKE_BUILD_TYPE is not set. Allowed values are: ${allowed_build_types}.")
  else()
    list(FIND allowed_build_types ${CMAKE_BUILD_TYPE} is_allowed)
    if(is_allowed EQUAL -1)
      message(FATAL_ERROR "Invalid build type: ${CMAKE_BUILD_TYPE}. Allowed values are: ${allowed_build_types}.")
    endif()
  endif()

  if(CMAKE_BUILD_TYPE STREQUAL "WurfRelease")
    add_definitions(-DWURFRELEASE)
  else()
    add_definitions(-DWURFDEBUG)
  endif()

endif()

