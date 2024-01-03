cmake_minimum_required(VERSION 3.26)
project(au)
#au claims at least c++14 necessary.
#so does gtest.
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


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
if(${AU_ENABLE_TESTING})
option(AU_FORCE_FETCH_CONTENT_GTEST "Forces Au cmakelists.txt to use fetch content to retrieve gtest" OFF)
if(${AU_FORCE_FETCH_CONTENT_GTEST})
#If we are using another package manager, or it's already installed, see if we can just find gtest.
find_package(GTest)
endif()
# if we don't find it, just download it.
if(NOT GTEST_LIBRARY)
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
endif()

#provides "gtest_discover_tests"
include(GoogleTest)
endif()

add_subdirectory(au)