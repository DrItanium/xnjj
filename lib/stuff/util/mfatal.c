/* Written by Kris Maglione <maglione.k at Gmail> */
/* Public domain */
#include <string.h>
#include <unistd.h>
#include "util.h"

/* Can't malloc */
void
mfatal(char *name, uint size) {
	const char
		couldnot[] = ": fatal: Could not ",
		paren[] = "() ",
		bytes[] = " bytes\n";
	char buf[1024];
	char sizestr[8];
	int i;

	i = sizeof sizestr;
	do {
		sizestr[--i] = '0' + (size%10);
		size /= 10;
	} while(size > 0);

	stuff_strlcat(buf, argv0, sizeof buf);
	stuff_strlcat(buf, couldnot, sizeof buf);
	stuff_strlcat(buf, name, sizeof buf);
	stuff_strlcat(buf, paren, sizeof buf);
	stuff_strlcat(buf, sizestr+i, sizeof buf);
	stuff_strlcat(buf, bytes, sizeof buf);
	write(2, buf, strlen(buf));

	exit(1);
}
