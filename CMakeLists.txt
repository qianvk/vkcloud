cmake_minimum_required(VERSION 3.10)  # Minimum required CMake version
project(vkcloud)  # Project name

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Make sure we link everything statically
# set(CMAKE_EXE_LINKER_FLAGS "-static -static-libgcc -static-libstdc++")
# set(CMAKE_FIND_LIBRARY_SUFFIXES .a)  # Prioritize static libraries
# set(BUILD_SHARED_LIBS OFF)  # Disable shared libraries

include(cmake/jsoncpp.cmake)
include(cmake/boost.cmake)
include(cmake/grpc.cmake)

# Add executable
add_executable(vkcloud
  src/vkcloud.cc
  src/http_connection.cc
  src/logic_system.cc
  src/server.cc
  src/message.pb.cc
  src/message.grpc.pb.cc
  src/asio_io_service_pool.cc
  src/configuration_manager.cc
  src/verify_grpc_client.cc
)

# ✅ Step 4: Ensure MyApp waits for submodule to finish building
add_dependencies(vkcloud jsoncpp_project)
add_dependencies(vkcloud boost_project)
add_dependencies(vkcloud grpc_project)
# ✅ Step 5: Link submodule library to MyApp
target_link_libraries(vkcloud PRIVATE jsoncpp)
target_link_libraries(vkcloud PRIVATE grpc)

target_include_directories(vkcloud PRIVATE ${JSONCPP_INSTALL_DIR}/include)
target_include_directories(vkcloud PRIVATE ${BOOST_INSTALL_DIR}/include)
target_include_directories(vkcloud PRIVATE ${GRPC_INSTALL_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/include)

file(COPY_FILE ${CMAKE_SOURCE_DIR}/config.json ${CMAKE_BINARY_DIR}/config.json)

# Get include directories and generate a .clangd file
set(CLANGD_FILE ${CMAKE_SOURCE_DIR}/.clangd)

file(WRITE ${CLANGD_FILE} "CompileFlags:\n  Add:\n")

# Collect include directories
get_target_property(INCLUDE_DIRS vkcloud INCLUDE_DIRECTORIES)
foreach(dir ${INCLUDE_DIRS})
  file(APPEND ${CLANGD_FILE} "    - '--include-directory=${dir}'\n")
endforeach()

file(APPEND ${CLANGD_FILE} "    - '-std=c++${CMAKE_CXX_STANDARD}'\n")
