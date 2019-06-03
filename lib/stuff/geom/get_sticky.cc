/* Copyright ©2006-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include <stuff/geom.h>

Align
get_sticky(Rectangle src, Rectangle dst) {
	int corner = 0;
	if(src.min.x != dst.min.x
	&& src.max.x == dst.max.x)
		corner |= (int)East;
	else
		corner |= (int)West;

	if(src.min.y != dst.min.y
	&& src.max.y == dst.max.y)
		corner |= (int)South;
	else
		corner |= (int)North;

	return Align(corner);
}
