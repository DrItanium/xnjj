#ifndef STUFF_CLIENTUTIL_H__
#define STUFF_CLIENTUTIL_H__
/* Copyright ©2009-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */

#ifndef CLIENTEXTERN
#  define CLIENTEXTERN extern
#endif

char*	readctl(char*, char*);
void	client_init(char*);

CLIENTEXTERN IxpClient*	client;

#endif
