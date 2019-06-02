/* Written by Kris Maglione <maglione.k at Gmail> */
/* Public domain */
#include <string.h>
#include "util.h"

void*
_emallocz(uint size) {
	void *ret = emalloc(size);
	memset(ret, 0, size);
	return ret;
}
