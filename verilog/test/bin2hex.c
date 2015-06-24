/*
 * NAME
 *
 * bin2hex
 *
 * DESCRIPTION
 *
 * Given a binary file, convert each byte to ascii hex, with one word
 * per line.
 *
 *   bin2hex t0001-no_hazard.elf > t0001-no_hazard.hex
 *
 * Verilog simulators can read ascii hex values but not binary.  This
 * program does this conversion so it can be used with Verilog.
 *
 * AUTHOR
 *
 * Jeremiah Mahler <jmmahler@gmail.com>
 *
 */

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	uint8_t byte;
	int inputfd;
	ssize_t len;
	int n;
	int byte_nl = 4;  /* break with newline every 4 bytes */

	if (2 != argc) {
		fprintf(stderr, "usage: %s <bin file> > <out file>\n", argv[0]);
		return 1;
	}

	inputfd = open(argv[1], O_RDONLY);
	if (inputfd < 0) {
		perror("open");
		return 1;
	}

	n = 1;
	while (1) {
		len = read(inputfd, &byte, sizeof(byte));
		if (len < 0) {
			perror("read");
			return 1;
		} else if (0 == len) {
			break;
		}

		printf("%02X", byte);

		/* add newline every byte_nl bytes */
		if (0 == n % byte_nl) {
			printf("\n");
		}

		n++;
	}

	close(inputfd);

	return 0;
}
