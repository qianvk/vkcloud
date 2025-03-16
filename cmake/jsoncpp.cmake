include(ExternalProject)

# Define submodule build/install directories
set(JSONCPP_INSTALL_DIR ${CMAKE_BINARY_DIR}/third_party/jsoncpp)
# set(JSONCPP_BUILD_DIR ${CMAKE_BINARY_DIR}/third_party_build)

# ✅ Build the submodule first
ExternalProject_Add(jsoncpp_project
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/third_party/jsoncpp
    # BINARY_DIR ${JSONCPP_BUILD_DIR}
    INSTALL_DIR ${JSONCPP_INSTALL_DIR}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${JSONCPP_INSTALL_DIR}
        -DCMAKE_BUILD_TYPE=Release
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DBUILD_OBJECT_LIBS=OFF
        -DJSONCPP_WITH_TESTS=OFF
    UPDATE_COMMAND ""
    BUILD_COMMAND make -j$(nproc)
    INSTALL_COMMAND make install
    BUILD_BYPRODUCTS ${JSONCPP_INSTALL_DIR}/lib/libjsoncpp.a
)

# ✅ Create an imported target for the submodule static library
add_library(jsoncpp STATIC IMPORTED)
set_target_properties(jsoncpp PROPERTIES
    IMPORTED_LOCATION ${JSONCPP_INSTALL_DIR}/lib/libjsoncpp.a
)

# ✅ Find the submodule's include directory dynamically
find_path(JSONCPP_INCLUDE_DIR
    # NAMES submodule.h  # Change this to an actual header in the submodule
    PATHS ${JSONCPP_INSTALL_DIR}/include
    NO_DEFAULT_PATH
)

# ✅ Make these variables available in the parent CMakeLists.txt
set(JSONCPP_INCLUDE_DIR ${JSONCPP_INCLUDE_DIR} CACHE PATH "jsoncpp include dir")
set(JSONCPP_INSTALL_DIR ${JSONCPP_INSTALL_DIR} CACHE PATH "jsoncpp install dir")

