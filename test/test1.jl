# Example based on tutorial by Philipp K. Janert
# (http://www.linuxjournal.com/article/4879)):

module XlibTest1

import Xlib: BlackPixel, ButtonPressMask, ButtonRelease, ButtonReleaseMask,
    DefaultRootWindow, DefaultScreen, DisplayHeight, DisplayWidth, EventType,
    MapNotify, ProtocolRevision, ProtocolVersion, ScreenOfDisplay,
    StructureNotifyMask, WhitePixel, XCloseDisplay, XCreateGC,
    XCreateSimpleWindow, XDestroyWindow, XDrawLine, XEvent, XMapWindow,
    XNextEvent, XOpenDisplay, XSelectInput, XSetForeground, XWarpPointer

function test1()

    dpy = XOpenDisplay()
    dpy == C_NULL && return 1
    scr = DefaultScreen(dpy)
    white = WhitePixel(dpy, scr)
    black = BlackPixel(dpy, scr)

    println("default screen: ", DefaultScreen(dpy))
    println("protocol version: ", ProtocolVersion(dpy))
    println("protocol revision: ", ProtocolRevision(dpy))
    println("default screen of display: ", ScreenOfDisplay(dpy, scr))
    println("size of screen: ", DisplayWidth(dpy, scr), " x ", DisplayHeight(dpy, scr))
    println("black pixel: ", black)
    println("white pixel: ", white)

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

    #=
    sleep(0.1)
    XWarpPointer(dpy, DefaultRootWindow(dpy), None, 0, 0, 0, 0, 120, 10)
    for k in 1:30
        sleep(0.1)
        XWarpPointer(dpy, DefaultRootWindow(dpy), None, 0, 0, 0, 0, 3, -1)
    end
    =#

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

test1()

end
