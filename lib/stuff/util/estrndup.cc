/* Written by Kris Maglione <maglione.k at Gmail> */
/* Public domain */
#include <string.h>
#include "util.h"

char*
estrndup(const char *str, uint len) {
	len = min(len, strlen(str));
	char* ret = (char*)emalloc(len + 1);
	memcpy(ret, str, len);
	ret[len] = '\0';
	return (char*)ret;
}
