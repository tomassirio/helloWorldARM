#include <unistd.h>

void main() {
  const char msg[] = "Hello, ARM!\n";
  write(0, msg, sizeof(msg));
  exit(0);
}
