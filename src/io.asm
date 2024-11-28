
_strlen: ; rsi: str
        xor rax, rax
.loop:
        cmp byte [rsi+rax], 0x00
        jz .eloop
        inc rax
        jmp .loop
.eloop:
        ret

_streq: ; rsi: str, rdi: str
        mov rax, 0x00
.loop:
        mov cl, [rsi+rax]
        or cl, cl
        jz .eloop
        cmp byte [rdi+rax], 0x00
        je .eloop
        cmp cl, [rdi+rax]
        jne .eloop
        inc rax
        jmp .loop
.eloop:
        mov r12, 0x01
        xor r11, r11
        cmp cl, [rdi+rax]
        cmovne r11, r12
        mov rax, r11
        ret
_fputstr: ; rax: fd, rsi: str
        push rdi
        push rdx
        mov rdi, rax
        call _strlen
        mov rdx, rax
        mov rax, 0x01
        syscall
        pop rdx
        pop rdi
        ret

_putstr: ; rsi: str
        mov rax, 0x01
        call _fputstr
        ret

