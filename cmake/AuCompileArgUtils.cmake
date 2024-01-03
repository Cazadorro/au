set(AU_CMAKE_UTILS_GCC_EXTRA_COMPILE_ARGS
        -pedantic
        -Wall
        -Wextra
        -Wshadow
        -Wnon-virtual-dtor
        -fmax-errors=5
        -Wold-style-cast
        -Wcast-align
        -Wunused
        -Woverloaded-virtual
        -Wpedantic
        -Wconversion
        -Wsign-conversion
        -Wmisleading-indentation
        -Wduplicated-cond
        -Wduplicated-branches
        -Wlogical-op
        -Wnull-dereference
        -Wuseless-cast
        -Wdouble-promotion
        -Wformat=2
)

set(AU_CMAKE_UTILS_CLANG_EXTRA_COMPILE_ARGS
        ${LIBSNDFILE_WRAPPER_GCC_EXTRA_ARGS}
        -Wlifetime
        -Wimplicit-fallthrough
        # Security
        -U_FORTIFY_SOURCE  # https://github.com/google/sanitizers/issues/247
        -fstack-protector
        -fno-omit-frame-pointer
        # Diagnostics
        -fcolor-diagnostics
        -Wthread-safety
        -Wself-assign
)

set(AU_CMAKE_UTILS_MSVC_EXTRA_COMPILE_ARGS
        /permissive
        /W4
        /w14640
        /w14242
        /w14254
        /w14263
        /w14265
        /w14287
        /we4289
        /w14296
        /w14311
        /w14545
        /w14546
        /w14547
        /w14549
        /w14555
        /w14619
        /w14640
        /w14826
        /w14905
        /w14906
        /w14928
        /Zc:__cplusplus
)

set(AU_CMAKE_UTILS_GENERATED_EXTRA_COMPILE_ARGS
        $<$<CXX_COMPILER_ID:Clang>: ${AU_CMAKE_UTILS_CLANG_EXTRA_COMPILE_ARGS}>
        $<$<CXX_COMPILER_ID:GNU>: ${AU_CMAKE_UTILS_GCC_EXTRA_COMPILE_ARGS}>
        $<$<CXX_COMPILER_ID:MSVC>: ${AU_CMAKE_UTILS_MSVC_EXTRA_COMPILE_ARGS}>
)

set(AU_CMAKE_UTILS_GENERATED_DEBUG_COMPILE_ARGS
        $<$<CXX_COMPILER_ID:Clang>: -g -ggdb>
        $<$<CXX_COMPILER_ID:GNU>: -g -ggdb>
        $<$<CXX_COMPILER_ID:MSVC>: /DEBUG>
)

set(AU_CMAKE_UTILS_GENERATED_RELEASE_COMPILE_ARGS
        $<$<CXX_COMPILER_ID:Clang>: -03>
        $<$<CXX_COMPILER_ID:GNU>: -03>
        $<$<CXX_COMPILER_ID:MSVC>: /02>
)

set(AU_CMAKE_UTILS_GENERATED_RELWITHDEBINFO_COMPILE_ARGS
        $<$<CXX_COMPILER_ID:Clang>: -g -ggdb -03>
        $<$<CXX_COMPILER_ID:GNU>: -g -ggdb -03>
        $<$<CXX_COMPILER_ID:MSVC>: /DEBUG /02>
)

set(AU_CMAKE_UTILS_GENERATED_CONFIG_COMPILE_ARGS
        $<$<CONFIG:Debug>: ${AU_CMAKE_UTILS_GENERATED_DEBUG_COMPILE_ARGS}>
        $<$<CONFIG:Release>: ${AU_CMAKE_UTILS_GENERATED_RELEASE_COMPILE_ARGS}>
        $<$<CONFIG:RelWithDebInfo>: ${AU_CMAKE_UTILS_GENERATED_RELWITHDEBINFO_COMPILE_ARGS}>
)