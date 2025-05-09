# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /root/lqc/aicas/llama/llama.cpp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /root/lqc/aicas/llama/llama.cpp/build

# Include any dependencies generated for this target.
include examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/compiler_depend.make

# Include the progress variables for this target.
include examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/progress.make

# Include the compile flags for this target's objects.
include examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/flags.make

examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o: examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/flags.make
examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o: /root/lqc/aicas/llama/llama.cpp/examples/llava/qwen2vl-cli.cpp
examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o: examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/root/lqc/aicas/llama/llama.cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o"
	cd /root/lqc/aicas/llama/llama.cpp/build/examples/llava && ccache /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o -MF CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o.d -o CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o -c /root/lqc/aicas/llama/llama.cpp/examples/llava/qwen2vl-cli.cpp

examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.i"
	cd /root/lqc/aicas/llama/llama.cpp/build/examples/llava && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /root/lqc/aicas/llama/llama.cpp/examples/llava/qwen2vl-cli.cpp > CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.i

examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.s"
	cd /root/lqc/aicas/llama/llama.cpp/build/examples/llava && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /root/lqc/aicas/llama/llama.cpp/examples/llava/qwen2vl-cli.cpp -o CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.s

# Object files for target llama-qwen2vl-cli
llama__qwen2vl__cli_OBJECTS = \
"CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o"

# External object files for target llama-qwen2vl-cli
llama__qwen2vl__cli_EXTERNAL_OBJECTS = \
"/root/lqc/aicas/llama/llama.cpp/build/examples/llava/CMakeFiles/llava.dir/llava.cpp.o" \
"/root/lqc/aicas/llama/llama.cpp/build/examples/llava/CMakeFiles/llava.dir/clip.cpp.o"

bin/llama-qwen2vl-cli: examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/qwen2vl-cli.cpp.o
bin/llama-qwen2vl-cli: examples/llava/CMakeFiles/llava.dir/llava.cpp.o
bin/llama-qwen2vl-cli: examples/llava/CMakeFiles/llava.dir/clip.cpp.o
bin/llama-qwen2vl-cli: examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/build.make
bin/llama-qwen2vl-cli: common/libcommon.a
bin/llama-qwen2vl-cli: bin/libllama.so
bin/llama-qwen2vl-cli: bin/libggml.so
bin/llama-qwen2vl-cli: bin/libggml-cpu.so
bin/llama-qwen2vl-cli: bin/libggml-base.so
bin/llama-qwen2vl-cli: examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/root/lqc/aicas/llama/llama.cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../bin/llama-qwen2vl-cli"
	cd /root/lqc/aicas/llama/llama.cpp/build/examples/llava && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/llama-qwen2vl-cli.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/build: bin/llama-qwen2vl-cli
.PHONY : examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/build

examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/clean:
	cd /root/lqc/aicas/llama/llama.cpp/build/examples/llava && $(CMAKE_COMMAND) -P CMakeFiles/llama-qwen2vl-cli.dir/cmake_clean.cmake
.PHONY : examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/clean

examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/depend:
	cd /root/lqc/aicas/llama/llama.cpp/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /root/lqc/aicas/llama/llama.cpp /root/lqc/aicas/llama/llama.cpp/examples/llava /root/lqc/aicas/llama/llama.cpp/build /root/lqc/aicas/llama/llama.cpp/build/examples/llava /root/lqc/aicas/llama/llama.cpp/build/examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : examples/llava/CMakeFiles/llama-qwen2vl-cli.dir/depend

