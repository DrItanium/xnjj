/* Copyright ©2007-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include "../x11.h"

Window*
window(XWindow xw) {
    auto w = emallocz<Window>();
	w->type = WWindow;
	w->xid = xw;
	return (decltype(w))freelater(w);
}
