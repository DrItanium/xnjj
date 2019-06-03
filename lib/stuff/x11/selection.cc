/* Copyright ©2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include "x11.h"

Handlers* getHandlers();

typedef struct Data	Data;

struct Data {
	long	selection;
	void	(*callback)(void*, char*);
	void*	aux;
};

static bool
_getselection(Window *w, long selection, char *type) {
	XConvertSelection(display, selection, xatom(type),
			  selection, w->xid, CurrentTime);
	return true;
}

void
getselection(char *selection, void (*callback)(void*, char*), void *aux) {
	Data* d = emallocz<Data>(sizeof *d);
	d->selection = xatom(selection);
	d->callback = callback;
	d->aux = aux;

	Window* w = createwindow(&scr.root, Rect(0, 0, 1, 1), 0, InputOnly, nil, 0);
	w->aux = d;
	sethandler(w, getHandlers());

	_getselection(w, d->selection, "UTF8_STRING");
}

static bool
selection_event(Window *w, void *aux, XSelectionEvent *ev) {
	char **ret;

	Data* d = (Data*)aux;
	if(ev->property == None && ev->target != xatom("STRING"))
		return _getselection(w, d->selection, "STRING");
	else if(ev->property == None)
		d->callback(d->aux, nil);
	else {
		getprop_textlist(w, atomname(ev->property), &ret);
		delproperty(w, atomname(ev->property));
		d->callback(d->aux, ret ? *ret : nil);
		free(ret);
	}
	destroywindow(w);
	return false;
}

Handlers*
getHandlers() {
    static Handlers handlers;
    static bool init = false;
    if (!init) {
        init = true;
        handlers.selection = selection_event;
    }
    return &handlers;
}

