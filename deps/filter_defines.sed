#
# filter_defines.sed --
#
# SED code to convert #define in X11 headers into Julia constants.
#
#------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
#
# This file is part of Xlib.jl which is licensed under the MIT "Expat" License.
#

# Replace tabs by ordinary spaces:
s/	/ /g

# Delete non-#define lines and normalize spacing:
/^ *# *define [_A-Za-z][_A-Za-z0-9]* /!d
s/^ *# *define  */#define /

# Convert comments:
s/\/\* *\(.*\)\*\/ *$/# \1/

# Remove trailing spaces:
s/  *$//

# String constants:
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *\(".*"\)/const \1 = \2/

# Long integer constants:
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *\([-+]\?[0-9][0-9]*\)L/const \1 = Clong(\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *\([-+]\?[0-9][0-9]*\)L *)/const \1 = Clong(\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *\([-+]\?[0-9][0-9]*\)UL/const \1 = Culong(\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *\([-+]\?[0-9][0-9]*\)UL *)/const \1 = Culong(\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\)UL/const \1 = Culong(0x\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\)UL *)/const \1 = Culong(0x\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\)L/const \1 = Clong(0x\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\)L *)/const \1 = Clong(0x\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *1UL *<< *\([0-9][0-9]*\) *)/const \1 = Culong(1)<<\2/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *1L *<< *\([0-9][0-9]*\) *)/const \1 = Clong(1)<<\2/

# Integer constants:
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *\([-+]\?[0-9][0-9]*\)U\($\|[^_0-9A-Za-z]\)/const \1 = Cuint(\2)\3/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *\([-+]\?[0-9][0-9]*\)U *)/const \1 = Cuint(\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *\([-+]\?[0-9][0-9]*\)\($\|[^_0-9A-Za-z]\)/const \1 = Cint(\2)\3/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *\([-+]\?[0-9][0-9]*\) *)/const \1 = Cint(\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\)U\($\|[^_0-9A-Za-z]\)/const \1 = Cuint(0x\2)\3/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\)U *)/const \1 = Cuint(0x\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\)\($\|[^_0-9A-Za-z]\)/const \1 = Cint(0x\2)\3/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *0[xX]\([0-9A-Fa-f][0-9A-Fa-f]*\) *)/const \1 = Cint(0x\2)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *1U *<< *\([0-9][0-9]*\) *)/const \1 = Cuint(1)<<\2/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *1 *<< *\([0-9][0-9]*\) *)/const \1 = Cint(1)<<\2/

# Integer casts:
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *\(char\|short\|int\|long\) *)\([_A-Za-z][_A-Za-z0-9]*\)/const \1 = C\2(\3)/
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *unsigned  *\(char\|short\|int\|long\) *)\([_A-Za-z][_A-Za-z0-9]*\)/const \1 = Cu\2(\3)/

# Specific cases:
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *( *( *unsigned  *\(char\|short\|int\|long\) *)~0L\? *)/const \1 = ~zero(Cu\2)/

# Symbol defined as an alias to another symbol:
s/^#define \([_A-Za-z][_A-Za-z0-9]*\)  *\([_A-Za-z][_A-Za-z0-9]*\)/const \1 = \2/

# Fix types names:
s/^const \([_A-Za-z][_A-Za-z0-9]*\) *= *\(char\|short\|int\|long\)/const \1 = C\2/
s/^const \([_A-Za-z][_A-Za-z0-9]*\) *= *unsigned  *\(char\|short\|int\|long\)/const \1 = Cu\2/

# Fix symbols names:
s/\(^\|[^_0-9A-Za-z]\)\(Bool\|Complex\)\($\|[^_0-9A-Za-z]\)/\1_\2\3/g

# Remove remaining defines:
/^#define /d

# Final cleanup for unclosed-comments (FIXME: merge commentary lines):
s/\/\* */# /

# Align definitions:
s/^\(const . \)=/\1 =/
s/^\(const .. \)=/\1 =/
s/^\(const ... \)=/\1 =/
s/^\(const .... \)=/\1 =/
s/^\(const ..... \)=/\1 =/
s/^\(const ...... \)=/\1 =/
s/^\(const ....... \)=/\1 =/
s/^\(const ........ \)=/\1 =/
s/^\(const ......... \)=/\1 =/
s/^\(const .......... \)=/\1 =/
s/^\(const ........... \)=/\1 =/
s/^\(const ............ \)=/\1 =/
s/^\(const ............. \)=/\1 =/
s/^\(const .............. \)=/\1 =/
s/^\(const ............... \)=/\1 =/
s/^\(const ................ \)=/\1 =/
s/^\(const ................. \)=/\1 =/
s/^\(const .................. \)=/\1 =/
s/^\(const ................... \)=/\1 =/
s/^\(const .................... \)=/\1 =/
s/^\(const ..................... \)=/\1 =/
s/^\(const ...................... \)=/\1 =/
s/^\(const ....................... \)=/\1 =/
s/^\(const ........................ \)=/\1 =/
s/^\(const ......................... \)=/\1 =/
s/^\(const .......................... \)=/\1 =/
s/^\(const ........................... \)=/\1 =/
s/^\(const ............................ \)=/\1 =/
s/^\(const ............................. \)=/\1 =/
s/^\(const .............................. \)=/\1 =/
