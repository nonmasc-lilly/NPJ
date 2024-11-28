_exit: ; rax: byte
        mov rdi, rax
        mov rax, 0x3C
        syscall
        hlt ; crash on return

_error: ; rax: byte, rsi: str
        push rax
        call _putstr
        pop rax
        call _exit
