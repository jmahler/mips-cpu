
/*
 * A general approximation of the values that should be produced
 * by main.asm.
 */

#include <string.h>
#include <stdio.h>

int main() {

	char buf[128];
	int a1, a2, a3;
	int t0, t1, t2, t3;

	printf("%.8x\n", 0);

	a1 = 3;
	a2 = 15792;
	a3 = 257;
	printf("%.8x\n", a1);
	printf("%.8x\n", a2);
	printf("%.8x\n", a3);

	printf("%.8x\n", 0);

	memcpy(buf+0, &a1, 4); printf("%.8x\n", 0);
	memcpy(buf+4, &a2, 4); printf("%.8x\n", 4);
	memcpy(buf+8, &a3, 4); printf("%.8x\n", 8);

	t0 = a1 ^ a2; printf("%.8x\n", t0);
	t1 = a1 & a2; printf("%.8x\n", t1);
	t2 = a1 | a2; printf("%.8x\n", t2);
	t3 = ~(a1 | a2); printf("%.8x\n", t3);

	printf("%.8x\n", 12);
	printf("%.8x\n", 16);
	printf("%.8x\n", 20);
	printf("%.8x\n", 24);

	// slt $t0, $a1, $a2  # 1
	t0 = a1 < a2;
	printf("%.8x\n", t0);

	printf("%.8x\n", 0);

	// lw
	memcpy(&t3, buf+8, 4); printf("%.8x\n", t3);
	memcpy(&t2, buf+4, 4); printf("%.8x\n", t2);
	memcpy(&t1, buf+0, 4); printf("%.8x\n", t1);

	printf("%.8x\n", 0);

	t3 = t0 + 12; printf("%.8x\n", t3);
	t2 = t2 ^ t2; printf("%.8x\n", t2);
	t1 = t0 + t3; printf("%.8x\n", t1);

	printf("%.8x\n", 0);
	printf("%.8x\n", 0);
	printf("%.8x\n", 0);

	t3 = t3 ^ t1; printf("%.8x\n", t3);

	printf("%.8x\n", 0);
	printf("%.8x\n", 0);
	printf("%.8x\n", 0);

	t3 = t3 + t1; printf("%.8x\n", t3);

	printf("%.8x\n", 0);
	printf("%.8x\n", 0);
	printf("%.8x\n", 0);

	t3 = t3 + 12; printf("%.8x\n", t3);

	printf("%.8x\n", 0);
	printf("%.8x\n", 0);
	printf("%.8x\n", 0);

	t3 = ~(t3 | t2); printf("%.8x\n", t3);

	printf("%.8x\n", 0);

	return 0;
}
