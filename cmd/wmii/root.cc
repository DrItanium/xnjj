/* Copyright ©2008-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include "dat.h"
#include "fns.h"

static Handlers& getHandlers();

void
root_init(void) {
	WinAttr wa;

	wa.cursor = cursor[CurNormal];
	wa.event_mask = EnterWindowMask
		      | FocusChangeMask
		      | LeaveWindowMask
		      | PointerMotionMask
		      | SubstructureNotifyMask
		      | SubstructureRedirectMask;
	setwinattr(&scr.root, &wa, CWCursor
			         | CWEventMask);
	sethandler(&scr.root, &getHandlers());
}

static bool
enter_event(Window *w, void *aux, XCrossingEvent *e) {
	disp.sel = true;
	frame_draw_all();
	return false;
}

static bool
leave_event(Window *w, void *aux, XCrossingEvent *e) {
	if(!e->same_screen) {
		disp.sel = false;
		frame_draw_all();
	}
	return false;
}

static bool
focusin_event(Window *w, void *aux, XFocusChangeEvent *e) {
	if(e->mode == NotifyGrab)
		disp.hasgrab = &c_root;
	return false;
}

static bool
mapreq_event(Window *w, void *aux, XMapRequestEvent *e) {
	XWindowAttributes wa;

	if(!XGetWindowAttributes(display, e->window, &wa) || wa.override_redirect)
		return false;
	if(!win2client(e->window))
		client_create(e->window, &wa);
	return false;
}

static bool
motion_event(Window *w, void *aux, XMotionEvent *e) {
	Rectangle r, r2;

	r = rectsetorigin(Rect(0, 0, 1, 1), Pt(e->x_root, e->y_root));
	r2 = constrain(r, 0);
	if(!eqrect(r, r2))
		warppointer(r2.min);
	return false;
}

static bool
kdown_event(Window *w, void *aux, XKeyEvent *e) {

	e->state &= valid_mask;
	kpress(w->xid, e->state, (KeyCode)e->keycode);
	return false;
}

Handlers&
getHandlers() {
static Handlers handlers = {
	.enter = enter_event,
	.focusin = focusin_event,
	.kdown = kdown_event,
	.leave = leave_event,
	.mapreq = mapreq_event,
	.motion = motion_event,
};
return handlers;
}

