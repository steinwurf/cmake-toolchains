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
  
  set(CMAKE_CXX_FLAGS_WURFRELEASE_OSIZE "-Os -g -UNDEBUG")
  set(CMAKE_C_FLAGS_WURFRELEASE_OSIZE "-Os -g -UNDEBUG")
  
  # For WurfReleaseNoAssert we want to have the same optimization level and debug information as WurfRelease, but we want to disable asserts. This is useful for performance testing where we want to measure the performance impact.
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
  

  set(CMAKE_CXX_FLAGS_WURFRELEASE_FULL_LTO "${CMAKE_CXX_FLAGS_WURFRELEASE} -flto")
  set(CMAKE_C_FLAGS_WURFRELEASE_FULL_LTO "${CMAKE_C_FLAGS_WURFRELEASE} -flto")
  set(CMAKE_EXE_LINKER_FLAGS_WURFRELEASE_FULL_LTO "-flto")
  set(CMAKE_SHARED_LINKER_FLAGS_WURFRELEASE_FULL_LTO "-flto")


  # Check that a build type is set and that it is one of the supported ones
  set(allowed_build_types Debug WurfRelease WurfRelease_Osize WurfRelease_No_Assert WurfRelease_Full_LTO WurfFlameGraph WurfRelease_PGO_Prof WurfRelease_PGO_Use)
  if(NOT CMAKE_BUILD_TYPE)
    message(FATAL_ERROR "CMAKE_BUILD_TYPE is not set. Allowed values are: ${allowed_build_types}.")
  else()
    list(FIND allowed_build_types ${CMAKE_BUILD_TYPE} is_allowed)
    if(is_allowed EQUAL -1)
      message(FATAL_ERROR "Invalid build type: ${CMAKE_BUILD_TYPE}. Allowed values are: ${allowed_build_types}.")
    endif()
  endif()

  # LTO mode used when LTO is enabled for the WurfRelease build type.
  #
  # "thin" lets the linker run the LTO backend in parallel, "full" optimizes
  # the whole program as a single module. Only used by the zig toolchains,
  # other compilers are left with the mode cmake picks for IPO. The mode can
  # also be set with the STEINWURF_LTO_MODE environment variable, which is
  # useful when cmake is invoked through a wrapper that does not forward -D
  # options.
  if(DEFINED ENV{STEINWURF_LTO_MODE} AND NOT DEFINED STEINWURF_LTO_MODE)
    set(steinwurf_default_lto_mode "$ENV{STEINWURF_LTO_MODE}")
  else()
    set(steinwurf_default_lto_mode "thin")
  endif()

  set(STEINWURF_LTO_MODE "${steinwurf_default_lto_mode}" CACHE STRING
    "LTO mode used for the WurfRelease build type: thin or full.")
  set_property(CACHE STEINWURF_LTO_MODE PROPERTY STRINGS thin full)

  if(NOT STEINWURF_LTO_MODE MATCHES "^(thin|full)$")
    message(FATAL_ERROR "Invalid STEINWURF_LTO_MODE: ${STEINWURF_LTO_MODE}. Allowed values are: thin, full.")
  endif()

  if(CMAKE_BUILD_TYPE STREQUAL "WurfRelease")
    add_definitions(-DWURFRELEASE)
	# Enable LTO (Link Time Optimization) for WurfRelease build type if supported by the compiler this has shown to give significant performance gains 
	# 1. Include the built-in IPO/LTO checking module
	include(CheckIPOSupported)
	check_ipo_supported(RESULT ipo_supported OUTPUT ipo_error)

	# 2. Enable LTO globally for ALL targets and ALL profiles
	if(ipo_supported)
		set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

		# 3. Pin the LTO mode on the clang -cc1 command line when clang is
		# driven by zig.
		#
		# cmake implements IPO for clang by passing -flto=thin, but the zig
		# c++ driver rewrites that to -flto=full before calling clang -cc1
		# (seen with both zig 0.13 and zig 0.16). The objects then carry a
		# FULL_LTO_GLOBALVAL_SUMMARY_BLOCK instead of a
		# GLOBALVAL_SUMMARY_BLOCK, which means the linker optimizes and
		# code-generates the whole program in a single thread.
		#
		# -Xclang hands the option straight to -cc1, after the rewrite, so it
		# is what decides the mode. With thin LTO the linker backend runs in
		# parallel: on plumr this took the final link from 155s on one core
		# to 48s across ~8 cores, at the cost of a 1.3% larger stripped
		# binary. Measure before changing the mode of an existing project,
		# full LTO can still optimize better.
		if(STEINWURF_ZIG_TOOLCHAIN AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
			add_compile_options(
				"$<$<COMPILE_LANGUAGE:C>:-Xclang;-flto=${STEINWURF_LTO_MODE}>"
				"$<$<COMPILE_LANGUAGE:CXX>:-Xclang;-flto=${STEINWURF_LTO_MODE}>")
			message(STATUS "Global IPO / ${STEINWURF_LTO_MODE} LTO enabled")
		else()
			message(STATUS "Global IPO / LTO enabled")
		endif()
	else()
		message(WARNING "IPO / LTO is not supported: ${ipo_error}")
	endif()
  else()
    add_definitions(-DWURFDEBUG)
  endif()

endif()

