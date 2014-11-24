
void main(void) {
	register int x asm("t0") = 0x100f;
	register int y asm("t1") = 0x10f0;
	register int z asm("t2");

	z = x | y;
}
