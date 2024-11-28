format elf64 executable
entry _start

segment readable executable
include "interface.asm"
_start:
        mov rsi, strings.welcome_message       
        call _putstr
        cmp qword [rsp], 0x02
        je .C0
        mov rax, 0x01
        mov rsi, strings.err_inv_args
        call _error
.C0:
        lea rbp, [rsp+8]
.options:
        mov rsi, [rbp+8]
        mov rdi, strings.type_values.help
        call _streq
        jz .help
        mov rdi, strings.type_values.C
        call _streq
        jz .C
        mov rdi, strings.type_values.CM
        call _streq
        jz .CM
        mov rdi, strings.type_values.CB
        call _streq
        jz .CB

        mov rax, 0x02
        mov rsi, strings.err_inv_type
        call _error
.help:
        mov rsi, strings.help_menu
        call _putstr
        jmp .succ_exit
.C:
        call .simple_1_format
        call .simple_1_main_c
        mov rax, 0x02
        mov rdi, strings.paths.Makefile
        mov rsi, 0x41 ; WRONLY | CREAT
        mov rdx, 0x1B6 ; +RW -X
        syscall
        push rax
        mov rsi, strings.templates.Makefile
        call _fputstr
        pop rdi
        mov rax, 0x03
        syscall
        jmp .succ_exit
.CM:
        call .simple_1_format
        call .simple_1_main_c
        mov rax, 0x02
        mov rdi, strings.paths.CMakeLists.txt
        mov rsi, 0x41
        mov rdx, 0x1B6
        syscall
        push rax
        mov rsi, strings.templates.CMakeLists.txt
        call _fputstr
        pop rdi
        mov rax, 0x03
        syscall
        jmp .succ_exit
.CB:
        call .simple_1_format
        call .simple_1_main_c
        mov rax, 0x02
        mov rdi, strings.paths.make.sh
        mov rsi, 0x41
        mov rdx, 0x1FF
        syscall
        push rax
        mov rsi, strings.templates.make.sh
        call _fputstr
        pop rdi
        mov rax, 0x03
        syscall
        jmp .succ_exit

.simple_1_format:
        mov rax, 0x53
        mov rdi, strings.paths.src
        mov rsi, 0x1FF
        syscall
        mov rax, 0x53
        mov rdi, strings.paths.build
        mov rsi, 0x1FF
        syscall
        mov rax, 0x02
        mov rdi, strings.paths.README.md
        mov rsi, 0x41 ; WRONLY | CREAT
        mov rdx, 0x1B6 ; +RW -X
        syscall
        mov rdi, rax
        mov rax, 0x03
        syscall
        ret
.simple_1_main_c:
        mov rax, 0x02
        mov rdi, strings.paths.main.c
        mov rsi, 0x41 ; WRONLY | CREAT
        mov rdx, 0x1B6 ; +RW -X
        syscall
        push rax
        mov rsi, strings.templates.C
        call _fputstr
        pop rdi
        mov rax, 0x03
        syscall
        ret

.succ_exit:
        mov rax, 0x00
        call _exit

segment readable
strings:
.welcome_message: db "NPJ (1.0)", 0x0A, 0x00
.help_menu:
        db "Help menu:", 0x0A
        db "Usage: npj <type>", 0x0A
        db "Type may be one of the following:", 0x0A
        db 0x09, "`-h` open this menu", 0x0A
        db 0x09, "`C` create a Makefile C project", 0x0A
        db 0x09, "`CM` create a CMake C project", 0x0A
        db 0x09, "`CB` create a make.sh C project", 0x0A
        db 0x00
.err_inv_args: db "Usage: npj <type>", 0x0A, 0x00
.err_inv_type: db "Invalid project type, use `npj -h` for help", 0x0A, 0x00

strings.type_values:
.help: db "-h", 0x00
.C: db "C", 0x00
.CM: db "CM", 0x00
.CB: db "CB", 0x00

strings.paths:
.src: db "./src", 0x00
.build: db "./build", 0x00
.Makefile: db "./Makefile", 0x00
.README.md: db "./README.md", 0x00
.main.c: db "./src/main.c", 0x00
.CMakeLists.txt: db "./CMakeLists.txt", 0x00
.make.sh: db "./make.sh", 0x00

strings.templates:
.Makefile:
        db "ifeq ($(origin CC), default)", 0x0A, 0x0D
        db "CC = gcc", 0x0A, 0x0D
        db "endif", 0x0A, 0x0D
        db "CFLAGS ?= -std=c89 -Wpedantic", 0x0A, 0x0D, 0x0A, 0x0D
        db "all: build/main", 0x0D, 0x0A, 0x0D, 0x0A
        db "build/main: src/main.c", 0x0D, 0x0A
        db 0x09, "$(CC) -o $@ $^ $(CFLAGS)", 0x0D, 0x0A
        db 0x00
.C:
        db "#include <stdio.h>", 0x0D, 0x0A
        db "int main(int argc, char **argv) {", 0x0D, 0x0A
        db "    printf(", 0x22, "Hello World!\n", 0x22, ");", 0x0D, 0x0A
        db "}", 0x0D, 0x0A
        db 0x00
.CMakeLists.txt:
        db "cmake_minimum_required(VERSION 3.21)", 0x0A, 0x0D
        db "project(", 0x0A, 0x0D
        db 0x09, 0x22, "project_name", 0x22, 0x0A, 0x0D
        db 0x09, "DESCRIPTION ", 0x22, "project_description", 0x22, 0x0A, 0x0D
        db 0x09, "VERSION 0.1", 0x0A, 0x0D
        db 0x09, "LANGUAGES C", 0x0A, 0x0D
        db ")", 0x0A, 0x0D
        db "add_executable(", 0x0A, 0x0D
        db 0x09, "main", 0x0A, 0x0D
        db 0x09, "src/main.c", 0x0A, 0x0D
        db ")", 0x0A, 0x0D
        db "set_property(", 0x0A, 0x0D
        db 0x09, "TARGET main", 0x0A, 0x0D
        db 0x09, "PROPERTY C_STANDARD 90", 0x0A, 0x0D
        db ")", 0x0A, 0x0D
        db 0x00
.make.sh:
        db "gcc -o build/main src/main.c -std=c90 -Wpedantic", 0x0A
        db 0x00
