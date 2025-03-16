include(ExternalProject)

# Define Boost install directory
set(BOOST_INSTALL_DIR ${CMAKE_BINARY_DIR}/third_party/boost CACHE PATH "Boost install dir")

# ✅ Install Boost.Asio & Boost.Beast headers (no compilation needed)
ExternalProject_Add(boost_project
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/third_party/boost
    BINARY_DIR ${BOOST_INSTALL_DIR}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND
        # asio dependencies
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/asio/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/system/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/throw_exception/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/core/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/assert/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/config/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/date_time/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/smart_ptr/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/utility/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/static_assert/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/type_traits/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/numeric/conversion/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/mpl/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/preprocessor/include ${BOOST_INSTALL_DIR}/include &&
        # beast dependencies
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/beast/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/optional/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/mp11/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/bind/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/intrusive/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/move/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/logic/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/static_string/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/container_hash/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/describe/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/io/include ${BOOST_INSTALL_DIR}/include &&
        ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/third_party/boost/libs/endian/include ${BOOST_INSTALL_DIR}/include
)

# ✅ Find Boost headers after installation
find_path(BOOST_INCLUDE_DIR
    # NAMES boost/asio.hpp
    PATHS ${BOOST_INSTALL_DIR}/include
    NO_DEFAULT_PATH
)

# ✅ Make Boost include path available globally
set(BOOST_INCLUDE_DIR ${BOOST_INCLUDE_DIR} CACHE PATH "Boost include dir")

