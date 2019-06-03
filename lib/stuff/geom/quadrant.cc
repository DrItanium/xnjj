/* Copyright ©2006-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include <stuff/geom.h>

Align
quadrant(Rectangle r, Point pt) {

	pt = subpt(pt, r.min);
	int ret = (int)East  * (pt.x >= Dx(r) * .7)
	    | (int)West  * (pt.x <= Dx(r) * .3)
	    | (int)South * (pt.y >= Dy(r) * .7)
	    | (int)North * (pt.y <= Dy(r) * .3);

	return Align(ret);
}
