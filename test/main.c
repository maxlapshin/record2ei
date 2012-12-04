#include <arpa/inet.h>
#include <stdlib.h>
#include <unistd.h>

void handle(char *buffer, int size);

int main(void) {
  int32_t size;
  char *buffer = NULL;

  while(1) {
    if(read(0, &size, 4) != 4) exit(5);
    size = ntohl(size);

    buffer = (char *)malloc(size);
    int s = 0;
    while(s < size) {
      int r;
      r = read(0, buffer + s, size - s);
      if(r == 0) exit(0);
      if(r < 0) exit(7);
      s += r;
    }
    handle(buffer, size);
    free(buffer);
  }
}


void write_x(ei_x_buff *x) {
  uint32_t len = htonl(x->buffsz);
  write(1, &len, 4);
  write(1, x->buff, x->buffsz);
}
