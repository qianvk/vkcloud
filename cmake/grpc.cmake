include(ExternalProject)

# Define submodule build/install directories
set(GRPC_INSTALL_DIR ${CMAKE_BINARY_DIR}/third_party/grpc)
# set(GRPC_BUILD_DIR ${CMAKE_BINARY_DIR}/third_party_build)

# ✅ Build the submodule first
ExternalProject_Add(grpc_project
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/third_party/grpc
    # BINARY_DIR ${GRPC_BUILD_DIR}
    INSTALL_DIR ${GRPC_INSTALL_DIR}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${GRPC_INSTALL_DIR}
        -DCMAKE_BUILD_TYPE=Release
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DgRPC_BUILD_TESTS=OFF
        -DgRPC_INSTALL=ON
        -DgRPC_BUILD_CXX_PLUGIN=ON
        -DgRPC_ABSL_PROVIDER=module
        -DgRPC_RE2_PROVIDER=module
        -DgRPC_SSL_PROVIDER=module
        -DgRPC_ZLIB_PROVIDER=module
        -DgRPC_PROTOBUF_PROVIDER=module
    UPDATE_COMMAND ""
    BUILD_COMMAND make -j7
    INSTALL_COMMAND make install
    # BUILD_BYPRODUCTS ${GRPC_INSTALL_DIR}/lib/libgrpc.a
)

# Manually add required system libraries for OpenSSL static linking
# file(GLOB GRPC_STATIC_LIBS "${GRPC_INSTALL_DIR}/lib/*.a"
# "${GRPC_INSTALL_DIR}/lib/libcrypto.a"
# "${GRPC_INSTALL_DIR}/lib/libssl.a"
# )

# ✅ Create an imported target for the submodule static library
# add_library(grpc STATIC IMPORTED)
# set_target_properties(grpc PROPERTIES
#     IMPORTED_LOCATION "${GRPC_INSTALL_DIR}/lib/libgrpc++.a"
# )
# set_target_properties(
#     grpc PROPERTIES
#     IMPORTED_LINK_INTERFACE_LIBRARIES
#     "dl"
#     "pthread"
# )

add_library(grpc INTERFACE)
target_link_libraries(
    grpc INTERFACE
    -Wl,-Bstatic
    ${GRPC_INSTALL_DIR}/lib/libgrpc.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc++.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc++_alts.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc++_error_details.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc++_reflection.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc++_unsecure.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc_authorization_provider.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc_plugin_support.a
    ${GRPC_INSTALL_DIR}/lib/libgrpc_unsecure.a
    ${GRPC_INSTALL_DIR}/lib/libgrpcpp_channelz.a

    ${GRPC_INSTALL_DIR}/lib/libaddress_sorting.a
    ${GRPC_INSTALL_DIR}/lib/libcares.a
    ${GRPC_INSTALL_DIR}/lib/libssl.a
    ${GRPC_INSTALL_DIR}/lib/libcrypto.a
    ${GRPC_INSTALL_DIR}/lib/libgpr.a
    ${GRPC_INSTALL_DIR}/lib/libprotobuf-lite.a
    ${GRPC_INSTALL_DIR}/lib/libprotobuf.a
    ${GRPC_INSTALL_DIR}/lib/libprotoc.a
    ${GRPC_INSTALL_DIR}/lib/libre2.a
    ${GRPC_INSTALL_DIR}/lib/libupb.a
    ${GRPC_INSTALL_DIR}/lib/libupb_base_lib.a
    ${GRPC_INSTALL_DIR}/lib/libupb_json_lib.a
    ${GRPC_INSTALL_DIR}/lib/libupb_mem_lib.a
    ${GRPC_INSTALL_DIR}/lib/libupb_message_lib.a
    ${GRPC_INSTALL_DIR}/lib/libupb_mini_descriptor_lib.a
    ${GRPC_INSTALL_DIR}/lib/libupb_textformat_lib.a
    ${GRPC_INSTALL_DIR}/lib/libupb_wire_lib.a
    ${GRPC_INSTALL_DIR}/lib/libutf8_range.a
    ${GRPC_INSTALL_DIR}/lib/libutf8_range_lib.a
    ${GRPC_INSTALL_DIR}/lib/libutf8_validity.a
    ${GRPC_INSTALL_DIR}/lib/libz.a

    ${GRPC_INSTALL_DIR}/lib/libabsl_hash.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_bad_any_cast_impl.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_bad_optional_access.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_bad_variant_access.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_city.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_civil_time.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_cord.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_cord_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_cordz_functions.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_cordz_info.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_cordz_handle.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_cordz_sample_token.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_crc_cord_state.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_crc32c.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_crc_cpu_detect.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_crc_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_message.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_examine_stack.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_symbolize.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_synchronization.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_vlog_config_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_demangle_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_demangle_rust.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_stacktrace.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_debugging_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_decode_rust_punycode.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_die_if_null.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_exponential_biased.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_failure_signal_handler.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_reflection.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_commandlineflag.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_commandlineflag_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_config.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_marshalling.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_parse.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_private_handle_accessor.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_program_name.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_usage.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_flags_usage_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_graphcycles_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_hashtablez_sampler.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_int128.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_kernel_timeout_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_leak_check.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_entry.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_flags.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_globals.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_initialize.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_check_op.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_conditions.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_fnmatch.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_format.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_globals.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_log_sink_set.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_nullguard.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_internal_proto.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_severity.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_log_sink.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_low_level_hash.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_malloc_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_periodic_sampler.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_poison.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_distributions.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_randen_hwaes_impl.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_distribution_test_util.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_platform.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_pool_urbg.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_randen.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_randen_hwaes.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_randen_slow.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_internal_seed_material.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_seed_gen_exception.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_random_seed_sequences.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_raw_hash_set.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_raw_logging_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_scoped_set_env.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_spinlock_wait.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_status.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_statusor.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_str_format_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_strerror.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_string_view.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_strings.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_strings_internal.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_throw_delegate.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_time.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_time_zone.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_utf8_for_code_point.a
    ${GRPC_INSTALL_DIR}/lib/libabsl_base.a
    -Wl,-Bdynamic
    pthread
    dl
    /usr/lib/libsystemd.so
)

# ✅ Find the submodule's include directory dynamically
find_path(GRPC_INCLUDE_DIR
    # NAMES submodule.h  # Change this to an actual header in the submodule
    PATHS ${GRPC_INSTALL_DIR}/include
    NO_DEFAULT_PATH
)

# ✅ Make these variables available in the parent CMakeLists.txt
set(GRPC_INCLUDE_DIR ${GRPC_INCLUDE_DIR} CACHE PATH "grpc include dir")
set(GRPC_INSTALL_DIR ${GRPC_INSTALL_DIR} CACHE PATH "grpc install dir")

