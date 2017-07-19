# A Julia interface to the X11 library

**Xlib.jl** is a Julia package which aims at using X11 library (as a client)
directly from Julia.  The Package is far from complete (all constants, most
structures and some functions are covered).  To whet your appetite here is a
short example (inspired by a
[tutorial by Philipp K. Janert](http://www.linuxjournal.com/article/4879)):

```
    import Xlib: BlackPixel, ButtonPressMask, ButtonRelease,
        ButtonReleaseMask, DefaultRootWindow, DefaultScreen, EventType,
        MapNotify, StructureNotifyMask, WhitePixel, XCloseDisplay,
        XCreateGC, XCreateSimpleWindow, XDestroyWindow, XDrawLine,
        XEvent, XMapWindow, XNextEvent, XOpenDisplay, XSelectInput,
        XSetForeground

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
