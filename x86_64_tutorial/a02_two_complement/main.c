#include <stdio.h>

int main() {
  int a = 4;   // 0100
  int b = 1;   // 0001
  printf(" 4 - 1 = %d ", 4 + (~b +1));
  printf(" 4 -1 %d", a - b);
}