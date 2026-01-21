News for cmake-toolchains
==========================

This file lists the major changes between versions. For a more detailed list of
every change, see the Git log.

Latest
------
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

