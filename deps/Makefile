#
# Makefile --
#
# Rules to generate architecture dependent X11 definitions.
#
#------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
#
# This file is part of Xlib.jl which is licensed under the MIT "Expat" License.
#

srcdir = .

X11_INCDIR = /usr/include/X11

CC = gcc
CPPFLAGS = -I.
CFLAGS = -O2 -Wall
LDFLAGS =

default: all

clean:
	rm -f *~ *.o gendeps types.jl accessors.jl constants.jl

all: types.jl accessors.jl

constants.jl: filter_defines.sed $(X11_INCDIR)/X.h $(X11_INCDIR)/Xlib.h
	echo "# Constants from \`X.h\`" >"$@"
	cat "$(X11_INCDIR)/X.h" | sed -f filter_defines.sed >>"$@"
	echo "" >>"$@"
	echo "# Constants from \`Xlib.h\`" >>"$@"
	cat "$(X11_INCDIR)/Xlib.h" | sed -f filter_defines.sed >>"$@"

types.jl: gendeps
	./gendeps types > "$@"

offsets.jl: gendeps
	./gendeps offsets > "$@"

accessors.jl: gendeps
	./gendeps accessors > "$@"

gendeps: $(srcdir)/gendeps.c Makefile
	$(CC) $(CPPFLAGS) $(CFLAGS) "$<" -o "$@" $(LDFLAGS)
