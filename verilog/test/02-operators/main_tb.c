
#include <stdio.h>
#include <stdint.h>

int main() {
	uint32_t x1 = 1;
	uint32_t x2 = 3;
	uint32_t x3 = 5;
	uint32_t x4 = 7;

	printf("%X\n", x1 ^ x2);
	printf("%X\n", x1 & x2);
	printf("%X\n", x1 | x2);
	printf("%X\n", ~(x1 | x2));
	printf("%X\n", x1 < x2);
	printf("%X\n", x1 + x2);
}
