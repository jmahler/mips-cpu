
/*
 * Convert a binary file to
 * an ascii hex file suitable for
 * $readmemh.
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <stdio.h>
#include <unistd.h>
#include <stdint.h>

int main(int argc, char** argv) {

	int fd;
	uint32_t word;

	if (argc != 2)
		printf("usage: a.out <bin file>\n");

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		printf("Unable to open file\n");
	}

	while (0 < read(fd, &word, sizeof(word))) {
		printf("%08x\n", word);
	}

	return 0;
}
