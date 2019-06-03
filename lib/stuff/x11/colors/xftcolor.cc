/* Copyright ©2007-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include "../x11.h"

XftColor*
xftcolor(Image *i, Color *c) {

	XftColor* xc = emallocz<XftColor>(sizeof(*c));
	*xc = (XftColor){ pixelvalue(i, c), c->red, c->green, c->blue, c->alpha };
	return (XftColor*)freelater(xc);
}
