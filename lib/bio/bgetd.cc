#include "plan9.h"
#include <bio.h>

struct	bgetd
{
	Biobuf*	b;
	int		eof;
};

static int
Bgetdf(void *vp)
{
	int c;
	bgetd *bg = (bgetd*)vp;

	c = Bgetc(bg->b);
	if(c == Beof)
		bg->eof = 1;
	return c;
}

int
Bgetd(Biobuf *bp, double *dp)
{
	double d;
	bgetd b;

	b.b = bp;
	b.eof = 0;
	d = fmtcharstod(Bgetdf, &b);
	if(b.eof)
		return -1;
	Bungetc(bp);
	*dp = d;
	return 1;
}
