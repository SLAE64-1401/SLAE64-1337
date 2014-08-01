#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "polarssl/include/aes.h"
#include "polarssl/include/sha256.h"

#include "polarssl/include/sha1.h"

int main()
{
unsigned char password[] = "494848" ;

size_t pass_len = 6 ;

unsigned char key[32];

size_t input_len = 64;

int i = 0;

sha256_context sha256_ctx;
sha256_starts(&sha256_ctx, 0);
sha256_update(&sha256_ctx, password, pass_len);
sha256_finish(&sha256_ctx, key);

for(i = 0 ; i < 32 ; i++){
printf("\\x%x" , key[i] );};
return 0;
}