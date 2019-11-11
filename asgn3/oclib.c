// $Id: oclib.c,v 1.7 2019-09-19 17:08:34-07 - - $

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define not !
#define nullptr 0
#define string char*

#include "oclib.h"

void fail (string expr, string file, int line) {
   fprintf (stderr, "%s:%d: assert (%s) failed\n", file, line, expr);
   abort();
}

void* xcalloc (int nelem, int size) {
   void* result = calloc (nelem, size);
   assert (result != nullptr);
   return result;
}

void putchr (int chr) { printf ("%c", chr); }
void putint (int num) { printf ("%d", num); }
void putstr (string str) { printf ("%s", str); }

int getchr() { return getchar(); }

static char get_buffer[0x1000];

string getstr (void) {
   static char format[16];
   sprintf (format, "%%%zds", sizeof get_buffer - 1);
   int count = scanf (format, get_buffer);
   return count != 1 ? nullptr : strdup (get_buffer);
}

string getln (void) {
   string result = fgets (get_buffer, sizeof get_buffer, stdin);
   return result == nullptr ? nullptr : strdup (result);
} 
