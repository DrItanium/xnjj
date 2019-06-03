#ifndef CMD_STRUT_DAT_H__
#define CMD_STRUT_DAT_H__
#include <fmt.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>
#include <stuff/x.h>
#include <stuff/util.h>

enum { DAuto, DHorizontal, DVertical };

Handlers& getHandlers();
extern int	direction;

#endif
