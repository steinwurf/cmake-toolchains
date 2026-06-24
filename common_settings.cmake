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
  
  # For WurfReleaseNoAssert we want to have the same optimization level and debug information as WurfRelease, but we want to disable asserts. This is useful for performance testing where we want to ensure that asserts are not affecting performance.
  set(CMAKE_CXX_FLAGS_WURFRELEASE_NO_ASSERT "-O2 -g -DNDEBUG")
  set(CMAKE_C_FLAGS_WURFRELEASE_NO_ASSERT "-O2 -g -DNDEBUG")

  # Define the WurfFlameGraph build type / configuration its an extention of WurfRelease.
  # -O2 optimization level as flame graphs are typically used for performance analysis and we want to optimize the code
  # -g include debug information
  # -UNDEBUG disable NDEBUG which is set in Release mode (ensure that asserts are active)
  # -fno-omit-frame-pointer ensure that the frame pointer is not omitted, which is crucial for accurate stack traces in flame graphs
  set(CMAKE_CXX_FLAGS_WURFFLAMEGRAPH "${CMAKE_CXX_FLAGS_WURFRELEASE} -fno-omit-frame-pointer")
  set(CMAKE_C_FLAGS_WURFFLAMEGRAPH "${CMAKE_C_FLAGS_WURFRELEASE} -fno-omit-frame-pointer")

  # Define the WurfRelease_PGO_Prof build type / configuration its an extention of WurfRelease.
  # -O2 optimization level as PGO is typically used for performance analysis and we want to optimize the code
  # -g include debug information
  # -UNDEBUG disable NDEBUG which is set in Release mode (ensure that asserts are
  #  active)
  # -fprofile-generate enable profile generation for PGO, which instruments the code to
  #  collect runtime profile data that can be used for optimizing the code in a subsequent PGO build
  set(CMAKE_CXX_FLAGS_WURFRELEASE_PGO_PROF "${CMAKE_CXX_FLAGS_WURFRELEASE} -fprofile-generate")
  set(CMAKE_C_FLAGS_WURFRELEASE_PGO_PROF "${CMAKE_C_FLAGS_WURFRELEASE} -fprofile-generate") 
  
  # MANDATORY: The linker must also have the generate flag to link the LLVM profiling runtime
  set(CMAKE_EXE_LINKER_FLAGS_WURFRELEASE_PGO_PROF "-fprofile-generate")
  set(CMAKE_SHARED_LINKER_FLAGS_WURFRELEASE_PGO_PROF "-fprofile-generate")
  
  # Fail the configuration immediately if the target profile file does not exist
  if(CMAKE_BUILD_TYPE STREQUAL "WurfRelease_PGO_Use")
      if(NOT EXISTS "${PGO_PROFILE_FILE}")
          message(FATAL_ERROR "PGO profile data not found at: ${PGO_PROFILE_FILE}\nPlease generate it using the WurfRelease_PGO_Prof build type first, or provide a valid path using -DPGO_PROFILE_FILE.")
      endif()
  endif()

  set(CMAKE_CXX_FLAGS_WURFRELEASE_PGO_USE "${CMAKE_CXX_FLAGS_WURFRELEASE} -fprofile-use=${PGO_PROFILE_FILE} -Wno-profile-instr-unprofiled -Wno-profile-instr-out-of-date")
  set(CMAKE_C_FLAGS_WURFRELEASE_PGO_USE "${CMAKE_C_FLAGS_WURFRELEASE} -fprofile-use=${PGO_PROFILE_FILE} -Wno-profile-instr-unprofiled -Wno-profile-instr-out-of-date")

  # MANDATORY: The linker must also use the profile data
  set(CMAKE_EXE_LINKER_FLAGS_WURFRELEASE_PGO_USE "-fprofile-use=${PGO_PROFILE_FILE}")
  set(CMAKE_SHARED_LINKER_FLAGS_WURFRELEASE_PGO_USE "-fprofile-use=${PGO_PROFILE_FILE}")



  # Check that a build type is set and that it is one of the supported ones
  set(allowed_build_types Debug WurfRelease WurfRelease_No_Assert WurfFlameGraph WurfRelease_PGO_Prof WurfRelease_PGO_Use)
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

