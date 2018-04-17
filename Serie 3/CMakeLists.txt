cmake_minimum_required(VERSION 3.10)
project(Serie_3 C)

set(CMAKE_C_STANDARD 11)

include_directories(skeleton)

add_executable(Serie_3
        skeleton/compile.c
        skeleton/compiler.c
        skeleton/compiler.h
        skeleton/memory.c
        skeleton/memory.h
        skeleton/mips.c
        skeleton/mips.h
        skeleton/test.c)
