cmake_minimum_required(VERSION 3.30)

# Note project name here must match the project name in pyproject.toml
set(PROJECT_NAME boostpython_pyodide)

project(${PROJECT_NAME})
cmake_policy(SET CMP0167 NEW)  # To suppress a warning

# Find python and Boost - both are required dependencies
find_package(Python3 COMPONENTS Interpreter Development)
find_package(Boost COMPONENTS python REQUIRED)

# Without this, any build libraries automatically have names "lib{x}.so"
set(CMAKE_SHARED_MODULE_PREFIX "")

# Add a shared module - modules are intended to be imported at runtime.
# - This is where you add the source files
add_library(hello_ext MODULE hello_ext.cpp)

# Set up the libraries and header search paths for this target
target_include_directories(hello_ext PRIVATE ${Python3_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})
target_link_libraries(hello_ext PRIVATE ${Boost_PYTHON_LIBRARY})

# Install it to the project folder
install(TARGETS hello_ext DESTINATION ${PROJECT_NAME})
