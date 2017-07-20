#! /bin/sh
#
# filter_api.tcl --
#
# Tcl script to build the contents of `src/methods.jl` from that of
# `deps/api.txt`.  Usage:
#
#     ./filter_api.tcl <api.txt >methods.jl
#
#------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
#
# This file is part of Xlib.jl which is licensed under the MIT "Expat" License.
#
#------------------------------------------------------------------------------
#
#                                                                   -*- TCL -*-
# The next line restarts using tclsh \
    exec tclsh "$0" "$@"

set INPUT stdin
set OUTPUT stdout
set NAME "\[_A-Za-z\]\[_A-Za-z0-9\]*"
set TYPE "$NAME"
set TEMP "$NAME"
for {set i 1} {$i <= 3} {incr i} {
  set TEMP "Ptr\\{$TEMP\\}"
  append TYPE "|$TEMP"
}
#puts stderr $TYPE
#set TYPE "\[_A-Za-z\]\[_A-Za-z0-9{}\]*"
set ARGS "\[ _A-Za-z0-9,:{}\]*"
set PROTO "^($TYPE) +($NAME) *\\(($ARGS)\\) *; *\$"

# Conversion table for input types:
array set INPUT_TYPE {
  Cint     Integer
  Cshort   Integer
  Clong    Integer
  Cuint    Integer
  Cushort  Integer
  Culong   Integer
  _Bool    Integer
  Status   Integer
  _KeyCode Integer
}

set n 0
set linenumber 0
while {[gets $INPUT line] >= 0} {
  incr linenumber
  regsub -all -- "\[ \t\]+" $line " " line
  regsub -all -- "^ +" $line "" line
  regsub -all -- " +\$" $line "" line

  if {[regexp -nocase "^ *# *-\\*- *julia *-\\*- *$" $line]} {
    continue
  }

  if {[regexp -- $PROTO $line unused ret func args]} {
    incr n
    set names {}
    set types {}
    set status 0
    set nargs 0
    set proto "${func}("
    set arglist ""
    set typelist ""
    set pfx ""
    foreach arg [split $args ","] {
      set i [string first "::" $arg]
      if {$i < 0} {
        set status -1
        break
      }
      set name [string trim [string range $arg 0 [expr {$i - 1}]]]
      set type [string trim [string range $arg [expr {$i + 2}] end]]
      if {[info exists INPUT_TYPE($type)]} {
        set gtype $INPUT_TYPE($type)
      } else {
        set gtype $type
      }
      append proto $pfx $name "::" $gtype
      append arglist $pfx $name
      append typelist $pfx $type
      incr nargs
      set pfx ", "
    }
    if {$status != 0} {
      puts stderr "syntax error (line: $linenumber)"
      continue
    }
    append proto ")"
    if {$nargs == 1} {
      set typelist "($typelist,)"
    } else {
      set typelist "($typelist)"
    }
    set code "$proto =\n"
    append code "    ccall((:${func}, _XLIB), ${ret},"
    if {$nargs <= 2} {
      append code " $typelist, $arglist)"
    } else {
      append code "\n          $typelist,"
      append code "\n          $arglist)"
    }
    puts $OUTPUT $code
  } else {
    puts $OUTPUT $line
  }
}
puts stderr "Found $n prototypes"
