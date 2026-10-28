# Result

```bash
1
2
3
4
5
6
```
# fix
Fixed and verified — clean build, correct output (`1 2 3 4 5 6`).

## Root cause

`CMakeLists.txt:10` declared `project(... LANGUAGES C)`. Without `ASM` in the languages list, CMake has no rule for `.s` files and silently drops `src/maxofthree.s` from the target — which is why ninja only compiled `main.c.o` and the link failed with `undefined reference to 'maxofthree'`.

## Changes

**`CMakeLists.txt`**
- `LANGUAGES C` → `LANGUAGES C ASM` — CMake now detects clang as the assembler and compiles/links `maxofthree.s`
- Removed `-lm` from `add_compile_options` (it's a linker flag and caused the `linker input unused` warning; it was already correctly in `target_link_options`)
- Scoped `-pedantic`, `-pedantic-errors`, `-Wall`, `-Wextra` to C only via `$<$<COMPILE_LANGUAGE:C>:...>` generator expressions, so they don't leak into ASM compiles

**`src/maxofthree.s`**
- Added `.section .note.GNU-stack,"",@progbits` (matching your other examples) — silences the `missing .note.GNU-stack section implies executable stack` linker warning

One note: the remaining `-MD/-MT/-MF` warnings on the ASM step are injected by CMake's own depfile handling when using clang as the assembler — they're benign and can't be removed via flags. The link and exec-stack warnings are gone.

# justfile

```justfile
# Detect OS
os := `uname`

# project name
project_name := `basename "$(pwd)"`
full_project_name := `pwd`

# clang & gcc basic & clang-format basic & cmake basic
clang := `which clang` 
clangpp := `which clang++` 
gcc := `which gcc`
clang_format_basic := `which clang-format`
cmake := `which cmake`

# compiler settings
# Find best clang version (21+) on Linux, fallback to system clang
clang_which := if os == "Linux" { \
    clang \
  } else if os == "Darwin" { \
    "/opt/homebrew/opt/llvm/bin/clang" \
  } else { \
    clang \
  }
clangpp_which := if os == "Linux" { \
    clangpp \
  } else if os == "Darwin" { \
    "/opt/homebrew/opt/llvm/bin/clang++" \
  } else { \
    clangpp \
  }
gcc_which := if os == "Linux" { \
	gcc
  } else if os == "Darwin" { \
    `sh -c 'if [ -x "/opt/homebrew/opt/gcc@15/bin/gcc-15" ]; then echo "/opt/homebrew/opt/gcc@15/bin/gcc-15"; exit 0; fi; for v in {14..30}; do if [ -x "/opt/homebrew/opt/llvm@$v/bin/clang" ]; then echo "/opt/homebrew/opt/llvm@$v/bin/clang"; exit 0; fi; done; echo "/opt/homebrew/opt/llvm/bin/clang"'` \
  } else { \
    gcc \
  }

# cmake settings(4.0)
cmake_which := if os == "Linux" { \
    cmake \
  } else if os == "Darwin" { \
    "/opt/homebrew/bin/cmake"
  } else { \
    cmake \
  }

# clang-format - find best version (21+) on Linux
clang_format := if os == "Linux" { \
    clang_format_basic \
  } else if os == "Darwin" { \
    "/opt/homebrew/opt/llvm/bin/clang-format" \
  } else { \
    clang_format_basic \
  }

# fmt .clang-format(linuxOS / macOS)
fmt_flags := if os == "Linux" { \
    ". -regex '.*\\.\\(cpp\\|hpp\\|cc\\|cxx\\|c\\|h\\)' -exec " \
    +clang_format+ \
    " -style=file -i {} \\;" \
  } else if os == "Darwin" { \
    ". -iname '*.cpp' \
    -o -iname '*.hpp' \
    -o -iname '*.cc' \
    -o -iname '*.c' \
    -o -iname '*.cxx' \
    -o -iname '*.c' \
    -o -iname '*.h' | " \
    +clang_format+ \
    " -style=file -i --files=/dev/stdin" \
  } else { \
    ". -regex '.*\\.\\(cpp\\|hpp\\|cc\\|cxx\\|c\\|h\\)' -exec " \
    +clang_format+ \
    " -style=file -i {} \\;" \
  }  

# fast fmt(LinuxOS / macOS)(Install "cargo install fd-find")
fm_flags := "-e c \
  -e h \
  -e cpp \
  -e hpp \
  -e cc \
  -e cxx -x " \
  +clang_format+  \
  " -style=file -i {} \\;"

# Source and target directories
src_dir := "src"
target_dir := "target"

# Files
source := src_dir+"/main.c"
add_files := src_dir+"/maxofthree.s"
target := target_dir+"/"+project_name

# Optimize (O2(RelWithDebInfo), O3(Release))
ldflags_optimize := "-std=c23 -Wall -O2 -pedantic -pthread -pedantic-errors -lm -Wextra -ggdb"

# Common flags
ldflags_common := "-std=c23 -pedantic -pthread -pedantic-errors -lm -Wall -Wextra -ggdb -Werror"
ldflags_debug := "-std=c23 -pthread -lm -Wall -Wextra -ggdb"
ldflags_clang_debug := "--analyze -std=c23 -Xanalyzer -analyzer-output=text"
ldflags_gcc_debug := "-std=c23 -Wmaybe-uninitialized -Wall -Wextra -pedantic -Werror -O1 -ggdb"
ldflags_emit_llvm := "-S -emit-llvm"
ldflags_assembly := "-Wall -save-temps"
ldflags_fsanitize_address := "-g -fsanitize=address -fno-omit-frame-pointer -c"
ldflags_fsanitize_object := "-g -fsanitize=address"
ldflags_fsanitize_thread := "-g -fsanitize=thread -fno-omit-frame-pointer -c"
ldflags_fsanitize_thread_object := "-g -fsanitize=thread"
ldflags_fsanitize_valgrind := "-fsanitize=address -g3"
ldflags_fsanitize_valgrind_O0 := "-O0 -g -std=c23 -pedantic -pthread -pedantic-errors -lm -Wall -Wextra -ggdb -Werror"
ldflags_fsanitize_leak := "-fsanitize=leak -g"

# (C)clang compile(LinuxOS)
r:
	just fm
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	{{clang}} {{ldflags_common}} -o ./{{target_dir}}/{{project_name}} {{source}} {{add_files}}
	{{target}}

# (C)clang compile(Debug in detail)(LinuxOS)
rd:
	just fm
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	{{clang}} {{ldflags_clang_debug}} -o ./{{target_dir}}/{{project_name}} {{source}}
	{{target}}

# (C)gcc compile(Debug in detail)(LinuxOS)
rd2:
	just fm
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	{{gcc_which}} {{ldflags_gcc_debug}} -o ./{{target_dir}}/{{project_name}} ./{{source}}
	./{{target}}

# (C)clang compile(Optimization/LinuxOS/ macOS)
ro:
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	{{clang_which}} {{ldflags_optimize}} -o ./{{target_dir}}/{{project_name}} {{source}}
	{{target}}

# cmake compile(LinuxOS)
cr:
	just fm
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	export CC={{clang}}
	cmake -D CMAKE_BUILD_TYPE=Debug \
	      -D CMAKE_C_COMPILER={{clang}} \
	      -G Ninja .
	ninja
	mv build.ninja CMakeCache.txt CMakeFiles cmake_install.cmake .ninja_deps .ninja_log debug {{target_dir}}
	./{{target_dir}}/debug/{{project_name}}

# cmake compile(LinuxOS)
cro:
	just fm
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	cmake -D CMAKE_BUILD_TYPE=RelWithDebInfo \
	      -D CMAKE_C_COMPILER={{clang}} \
	      -D CMAKE_C_FLAGS_RELWITHDEBINFO_INIT="-O2 -g" \
	      -G Ninja .
	ninja
	mv build.ninja CMakeCache.txt CMakeFiles cmake_install.cmake .ninja_deps .ninja_log relwithdebinfo {{target_dir}}
	./{{target_dir}}/relwithdebinfo/{{project_name}}

# cmake compile(LinuxOS)
cro3:
	just fm
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	cmake -D CMAKE_BUILD_TYPE=Release \
	      -D CMAKE_C_COMPILER={{clang}} \
	      -D CMAKE_C_FLAGS_RELEASE_INIT="-O3 -DNDEBUG" \
	      -G Ninja .
	ninja
	mv build.ninja CMakeCache.txt CMakeFiles cmake_install.cmake .ninja_deps .ninja_log release {{target_dir}}
	./{{target_dir}}/release/{{project_name}}

# zig C compile(LinuxOS)
zr:
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	export CC={{clang}}
	zig cc {{ldflags_common}} -o {{target}} {{source}}
	{{target}}
	
# cmake ctest
ctest:
	rm -rf build
	mkdir -p build
	cmake -D CMAKE_C_COMPILER={{clang}} \
		  -S . -B build
	cmake --build build
	ctest --test-dir ./build

# clang build
b:
	rm -rf {{target_dir}}
	mkdir -p {{target_dir}}
	{{clang_which}} {{ldflags_debug}} -o {{target}} {{source}}

# clangd .cache(c23 LSP build)
clangd:
	rm -rf .cache {{target_dir}} build
	{{cmake_which}} -DCMAKE_BUILD_TYPE:STRING=Debug \
					-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE \
					-DCMAKE_C_COMPILER:FILEPATH={{clang_which}} \
					-DCMAKE_CXX_COMPILER:FILEPATH={{clangpp_which}} -Wno-unused-cli \
					-S {{full_project_name}} \
					-B {{full_project_name}}/target \
					-G Ninja

# move target
move:
	rm -rf {{target_dir}}
	mkdir {{target_dir}}
	mv CMakeCache.txt CMakeFiles cmake_install.cmake .ninja_deps .ninja_log build.ninja *.bc *.i *.s *.o *.ll a.out target

# .clang-format init(LinuxOS/macOS)
cl:
	rm -rf .clang-format
	{{clang_format}} -style=WebKit -dump-config > .clang-format

# .clang-format fmt(LinuxOS/ macOS)
fmt:
	find {{fmt_flags}}

# (fast).clang-format fmt(cargo install fd-find)(LinuxOS / macOS)
fm:
	fd {{fm_flags}}

# clang LLVM emit-file
ll:
	rm -rf target
	mkdir -p target
	cp -rf {{src_dir}}/*.* ./.
	{{clang_which}} {{ldflags_emit_llvm}} main.c
	mv *.ll {{target_dir}}
	{{clang_which}} {{ldflags_common}} -o {{target}} {{source}}
	mv *.cpp {{target_dir}}
	rm -rf *.out

# Assembly emit-file
as:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_assembly}} -o {{target}} {{source}}
	mv *.i {{target_dir}}
	mv *.o {{target_dir}}
	mv *.s {{target_dir}}
	mv *.bc {{target_dir}}

# Clang Sanitize(ASan=address / LSan=leak / TSan=thread / MSan=memory / UBSan=undefined (Undefined Behavior)
san SAN:
	rm -rf target
	mkdir -p target
	{{clang_which}} -g -fsanitize={{SAN}} -fno-omit-frame-pointer -c {{source}}
	{{clang_which}} -g -fsanitize={{SAN}} *.o 
	mv a.out *.o {{target_dir}}
	{{target_dir}}/a.out

# clang (ASan)fsanitize_address
asan:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_address}} {{source}}
	{{clang_which}} {{ldflags_fsanitize_object}} *.o 
	mv a.out *.o {{target_dir}}
	{{target_dir}}/a.out

# clang LSan_Leak_Sanitizer
lsan:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_leak}} {{source}} -o {{target}}
	{{target}}

# clang TSan_Thread_Sanitizer
tsan:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_thread}} {{source}}
	{{clang_which}} {{ldflags_fsanitize_thread_object}} *.o 
	mv a.out *.o {{target_dir}}
	{{target_dir}}/a.out

# leak memory check(valgrind)
[linux]
leaks:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_valgrind}} {{source}} -o {{target}}
	valgrind --leak-check=full {{target}}

# leak memory check(leaks / macOS)
[macos]
leaks:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_valgrind}} {{source}} -o {{target}}
	leaks --atExit -- {{target}}

# leak memory check(valgrind)
[linux]
valgrind:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_valgrind_O0}} {{source}} -o {{project_name}}
	mv {{project_name}} {{target_dir}}
	valgrind --leak-check=full {{target_dir}}/{{project_name}}

# valgrind --track-origins=yes 
[linux]
valgrind_detail:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_valgrind_O0}} {{source}} -o {{project_name}}
	mv {{project_name}} {{target_dir}}
	valgrind --leak-check=full --track-origins=yes {{target_dir }}/{{project_name}}

# valgrind --tool=memcheck --vgdb=yes --vgdb-error=0
[linux]
valgrind_memcheck:
	rm -rf target
	mkdir -p target
	{{clang_which}} -O0 -g {{source}} -o {{project_name}}
	mv {{project_name}} {{target_dir}}
	valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all --tool=memcheck --vgdb=yes --vgdb-error=0 {{target_dir }}/{{project_name}}
 
# thread check(data race)
thread:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_thread}} {{source}} -o {{target}}
	{{target}}

# object file emit-file
obj:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_assembly}} -o {{target}} {{source}}
	mv *.ii {{target_dir}}
	mv *.o {{target_dir}}
	mv *.s {{target_dir}}
	mv *.bc {{target_dir}}
	objdump --disassemble -S -C {{target_dir}}/main.o

# hex view("rg -i <search>" | "grep -rni <search>")
[linux]
xx:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_valgrind}} {{source}} -o {{project_name}}
	xxd -c 16 {{project_name}} > hex_print.txt
	mv {{project_name}} hex_print.txt {{target_dir}}

# hex view("rg -i <search>" | "grep -rni <search>")
[macos]
xx:
	rm -rf target
	mkdir -p target
	{{clang_which}} {{ldflags_fsanitize_valgrind}} {{source}} -o {{project_name}}
	xxd -c 16 {{project_name}} > hex_print.txt
	mv {{project_name}} {{project_name}}.* hex_print.txt {{target_dir}}

# clean files
clean:
	rm -rf {{target_dir}} *.out {{src_dir}}/*.out *.bc {{src_dir}}/target/ *.dSYM {{src_dir}}/*.dSYM *.i *.o *.s
	rm -rf build CMakeCache.txt CMakeFiles .cache build.ninja cmake_install.cmake build debug

# C init(int main(void))
init:
	mkdir -p src
	echo '#include <stdio.h>' > src/main.c
	echo '' >> src/main.c
	echo 'int main(void) {' >> src/main.c
	echo '    printf("Hello world C lang ");' >> src/main.c
	echo '    return 0;' >> src/main.c
	echo '}' >> src/main.c
	echo '# BasedOnStyle: WebKit' > .clang-format
	echo '# LLVM, Google, Chromium, Mozilla, WebKit' >> .clang-format
	echo "" >> .clang-format
	echo 'BasedOnStyle: LLVM' >> .clang-format
	echo 'IndentWidth: 4' >> .clang-format
	echo 'ContinuationIndentWidth: 4' >> .clang-format
	echo 'IndentCaseLabels: false' >> .clang-format
	echo 'IndentCaseBlocks: false' >> .clang-format
	echo 'IndentGotoLabels: true' >> .clang-format
	echo 'IndentPPDirectives: None' >> .clang-format
	echo 'IndentExternBlock: NoIndent' >> .clang-format
	echo "" >> .clang-format
	echo 'ColumnLimit: 80' >> .clang-format
	echo 'cmake_minimum_required(VERSION 4.0)' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo 'set(CMAKE_C_STANDARD 23)' >> CMakeLists.txt
	echo 'set(CMAKE_C_STANDARD_REQUIRED ON)' >> CMakeLists.txt
	echo 'set(CMAKE_C_EXTENSIONS OFF)' >> CMakeLists.txt
	echo '# set(CMAKE_EXPORT_COMPILE_COMMANDS ON)' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo 'get_filename_component(ProjectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)' >> CMakeLists.txt
	echo 'string(REPLACE " " "_" ProjectId ${ProjectId})' >> CMakeLists.txt
	echo 'project(${ProjectId} LANGUAGES C)' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo '# Force GCC 15(LinuxOS)' >> CMakeLists.txt
	echo '# set(CMAKE_C_COMPILER "/opt/gcc-15/bin/gcc")' >> CMakeLists.txt
	echo '# Force GCC 15(macOS)' >> CMakeLists.txt
	echo '# set(CMAKE_C_COMPILER "/opt/homebrew/opt/gcc@15/bin/gcc-15")' >> CMakeLists.txt
	echo '# Force Clang 21(LinuxOS)' >> CMakeLists.txt
	echo '# set(CMAKE_C_COMPILER "/usr/bin/clang-21")' >> CMakeLists.txt
	echo '# Force Clang 21(macOS)' >> CMakeLists.txt
	echo '# set(CMAKE_CXX_COMPILER "/opt/homebrew/opt/llvm/bin/clang")' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo 'SET (CMAKE_C_FLAGS_INIT                "-Wall -std=c23")' >> CMakeLists.txt
	echo 'SET (CMAKE_C_FLAGS_DEBUG_INIT          "-g")' >> CMakeLists.txt
	echo 'SET (CMAKE_C_FLAGS_MINSIZEREL_INIT     "-Os -DNDEBUG")' >> CMakeLists.txt
	echo 'SET (CMAKE_C_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")' >> CMakeLists.txt
	echo 'SET (CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "-O2 -g")' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo 'SET (CMAKE_CXX_FLAGS_INIT                "-Wall -std=c++26")' >> CMakeLists.txt
	echo 'SET (CMAKE_CXX_FLAGS_DEBUG_INIT          "-g")' >> CMakeLists.txt
	echo 'SET (CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "-Os -DNDEBUG")' >> CMakeLists.txt
	echo 'SET (CMAKE_CXX_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")' >> CMakeLists.txt
	echo 'SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O2 -g")' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo '# Common compile flags' >> CMakeLists.txt
	echo 'add_compile_options(' >> CMakeLists.txt
	echo '    -pedantic' >> CMakeLists.txt
	echo '    -pthread' >> CMakeLists.txt
	echo '    -pedantic-errors' >> CMakeLists.txt
	echo '    -lm' >> CMakeLists.txt
	echo '    -Wall' >> CMakeLists.txt
	echo '    -Wextra' >> CMakeLists.txt
	echo '    -ggdb' >> CMakeLists.txt
	echo '    # -std=c23' >> CMakeLists.txt
	echo ')' >> CMakeLists.txt
	echo ''>> CMakeLists.txt
	echo '# Main executable with C sources' >> CMakeLists.txt
	echo 'add_executable(${ProjectId}' >> CMakeLists.txt
	echo '    src/main.c' >> CMakeLists.txt
	echo '    # src/mandelbrot.c' >> CMakeLists.txt
	echo ')' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo 'target_link_options(${ProjectId} PRIVATE -pthread -lm)' >> CMakeLists.txt
	echo '' >> CMakeLists.txt
	echo '# Output directory' >> CMakeLists.txt
	echo 'set_target_properties(${ProjectId} PROPERTIES' >> CMakeLists.txt
	echo '    RUNTIME_OUTPUT_DIRECTORY' >> CMakeLists.txt
	echo '       "${CMAKE_BINARY_DIR}/$<LOWER_CASE:$<CONFIG>>"' >> CMakeLists.txt
	echo ')' >> CMakeLists.txt
	echo '# General(macOS)' >> .gitignore
	echo '.DS_Store' >> .gitignore
	echo '' >> .gitignore
	echo '# build files' >> .gitignore
	echo 'debug' >> .gitignore
	echo 'justfile' >> .gitignore
	echo 'target' >> .gitignore
	echo 'build' >> .gitignore
	echo '# clangd' >> .gitignore
	echo '.cache' >> .gitignore
	echo '' >> .gitignore
	echo '# Prerequisites' >> .gitignore
	echo '*.d' >> .gitignore
	echo '' >> .gitignore
	echo '# Object files' >> .gitignore
	echo '*.o' >> .gitignore
	echo '*.ko' >> .gitignore
	echo '*.obj' >> .gitignore
	echo '*.elf' >> .gitignore
	echo '' >> .gitignore
	echo '# Linker output' >> .gitignore
	echo '*.ilk' >> .gitignore
	echo '*.map' >> .gitignore
	echo '*.exp' >> .gitignore
	echo '' >> .gitignore
	echo '# Precompiled Headers' >> .gitignore
	echo '*.gch' >> .gitignore
	echo '*.pch' >> .gitignore
	echo '' >> .gitignore
	echo '# Libraries' >> .gitignore
	echo '*.lib' >> .gitignore
	echo '*.a' >> .gitignore
	echo '*.la' >> .gitignore
	echo '*.lo' >> .gitignore
	echo '' >> .gitignore
	echo '# Shared objects (inc. Windows DLLs)' >> .gitignore
	echo '*.dll' >> .gitignore
	echo '*.so' >> .gitignore
	echo '*.so.*' >> .gitignore
	echo '*.dylib' >> .gitignore
	echo '' >> .gitignore
	echo '# Executables' >> .gitignore
	echo '*.exe' >> .gitignore
	echo '*.out' >> .gitignore
	echo '*.app' >> .gitignore
	echo '*.i*86' >> .gitignore
	echo '*.x86_64' >> .gitignore
	echo '*.hex' >> .gitignore
	echo '' >> .gitignore
	echo '# Debug files' >> .gitignore
	echo '*.dSYM/' >> .gitignore
	echo '*.su' >> .gitignore
	echo '*.idb' >> .gitignore
	echo '*.pdb' >> .gitignore
	echo '' >> .gitignore
	echo '# Kernel Module Compile Results' >> .gitignore
	echo '*.mod*' >> .gitignore
	echo '*.cmd' >> .gitignore
	echo '.tmp_versions/' >> .gitignore
	echo 'modules.order' >> .gitignore
	echo 'Module.symvers' >> .gitignore
	echo 'Mkfile.old' >> .gitignore
	echo 'dkms.conf' >> .gitignore
	echo '' >> .gitignore
	echo '# debug information files' >> .gitignore
	echo '*.dwo' >> .gitignore
 
# C init(int main(int argc, char* argv[]))
init2:
	mkdir -p src
	echo '# BasedOnStyle: WebKit' > .clang-format
	echo '# LLVM, Google, Chromium, Mozilla, WebKit' >> .clang-format
	echo "" >> .clang-format
	echo 'BasedOnStyle: WebKit' >> .clang-format
	echo 'IndentWidth: 4' >> .clang-format
	echo 'ContinuationIndentWidth: 4' >> .clang-format
	echo 'IndentCaseLabels: false' >> .clang-format
	echo 'IndentCaseBlocks: false' >> .clang-format
	echo 'IndentGotoLabels: true' >> .clang-format
	echo 'IndentPPDirectives: None' >> .clang-format
	echo 'IndentExternBlock: NoIndent' >> .clang-format
	echo '#include <stdio.h>' > src/main.c
	echo '' >> src/main.c
	echo 'int main(int argc, char* argv[]) {' >> src/main.c
	echo '    printf("Hello world C lang ");' >> src/main.c
	echo '    int i;' >> src/main.c
	echo '    ' >> src/main.c
	echo '    for (i=0; i < argc; i++) {' >> src/main.c
	echo '        printf("%s", argv[i]);' >> src/main.c
	echo '    }' >> src/main.c
	echo '    return 0;' >> src/main.c
	echo '}' >> src/main.c

# Debugging(VSCode codelldb ver)
codelldb:
	just cr
	rm -rf .vscode
	mkdir -p .vscode
	echo '{' > .vscode/launch.json
	echo '    "version": "0.2.0",' >> .vscode/launch.json
	echo '    "configurations": [' >> .vscode/launch.json
	echo '        {' >> .vscode/launch.json
	echo '            "type": "lldb",' >> .vscode/launch.json
	echo '            "request": "launch",' >> .vscode/launch.json
	echo '            "name": "Launch",' >> .vscode/launch.json
	echo '            "program": "${workspaceFolder}/target/debug/${fileWorkspaceFolderBasename}",' >> .vscode/launch.json
	echo '            "args": [],' >> .vscode/launch.json
	echo '            "cwd": "${workspaceFolder}"' >> .vscode/launch.json
	echo '            // "preLaunchTask": "C/C++: clang build active file"' >> .vscode/launch.json
	echo '        },' >> .vscode/launch.json
	echo '        {' >> .vscode/launch.json
	echo '            "name": "gcc - Build and debug active file",' >> .vscode/launch.json
	echo '            "type": "lldb",' >> .vscode/launch.json
	echo '            "request": "launch",' >> .vscode/launch.json
	echo '            "program": "${fileDirname}/target/debug/${fileWorkspaceFolderBasename}",' >> .vscode/launch.json
	echo '            "args": [],' >> .vscode/launch.json
	echo '            "stopAtEntry": false,' >> .vscode/launch.json
	echo '            "cwd": "${fileDirname}",' >> .vscode/launch.json
	echo '            "environment": [],' >> .vscode/launch.json
	echo '            "externalConsole": false,' >> .vscode/launch.json
	echo '            "MIMode": "lldb"' >> .vscode/launch.json
	echo '            // "tasks": "C/C++: clang build active file"' >> .vscode/launch.json
	echo '        }' >> .vscode/launch.json
	echo '    ]' >> .vscode/launch.json
	echo '}' >> .vscode/launch.json
	echo '{' > .vscode/tasks.json
	echo '    "tasks": [' >> .vscode/tasks.json
	echo '        {' >> .vscode/tasks.json
	echo '            "type": "C_Cpp_Build",' >> .vscode/tasks.json
	echo '            "label": "C/C++: clang build active file",' >> .vscode/tasks.json
	echo '            "command": "{{clang_which}}",' >> .vscode/tasks.json
	echo '            "args": [' >> .vscode/tasks.json
	echo '                "-c",' >> .vscode/tasks.json
	echo '                "-fcolor-diagnostics",' >> .vscode/tasks.json
	echo '                "-fansi-escape-codes",' >> .vscode/tasks.json
	echo '                "-g",' >> .vscode/tasks.json
	echo '                "${file}",' >> .vscode/tasks.json
	echo '                "-o",' >> .vscode/tasks.json
	echo '                "${fileDirname}/target/debug/${fileWorkspaceFolderBasename}"' >> .vscode/tasks.json
	echo '            ],' >> .vscode/tasks.json
	echo '            "options": {' >> .vscode/tasks.json
	echo '                "cwd": "${fileDirname}"' >> .vscode/tasks.json
	echo '            },' >> .vscode/tasks.json
	echo '            "problemMatcher": [' >> .vscode/tasks.json
	echo '                "$gcc"' >> .vscode/tasks.json
	echo '            ],' >> .vscode/tasks.json
	echo '            "group": {' >> .vscode/tasks.json
	echo '                "kind": "build",' >> .vscode/tasks.json
	echo '                "isDefault": true' >> .vscode/tasks.json
	echo '            },' >> .vscode/tasks.json
	echo '            "detail": "Task generated by Debugger."' >> .vscode/tasks.json
	echo '        }' >> .vscode/tasks.json
	echo '    ],' >> .vscode/tasks.json
	echo '    "version": "2.0.0"' >> .vscode/tasks.json
	echo '}' >> .vscode/tasks.json

# Debugging(VSCode)
vscode:
	just cr
	rm -rf .vscode
	mkdir -p .vscode
	echo '{' > .vscode/launch.json
	echo '    "version": "0.2.0",' >> .vscode/launch.json
	echo '    "configurations": [' >> .vscode/launch.json
	echo '        {' >> .vscode/launch.json
	echo '            "type": "lldb",' >> .vscode/launch.json
	echo '            "request": "launch",' >> .vscode/launch.json
	echo '            "name": "Launch",' >> .vscode/launch.json
	echo '            "program": "${workspaceFolder}/target/debug/${fileWorkspaceFolderBasename}",' >> .vscode/launch.json
	echo '            "args": [],' >> .vscode/launch.json
	echo '            "cwd": "${workspaceFolder}"' >> .vscode/launch.json
	echo '            // "preLaunchTask": "C/C++: clang build active file"' >> .vscode/launch.json
	echo '        },' >> .vscode/launch.json
	echo '        {' >> .vscode/launch.json
	echo '            "name": "gcc - Build and debug active file",' >> .vscode/launch.json
	echo '            "type": "cppdbg",' >> .vscode/launch.json
	echo '            "request": "launch",' >> .vscode/launch.json
	echo '            "program": "${fileDirname}/target/debug/${fileWorkspaceFolderBasename}",' >> .vscode/launch.json
	echo '            "args": [],' >> .vscode/launch.json
	echo '            "stopAtEntry": false,' >> .vscode/launch.json
	echo '            "cwd": "${fileDirname}",' >> .vscode/launch.json
	echo '            "environment": [],' >> .vscode/launch.json
	echo '            "externalConsole": false,' >> .vscode/launch.json
	echo '            "MIMode": "lldb"' >> .vscode/launch.json
	echo '            // "tasks": "C/C++: clang build active file"' >> .vscode/launch.json
	echo '        }' >> .vscode/launch.json
	echo '    ]' >> .vscode/launch.json
	echo '}' >> .vscode/launch.json
	echo '{' > .vscode/tasks.json
	echo '    "tasks": [' >> .vscode/tasks.json
	echo '        {' >> .vscode/tasks.json
	echo '            "type": "cppbuild",' >> .vscode/tasks.json
	echo '            "label": "C/C++: clang build active file",' >> .vscode/tasks.json
	echo '            "command": "{{clang_which}}",' >> .vscode/tasks.json
	echo '            "args": [' >> .vscode/tasks.json
	echo '                "-c",' >> .vscode/tasks.json
	echo '                "-fcolor-diagnostics",' >> .vscode/tasks.json
	echo '                "-fansi-escape-codes",' >> .vscode/tasks.json
	echo '                "-g",' >> .vscode/tasks.json
	echo '                "${file}",' >> .vscode/tasks.json
	echo '                "-o",' >> .vscode/tasks.json
	echo '                "${fileDirname}/target/debug/${fileBasenameNoExtension}"' >> .vscode/tasks.json
	echo '            ],' >> .vscode/tasks.json
	echo '            "options": {' >> .vscode/tasks.json
	echo '                "cwd": "${fileDirname}"' >> .vscode/tasks.json
	echo '            },' >> .vscode/tasks.json
	echo '            "problemMatcher": [' >> .vscode/tasks.json
	echo '                "$gcc"' >> .vscode/tasks.json
	echo '            ],' >> .vscode/tasks.json
	echo '            "group": {' >> .vscode/tasks.json
	echo '                "kind": "build",' >> .vscode/tasks.json
	echo '                "isDefault": true' >> .vscode/tasks.json
	echo '            },' >> .vscode/tasks.json
	echo '            "detail": "Task generated by Debugger."' >> .vscode/tasks.json
	echo '        }' >> .vscode/tasks.json
	echo '    ],' >> .vscode/tasks.json
	echo '    "version": "2.0.0"' >> .vscode/tasks.json
	echo '}' >> .vscode/tasks.json	

```
