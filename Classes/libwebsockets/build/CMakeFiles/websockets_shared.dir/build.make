# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/2.8.10.2/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/2.8.10.2/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/local/Cellar/cmake/2.8.10.2/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/edwardzhou/install/libwebsockets

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/edwardzhou/install/libwebsockets/build

# Include any dependencies generated for this target.
include CMakeFiles/websockets_shared.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/websockets_shared.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/websockets_shared.dir/flags.make

CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o: ../lib/base64-decode.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/base64-decode.c

CMakeFiles/websockets_shared.dir/lib/base64-decode.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/base64-decode.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/base64-decode.c > CMakeFiles/websockets_shared.dir/lib/base64-decode.c.i

CMakeFiles/websockets_shared.dir/lib/base64-decode.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/base64-decode.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/base64-decode.c -o CMakeFiles/websockets_shared.dir/lib/base64-decode.c.s

CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.requires

CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.provides: CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.provides

CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o

CMakeFiles/websockets_shared.dir/lib/handshake.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/handshake.c.o: ../lib/handshake.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/handshake.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/handshake.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/handshake.c

CMakeFiles/websockets_shared.dir/lib/handshake.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/handshake.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/handshake.c > CMakeFiles/websockets_shared.dir/lib/handshake.c.i

CMakeFiles/websockets_shared.dir/lib/handshake.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/handshake.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/handshake.c -o CMakeFiles/websockets_shared.dir/lib/handshake.c.s

CMakeFiles/websockets_shared.dir/lib/handshake.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/handshake.c.o.requires

CMakeFiles/websockets_shared.dir/lib/handshake.c.o.provides: CMakeFiles/websockets_shared.dir/lib/handshake.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/handshake.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/handshake.c.o.provides

CMakeFiles/websockets_shared.dir/lib/handshake.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/handshake.c.o

CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o: ../lib/libwebsockets.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/libwebsockets.c

CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/libwebsockets.c > CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.i

CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/libwebsockets.c -o CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.s

CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.requires

CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.provides: CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.provides

CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o

CMakeFiles/websockets_shared.dir/lib/output.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/output.c.o: ../lib/output.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/output.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/output.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/output.c

CMakeFiles/websockets_shared.dir/lib/output.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/output.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/output.c > CMakeFiles/websockets_shared.dir/lib/output.c.i

CMakeFiles/websockets_shared.dir/lib/output.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/output.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/output.c -o CMakeFiles/websockets_shared.dir/lib/output.c.s

CMakeFiles/websockets_shared.dir/lib/output.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/output.c.o.requires

CMakeFiles/websockets_shared.dir/lib/output.c.o.provides: CMakeFiles/websockets_shared.dir/lib/output.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/output.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/output.c.o.provides

CMakeFiles/websockets_shared.dir/lib/output.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/output.c.o

CMakeFiles/websockets_shared.dir/lib/parsers.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/parsers.c.o: ../lib/parsers.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_5)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/parsers.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/parsers.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/parsers.c

CMakeFiles/websockets_shared.dir/lib/parsers.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/parsers.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/parsers.c > CMakeFiles/websockets_shared.dir/lib/parsers.c.i

CMakeFiles/websockets_shared.dir/lib/parsers.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/parsers.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/parsers.c -o CMakeFiles/websockets_shared.dir/lib/parsers.c.s

CMakeFiles/websockets_shared.dir/lib/parsers.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/parsers.c.o.requires

CMakeFiles/websockets_shared.dir/lib/parsers.c.o.provides: CMakeFiles/websockets_shared.dir/lib/parsers.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/parsers.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/parsers.c.o.provides

CMakeFiles/websockets_shared.dir/lib/parsers.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/parsers.c.o

CMakeFiles/websockets_shared.dir/lib/sha-1.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/sha-1.c.o: ../lib/sha-1.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_6)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/sha-1.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/sha-1.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/sha-1.c

CMakeFiles/websockets_shared.dir/lib/sha-1.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/sha-1.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/sha-1.c > CMakeFiles/websockets_shared.dir/lib/sha-1.c.i

CMakeFiles/websockets_shared.dir/lib/sha-1.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/sha-1.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/sha-1.c -o CMakeFiles/websockets_shared.dir/lib/sha-1.c.s

CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.requires

CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.provides: CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.provides

CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/sha-1.c.o

