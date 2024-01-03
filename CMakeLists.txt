cmake_minimum_required(VERSION 3.26)
project(au)
#au claims at least c++14 necessary.
#so does gtest.
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# according to cmake for library authors https://www.youtube.com/watch?v=m0DwB4OvDXk, needed for apple support.
if (NOT APPLE)
    set(CMAKE_INSTALL_RPATH $ORIGIN)
endif ()


#top level CMakeLists.txt is effectively the same as a "Bazel Workspace" as far as I can tell.

# don't need to fetch bazel skylib, as we aren't using bazel.

# TODO, AU is doing a bunch of weird toolchain stuff I don't understand, is this for CI?

# we can include .cmake files if we want, do something like copts.bzl, this is what AuCompileArgUtils.cmake is.
# It contains compile arguments needed to build tests, probably more strict, but since the project contains a *loooot*
# of implicit compiler directives from "toolchains" that I don't have time to parse through, I'm taking a conservative approach here.
# Note that  things like $<$<CXX_COMPILER_ID:Clang>: -g -ggdb -03> are known as "generator expression", see
# https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
# the above example generates the following set of compile arguments in place, when the given compiler ID is seen at
# *generation time*.


# Extra flags we want to pass to the compilers.
# -Wall is already set by aspect_gcc_toolchain.
# Note, since this is an interface library, there's no point in putting this on any of the *actually* exposed public targets to the end users,
# only the *compiled binaries*, ie *tests* need these arguments.

option(AU_ENABLE_TESTING "Enables Au Tests" ON)
if (${AU_ENABLE_TESTING})
    option(AU_FORCE_FETCH_CONTENT_GTEST "Forces Au cmakelists.txt to use fetch content to retrieve gtest" OFF)
    if (${AU_FORCE_FETCH_CONTENT_GTEST})
        #If we are using another package manager, or it's already installed, see if we can just find gtest.
        find_package(GTest)
    endif ()
    # if we don't find it, just download it.
    if (NOT GTEST_LIBRARY)
        #    https://coderefinery.github.io/cmake-workshop/fetch-content/
        include(FetchContent)
        FetchContent_Declare(
                googletest
                GIT_REPOSITORY https://github.com/google/googletest.git
                GIT_TAG v1.14.0
        )
        # https://google.github.io/googletest/quickstart-cmake.html
        # For Windows: Prevent overriding the parent project's compiler/linker settings
        set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
        FetchContent_MakeAvailable(googletest)
    endif ()

    #provides "gtest_discover_tests"
    include(GoogleTest)
endif ()

#after adding subdirectory, targets are now available in file.
add_subdirectory(au)


#Install code
# Note much of this comes from Deep Cmake for Library Authors by Craig Scott https://www.youtube.com/watch?v=m0DwB4OvDXk
# Note much of CMakes own documentation is not up-to-date with this presentation.

#TODO figure out if this is the actual version.
set_target_properties(au PROPERTIES
        SOVERSION 3
        VERSION 3.4.0)

set_target_properties(au PROPERTIES EXPORT_NAME au)
add_library(au::au ALIAS au)
add_library(au::io ALIAS io)
add_library(au::testing ALIAS testing)
add_library(au::units ALIAS units)

# You still need "private" targets to be exposed in the export set, but we can make the targets harder to touch
# by changing the export name for them
# https://stackoverflow.com/questions/68317064/how-to-link-a-shared-library-without-having-to-export-its-internal-targets

set_target_properties(chrono_interop PROPERTIES EXPORT_NAME _private_chrono_interop)
set_target_properties(constant PROPERTIES EXPORT_NAME _private_constant)
set_target_properties(math PROPERTIES EXPORT_NAME _private_math)
set_target_properties(quantity PROPERTIES EXPORT_NAME _private_quantity)
set_target_properties(quantity_point PROPERTIES EXPORT_NAME _private_quantity_point)
set_target_properties(zero PROPERTIES EXPORT_NAME _private_zero)
set_target_properties(stdx PROPERTIES EXPORT_NAME _private_stdx)
set_target_properties(unit_of_measure PROPERTIES EXPORT_NAME _private_unit_of_measure)
set_target_properties(prefix PROPERTIES EXPORT_NAME _private_prefix)
set_target_properties(unit_symbol PROPERTIES EXPORT_NAME _private_unit_symbol)
set_target_properties(wrapper_operations PROPERTIES EXPORT_NAME _private_wrapper_operations)
set_target_properties(apply_magnitude PROPERTIES EXPORT_NAME _private_apply_magnitude)
set_target_properties(conversion_policy PROPERTIES EXPORT_NAME _private_conversion_policy)
set_target_properties(operators PROPERTIES EXPORT_NAME _private_operators)
set_target_properties(utility PROPERTIES EXPORT_NAME _private_utility)
set_target_properties(dimension PROPERTIES EXPORT_NAME _private_dimension)
set_target_properties(magnitude PROPERTIES EXPORT_NAME _private_magnitude)
set_target_properties(power_aliases PROPERTIES EXPORT_NAME _private_power_aliases)
set_target_properties(apply_rational_magnitude_to_integral PROPERTIES EXPORT_NAME _private_apply_rational_magnitude_to_integral)
set_target_properties(packs PROPERTIES EXPORT_NAME _private_packs)

include(CMakePackageConfigHelpers)

include(GNUInstallDirs)

install(TARGETS
        #public targets
        au io testing units
        #private targets
        chrono_interop constant math quantity quantity_point zero stdx
        unit_of_measure prefix unit_symbol wrapper_operations apply_magnitude
        conversion_policy operators utility dimension magnitude power_aliases
        apply_rational_magnitude_to_integral packs
        EXPORT au_Targets
        FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        COMPONENT au_Development
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT au_RunTime
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT au_RunTIme
        NAMELINK_COMPONENT au_Development
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT au_Development
)

set(au_INSTALL_CMAKEDIR
        ${CMAKE_INSTALL_DATADIR}/au-container
        CACHE STRING "Path to au cmake files"
)

install(EXPORT au_Targets
        DESTINATION ${au_INSTALL_CMAKEDIR}
        NAMESPACE au::
        FILE auTargets.cmake
        COMPONENT au_Development
)

configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.cmake.in
        "${CMAKE_CURRENT_BINARY_DIR}/auConfig.cmake"
        INSTALL_DESTINATION ${au_INSTALL_CMAKEDIR}
)


get_target_property(au_VERSION au VERSION)

write_basic_package_version_file(auConfigVersion.cmake VERSION ${au_VERSION} COMPATIBILITY SameMajorVersion)

install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/auConfig.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/auConfigVersion.cmake
        DESTINATION ${au_INSTALL_CMAKEDIR}
)
