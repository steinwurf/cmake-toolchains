# zig-cmake-toolchains

Provided a series toolchain files for use zig as c/c++ cross-compiler

## Usage

Just build your cmake project by CMAKE_TOOLCHAIN_FILE like this:

    mkdir build
    cd build
    cmake -DCMAKE_TOOLCHAIN_FILE=<PathToZigCmakeToolchainsDir>/zig-toolchain-powerpc64le-linux-musl.cmake ..
    cmake --build .

## Updating the toolchains

The toolchain files are generated using the jinja2 template
`zig-toolchain-template.cmake.jinja`.
If you make changes to the file, please make sure to update the toolchains.

To update the toolchains, you need create a virtual environment and install the required dependencies:

    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt

Then you can run the `update.py` script:

    python update.py
