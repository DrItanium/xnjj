#include <stuff/x.h>
#include <map>

typedef void (*EventHandler)(XEvent*);

#define handle(w, fn, ev) \
	BLOCK(if((w)->handler->fn) (w)->handler->fn((w), ev))

extern std::map<uint, EventHandler> event_handler;
//extern EventHandler event_handler[LASTEvent];

