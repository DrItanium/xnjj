/* Copyright ©2007-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include <string.h>
#include "../x11.h"

uint
fillstring(Image *dst, Font *font,
	   Rectangle r, Align align,
	   const char *text, CTuple *col, int borderw) {

	fill(dst, r, &col->bg);
	if(borderw)
		border(dst, r, borderw, &col->border);
	return drawstring(dst, font, r, align, text, &col->fg);
}

uint
drawstring(Image *dst, Font *font,
	   Rectangle r, Align align,
	   const char *text, Color *col) {
	uint x;

	auto shortened = 0;

	uint len = strlen(text);
	char* buf = (char*)emalloc(len+1);
	memcpy(buf, text, len+1);

	r.max.y -= font->pad.min.y;
	r.min.y += font->pad.max.y;

	uint height = font->ascent + font->descent;
	uint y = r.min.y + Dy(r) / 2 - height / 2 + font->ascent;

	uint width = Dx(r) - font->pad.min.x - font->pad.max.x - (font->height & ~1);

	r.min.x += font->pad.min.x;
	r.max.x -= font->pad.max.x;

	/* shorten text if necessary */
	Rectangle tr = ZR;
	while(len > 0) {
		tr = textextents_l(font, buf, len + min(shortened, 3), nil);
		if(Dx(tr) <= width)
			break;
		while(len > 0 && (buf[--len]&0xC0) == 0x80)
			buf[len] = '.';
		buf[len] = '.';
		shortened++;
	}

	if(len == 0 || Dx(tr) > width)
		goto done;

	/* mark shortened info in the string */
	if(shortened)
		len += min(shortened, 3);

	switch (align) {
	case East:
		x = r.max.x - (tr.max.x + (font->height / 2));
		break;
	case Center:
		x = r.min.x + (Dx(r) - Dx(tr)) / 2 - tr.min.x;
		break;
	default:
		x = r.min.x + (font->height / 2) - tr.min.x;
		break;
	}

	setgccol(dst, col);
	switch(font->type) {
	case FFontSet:
		Xutf8DrawString(display, dst->xid,
				font->font.set, dst->gc,
				x, y,
				buf, len);
		break;
	case FXft:
		xft->drawstring((Display*)xftdrawable(dst), xftcolor(dst, col),
				font->font.xft,
				x, y, buf, len);
		break;
	case FX11:
		XSetFont(display, dst->gc, font->font.x11->fid);
		XDrawString(display, dst->xid, dst->gc,
			    x, y, buf, len);
		break;
	default:
		die("Invalid font type.");
	}

done:
	free(buf);
	return Dx(tr);
}