CMakeFiles/websockets_shared.dir/lib/client.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/client.c.o: ../lib/client.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_7)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/client.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/client.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/client.c

CMakeFiles/websockets_shared.dir/lib/client.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/client.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/client.c > CMakeFiles/websockets_shared.dir/lib/client.c.i

CMakeFiles/websockets_shared.dir/lib/client.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/client.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/client.c -o CMakeFiles/websockets_shared.dir/lib/client.c.s

CMakeFiles/websockets_shared.dir/lib/client.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/client.c.o.requires

CMakeFiles/websockets_shared.dir/lib/client.c.o.provides: CMakeFiles/websockets_shared.dir/lib/client.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/client.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/client.c.o.provides

CMakeFiles/websockets_shared.dir/lib/client.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/client.c.o

CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o: ../lib/client-handshake.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_8)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/client-handshake.c

CMakeFiles/websockets_shared.dir/lib/client-handshake.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/client-handshake.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/client-handshake.c > CMakeFiles/websockets_shared.dir/lib/client-handshake.c.i

CMakeFiles/websockets_shared.dir/lib/client-handshake.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/client-handshake.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/client-handshake.c -o CMakeFiles/websockets_shared.dir/lib/client-handshake.c.s

CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.requires

CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.provides: CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.provides

CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o

CMakeFiles/websockets_shared.dir/lib/client-parser.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/client-parser.c.o: ../lib/client-parser.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_9)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/client-parser.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/client-parser.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/client-parser.c

CMakeFiles/websockets_shared.dir/lib/client-parser.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/client-parser.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/client-parser.c > CMakeFiles/websockets_shared.dir/lib/client-parser.c.i

CMakeFiles/websockets_shared.dir/lib/client-parser.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/client-parser.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/client-parser.c -o CMakeFiles/websockets_shared.dir/lib/client-parser.c.s

CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.requires

CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.provides: CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.provides

CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/client-parser.c.o

CMakeFiles/websockets_shared.dir/lib/server.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/server.c.o: ../lib/server.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_10)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/server.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/server.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/server.c

CMakeFiles/websockets_shared.dir/lib/server.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/server.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/server.c > CMakeFiles/websockets_shared.dir/lib/server.c.i

CMakeFiles/websockets_shared.dir/lib/server.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/server.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/server.c -o CMakeFiles/websockets_shared.dir/lib/server.c.s

CMakeFiles/websockets_shared.dir/lib/server.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/server.c.o.requires

CMakeFiles/websockets_shared.dir/lib/server.c.o.provides: CMakeFiles/websockets_shared.dir/lib/server.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/server.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/server.c.o.provides

CMakeFiles/websockets_shared.dir/lib/server.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/server.c.o

CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o: ../lib/server-handshake.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_11)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/server-handshake.c

CMakeFiles/websockets_shared.dir/lib/server-handshake.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/server-handshake.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/server-handshake.c > CMakeFiles/websockets_shared.dir/lib/server-handshake.c.i

CMakeFiles/websockets_shared.dir/lib/server-handshake.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/server-handshake.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/server-handshake.c -o CMakeFiles/websockets_shared.dir/lib/server-handshake.c.s

CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.requires

CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.provides: CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.provides

CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o

CMakeFiles/websockets_shared.dir/lib/extension.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/extension.c.o: ../lib/extension.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_12)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/extension.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/extension.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/extension.c

CMakeFiles/websockets_shared.dir/lib/extension.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/extension.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/extension.c > CMakeFiles/websockets_shared.dir/lib/extension.c.i

CMakeFiles/websockets_shared.dir/lib/extension.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/extension.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/extension.c -o CMakeFiles/websockets_shared.dir/lib/extension.c.s

CMakeFiles/websockets_shared.dir/lib/extension.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/extension.c.o.requires

CMakeFiles/websockets_shared.dir/lib/extension.c.o.provides: CMakeFiles/websockets_shared.dir/lib/extension.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/extension.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/extension.c.o.provides

CMakeFiles/websockets_shared.dir/lib/extension.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/extension.c.o

CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o: ../lib/extension-deflate-frame.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_13)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/extension-deflate-frame.c

CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/extension-deflate-frame.c > CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.i

CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/extension-deflate-frame.c -o CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.s

CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.requires

CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.provides: CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.provides

CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o

CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o: ../lib/extension-deflate-stream.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_14)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/extension-deflate-stream.c

CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/extension-deflate-stream.c > CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.i

CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/extension-deflate-stream.c -o CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.s

CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.requires

CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.provides: CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.provides

CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o

CMakeFiles/websockets_shared.dir/lib/daemonize.c.o: CMakeFiles/websockets_shared.dir/flags.make
CMakeFiles/websockets_shared.dir/lib/daemonize.c.o: ../lib/daemonize.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/edwardzhou/install/libwebsockets/build/CMakeFiles $(CMAKE_PROGRESS_15)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/websockets_shared.dir/lib/daemonize.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/websockets_shared.dir/lib/daemonize.c.o   -c /Users/edwardzhou/install/libwebsockets/lib/daemonize.c

CMakeFiles/websockets_shared.dir/lib/daemonize.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/websockets_shared.dir/lib/daemonize.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/edwardzhou/install/libwebsockets/lib/daemonize.c > CMakeFiles/websockets_shared.dir/lib/daemonize.c.i

CMakeFiles/websockets_shared.dir/lib/daemonize.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/websockets_shared.dir/lib/daemonize.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/edwardzhou/install/libwebsockets/lib/daemonize.c -o CMakeFiles/websockets_shared.dir/lib/daemonize.c.s

CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.requires:
.PHONY : CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.requires

CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.provides: CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.requires
	$(MAKE) -f CMakeFiles/websockets_shared.dir/build.make CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.provides.build
.PHONY : CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.provides

CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.provides.build: CMakeFiles/websockets_shared.dir/lib/daemonize.c.o

# Object files for target websockets_shared
websockets_shared_OBJECTS = \
"CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o" \
"CMakeFiles/websockets_shared.dir/lib/handshake.c.o" \
"CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o" \
"CMakeFiles/websockets_shared.dir/lib/output.c.o" \
"CMakeFiles/websockets_shared.dir/lib/parsers.c.o" \
"CMakeFiles/websockets_shared.dir/lib/sha-1.c.o" \
"CMakeFiles/websockets_shared.dir/lib/client.c.o" \
"CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o" \
"CMakeFiles/websockets_shared.dir/lib/client-parser.c.o" \
"CMakeFiles/websockets_shared.dir/lib/server.c.o" \
"CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o" \
"CMakeFiles/websockets_shared.dir/lib/extension.c.o" \
"CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o" \
"CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o" \
"CMakeFiles/websockets_shared.dir/lib/daemonize.c.o"

# External object files for target websockets_shared
websockets_shared_EXTERNAL_OBJECTS =

lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/handshake.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/output.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/parsers.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/sha-1.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/client.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/client-parser.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/server.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/extension.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/lib/daemonize.c.o
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/build.make
lib/libwebsockets.dylib: /usr/lib/libz.dylib
lib/libwebsockets.dylib: /usr/lib/libssl.dylib
lib/libwebsockets.dylib: /usr/lib/libcrypto.dylib
lib/libwebsockets.dylib: CMakeFiles/websockets_shared.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking C shared library lib/libwebsockets.dylib"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/websockets_shared.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/websockets_shared.dir/build: lib/libwebsockets.dylib
.PHONY : CMakeFiles/websockets_shared.dir/build

CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/base64-decode.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/handshake.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/libwebsockets.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/output.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/parsers.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/sha-1.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/client.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/client-handshake.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/client-parser.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/server.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/server-handshake.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/extension.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/extension-deflate-frame.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/extension-deflate-stream.c.o.requires
CMakeFiles/websockets_shared.dir/requires: CMakeFiles/websockets_shared.dir/lib/daemonize.c.o.requires
.PHONY : CMakeFiles/websockets_shared.dir/requires

CMakeFiles/websockets_shared.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/websockets_shared.dir/cmake_clean.cmake
.PHONY : CMakeFiles/websockets_shared.dir/clean

CMakeFiles/websockets_shared.dir/depend:
	cd /Users/edwardzhou/install/libwebsockets/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/edwardzhou/install/libwebsockets /Users/edwardzhou/install/libwebsockets /Users/edwardzhou/install/libwebsockets/build /Users/edwardzhou/install/libwebsockets/build /Users/edwardzhou/install/libwebsockets/build/CMakeFiles/websockets_shared.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/websockets_shared.dir/depend

