# Boost::Python CMake project for Pyodide

This is an example "Hello World" project showing how to use CMake with Boost::Python to
build a wheel which runs under Pyodide in a web-browser, based on 
[this gist](https://gist.github.com/ndevenish/ff771feb6817f7debfa728386110f567).

Since Pyodide doesn't ship with Boost::Python, we have to compile it ourselves -
this together with installing the emscripten SDK is done in the
[setup_emsdk_env.sh](setup_emsdk_env.sh) file.
(Note that this script assumes you have `mamba` installed and the `MAMBA_EXE`
environment variable defined pointing to the `mamba` executable).

To run this example, clone the project and then run:

```sh
source ./setup_emsdk_env.sh
pyodide build
npm install
npm test
```

After the first time, you don't have to run `setup_emsdk_env.sh`, and can do:

```sh
mamba activate ems
source build_env/emsdk/emsdk_env.sh
pyodide build
npm test
```
