cmake_minimum_required(VERSION 4.0)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
# set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

get_filename_component(ProjectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" ProjectId ${ProjectId})
project(${ProjectId} LANGUAGES C ASM)

# Force GCC 15(LinuxOS)
# set(CMAKE_C_COMPILER "/opt/gcc-15/bin/gcc")
# Force GCC 15(macOS)
# set(CMAKE_C_COMPILER "/opt/homebrew/opt/gcc@15/bin/gcc-15")
# Force Clang 21(LinuxOS)
# set(CMAKE_C_COMPILER "/usr/bin/clang-21")
# Force Clang 21(macOS)
# set(CMAKE_CXX_COMPILER "/opt/homebrew/opt/llvm/bin/clang")

SET (CMAKE_C_FLAGS_INIT                "-Wall -std=c23")
SET (CMAKE_C_FLAGS_DEBUG_INIT          "-g")
SET (CMAKE_C_FLAGS_MINSIZEREL_INIT     "-Os -DNDEBUG")
SET (CMAKE_C_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")
SET (CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "-O2 -g")

SET (CMAKE_CXX_FLAGS_INIT                "-Wall -std=c++26")
SET (CMAKE_CXX_FLAGS_DEBUG_INIT          "-g")
SET (CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "-Os -DNDEBUG")
SET (CMAKE_CXX_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")
SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O2 -g")

# Common compile flags (C-only flags scoped so they don't leak into ASM builds)
add_compile_options(
    $<$<COMPILE_LANGUAGE:C>:-pedantic>
    $<$<COMPILE_LANGUAGE:C>:-pedantic-errors>
    $<$<COMPILE_LANGUAGE:C>:-Wall>
    $<$<COMPILE_LANGUAGE:C>:-Wextra>
    -ggdb
    # -std=c23
)

# Main executable with C sources
add_executable(${ProjectId}
    src/main.c
    src/maxofthree.s
)

target_link_options(${ProjectId} PRIVATE -pthread -lm)

# Output directory
set_target_properties(${ProjectId} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY
       "${CMAKE_BINARY_DIR}/$<LOWER_CASE:$<CONFIG>>"
)
