/* Copyright ©2007-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include <string.h>
#include "../x11.h"

char**
strlistdup(char *list[]) {
	char **p;
	char *q;

	auto n = 0;
	auto m = 0;
	for(p=list; *p; p++, n++) {
		m += strlen(*p) + 1;
    }

	p = (char**)malloc((n+1) * sizeof(*p) + m);
	q = (char*)&p[n+1];

	for(auto i=0; i < n; i++) {
		p[i] = q;
		m = strlen(list[i]) + 1;
		memcpy(q, list[i], m);
		q += m;
	}
	p[n] = nil;
	return p;
}
