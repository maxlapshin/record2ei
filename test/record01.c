#include "record01_ei.h"

#include "main.c"

void handle(char *buf, int size) {
  int idx = 0;
  int version = 0;
  ei_decode_version(buf, &idx, &version);

  struct record01 *rec = read_record01(buf, &idx);
  if(!rec) exit(8);

  rec->value = rec->value + 42;

  ei_x_buff x;
  ei_x_new_with_version(&x);
  write_record01(&x, *rec);
  write_x(&x);
  ei_x_free(&x);
}
