cmake_minimum_required(VERSION 3.26)
project(au)


#TODO some libraries (like "apply_magnitude") are apparently "implementation detail only" libraries, do we hide this from the export set of targets?
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR PARENT_PATH AU_PARENT_DIRECTORY)

# While CMake is capable of globbing, we don't do it. It screws with IDEs ability to find files,
# and having a library be installable.

# interface libraries are basically header only, and while the bazel version looks for .cc files, there actually is none in the given directory
add_library(stdx INTERFACE)

# file set here can be used in an install target to install headers appropriately
target_sources(stdx
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}  #ensures that ${AU_PARENT_DIRECTORY} is not included in include path for installed library.
        FILES
        ${AU_PARENT_DIRECTORY}/au/stdx/experimental/is_detected.hh
        ${AU_PARENT_DIRECTORY}/au/stdx/functional.hh
        ${AU_PARENT_DIRECTORY}/au/stdx/type_traits.hh
        ${AU_PARENT_DIRECTORY}/au/stdx/utility.hh
)

target_include_directories(stdx INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(utility INTERFACE)

target_sources(utility
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/utility/factoring.hh
        ${AU_PARENT_DIRECTORY}/au/utility/string_constant.hh
        ${AU_PARENT_DIRECTORY}/au/utility/type_traits.hh
)

target_link_libraries(utility INTERFACE stdx)
target_include_directories(utility INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(packs INTERFACE)

target_sources(packs
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/packs.hh
)

target_link_libraries(packs INTERFACE stdx utility)
target_include_directories(packs INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(zero INTERFACE)

target_sources(zero
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/zero.hh
)
target_include_directories(zero INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(power_aliases INTERFACE)

target_sources(power_aliases
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/power_aliases.hh
)
target_include_directories(power_aliases INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(magnitude INTERFACE)

target_sources(magnitude
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/magnitude.hh
)

target_link_libraries(magnitude INTERFACE packs power_aliases stdx utility zero)

target_include_directories(magnitude INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(apply_rational_magnitude_to_integral INTERFACE)

target_sources(apply_rational_magnitude_to_integral
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/apply_rational_magnitude_to_integral.hh
)

target_link_libraries(apply_rational_magnitude_to_integral INTERFACE magnitude)

target_include_directories(apply_rational_magnitude_to_integral INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
add_library(apply_magnitude INTERFACE)

target_sources(apply_magnitude
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/apply_magnitude.hh
)

target_link_libraries(apply_magnitude INTERFACE magnitude apply_rational_magnitude_to_integral)

target_include_directories(apply_magnitude INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(dimension INTERFACE)

target_sources(dimension
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/dimension.hh
)

target_link_libraries(dimension INTERFACE packs power_aliases)

target_include_directories(dimension INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(unit_of_measure INTERFACE)

target_sources(unit_of_measure
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/unit_of_measure.hh
)

target_link_libraries(unit_of_measure INTERFACE dimension magnitude power_aliases stdx utility zero)

target_include_directories(unit_of_measure INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(conversion_policy INTERFACE)

target_sources(conversion_policy
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/conversion_policy.hh
)

target_link_libraries(conversion_policy INTERFACE magnitude stdx unit_of_measure)

target_include_directories(conversion_policy INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(operators INTERFACE)

target_sources(operators
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/operators.hh
)


target_include_directories(operators INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(quantity INTERFACE)

target_sources(quantity
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/quantity.hh
)

target_link_libraries(quantity INTERFACE apply_magnitude conversion_policy operators unit_of_measure zero)

target_include_directories(quantity INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
add_library(quantity_point INTERFACE)

target_sources(quantity_point
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/quantity_point.hh
)

target_link_libraries(quantity_point INTERFACE quantity stdx utility)

target_include_directories(quantity_point INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(wrapper_operations INTERFACE)

target_sources(wrapper_operations
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/wrapper_operations.hh
)

target_link_libraries(wrapper_operations INTERFACE quantity stdx)
target_include_directories(wrapper_operations INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(unit_symbol INTERFACE)

target_sources(unit_symbol
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/unit_symbol.hh
)

target_link_libraries(unit_symbol INTERFACE wrapper_operations)

target_include_directories(unit_symbol INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(prefix INTERFACE)

target_sources(prefix
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/prefix.hh
)

target_link_libraries(prefix INTERFACE quantity quantity_point unit_of_measure unit_symbol)

target_include_directories(prefix INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


#    TODO fix Units test_cc to include *all units* and also include *all headers* for actual thing!
add_library(units INTERFACE)

target_sources(units
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
         ${AU_PARENT_DIRECTORY}/au/units/amperes.hh
         ${AU_PARENT_DIRECTORY}/au/units/bars.hh
         ${AU_PARENT_DIRECTORY}/au/units/becquerel.hh
         ${AU_PARENT_DIRECTORY}/au/units/bits.hh
         ${AU_PARENT_DIRECTORY}/au/units/bytes.hh
         ${AU_PARENT_DIRECTORY}/au/units/candelas.hh
         ${AU_PARENT_DIRECTORY}/au/units/celsius.hh
         ${AU_PARENT_DIRECTORY}/au/units/coulombs.hh
         ${AU_PARENT_DIRECTORY}/au/units/days.hh
         ${AU_PARENT_DIRECTORY}/au/units/degrees.hh
         ${AU_PARENT_DIRECTORY}/au/units/fahrenheit.hh
         ${AU_PARENT_DIRECTORY}/au/units/farads.hh
         ${AU_PARENT_DIRECTORY}/au/units/fathoms.hh
         ${AU_PARENT_DIRECTORY}/au/units/feet.hh
         ${AU_PARENT_DIRECTORY}/au/units/furlongs.hh
         ${AU_PARENT_DIRECTORY}/au/units/grams.hh
         ${AU_PARENT_DIRECTORY}/au/units/grays.hh
         ${AU_PARENT_DIRECTORY}/au/units/henries.hh
         ${AU_PARENT_DIRECTORY}/au/units/hertz.hh
         ${AU_PARENT_DIRECTORY}/au/units/hours.hh
         ${AU_PARENT_DIRECTORY}/au/units/inches.hh
         ${AU_PARENT_DIRECTORY}/au/units/joules.hh
         ${AU_PARENT_DIRECTORY}/au/units/katals.hh
         ${AU_PARENT_DIRECTORY}/au/units/kelvins.hh
         ${AU_PARENT_DIRECTORY}/au/units/knots.hh
         ${AU_PARENT_DIRECTORY}/au/units/liters.hh
         ${AU_PARENT_DIRECTORY}/au/units/lumens.hh
         ${AU_PARENT_DIRECTORY}/au/units/lux.hh
         ${AU_PARENT_DIRECTORY}/au/units/meters.hh
         ${AU_PARENT_DIRECTORY}/au/units/miles.hh
         ${AU_PARENT_DIRECTORY}/au/units/minutes.hh
         ${AU_PARENT_DIRECTORY}/au/units/moles.hh
         ${AU_PARENT_DIRECTORY}/au/units/nautical_miles.hh
         ${AU_PARENT_DIRECTORY}/au/units/newtons.hh
         ${AU_PARENT_DIRECTORY}/au/units/ohms.hh
         ${AU_PARENT_DIRECTORY}/au/units/pascals.hh
         ${AU_PARENT_DIRECTORY}/au/units/percent.hh
         ${AU_PARENT_DIRECTORY}/au/units/pounds_force.hh
         ${AU_PARENT_DIRECTORY}/au/units/pounds_mass.hh
         ${AU_PARENT_DIRECTORY}/au/units/radians.hh
         ${AU_PARENT_DIRECTORY}/au/units/revolutions.hh
         ${AU_PARENT_DIRECTORY}/au/units/seconds.hh
         ${AU_PARENT_DIRECTORY}/au/units/siemens.hh
         ${AU_PARENT_DIRECTORY}/au/units/slugs.hh
         ${AU_PARENT_DIRECTORY}/au/units/standard_gravity.hh
         ${AU_PARENT_DIRECTORY}/au/units/steradians.hh
         ${AU_PARENT_DIRECTORY}/au/units/tesla.hh
         ${AU_PARENT_DIRECTORY}/au/units/unos.hh
         ${AU_PARENT_DIRECTORY}/au/units/volts.hh
         ${AU_PARENT_DIRECTORY}/au/units/watts.hh
         ${AU_PARENT_DIRECTORY}/au/units/webers.hh
         ${AU_PARENT_DIRECTORY}/au/units/yards.hh
)

target_link_libraries(units INTERFACE prefix quantity quantity_point unit_of_measure unit_symbol)
target_include_directories(units INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(constant INTERFACE)

target_sources(constant
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/constant.hh
)

target_link_libraries(constant INTERFACE quantity unit_of_measure wrapper_operations)

target_include_directories(constant INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_library(math INTERFACE)

target_sources(math
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/math.hh
)

target_link_libraries(math INTERFACE constant quantity quantity_point units)

target_include_directories(math INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(chrono_interop INTERFACE)

target_sources(chrono_interop
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/chrono_interop.hh
)

target_link_libraries(chrono_interop INTERFACE units)

target_include_directories(chrono_interop INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(io INTERFACE)

target_sources(io
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/io.hh
)

target_link_libraries(io INTERFACE quantity quantity_point zero)

target_include_directories(io INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(testing INTERFACE)

target_sources(testing
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/testing.hh
)

target_link_libraries(testing INTERFACE io stdx unit_of_measure)

target_include_directories(testing INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_library(au INTERFACE)

target_sources(au
        INTERFACE
        FILE_SET HEADERS
        TYPE HEADERS
        BASE_DIRS ${AU_PARENT_DIRECTORY}
        FILES
        ${AU_PARENT_DIRECTORY}/au/au.hh
)

target_link_libraries(au INTERFACE chrono_interop constant math)

target_include_directories(au INTERFACE
        $<BUILD_INTERFACE:${AU_PARENT_DIRECTORY}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Testing targets
if (${AU_ENABLE_TESTING})
    include(../cmake/AuCompileArgUtils.cmake)

    # tests
    enable_testing()
    # TODO, AU is doing a bunch of weird toolchain stuff I don't understand, is this for CI?
    #chrono policy validation was marked as "test only", so, we'll just not use it outside of testing?

    add_library(chrono_policy_validation INTERFACE)

    # TODO, if this is a test only library, don't know if we need to do this, but probably doesn't hurt if this isn't in the
    #  cmake export set on installation 2024-1-2
    target_sources(chrono_policy_validation
            INTERFACE
            FILE_SET HEADERS
            TYPE HEADERS
            BASE_DIRS ${AU_PARENT_DIRECTORY}
            FILES
            ${AU_PARENT_DIRECTORY}/au/chrono_policy_validation.hh
    )

    target_link_libraries(chrono_policy_validation INTERFACE dimension quantity stdx unit_of_measure GTest::gtest)


    add_executable(stdx_test)
    target_sources(stdx_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/stdx/test/utility_test.cc
    )
    target_link_libraries(stdx_test PRIVATE
            stdx
            GTest::gtest_main GTest::gmock_main
    )
    target_compile_options(stdx_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )
    gtest_discover_tests(stdx_test)

    add_executable(utility_test)
    target_sources(utility_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/utility/test/factoring_test.cc
            ${AU_PARENT_DIRECTORY}/au/utility/test/string_constant_test.cc
            ${AU_PARENT_DIRECTORY}/au/utility/test/type_traits_test.cc
    )

    target_link_libraries(utility_test PRIVATE
            utility
            GTest::gtest_main GTest::gmock_main
    )
    target_compile_options(utility_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )
    gtest_discover_tests(utility_test)


    add_executable(packs_test)
    target_sources(packs_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/packs_test.cc
    )

    target_link_libraries(packs_test PRIVATE
            packs
            GTest::gtest_main GTest::gmock_main
    )
    target_compile_options(packs_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(packs_test)


    add_executable(zero_test)
    target_sources(zero_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/zero_test.cc
    )

    target_link_libraries(zero_test PRIVATE
            zero
            GTest::gtest_main GTest::gmock_main
    )
    target_compile_options(zero_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(zero_test)

    add_executable(power_aliases_test)
    target_sources(power_aliases_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/power_aliases_test.cc
    )
    target_link_libraries(power_aliases_test PRIVATE
            packs
            power_aliases
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(power_aliases_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(power_aliases_test)

    add_executable(magnitude_test)
    target_sources(magnitude_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/magnitude_test.cc
    )

    target_link_libraries(magnitude_test PRIVATE
            magnitude
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(magnitude_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(magnitude_test)

    add_executable(apply_rational_magnitude_to_integral_test)
    target_sources(apply_rational_magnitude_to_integral_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/apply_rational_magnitude_to_integral_test.cc
    )

    target_link_libraries(apply_rational_magnitude_to_integral_test PRIVATE
            apply_rational_magnitude_to_integral
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(apply_rational_magnitude_to_integral_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(apply_rational_magnitude_to_integral_test)


    add_executable(apply_magnitude_test)
    target_sources(apply_magnitude_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/apply_magnitude_test.cc
    )

    target_link_libraries(apply_magnitude_test PRIVATE
            apply_magnitude
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(apply_magnitude_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(apply_magnitude_test)

    add_executable(dimension_test)
    target_sources(dimension_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/dimension_test.cc
    )

    target_link_libraries(dimension_test PRIVATE
            dimension
            testing
            units
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(dimension_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(dimension_test)

    add_executable(unit_of_measure_test)
    target_sources(unit_of_measure_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/unit_of_measure_test.cc
    )

    target_link_libraries(unit_of_measure_test PRIVATE
            prefix
            testing
            unit_of_measure
            units
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(unit_of_measure_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(unit_of_measure_test)


    add_executable(conversion_policy_test)
    target_sources(conversion_policy_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/conversion_policy_test.cc
    )

    target_link_libraries(conversion_policy_test PRIVATE
            conversion_policy
            unit_of_measure
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(conversion_policy_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(conversion_policy_test)

    add_executable(operators_test)
    target_sources(operators_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/operators_test.cc
    )

    target_link_libraries(operators_test PRIVATE
            operators
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(operators_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(operators_test)

    add_executable(quantity_test)
    target_sources(quantity_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/quantity_test.cc
            ${AU_PARENT_DIRECTORY}/au/quantity_chrono_policy_correspondence_test.cc
    )

    target_link_libraries(quantity_test PRIVATE
            quantity
            chrono_policy_validation
            prefix
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(quantity_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(quantity_test)

    add_executable(quantity_point_test)
    target_sources(quantity_point_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/quantity_point_test.cc
    )

    target_link_libraries(quantity_point_test PRIVATE
            quantity_point
            prefix
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(quantity_point_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(quantity_point_test)


    add_executable(wrapper_operations_test)
    target_sources(wrapper_operations_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/wrapper_operations_test.cc
    )

    target_link_libraries(wrapper_operations_test PRIVATE
            wrapper_operations
            testing
            units
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(wrapper_operations_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(wrapper_operations_test)


    add_executable(unit_symbol_test)
    target_sources(unit_symbol_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/unit_symbol_test.cc
    )

    target_link_libraries(unit_symbol_test PRIVATE
            unit_symbol
            testing
            units
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(unit_symbol_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(unit_symbol_test)


    add_executable(prefix_test)
    target_sources(prefix_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/prefix_test.cc
    )

    target_link_libraries(prefix_test PRIVATE
            prefix
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(prefix_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(prefix_test)

#    TODO fix Units test_cc to include *all units* and also include *all headers* for actual thing!
    add_executable(units_test)
    target_sources(units_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/units/test/amperes_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/bars_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/becquerel_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/bits_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/bytes_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/candelas_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/celsius_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/coulombs_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/days_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/degrees_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/fahrenheit_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/farads_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/fathoms_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/feet_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/furlongs_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/grams_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/grays_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/henries_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/hertz_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/hours_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/inches_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/joules_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/katals_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/kelvins_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/knots_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/liters_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/lumens_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/lux_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/meters_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/miles_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/minutes_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/moles_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/nautical_miles_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/newtons_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/ohms_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/pascals_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/percent_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/pounds_force_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/pounds_mass_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/radians_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/revolutions_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/seconds_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/siemens_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/slugs_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/standard_gravity_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/steradians_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/tesla_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/unos_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/volts_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/watts_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/webers_test.cc
            ${AU_PARENT_DIRECTORY}/au/units/test/yards_test.cc
    )

    target_link_libraries(units_test PRIVATE
            units
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(units_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(units_test)
    

    add_executable(no_wconversion_test)
    target_sources(no_wconversion_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/no_wconversion_test.cc
    )

    target_link_libraries(no_wconversion_test PRIVATE
            quantity
            testing
            units
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(no_wconversion_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(no_wconversion_test)

    add_executable(constant_test)
    target_sources(constant_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/constant_test.cc
    )

    target_link_libraries(constant_test PRIVATE
            chrono_interop
            constant
            testing
            units
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(constant_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(constant_test)


    add_executable(math_test)
    target_sources(math_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/math_test.cc
    )

    target_link_libraries(math_test PRIVATE
            math
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(math_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(math_test)

    add_executable(chrono_policy_validation_test)
    target_sources(chrono_policy_validation_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/chrono_policy_validation_test.cc
    )

    target_link_libraries(chrono_policy_validation_test PRIVATE
            chrono_policy_validation
            prefix
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(chrono_policy_validation_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(chrono_policy_validation_test)

    add_executable(chrono_interop_test)
    target_sources(chrono_interop_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/chrono_interop_test.cc
    )

    target_link_libraries(chrono_interop_test PRIVATE
            chrono_interop
            prefix
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(chrono_interop_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(chrono_interop_test)

    add_executable(io_test)
    target_sources(io_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/io_test.cc
    )

    target_link_libraries(io_test PRIVATE
            io
            prefix
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(io_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(io_test)

    add_executable(testing_test)
    target_sources(testing_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/testing_test.cc
    )

    target_link_libraries(testing_test PRIVATE
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(testing_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(testing_test)


    add_executable(au_test)
    target_sources(au_test PRIVATE
            ${AU_PARENT_DIRECTORY}/au/au_test.cc
    )

    target_link_libraries(au_test PRIVATE
            au
            testing
            GTest::gtest_main GTest::gmock_main
    )

    target_compile_options(au_test
            PRIVATE ${AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS}
            ${AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS}
    )

    gtest_discover_tests(au_test)
endif ()




