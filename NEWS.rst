News for cmake-toolchains
==========================

This file lists the major changes between versions. For a more detailed list of
every change, see the Git log.

Latest
------
* tbd

1.4.0
-----
* Minor: Add ``zig-toolchain-arm-linux-musleabihf-cortex_a7.cmake`` for ARMv7
  Cortex-A7 with NEON. Zig's default for ``arm-linux-musleabihf`` is ARMv6
  without NEON. A toolchain file can set ``ZIG_CPU``, which is passed to zig as
  ``-mcpu``.

1.3.0
-----
* Minor: The clang UBSan toolchain adds ``-fno-sanitize-recover=undefined``,
  so UBSan aborts on the first error. Before, it printed a runtime error and
  carried on, so tests with undefined behaviour still passed.

1.2.0
-----
* Minor: Add `WurfRelease_Osize WurfRelease_No_Assert WurfRelease_Full_LTO WurfRelease_PGO_Prof WurfRelease_PGO_Use` helper profiles for performance optimization and profiling. Additionaly enable LTO by default for `WurfRelease` if the compiler/toolchain support it.

1.1.0
-----
* Minor: Add `WurfFlameGraph` build type that produces an optimized build with extra flags to get usefull flamegraphs 

1.0.8
-----
* Patch: Update common_settings.cmake to define WURFRELEASE and WURFDEBUG
  depending on the build type. This allows users to check for these definitions
  and print appropriate messages.

1.0.7
-----
* Patch: Fix common_settings.cmake to always set WurfRelase flags.

1.0.6
-----
* Patch: Update common_settings.cmake to have the WurfRelase build type defined
  there.

1.0.5
-----
* Patch: Fix clang-toolchain.cmake to not force lld as the linker.

1.0.4
-----
* Patch: Add no-debug toolchain to trigger errors when variables are only used in asserts.

1.0.3
-----
* Patch: Fix clang sanitizers.

1.0.2
-----
* Patch: Adding more sanitizers from Clang.

1.0.1
-----
* Patch: Force static runtime linking on Windows for MSVC.

1.0.0
-----
* Major: Initial version of cmake-toolchains.

