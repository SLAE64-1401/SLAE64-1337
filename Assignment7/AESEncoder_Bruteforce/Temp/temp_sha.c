#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "polarssl/include/aes.h"
#include "polarssl/include/sha256.h"

#include "polarssl/include/sha1.h"

int main()
{
const unsigned char password[] = "494848" ;

size_t pass_len = 6 ;

unsigned char key[20];

int i = 0;

 sha1_context sha_ctx;
sha1_starts(&sha_ctx);
sha1_update(&sha_ctx, password, pass_len);
sha1_finish(&sha_ctx, key);

for(i = 0 ; i < 20 ; i++){
printf("\\x%x" , key[i] );};
return 0;
}