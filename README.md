# A Julia interface to the X11 library

**Xlib.jl** is a [Julia](http://julialang.org/) package which aims at providing
an interface to the [X11 library](https://en.wikipedia.org/wiki/Xlib) (as a
client).  The objective is to provide a low-level but complete interface.  A
higher level interface could be build on top of this low-level version.  The
package is far from complete: all constants and all structures are covered but
only some functions have been wrapped (and tested).


## Installation

In the future, the building process will be automated and standardized but for
now, you have to clone the repository, go to the `deps` directory and type:

    make

also make sure that the constant `_XLIB` in `src/Xlib.jl` is correctly set.


## Example

To whet your appetite, here is a short example (inspired by a
[tutorial by Philipp K. Janert](http://www.linuxjournal.com/article/4879)):

```julia
using Xlib

function test1()

    dpy = XOpenDisplay()
    dpy == C_NULL && return 1
    scr = DefaultScreen(dpy)
    white = WhitePixel(dpy, scr)
    black = BlackPixel(dpy, scr)

    win = XCreateSimpleWindow(dpy,
                              DefaultRootWindow(dpy),
                              50, 50,   # origin
                              200, 200, # size
                              0, black, # border
                              white )   # background
    XMapWindow(dpy, win)

    evt = Ref(XEvent())
    eventMask = StructureNotifyMask
    XSelectInput(dpy, win, eventMask)
    while true
        XNextEvent(dpy, evt) # calls XFlush
        EventType(evt) == MapNotify && break
    end

    gc = XCreateGC(dpy, win, 0, C_NULL)
    XSetForeground(dpy, gc, black)
    XDrawLine(dpy, win, gc, 10, 10,190,190) # from-to
    XDrawLine(dpy, win, gc, 10,190,190, 10) # from-to

    eventMask = ButtonPressMask|ButtonReleaseMask
    XSelectInput(dpy,win,eventMask) # override previous settings
    while true
        XNextEvent(dpy, evt) # calls XFlush
        EventType(evt) == ButtonRelease && break
    end

    XDestroyWindow(dpy, win)
    XCloseDisplay(dpy)
    return 0
end
```


# Notes for Contributors

Whenever you add new symbols to be exported, update the file `src/exports.jl`
accordingly.  This can be automated by:

```julia
using Xlib
Xlib.generateexports("src/exports.jl")
```

