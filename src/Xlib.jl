#
# Xlib.jl --
#
# Julia wrapper of X11 library.
#
#------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
#
# This file is part of Xlib.jl which is licensed under the MIT "Expat" License.
#

module Xlib

using Compat

const _XLIB = "libX11.so" # FIXME: should be set in ../deps

include("constants.jl")
include("types.jl")
include("../deps/accessors.jl")

XOpenDisplay(name::AbstractString) =
    ccall((:XOpenDisplay, _XLIB), Ptr{Display}, (Cstring,), name)

XOpenDisplay() =
    ccall((:XOpenDisplay, _XLIB), Ptr{Display}, (Cstring,), C_NULL)

XCloseDisplay(dpy::Ptr{Display}) =
    ccall((:XCloseDisplay, _XLIB), Cint, (Ptr{Display},), dpy)

XEventsQueued(dpy::Ptr{Display}, mode::Integer) =
    ccall((:XEventsQueued, _XLIB), Cint, (Ptr{Display}, Cint), dpy, mode)

XPending(dpy::Ptr{Display}) =
    ccall((:XPending, _XLIB), Cint, (Ptr{Display},), dpy)

XQLength(dpy::Ptr{Display}) =
    ccall((:XQLength, _XLIB), Cint, (Ptr{Display},), dpy)

EventType(evt::XEvent) = evt.i01
EventType(evt::AbstractXEvent) = evt._type
EventType{T<:AbstractXEvent}(evt::Ref{T}) = EventType(evt[])

XNextEvent(dpy::Ptr{Display}, evt) =
    (@assert sizeof(evt) ≥ sizeof(XEvent);
     ccall((:XNextEvent, _XLIB), Cint, (Ptr{Display}, Ptr{Void}), dpy, evt))

XMapWindow(dpy::Ptr{Display}, win::Window) =
    ccall((:XMapWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, win)

XCreateSimpleWindow(dpy::Ptr{Display}, parent::Window, x::Integer, y::Integer, width::Integer, height::Integer, borderwidth::Integer, bordercolor::Integer, background::Integer) =
    ccall((:XCreateSimpleWindow, _XLIB), Window,
          (Ptr{Display}, Window, Cint, Cint, Cuint, Cuint, Cuint, Culong, Culong),
          dpy, parent, x, y, width, height, borderwidth, bordercolor, background)

XDestroyWindow(dpy::Ptr{Display}, win::Window) =
    ccall((:XDestroyWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, win)

XWarpPointer(dpy::Ptr{Display}, src::Window, dest::Window, src_x::Integer, src_y::Integer, src_width::Integer, src_height::Integer, dest_x::Integer, dest_y::Integer) =
    ccall((:XWarpPointer, _XLIB), Cint,
          (Ptr{Display}, Window, Window, Cint, Cint, Cuint, Cuint, Cint, Cint),
          dpy, src, dest, src_x, src_y, src_width, src_height, dest_x, dest_y)

XSelectInput(dpy::Ptr{Display}, win::Window, events::Integer) =
    ccall((:XSelectInput, _XLIB), Cint,
          (Ptr{Display}, Window, Clong), dpy, win, events)

#
# Graphics context.
#

XCreateGC(dpy::Ptr{Display}, drw::Drawable, mask::Integer, values) =
    ccall((:XCreateGC, _XLIB), GC,
          (Ptr{Display}, Drawable, Culong, Ptr{XGCValues}),
          dpy, drw, mask, values)

XSetArcMode(dpy::Ptr{Display}, gc::GC, arcmode::Integer) =
    ccall((:XSetArcMode, _XLIB), Cint,
          (Ptr{Display}, GC, Cint), dpy, gc, arcmode)

XSetClipMask(dpy::Ptr{Display}, gc::GC, pxm::Pixmap) =
    ccall((:XSetClipMask, _XLIB), Cint,
          (Ptr{Display}, GC, Pixmap), dpy, gc, pxm)

XSetClipOrigin(dpy::Ptr{Display}, gc::GC, x::Integer, y::Integer) =
    ccall((:XSetClipOrigin, _XLIB), Cint,
          (Ptr{Display}, GC, Cint, Cint), dpy, gc, x, y)

XSetClipRectangles(dpy::Ptr{Display}, gc::GC, x::Integer, y::Integer, rect::Vector{XRectangle}, ordering::Integer) =
    ccall((:XSetClipRectangles, _XLIB), Cint,
          (Ptr{Display}, GC, Cint, Cint, Ptr{XRectangle}, Cint, Cint),
          dpy, gc, x, y, rect, length(rect), ordering)

XSetBackground(dpy::Ptr{Display}, gc::GC, bg::Integer) =
    ccall((:XSetBackground, _XLIB), Cint,
          (Ptr{Display}, GC, Culong), dpy, gc, bg)

XSetForeground(dpy::Ptr{Display}, gc::GC, fg::Integer) =
    ccall((:XSetForeground, _XLIB), Cint,
          (Ptr{Display}, GC, Culong), dpy, gc, fg)

XDrawLine(dpy::Ptr{Display}, drw::Drawable, gc::GC, x1::Integer, y1::Integer, x2::Integer, y2::Integer) =
    ccall((:XDrawLine, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cint, Cint),
          dpy, drw, gc, x1, y1, x2, y2)

end
