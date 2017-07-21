#
# methods.jl --
#
# Julia methods wrapping the functions of the X11 library.
#
#------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
#
# This file is part of Xlib.jl which is licensed under the MIT "Expat" License.
#


const _KeyCode = (NeedWidePrototypes ? Cuint : KeyCode)

XLoadQueryFont(dpy::Ptr{Display}, name::AbstractString) =
    ccall((:XLoadQueryFont, _XLIB), Ptr{XFontStruct}, (Ptr{Display}, Cstring), dpy, name)

XQueryFont(dpy::Ptr{Display}, font_ID::XID) =
    ccall((:XQueryFont, _XLIB), Ptr{XFontStruct}, (Ptr{Display}, XID), dpy, font_ID)

XGetMotionEvents(dpy::Ptr{Display}, w::Window, start::Time, stop::Time, nevents_return::Ref{Cint}) =
    ccall((:XGetMotionEvents, _XLIB), Ptr{XTimeCoord},
          (Ptr{Display}, Window, Time, Time, Ptr{Cint}),
          dpy, w, start, stop, nevents_return)

XDeleteModifiermapEntry(modmap::Ptr{XModifierKeymap}, keycode_entry::Integer, modifier::Integer) =
    ccall((:XDeleteModifiermapEntry, _XLIB), Ptr{XModifierKeymap},
          (Ptr{XModifierKeymap}, _KeyCode, Cint),
          modmap, keycode_entry, modifier)

XGetModifierMapping(dpy::Ptr{Display}) =
    ccall((:XGetModifierMapping, _XLIB), Ptr{XModifierKeymap}, (Ptr{Display},), dpy)

XInsertModifiermapEntry(modmap::Ptr{XModifierKeymap}, keycode_entry::Integer, modifier::Integer) =
    ccall((:XInsertModifiermapEntry, _XLIB), Ptr{XModifierKeymap},
          (Ptr{XModifierKeymap}, _KeyCode, Cint),
          modmap, keycode_entry, modifier)

XNewModifiermap(max_keys_per_mod::Integer) =
    ccall((:XNewModifiermap, _XLIB), Ptr{XModifierKeymap}, (Cint,), max_keys_per_mod)

XCreateImage(dpy::Ptr{Display}, visual::Ptr{Visual}, depth::Integer, format::Integer, offset::Integer, data::Ptr{Void}, width::Integer, height::Integer, bitmap_pad::Integer, bytes_per_line::Integer) =
    ccall((:XCreateImage, _XLIB), Ptr{XImage},
          (Ptr{Display}, Ptr{Visual}, Cuint, Cint, Cint, Ptr{Void}, Cuint, Cuint, Cint, Cint),
          dpy, visual, depth, format, offset, data, width, height, bitmap_pad, bytes_per_line)

XInitImage(img::Ptr{XImage}) =
    ccall((:XInitImage, _XLIB), Status, (Ptr{XImage},), img)

XGetImage(dpy::Ptr{Display}, d::Drawable, x::Integer, y::Integer, width::Integer, height::Integer, plane_mask::Integer, format::Integer) =
    ccall((:XGetImage, _XLIB), Ptr{XImage},
          (Ptr{Display}, Drawable, Cint, Cint, Cuint, Cuint, Culong, Cint),
          dpy, d, x, y, width, height, plane_mask, format)

XGetSubImage(dpy::Ptr{Display}, d::Drawable, x::Integer, y::Integer, width::Integer, height::Integer, plane_mask::Integer, format::Integer, dest_img::Ptr{XImage}, dest_x::Integer, dest_y::Integer) =
    ccall((:XGetSubImage, _XLIB), Ptr{XImage},
          (Ptr{Display}, Drawable, Cint, Cint, Cuint, Cuint, Culong, Cint, Ptr{XImage}, Cint, Cint),
          dpy, d, x, y, width, height, plane_mask, format, dest_img, dest_x, dest_y)


# X function declarations.

XOpenDisplay(name) =
    ccall((:XOpenDisplay, _XLIB), Ptr{Display}, (Cstring,), name)

XrmInitialize() =
    ccall((:XrmInitialize, _XLIB), Void, (), )

XFetchBytes(dpy::Ptr{Display}, nbytes_return::Ref{Cint}) =
    ccall((:XFetchBytes, _XLIB), Ptr{Cchar}, (Ptr{Display}, Ptr{Cint}), dpy, nbytes_return)

XFetchBuffer(dpy::Ptr{Display}, nbytes_return::Ref{Cint}, buffer::Integer) =
    ccall((:XFetchBuffer, _XLIB), Ptr{Cchar},
          (Ptr{Display}, Ptr{Cint}, Cint),
          dpy, nbytes_return, buffer)

XGetAtomName(dpy::Ptr{Display}, atom::Atom) =
    ccall((:XGetAtomName, _XLIB), Cstring, (Ptr{Display}, Atom), dpy, atom)

XGetAtomNames(dpy::Ptr{Display}, atoms::Ptr{Atom}, count::Integer, names_return::Ptr{Cstring}) =
    ccall((:XGetAtomNames, _XLIB), Status,
          (Ptr{Display}, Ptr{Atom}, Cint, Ptr{Cstring}),
          dpy, atoms, count, names_return)

XGetDefault(dpy::Ptr{Display}, program::AbstractString, option::AbstractString) =
    ccall((:XGetDefault, _XLIB), Cstring,
          (Ptr{Display}, Cstring, Cstring),
          dpy, program, option)

XDisplayName(name) =
    ccall((:XDisplayName, _XLIB), Cstring, (Cstring,), name)

XKeysymToString(keysym::Integer) =
    ccall((:XKeysymToString, _XLIB), Cstring, (KeySym,), keysym)

# FIXME: Cint (*XSynchronize(dpy::Ptr{Display}, onoff::Integer))(dpy::Ptr{Display});

# FIXME: Cint (*XSetAfterFunction(dpy::Ptr{Display}, Cint (*procedure) (dpy::Ptr{Display})))(dpy::Ptr{Display});

XInternAtom(dpy::Ptr{Display}, atom_name, only_if_exists::Integer) =
    ccall((:XInternAtom, _XLIB), Atom,
          (Ptr{Display}, Cstring, _Bool),
          dpy, atom_name, only_if_exists)

XInternAtoms(dpy::Ptr{Display}, names::Ptr{Cstring}, count::Integer, onlyIfExists::Integer, atoms_return::Ptr{Atom}) =
    ccall((:XInternAtoms, _XLIB), Status,
          (Ptr{Display}, Ptr{Cstring}, Cint, _Bool, Ptr{Atom}),
          dpy, names, count, onlyIfExists, atoms_return)

XCopyColormapAndFree(dpy::Ptr{Display}, colormap::Colormap) =
    ccall((:XCopyColormapAndFree, _XLIB), Colormap, (Ptr{Display}, Colormap), dpy, colormap)

XCreateColormap(dpy::Ptr{Display}, w::Window, visual::Ptr{Visual}, alloc::Integer) =
    ccall((:XCreateColormap, _XLIB), Colormap,
          (Ptr{Display}, Window, Ptr{Visual}, Cint),
          dpy, w, visual, alloc)

XCreatePixmapCursor(dpy::Ptr{Display}, source::Pixmap, mask::Pixmap, foreground_color::Ptr{XColor}, background_color::Ptr{XColor}, x::Integer, y::Integer) =
    ccall((:XCreatePixmapCursor, _XLIB), Cursor,
          (Ptr{Display}, Pixmap, Pixmap, Ptr{XColor}, Ptr{XColor}, Cuint, Cuint),
          dpy, source, mask, foreground_color, background_color, x, y)

XCreateGlyphCursor(dpy::Ptr{Display}, source_font::Font, mask_font::Font, source_char::Integer, mask_char::Integer, foreground_color::Ptr{XColor}, background_color::Ptr{XColor}) =
    ccall((:XCreateGlyphCursor, _XLIB), Cursor,
          (Ptr{Display}, Font, Font, Cuint, Cuint, Ptr{XColor}, Ptr{XColor}),
          dpy, source_font, mask_font, source_char, mask_char, foreground_color, background_color)

XCreateFontCursor(dpy::Ptr{Display}, shape::Integer) =
    ccall((:XCreateFontCursor, _XLIB), Cursor, (Ptr{Display}, Cuint), dpy, shape)

XLoadFont(dpy::Ptr{Display}, name) =
    ccall((:XLoadFont, _XLIB), Font, (Ptr{Display}, Cstring), dpy, name)

XCreateGC(dpy::Ptr{Display}, d::Drawable, valuemask::Integer, values) =
    ccall((:XCreateGC, _XLIB), GC,
          (Ptr{Display}, Drawable, Culong, Ptr{XGCValues}),
          dpy, d, valuemask, values)

XGContextFromGC(gc::GC) =
    ccall((:XGContextFromGC, _XLIB), GContext, (GC,), gc)

XFlushGC(dpy::Ptr{Display}, gc::GC) =
    ccall((:XFlushGC, _XLIB), Void, (Ptr{Display}, GC), dpy, gc)

XCreatePixmap(dpy::Ptr{Display}, d::Drawable, width::Integer, height::Integer, depth::Integer) =
    ccall((:XCreatePixmap, _XLIB), Pixmap,
          (Ptr{Display}, Drawable, Cuint, Cuint, Cuint),
          dpy, d, width, height, depth)

XCreateBitmapFromData(dpy::Ptr{Display}, d::Drawable, data::Ptr{Cchar}, width::Integer, height::Integer) =
    ccall((:XCreateBitmapFromData, _XLIB), Pixmap,
          (Ptr{Display}, Drawable, Ptr{Cchar}, Cuint, Cuint),
          dpy, d, data, width, height)

XCreatePixmapFromBitmapData(dpy::Ptr{Display}, d::Drawable, data::Ptr{Cchar}, width::Integer, height::Integer, fg::Integer, bg::Integer, depth::Integer) =
    ccall((:XCreatePixmapFromBitmapData, _XLIB), Pixmap,
          (Ptr{Display}, Drawable, Ptr{Cchar}, Cuint, Cuint, Culong, Culong, Cuint),
          dpy, d, data, width, height, fg, bg, depth)

XCreateSimpleWindow(dpy::Ptr{Display}, parent::Window, x::Integer, y::Integer, width::Integer, height::Integer, border_width::Integer, border::Integer, background::Integer) =
    ccall((:XCreateSimpleWindow, _XLIB), Window,
          (Ptr{Display}, Window, Cint, Cint, Cuint, Cuint, Cuint, Culong, Culong),
          dpy, parent, x, y, width, height, border_width, border, background)

XGetSelectionOwner(dpy::Ptr{Display}, selection::Atom) =
    ccall((:XGetSelectionOwner, _XLIB), Window, (Ptr{Display}, Atom), dpy, selection)

XCreateWindow(dpy::Ptr{Display}, parent::Window, x::Integer, y::Integer, width::Integer, height::Integer, border_width::Integer, depth::Integer, class::Integer, visual::Ptr{Visual}, valuemask::Integer, attributes::Ptr{XSetWindowAttributes}) =
    ccall((:XCreateWindow, _XLIB), Window,
          (Ptr{Display}, Window, Cint, Cint, Cuint, Cuint, Cuint, Cint, Cuint, Ptr{Visual}, Culong, Ptr{XSetWindowAttributes}),
          dpy, parent, x, y, width, height, border_width, depth, class, visual, valuemask, attributes)

XListInstalledColormaps(dpy::Ptr{Display}, w::Window, num_return::Ptr{Cint}) =
    ccall((:XListInstalledColormaps, _XLIB), Ptr{Colormap},
          (Ptr{Display}, Window, Ptr{Cint}),
          dpy, w, num_return)

XListFonts(dpy::Ptr{Display}, pattern::Ptr{Cchar}, maxnames::Integer, actual_count_return::Ptr{Cint}) =
    ccall((:XListFonts, _XLIB), Ptr{Ptr{Cchar}},
          (Ptr{Display}, Ptr{Cchar}, Cint, Ptr{Cint}),
          dpy, pattern, maxnames, actual_count_return)

XListFontsWithInfo(dpy::Ptr{Display}, pattern::Ptr{Cchar}, maxnames::Integer, count_return::Ptr{Cint}, info_return::Ptr{Ptr{XFontStruct}}) =
    ccall((:XListFontsWithInfo, _XLIB), Ptr{Ptr{Cchar}},
          (Ptr{Display}, Ptr{Cchar}, Cint, Ptr{Cint}, Ptr{Ptr{XFontStruct}}),
          dpy, pattern, maxnames, count_return, info_return)

XGetFontPath(dpy::Ptr{Display}, npaths_return::Ptr{Cint}) =
    ccall((:XGetFontPath, _XLIB), Ptr{Ptr{Cchar}}, (Ptr{Display}, Ptr{Cint}), dpy, npaths_return)

XListExtensions(dpy::Ptr{Display}, nextensions_return::Ptr{Cint}) =
    ccall((:XListExtensions, _XLIB), Ptr{Ptr{Cchar}}, (Ptr{Display}, Ptr{Cint}), dpy, nextensions_return)

XListProperties(dpy::Ptr{Display}, w::Window, num_prop_return::Ptr{Cint}) =
    ccall((:XListProperties, _XLIB), Ptr{Atom},
          (Ptr{Display}, Window, Ptr{Cint}),
          dpy, w, num_prop_return)

XListHosts(dpy::Ptr{Display}, nhosts_return::Ptr{Cint}, state_return::Ptr{_Bool}) =
    ccall((:XListHosts, _XLIB), Ptr{XHostAddress},
          (Ptr{Display}, Ptr{Cint}, Ptr{_Bool}),
          dpy, nhosts_return, state_return)

# FIXME: XKeycodeToKeysym is deprecated, use XkbKeycodeToKeysym instead
XKeycodeToKeysym(dpy::Ptr{Display}, keycode::Integer, index::Integer) =
    ccall((:XKeycodeToKeysym, _XLIB), KeySym,
          (Ptr{Display}, _KeyCode, Cint),
          dpy, keycode, index)

XLookupKeysym(key_event::Ptr{XKeyEvent}, index::Integer) =
    ccall((:XLookupKeysym, _XLIB), KeySym, (Ptr{XKeyEvent}, Cint), key_event, index)

XGetKeyboardMapping(dpy::Ptr{Display}, first_keycode::Integer, keycode_count::Integer, keysyms_per_keycode_return::Ptr{Cint}) =
    ccall((:XGetKeyboardMapping, _XLIB), Ptr{KeySym},
          (Ptr{Display}, _KeyCode, Cint, Ptr{Cint}),
          dpy, first_keycode, keycode_count, keysyms_per_keycode_return)

XStringToKeysym(str::AbstractString) =
    ccall((:XStringToKeysym, _XLIB), KeySym, (Cstring,), str)

XMaxRequestSize(dpy::Ptr{Display}) =
    ccall((:XMaxRequestSize, _XLIB), Clong, (Ptr{Display},), dpy)

XExtendedMaxRequestSize(dpy::Ptr{Display}) =
    ccall((:XExtendedMaxRequestSize, _XLIB), Clong, (Ptr{Display},), dpy)

XResourceManagerString(dpy::Ptr{Display}) =
    ccall((:XResourceManagerString, _XLIB), Ptr{Cchar}, (Ptr{Display},), dpy)

XScreenResourceString(screen::Ptr{Screen}) =
    ccall((:XScreenResourceString, _XLIB), Ptr{Cchar}, (Ptr{Screen},), screen)

XDisplayMotionBufferSize(dpy::Ptr{Display}) =
    ccall((:XDisplayMotionBufferSize, _XLIB), Culong, (Ptr{Display},), dpy)

XVisualIDFromVisual(visual::Ptr{Visual}) =
    ccall((:XVisualIDFromVisual, _XLIB), VisualID, (Ptr{Visual},), visual)


# Multithread routines

XInitThreads() =
    ccall((:XInitThreads, _XLIB), Status, (), )

XLockDisplay(dpy::Ptr{Display}) =
    ccall((:XLockDisplay, _XLIB), Void, (Ptr{Display},), dpy)

XUnlockDisplay(dpy::Ptr{Display}) =
    ccall((:XUnlockDisplay, _XLIB), Void, (Ptr{Display},), dpy)


# Routines for dealing with extensions

XInitExtension(dpy::Ptr{Display}, name) =
    ccall((:XInitExtension, _XLIB), Ptr{XExtCodes}, (Ptr{Display}, Cstring), dpy, name)

XAddExtension(dpy::Ptr{Display}) =
    ccall((:XAddExtension, _XLIB), Ptr{XExtCodes}, (Ptr{Display},), dpy)

XFindOnExtensionList(structure::Ptr{Ptr{XExtData}}, number::Integer) =
    ccall((:XFindOnExtensionList, _XLIB), Ptr{XExtData}, (Ptr{Ptr{XExtData}}, Cint), structure, number)

XEHeadOfExtensionList(object::XEDataObject) =
    ccall((:XEHeadOfExtensionList, _XLIB), Ptr{Ptr{XExtData}}, (XEDataObject,), object)


# These are routines for which there are also macros

XRootWindow(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XRootWindow, _XLIB), Window, (Ptr{Display}, Cint), dpy, screen_number)

XDefaultRootWindow(dpy::Ptr{Display}) =
    ccall((:XDefaultRootWindow, _XLIB), Window, (Ptr{Display},), dpy)

XRootWindowOfScreen(screen::Ptr{Screen}) =
    ccall((:XRootWindowOfScreen, _XLIB), Window, (Ptr{Screen},), screen)

XDefaultVisual(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDefaultVisual, _XLIB), Ptr{Visual}, (Ptr{Display}, Cint), dpy, screen_number)

XDefaultVisualOfScreen(screen::Ptr{Screen}) =
    ccall((:XDefaultVisualOfScreen, _XLIB), Ptr{Visual}, (Ptr{Screen},), screen)

XDefaultGC(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDefaultGC, _XLIB), GC, (Ptr{Display}, Cint), dpy, screen_number)

XDefaultGCOfScreen(screen::Ptr{Screen}) =
    ccall((:XDefaultGCOfScreen, _XLIB), GC, (Ptr{Screen},), screen)

XBlackPixel(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XBlackPixel, _XLIB), Culong, (Ptr{Display}, Cint), dpy, screen_number)

XWhitePixel(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XWhitePixel, _XLIB), Culong, (Ptr{Display}, Cint), dpy, screen_number)

XAllPlanes() =
    ccall((:XAllPlanes, _XLIB), Culong, (), )

XBlackPixelOfScreen(screen::Ptr{Screen}) =
    ccall((:XBlackPixelOfScreen, _XLIB), Culong, (Ptr{Screen},), screen)

XWhitePixelOfScreen(screen::Ptr{Screen}) =
    ccall((:XWhitePixelOfScreen, _XLIB), Culong, (Ptr{Screen},), screen)

XNextRequest(dpy::Ptr{Display}) =
    ccall((:XNextRequest, _XLIB), Culong, (Ptr{Display},), dpy)

XLastKnownRequestProcessed(dpy::Ptr{Display}) =
    ccall((:XLastKnownRequestProcessed, _XLIB), Culong, (Ptr{Display},), dpy)

XServerVendor(dpy::Ptr{Display}) =
    ccall((:XServerVendor, _XLIB), Cstring, (Ptr{Display},), dpy)

XDisplayString(dpy::Ptr{Display}) =
    ccall((:XDisplayString, _XLIB), Cstring, (Ptr{Display},), dpy)

XDefaultColormap(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDefaultColormap, _XLIB), Colormap, (Ptr{Display}, Cint), dpy, screen_number)

XDefaultColormapOfScreen(screen::Ptr{Screen}) =
    ccall((:XDefaultColormapOfScreen, _XLIB), Colormap, (Ptr{Screen},), screen)

XDisplayOfScreen(screen::Ptr{Screen}) =
    ccall((:XDisplayOfScreen, _XLIB), Ptr{Display}, (Ptr{Screen},), screen)

XScreenOfDisplay(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XScreenOfDisplay, _XLIB), Ptr{Screen}, (Ptr{Display}, Cint), dpy, screen_number)

XDefaultScreenOfDisplay(dpy::Ptr{Display}) =
    ccall((:XDefaultScreenOfDisplay, _XLIB), Ptr{Screen}, (Ptr{Display},), dpy)

XEventMaskOfScreen(screen::Ptr{Screen}) =
    ccall((:XEventMaskOfScreen, _XLIB), Clong, (Ptr{Screen},), screen)

XScreenNumberOfScreen(screen::Ptr{Screen}) =
    ccall((:XScreenNumberOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

# FIXME:
# typedef int (*XErrorHandler) ( /* WARNING, this type not in Xlib spec */
# Ptr{Display} /* display */,
# Ptr{XErrorEvent} /* error_event */
# );

const XErrorHandler = Cfunc

XSetErrorHandler(handler::XErrorHandler) =
    ccall((:XSetErrorHandler, _XLIB), XErrorHandler, (XErrorHandler,), handler)

# FIXME:
# typedef int (*XIOErrorHandler) ( /* WARNING, this type not in Xlib spec */
# Ptr{Display} /* display */
# );
const XIOErrorHandler = Cfunc

XSetIOErrorHandler(handler::XIOErrorHandler) =
    ccall((:XSetIOErrorHandler, _XLIB), XIOErrorHandler, (XIOErrorHandler,), handler)

XListPixmapFormats(dpy::Ptr{Display}, count_return::Ptr{Cint}) =
    ccall((:XListPixmapFormats, _XLIB), Ptr{XPixmapFormatValues}, (Ptr{Display}, Ptr{Cint}), dpy, count_return)

XListDepths(dpy::Ptr{Display}, screen_number::Integer, count_return::Ptr{Cint}) =
    ccall((:XListDepths, _XLIB), Ptr{Cint},
          (Ptr{Display}, Cint, Ptr{Cint}),
          dpy, screen_number, count_return)


# ICCCM routines for things that don't require special include files; other
# declarations are given in Xutil.h

XReconfigureWMWindow(dpy::Ptr{Display}, w::Window, screen_number::Integer, mask::Integer, changes::Ptr{XWindowChanges}) =
    ccall((:XReconfigureWMWindow, _XLIB), Status,
          (Ptr{Display}, Window, Cint, Cuint, Ptr{XWindowChanges}),
          dpy, w, screen_number, mask, changes)

XGetWMProtocols(dpy::Ptr{Display}, w::Window, protocols_return::Ptr{Ptr{Atom}}, count_return::Ptr{Cint}) =
    ccall((:XGetWMProtocols, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Ptr{Atom}}, Ptr{Cint}),
          dpy, w, protocols_return, count_return)

XSetWMProtocols(dpy::Ptr{Display}, w::Window, protocols::Ptr{Atom}, count::Integer) =
    ccall((:XSetWMProtocols, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Atom}, Cint),
          dpy, w, protocols, count)

XIconifyWindow(dpy::Ptr{Display}, w::Window, screen_number::Integer) =
    ccall((:XIconifyWindow, _XLIB), Status,
          (Ptr{Display}, Window, Cint),
          dpy, w, screen_number)

XWithdrawWindow(dpy::Ptr{Display}, w::Window, screen_number::Integer) =
    ccall((:XWithdrawWindow, _XLIB), Status,
          (Ptr{Display}, Window, Cint),
          dpy, w, screen_number)

XGetCommand(dpy::Ptr{Display}, w::Window, argv_return::Ptr{Ptr{Ptr{Cchar}}}, argc_return::Ptr{Cint}) =
    ccall((:XGetCommand, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Ptr{Ptr{Cchar}}}, Ptr{Cint}),
          dpy, w, argv_return, argc_return)

XGetWMColormapWindows(dpy::Ptr{Display}, w::Window, windows_return::Ptr{Ptr{Window}}, count_return::Ptr{Cint}) =
    ccall((:XGetWMColormapWindows, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Ptr{Window}}, Ptr{Cint}),
          dpy, w, windows_return, count_return)

XSetWMColormapWindows(dpy::Ptr{Display}, w::Window, colormap_windows::Ptr{Window}, count::Integer) =
    ccall((:XSetWMColormapWindows, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Window}, Cint),
          dpy, w, colormap_windows, count)

XFreeStringList(list::Ptr{Ptr{Cchar}}) =
    ccall((:XFreeStringList, _XLIB), Void, (Ptr{Ptr{Cchar}},), list)

XSetTransientForHint(dpy::Ptr{Display}, w::Window, prop_window::Window) =
    ccall((:XSetTransientForHint, _XLIB), Cint,
          (Ptr{Display}, Window, Window),
          dpy, w, prop_window)


# The following are given in alphabetical order

XActivateScreenSaver(dpy::Ptr{Display}) =
    ccall((:XActivateScreenSaver, _XLIB), Cint, (Ptr{Display},), dpy)

XAddHost(dpy::Ptr{Display}, host::Ptr{XHostAddress}) =
    ccall((:XAddHost, _XLIB), Cint, (Ptr{Display}, Ptr{XHostAddress}), dpy, host)

XAddHosts(dpy::Ptr{Display}, hosts::Ptr{XHostAddress}, num_hosts::Integer) =
    ccall((:XAddHosts, _XLIB), Cint,
          (Ptr{Display}, Ptr{XHostAddress}, Cint),
          dpy, hosts, num_hosts)

XAddToExtensionList(structure::Ptr{Ptr{XExtData}}, ext_data::Ptr{XExtData}) =
    ccall((:XAddToExtensionList, _XLIB), Cint, (Ptr{Ptr{XExtData}}, Ptr{XExtData}), structure, ext_data)

XAddToSaveSet(dpy::Ptr{Display}, w::Window) =
    ccall((:XAddToSaveSet, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XAllocColor(dpy::Ptr{Display}, colormap::Colormap, screen_in_out::Ptr{XColor}) =
    ccall((:XAllocColor, _XLIB), Status,
          (Ptr{Display}, Colormap, Ptr{XColor}),
          dpy, colormap, screen_in_out)

XAllocColorCells(dpy::Ptr{Display}, colormap::Colormap, contig::Integer, plane_masks_return::Ptr{Culong}, nplanes::Integer, pixels_return::Ptr{Culong}, npixels::Integer) =
    ccall((:XAllocColorCells, _XLIB), Status,
          (Ptr{Display}, Colormap, _Bool, Ptr{Culong}, Cuint, Ptr{Culong}, Cuint),
          dpy, colormap, contig, plane_masks_return, nplanes, pixels_return, npixels)

XAllocColorPlanes(dpy::Ptr{Display}, colormap::Colormap, contig::Integer, pixels_return::Ptr{Culong}, ncolors::Integer, nreds::Integer, ngreens::Integer, nblues::Integer, rmask_return::Ptr{Culong}, gmask_return::Ptr{Culong}, bmask_return::Ptr{Culong}) =
    ccall((:XAllocColorPlanes, _XLIB), Status,
          (Ptr{Display}, Colormap, _Bool, Ptr{Culong}, Cint, Cint, Cint, Cint, Ptr{Culong}, Ptr{Culong}, Ptr{Culong}),
          dpy, colormap, contig, pixels_return, ncolors, nreds, ngreens, nblues, rmask_return, gmask_return, bmask_return)

XAllocNamedColor(dpy::Ptr{Display}, colormap::Colormap, color_name::AbstractString, screen_def_return::Ptr{XColor}, exact_def_return::Ptr{XColor}) =
    ccall((:XAllocNamedColor, _XLIB), Status,
          (Ptr{Display}, Colormap, Cstring, Ptr{XColor}, Ptr{XColor}),
          dpy, colormap, color_name, screen_def_return, exact_def_return)

XAllowEvents(dpy::Ptr{Display}, event_mode::Integer, time::Time) =
    ccall((:XAllowEvents, _XLIB), Cint,
          (Ptr{Display}, Cint, Time),
          dpy, event_mode, time)

XAutoRepeatOff(dpy::Ptr{Display}) =
    ccall((:XAutoRepeatOff, _XLIB), Cint, (Ptr{Display},), dpy)

XAutoRepeatOn(dpy::Ptr{Display}) =
    ccall((:XAutoRepeatOn, _XLIB), Cint, (Ptr{Display},), dpy)

XBell(dpy::Ptr{Display}, percent::Integer) =
    ccall((:XBell, _XLIB), Cint, (Ptr{Display}, Cint), dpy, percent)

XBitmapBitOrder(dpy::Ptr{Display}) =
    ccall((:XBitmapBitOrder, _XLIB), Cint, (Ptr{Display},), dpy)

XBitmapPad(dpy::Ptr{Display}) =
    ccall((:XBitmapPad, _XLIB), Cint, (Ptr{Display},), dpy)

XBitmapUnit(dpy::Ptr{Display}) =
    ccall((:XBitmapUnit, _XLIB), Cint, (Ptr{Display},), dpy)

XCellsOfScreen(screen::Ptr{Screen}) =
    ccall((:XCellsOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XChangeActivePointerGrab(dpy::Ptr{Display}, event_mask::Integer, cursor::Cursor, time::Time) =
    ccall((:XChangeActivePointerGrab, _XLIB), Cint,
          (Ptr{Display}, Cuint, Cursor, Time),
          dpy, event_mask, cursor, time)

XChangeGC(dpy::Ptr{Display}, gc::GC, valuemask::Integer, values::Ptr{XGCValues}) =
    ccall((:XChangeGC, _XLIB), Cint,
          (Ptr{Display}, GC, Culong, Ptr{XGCValues}),
          dpy, gc, valuemask, values)

XChangeKeyboardControl(dpy::Ptr{Display}, value_mask::Integer, values::Ptr{XKeyboardControl}) =
    ccall((:XChangeKeyboardControl, _XLIB), Cint,
          (Ptr{Display}, Culong, Ptr{XKeyboardControl}),
          dpy, value_mask, values)

XChangeKeyboardMapping(dpy::Ptr{Display}, first_keycode::Integer, keysyms_per_keycode::Integer, keysyms::Ptr{KeySym}, num_codes::Integer) =
    ccall((:XChangeKeyboardMapping, _XLIB), Cint,
          (Ptr{Display}, Cint, Cint, Ptr{KeySym}, Cint),
          dpy, first_keycode, keysyms_per_keycode, keysyms, num_codes)

XChangePointerControl(dpy::Ptr{Display}, do_accel::Integer, do_threshold::Integer, accel_numerator::Integer, accel_denominator::Integer, threshold::Integer) =
    ccall((:XChangePointerControl, _XLIB), Cint,
          (Ptr{Display}, _Bool, _Bool, Cint, Cint, Cint),
          dpy, do_accel, do_threshold, accel_numerator, accel_denominator, threshold)

XChangeProperty(dpy::Ptr{Display}, w::Window, property::Atom, _type::Atom, format::Integer, mode::Integer, data::Ptr{Cuchar}, nelements::Integer) =
    ccall((:XChangeProperty, _XLIB), Cint,
          (Ptr{Display}, Window, Atom, Atom, Cint, Cint, Ptr{Cuchar}, Cint),
          dpy, w, property, _type, format, mode, data, nelements)

XChangeSaveSet(dpy::Ptr{Display}, w::Window, change_mode::Integer) =
    ccall((:XChangeSaveSet, _XLIB), Cint,
          (Ptr{Display}, Window, Cint),
          dpy, w, change_mode)

XChangeWindowAttributes(dpy::Ptr{Display}, w::Window, valuemask::Integer, attributes::Ptr{XSetWindowAttributes}) =
    ccall((:XChangeWindowAttributes, _XLIB), Cint,
          (Ptr{Display}, Window, Culong, Ptr{XSetWindowAttributes}),
          dpy, w, valuemask, attributes)

# FIXME: _Bool XCheckIfEvent(dpy::Ptr{Display}, event_return::Ptr{XEvent}, _Bool (*predicate) (dpy::Ptr{Display}, event::Ptr{XEvent}, arg::XPointer), arg::XPointer);
XCheckIfEvent(dpy::Ptr{Display}, event_return::Ref{XEvent}, predicate::Cfunc, arg::XPointer) =
    ccall((:XCheckIfEvent, _XLIB), _Bool,
          (Ptr{Display}, Ptr{XEvent}, Cfunc, XPointer),
          dpy, event_return, predicate, arg)

XCheckMaskEvent(dpy::Ptr{Display}, event_mask::Integer, event_return::Ref{XEvent}) =
    ccall((:XCheckMaskEvent, _XLIB), _Bool,
          (Ptr{Display}, Clong, Ptr{XEvent}),
          dpy, event_mask, event_return)

XCheckTypedEvent(dpy::Ptr{Display}, event_type::Integer, event_return::Ref{XEvent}) =
    ccall((:XCheckTypedEvent, _XLIB), _Bool,
          (Ptr{Display}, Cint, Ptr{XEvent}),
          dpy, event_type, event_return)

XCheckTypedWindowEvent(dpy::Ptr{Display}, w::Window, event_type::Integer, event_return::Ref{XEvent}) =
    ccall((:XCheckTypedWindowEvent, _XLIB), _Bool,
          (Ptr{Display}, Window, Cint, Ptr{XEvent}),
          dpy, w, event_type, event_return)

XCheckWindowEvent(dpy::Ptr{Display}, w::Window, event_mask::Integer, event_return::Ref{XEvent}) =
    ccall((:XCheckWindowEvent, _XLIB), _Bool,
          (Ptr{Display}, Window, Clong, Ptr{XEvent}),
          dpy, w, event_mask, event_return)

XCirculateSubwindows(dpy::Ptr{Display}, w::Window, direction::Integer) =
    ccall((:XCirculateSubwindows, _XLIB), Cint,
          (Ptr{Display}, Window, Cint),
          dpy, w, direction)

XCirculateSubwindowsDown(dpy::Ptr{Display}, w::Window) =
    ccall((:XCirculateSubwindowsDown, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XCirculateSubwindowsUp(dpy::Ptr{Display}, w::Window) =
    ccall((:XCirculateSubwindowsUp, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XClearArea(dpy::Ptr{Display}, w::Window, x::Integer, y::Integer, width::Integer, height::Integer, exposures::Integer) =
    ccall((:XClearArea, _XLIB), Cint,
          (Ptr{Display}, Window, Cint, Cint, Cuint, Cuint, _Bool),
          dpy, w, x, y, width, height, exposures)

XClearWindow(dpy::Ptr{Display}, w::Window) =
    ccall((:XClearWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XCloseDisplay(dpy::Ptr{Display}) =
    ccall((:XCloseDisplay, _XLIB), Cint, (Ptr{Display},), dpy)

XConfigureWindow(dpy::Ptr{Display}, w::Window, value_mask::Integer, values::Ptr{XWindowChanges}) =
    ccall((:XConfigureWindow, _XLIB), Cint,
          (Ptr{Display}, Window, Cuint, Ptr{XWindowChanges}),
          dpy, w, value_mask, values)

XConnectionNumber(dpy::Ptr{Display}) =
    ccall((:XConnectionNumber, _XLIB), Cint, (Ptr{Display},), dpy)

XConvertSelection(dpy::Ptr{Display}, selection::Atom, target::Atom, property::Atom, requestor::Window, time::Time) =
    ccall((:XConvertSelection, _XLIB), Cint,
          (Ptr{Display}, Atom, Atom, Atom, Window, Time),
          dpy, selection, target, property, requestor, time)

XCopyArea(dpy::Ptr{Display}, src::Drawable, dest::Drawable, gc::GC, src_x::Integer, src_y::Integer, width::Integer, height::Integer, dest_x::Integer, dest_y::Integer) =
    ccall((:XCopyArea, _XLIB), Cint,
          (Ptr{Display}, Drawable, Drawable, GC, Cint, Cint, Cuint, Cuint, Cint, Cint),
          dpy, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y)

XCopyGC(dpy::Ptr{Display}, src::GC, valuemask::Integer, dest::GC) =
    ccall((:XCopyGC, _XLIB), Cint,
          (Ptr{Display}, GC, Culong, GC),
          dpy, src, valuemask, dest)

XCopyPlane(dpy::Ptr{Display}, src::Drawable, dest::Drawable, gc::GC, src_x::Integer, src_y::Integer, width::Integer, height::Integer, dest_x::Integer, dest_y::Integer, plane::Integer) =
    ccall((:XCopyPlane, _XLIB), Cint,
          (Ptr{Display}, Drawable, Drawable, GC, Cint, Cint, Cuint, Cuint, Cint, Cint, Culong),
          dpy, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y, plane)

XDefaultDepth(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDefaultDepth, _XLIB), Cint, (Ptr{Display}, Cint), dpy, screen_number)

XDefaultDepthOfScreen(screen::Ptr{Screen}) =
    ccall((:XDefaultDepthOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XDefaultScreen(dpy::Ptr{Display}) =
    ccall((:XDefaultScreen, _XLIB), Cint, (Ptr{Display},), dpy)

XDefineCursor(dpy::Ptr{Display}, w::Window, cursor::Cursor) =
    ccall((:XDefineCursor, _XLIB), Cint,
          (Ptr{Display}, Window, Cursor),
          dpy, w, cursor)

XDeleteProperty(dpy::Ptr{Display}, w::Window, property::Atom) =
    ccall((:XDeleteProperty, _XLIB), Cint,
          (Ptr{Display}, Window, Atom),
          dpy, w, property)

XDestroyWindow(dpy::Ptr{Display}, w::Window) =
    ccall((:XDestroyWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XDestroySubwindows(dpy::Ptr{Display}, w::Window) =
    ccall((:XDestroySubwindows, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XDoesBackingStore(screen::Ptr{Screen}) =
    ccall((:XDoesBackingStore, _XLIB), Cint, (Ptr{Screen},), screen)

XDoesSaveUnders(screen::Ptr{Screen}) =
    ccall((:XDoesSaveUnders, _XLIB), _Bool, (Ptr{Screen},), screen)

XDisableAccessControl(dpy::Ptr{Display}) =
    ccall((:XDisableAccessControl, _XLIB), Cint, (Ptr{Display},), dpy)

XDisplayCells(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDisplayCells, _XLIB), Cint, (Ptr{Display}, Cint), dpy, screen_number)

XDisplayHeight(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDisplayHeight, _XLIB), Cint, (Ptr{Display}, Cint), dpy, screen_number)

XDisplayHeightMM(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDisplayHeightMM, _XLIB), Cint, (Ptr{Display}, Cint), dpy, screen_number)

XDisplayKeycodes(dpy::Ptr{Display}, min_keycodes_return::Ptr{Cint}, max_keycodes_return::Ptr{Cint}) =
    ccall((:XDisplayKeycodes, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cint}, Ptr{Cint}),
          dpy, min_keycodes_return, max_keycodes_return)

XDisplayPlanes(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDisplayPlanes, _XLIB), Cint, (Ptr{Display}, Cint), dpy, screen_number)

XDisplayWidth(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDisplayWidth, _XLIB), Cint, (Ptr{Display}, Cint), dpy, screen_number)

XDisplayWidthMM(dpy::Ptr{Display}, screen_number::Integer) =
    ccall((:XDisplayWidthMM, _XLIB), Cint, (Ptr{Display}, Cint), dpy, screen_number)

XDrawArc(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, width::Integer, height::Integer, angle1::Integer, angle2::Integer) =
    ccall((:XDrawArc, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cuint, Cuint, Cint, Cint),
          dpy, d, gc, x, y, width, height, angle1, angle2)

XDrawArcs(dpy::Ptr{Display}, d::Drawable, gc::GC, arcs::Ptr{XArc}, narcs::Integer) =
    ccall((:XDrawArcs, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XArc}, Cint),
          dpy, d, gc, arcs, narcs)

XDrawImageString(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, str::AbstractString, length::Integer = length(str)) =
    ccall((:XDrawImageString, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cstring, Cint),
          dpy, d, gc, x, y, str, length)

XDrawImageString16(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, str::Ptr{XChar2b}, length::Integer) =
    ccall((:XDrawImageString16, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Ptr{XChar2b}, Cint),
          dpy, d, gc, x, y, str, length)

XDrawLine(dpy::Ptr{Display}, d::Drawable, gc::GC, x1::Integer, y1::Integer, x2::Integer, y2::Integer) =
    ccall((:XDrawLine, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cint, Cint),
          dpy, d, gc, x1, y1, x2, y2)

XDrawLines(dpy::Ptr{Display}, d::Drawable, gc::GC, points::Ptr{XPoint}, npoints::Integer, mode::Integer) =
    ccall((:XDrawLines, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XPoint}, Cint, Cint),
          dpy, d, gc, points, npoints, mode)

XDrawPoint(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer) =
    ccall((:XDrawPoint, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint),
          dpy, d, gc, x, y)

XDrawPoints(dpy::Ptr{Display}, d::Drawable, gc::GC, points::Ptr{XPoint}, npoints::Integer, mode::Integer) =
    ccall((:XDrawPoints, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XPoint}, Cint, Cint),
          dpy, d, gc, points, npoints, mode)

XDrawRectangle(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, width::Integer, height::Integer) =
    ccall((:XDrawRectangle, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cuint, Cuint),
          dpy, d, gc, x, y, width, height)

XDrawRectangles(dpy::Ptr{Display}, d::Drawable, gc::GC, rectangles::Ptr{XRectangle}, nrectangles::Integer) =
    ccall((:XDrawRectangles, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XRectangle}, Cint),
          dpy, d, gc, rectangles, nrectangles)

XDrawSegments(dpy::Ptr{Display}, d::Drawable, gc::GC, segments::Ptr{XSegment}, nsegments::Integer) =
    ccall((:XDrawSegments, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XSegment}, Cint),
          dpy, d, gc, segments, nsegments)

XDrawString(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, str::AbstractString, length::Integer = length(str)) =
    ccall((:XDrawString, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cstring, Cint),
          dpy, d, gc, x, y, str, length)

XDrawString16(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, string::Ptr{XChar2b}, length::Integer) =
    ccall((:XDrawString16, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Ptr{XChar2b}, Cint),
          dpy, d, gc, x, y, string, length)

XDrawText(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, items::Ptr{XTextItem}, nitems::Integer) =
    ccall((:XDrawText, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Ptr{XTextItem}, Cint),
          dpy, d, gc, x, y, items, nitems)

XDrawText16(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, items::Ptr{XTextItem16}, nitems::Integer) =
    ccall((:XDrawText16, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Ptr{XTextItem16}, Cint),
          dpy, d, gc, x, y, items, nitems)

XEnableAccessControl(dpy::Ptr{Display}) =
    ccall((:XEnableAccessControl, _XLIB), Cint, (Ptr{Display},), dpy)

XEventsQueued(dpy::Ptr{Display}, mode::Integer) =
    ccall((:XEventsQueued, _XLIB), Cint, (Ptr{Display}, Cint), dpy, mode)

XFetchName(dpy::Ptr{Display}, w::Window, window_name_return::Ptr{Ptr{Cchar}}) =
    ccall((:XFetchName, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Ptr{Cchar}}),
          dpy, w, window_name_return)

XFillArc(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, width::Integer, height::Integer, angle1::Integer, angle2::Integer) =
    ccall((:XFillArc, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cuint, Cuint, Cint, Cint),
          dpy, d, gc, x, y, width, height, angle1, angle2)

XFillArcs(dpy::Ptr{Display}, d::Drawable, gc::GC, arcs::Ptr{XArc}, narcs::Integer) =
    ccall((:XFillArcs, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XArc}, Cint),
          dpy, d, gc, arcs, narcs)

XFillPolygon(dpy::Ptr{Display}, d::Drawable, gc::GC, points::Ptr{XPoint}, npoints::Integer, shape::Integer, mode::Integer) =
    ccall((:XFillPolygon, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XPoint}, Cint, Cint, Cint),
          dpy, d, gc, points, npoints, shape, mode)

XFillRectangle(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, width::Integer, height::Integer) =
    ccall((:XFillRectangle, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Cuint, Cuint),
          dpy, d, gc, x, y, width, height)

XFillRectangles(dpy::Ptr{Display}, d::Drawable, gc::GC, rectangles::Ptr{XRectangle}, nrectangles::Integer) =
    ccall((:XFillRectangles, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XRectangle}, Cint),
          dpy, d, gc, rectangles, nrectangles)

XFlush(dpy::Ptr{Display}) =
    ccall((:XFlush, _XLIB), Cint, (Ptr{Display},), dpy)

XForceScreenSaver(dpy::Ptr{Display}, mode::Integer) =
    ccall((:XForceScreenSaver, _XLIB), Cint, (Ptr{Display}, Cint), dpy, mode)

XFree(data::Ptr{Void}) =
    ccall((:XFree, _XLIB), Cint, (Ptr{Void},), data)

XFreeColormap(dpy::Ptr{Display}, colormap::Colormap) =
    ccall((:XFreeColormap, _XLIB), Cint, (Ptr{Display}, Colormap), dpy, colormap)

XFreeColors(dpy::Ptr{Display}, colormap::Colormap, pixels::Ptr{Culong}, npixels::Integer, planes::Integer) =
    ccall((:XFreeColors, _XLIB), Cint,
          (Ptr{Display}, Colormap, Ptr{Culong}, Cint, Culong),
          dpy, colormap, pixels, npixels, planes)

XFreeCursor(dpy::Ptr{Display}, cursor::Cursor) =
    ccall((:XFreeCursor, _XLIB), Cint, (Ptr{Display}, Cursor), dpy, cursor)

XFreeExtensionList(list::Ptr{Ptr{Cchar}}) =
    ccall((:XFreeExtensionList, _XLIB), Cint, (Ptr{Ptr{Cchar}},), list)

XFreeFont(dpy::Ptr{Display}, font_struct::Ptr{XFontStruct}) =
    ccall((:XFreeFont, _XLIB), Cint, (Ptr{Display}, Ptr{XFontStruct}), dpy, font_struct)

XFreeFontInfo(names::Ptr{Ptr{Cchar}}, free_info::Ptr{XFontStruct}, actual_count::Integer) =
    ccall((:XFreeFontInfo, _XLIB), Cint,
          (Ptr{Ptr{Cchar}}, Ptr{XFontStruct}, Cint),
          names, free_info, actual_count)

XFreeFontNames(list::Ptr{Ptr{Cchar}}) =
    ccall((:XFreeFontNames, _XLIB), Cint, (Ptr{Ptr{Cchar}},), list)

XFreeFontPath(list::Ptr{Ptr{Cchar}}) =
    ccall((:XFreeFontPath, _XLIB), Cint, (Ptr{Ptr{Cchar}},), list)

XFreeGC(dpy::Ptr{Display}, gc::GC) =
    ccall((:XFreeGC, _XLIB), Cint, (Ptr{Display}, GC), dpy, gc)

XFreeModifiermap(modmap::Ptr{XModifierKeymap}) =
    ccall((:XFreeModifiermap, _XLIB), Cint, (Ptr{XModifierKeymap},), modmap)

XFreePixmap(dpy::Ptr{Display}, pixmap::Pixmap) =
    ccall((:XFreePixmap, _XLIB), Cint, (Ptr{Display}, Pixmap), dpy, pixmap)

XGeometry(dpy::Ptr{Display}, screen::Integer, position::Ptr{Cchar}, default_position::Ptr{Cchar}, bwidth::Integer, fwidth::Integer, fheight::Integer, xadder::Integer, yadder::Integer, x_return::Ptr{Cint}, y_return::Ptr{Cint}, width_return::Ptr{Cint}, height_return::Ptr{Cint}) =
    ccall((:XGeometry, _XLIB), Cint,
          (Ptr{Display}, Cint, Ptr{Cchar}, Ptr{Cchar}, Cuint, Cuint, Cuint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}),
          dpy, screen, position, default_position, bwidth, fwidth, fheight, xadder, yadder, x_return, y_return, width_return, height_return)

XGetErrorDatabaseText(dpy::Ptr{Display}, name::Ptr{Cchar}, message::Ptr{Cchar}, default_string::Ptr{Cchar}, buffer_return::Ptr{Cchar}, length::Integer) =
    ccall((:XGetErrorDatabaseText, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Cint),
          dpy, name, message, default_string, buffer_return, length)

XGetErrorText(dpy::Ptr{Display}, code::Integer, buffer_return::Ptr{Cchar}, length::Integer) =
    ccall((:XGetErrorText, _XLIB), Cint,
          (Ptr{Display}, Cint, Ptr{Cchar}, Cint),
          dpy, code, buffer_return, length)

XGetFontProperty(font_struct::Ptr{XFontStruct}, atom::Atom, value_return::Ptr{Culong}) =
    ccall((:XGetFontProperty, _XLIB), _Bool,
          (Ptr{XFontStruct}, Atom, Ptr{Culong}),
          font_struct, atom, value_return)

XGetGCValues(dpy::Ptr{Display}, gc::GC, valuemask::Integer, values_return::Ptr{XGCValues}) =
    ccall((:XGetGCValues, _XLIB), Status,
          (Ptr{Display}, GC, Culong, Ptr{XGCValues}),
          dpy, gc, valuemask, values_return)

XGetGeometry(dpy::Ptr{Display}, d::Drawable, root_return::Ptr{Window}, x_return::Ptr{Cint}, y_return::Ptr{Cint}, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}, border_width_return::Ptr{Cuint}, depth_return::Ptr{Cuint}) =
    ccall((:XGetGeometry, _XLIB), Status,
          (Ptr{Display}, Drawable, Ptr{Window}, Ptr{Cint}, Ptr{Cint}, Ptr{Cuint}, Ptr{Cuint}, Ptr{Cuint}, Ptr{Cuint}),
          dpy, d, root_return, x_return, y_return, width_return, height_return, border_width_return, depth_return)

XGetIconName(dpy::Ptr{Display}, w::Window, icon_name_return::Ptr{Ptr{Cchar}}) =
    ccall((:XGetIconName, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Ptr{Cchar}}),
          dpy, w, icon_name_return)

XGetInputFocus(dpy::Ptr{Display}, focus_return::Ptr{Window}, revert_to_return::Ptr{Cint}) =
    ccall((:XGetInputFocus, _XLIB), Cint,
          (Ptr{Display}, Ptr{Window}, Ptr{Cint}),
          dpy, focus_return, revert_to_return)

XGetKeyboardControl(dpy::Ptr{Display}, values_return::Ptr{XKeyboardState}) =
    ccall((:XGetKeyboardControl, _XLIB), Cint, (Ptr{Display}, Ptr{XKeyboardState}), dpy, values_return)

XGetPointerControl(dpy::Ptr{Display}, accel_numerator_return::Ptr{Cint}, accel_denominator_return::Ptr{Cint}, threshold_return::Ptr{Cint}) =
    ccall((:XGetPointerControl, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}),
          dpy, accel_numerator_return, accel_denominator_return, threshold_return)

XGetPointerMapping(dpy::Ptr{Display}, map_return::Ptr{Cuchar}, nmap::Integer) =
    ccall((:XGetPointerMapping, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cuchar}, Cint),
          dpy, map_return, nmap)

XGetScreenSaver(dpy::Ptr{Display}, timeout_return::Ptr{Cint}, interval_return::Ptr{Cint}, prefer_blanking_return::Ptr{Cint}, allow_exposures_return::Ptr{Cint}) =
    ccall((:XGetScreenSaver, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}),
          dpy, timeout_return, interval_return, prefer_blanking_return, allow_exposures_return)

XGetTransientForHint(dpy::Ptr{Display}, w::Window, prop_window_return::Ptr{Window}) =
    ccall((:XGetTransientForHint, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Window}),
          dpy, w, prop_window_return)

XGetWindowProperty(dpy::Ptr{Display}, w::Window, property::Atom, long_offset::Integer, long_length::Integer, delete::Integer, req_type::Atom, actual_type_return::Ptr{Atom}, actual_format_return::Ptr{Cint}, nitems_return::Ptr{Culong}, bytes_after_return::Ptr{Culong}, prop_return::Ptr{Ptr{Cuchar}}) =
    ccall((:XGetWindowProperty, _XLIB), Cint,
          (Ptr{Display}, Window, Atom, Clong, Clong, _Bool, Atom, Ptr{Atom}, Ptr{Cint}, Ptr{Culong}, Ptr{Culong}, Ptr{Ptr{Cuchar}}),
          dpy, w, property, long_offset, long_length, delete, req_type, actual_type_return, actual_format_return, nitems_return, bytes_after_return, prop_return)

XGetWindowAttributes(dpy::Ptr{Display}, w::Window, window_attributes_return::Ptr{XWindowAttributes}) =
    ccall((:XGetWindowAttributes, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{XWindowAttributes}),
          dpy, w, window_attributes_return)

XGrabButton(dpy::Ptr{Display}, button::Integer, modifiers::Integer, grab_window::Window, owner_events::Integer, event_mask::Integer, pointer_mode::Integer, keyboard_mode::Integer, confine_to::Window, cursor::Cursor) =
    ccall((:XGrabButton, _XLIB), Cint,
          (Ptr{Display}, Cuint, Cuint, Window, _Bool, Cuint, Cint, Cint, Window, Cursor),
          dpy, button, modifiers, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor)

XGrabKey(dpy::Ptr{Display}, keycode::Integer, modifiers::Integer, grab_window::Window, owner_events::Integer, pointer_mode::Integer, keyboard_mode::Integer) =
    ccall((:XGrabKey, _XLIB), Cint,
          (Ptr{Display}, Cint, Cuint, Window, _Bool, Cint, Cint),
          dpy, keycode, modifiers, grab_window, owner_events, pointer_mode, keyboard_mode)

XGrabKeyboard(dpy::Ptr{Display}, grab_window::Window, owner_events::Integer, pointer_mode::Integer, keyboard_mode::Integer, time::Time) =
    ccall((:XGrabKeyboard, _XLIB), Cint,
          (Ptr{Display}, Window, _Bool, Cint, Cint, Time),
          dpy, grab_window, owner_events, pointer_mode, keyboard_mode, time)

XGrabPointer(dpy::Ptr{Display}, grab_window::Window, owner_events::Integer, event_mask::Integer, pointer_mode::Integer, keyboard_mode::Integer, confine_to::Window, cursor::Cursor, time::Time) =
    ccall((:XGrabPointer, _XLIB), Cint,
          (Ptr{Display}, Window, _Bool, Cuint, Cint, Cint, Window, Cursor, Time),
          dpy, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor, time)

XGrabServer(dpy::Ptr{Display}) =
    ccall((:XGrabServer, _XLIB), Cint, (Ptr{Display},), dpy)

XHeightMMOfScreen(screen::Ptr{Screen}) =
    ccall((:XHeightMMOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XHeightOfScreen(screen::Ptr{Screen}) =
    ccall((:XHeightOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

# FIXME: Cint XIfEvent(dpy::Ptr{Display}, event_return::Ptr{XEvent}, _Bool (*predicate) (dpy::Ptr{Display}, event::Ptr{XEvent}, arg::XPointer), arg::XPointer);
XIfEvent(dpy::Ptr{Display}, event_return::Ref{XEvent}, predicate::Cfunc, arg::XPointer) =
    ccall((:XIfEvent, _XLIB), Cint,
          (Ptr{Display}, Ptr{XEvent}, Cfunc, XPointer),
          dpy, event_return, predicate, arg)

XImageByteOrder(dpy::Ptr{Display}) =
    ccall((:XImageByteOrder, _XLIB), Cint, (Ptr{Display},), dpy)

XInstallColormap(dpy::Ptr{Display}, colormap::Colormap) =
    ccall((:XInstallColormap, _XLIB), Cint, (Ptr{Display}, Colormap), dpy, colormap)

XKeysymToKeycode(dpy::Ptr{Display}, keysym::KeySym) =
    ccall((:XKeysymToKeycode, _XLIB), KeyCode, (Ptr{Display}, KeySym), dpy, keysym)

XKillClient(dpy::Ptr{Display}, resource::XID) =
    ccall((:XKillClient, _XLIB), Cint, (Ptr{Display}, XID), dpy, resource)

XLookupColor(dpy::Ptr{Display}, colormap::Colormap, color_name::AbstractString, exact_def_return::Ref{XColor}, screen_def_return::Ref{XColor}) =
    ccall((:XLookupColor, _XLIB), Status,
          (Ptr{Display}, Colormap, Cstring, Ptr{XColor}, Ptr{XColor}),
          dpy, colormap, color_name, exact_def_return, screen_def_return)

XLowerWindow(dpy::Ptr{Display}, w::Window) =
    ccall((:XLowerWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XMapRaised(dpy::Ptr{Display}, w::Window) =
    ccall((:XMapRaised, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XMapSubwindows(dpy::Ptr{Display}, w::Window) =
    ccall((:XMapSubwindows, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XMapWindow(dpy::Ptr{Display}, w::Window) =
    ccall((:XMapWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XMaskEvent(dpy::Ptr{Display}, event_mask::Integer, event_return::Ref{XEvent}) =
    ccall((:XMaskEvent, _XLIB), Cint,
          (Ptr{Display}, Clong, Ptr{XEvent}),
          dpy, event_mask, event_return)

XMaxCmapsOfScreen(screen::Ptr{Screen}) =
    ccall((:XMaxCmapsOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XMinCmapsOfScreen(screen::Ptr{Screen}) =
    ccall((:XMinCmapsOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XMoveResizeWindow(dpy::Ptr{Display}, w::Window, x::Integer, y::Integer, width::Integer, height::Integer) =
    ccall((:XMoveResizeWindow, _XLIB), Cint,
          (Ptr{Display}, Window, Cint, Cint, Cuint, Cuint),
          dpy, w, x, y, width, height)

XMoveWindow(dpy::Ptr{Display}, w::Window, x::Integer, y::Integer) =
    ccall((:XMoveWindow, _XLIB), Cint,
          (Ptr{Display}, Window, Cint, Cint),
          dpy, w, x, y)

XNextEvent(dpy::Ptr{Display}, event_return::Ref{XEvent}) =
    ccall((:XNextEvent, _XLIB), Cint, (Ptr{Display}, Ptr{XEvent}), dpy, event_return)

XNoOp(dpy::Ptr{Display}) =
    ccall((:XNoOp, _XLIB), Cint, (Ptr{Display},), dpy)

XParseColor(dpy::Ptr{Display}, colormap::Colormap, spec::Ptr{Cchar}, exact_def_return::Ptr{XColor}) =
    ccall((:XParseColor, _XLIB), Status,
          (Ptr{Display}, Colormap, Ptr{Cchar}, Ptr{XColor}),
          dpy, colormap, spec, exact_def_return)

XParseGeometry(parsestring::Ptr{Cchar}, x_return::Ptr{Cint}, y_return::Ptr{Cint}, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}) =
    ccall((:XParseGeometry, _XLIB), Cint,
          (Ptr{Cchar}, Ptr{Cint}, Ptr{Cint}, Ptr{Cuint}, Ptr{Cuint}),
          parsestring, x_return, y_return, width_return, height_return)

XPeekEvent(dpy::Ptr{Display}, event_return::Ref{XEvent}) =
    ccall((:XPeekEvent, _XLIB), Cint, (Ptr{Display}, Ptr{XEvent}), dpy, event_return)

# FIXME: Cint XPeekIfEvent(dpy::Ptr{Display}, event_return::Ptr{XEvent}, _Bool (*predicate) (dpy::Ptr{Display}, event::Ptr{XEvent}, arg::XPointer), arg::XPointer);
XPeekIfEvent(dpy::Ptr{Display}, event_return::Ref{XEvent}, predicate::Cfunc, arg::XPointer) =
    ccall((:XPeekIfEvent, _XLIB), Cint,
          (Ptr{Display}, Ptr{XEvent}, Cfunc, XPointer),
          dpy, event_return, predicate, arg)

XPending(dpy::Ptr{Display}) =
    ccall((:XPending, _XLIB), Cint, (Ptr{Display},), dpy)

XPlanesOfScreen(screen::Ptr{Screen}) =
    ccall((:XPlanesOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XProtocolRevision(dpy::Ptr{Display}) =
    ccall((:XProtocolRevision, _XLIB), Cint, (Ptr{Display},), dpy)

XProtocolVersion(dpy::Ptr{Display}) =
    ccall((:XProtocolVersion, _XLIB), Cint, (Ptr{Display},), dpy)

XPutBackEvent(dpy::Ptr{Display}, event::Ref{XEvent}) =
    ccall((:XPutBackEvent, _XLIB), Cint, (Ptr{Display}, Ptr{XEvent}), dpy, event)

XPutImage(dpy::Ptr{Display}, d::Drawable, gc::GC, img::Ptr{XImage}, src_x::Integer, src_y::Integer, dest_x::Integer, dest_y::Integer, width::Integer, height::Integer) =
    ccall((:XPutImage, _XLIB), Cint,
          (Ptr{Display}, Drawable, GC, Ptr{XImage}, Cint, Cint, Cint, Cint, Cuint, Cuint),
          dpy, d, gc, img, src_x, src_y, dest_x, dest_y, width, height)

XQLength(dpy::Ptr{Display}) =
    ccall((:XQLength, _XLIB), Cint, (Ptr{Display},), dpy)

XQueryBestCursor(dpy::Ptr{Display}, d::Drawable, width::Integer, height::Integer, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}) =
    ccall((:XQueryBestCursor, _XLIB), Status,
          (Ptr{Display}, Drawable, Cuint, Cuint, Ptr{Cuint}, Ptr{Cuint}),
          dpy, d, width, height, width_return, height_return)

XQueryBestSize(dpy::Ptr{Display}, class::Integer, which_screen::Drawable, width::Integer, height::Integer, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}) =
    ccall((:XQueryBestSize, _XLIB), Status,
          (Ptr{Display}, Cint, Drawable, Cuint, Cuint, Ptr{Cuint}, Ptr{Cuint}),
          dpy, class, which_screen, width, height, width_return, height_return)

XQueryBestStipple(dpy::Ptr{Display}, which_screen::Drawable, width::Integer, height::Integer, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}) =
    ccall((:XQueryBestStipple, _XLIB), Status,
          (Ptr{Display}, Drawable, Cuint, Cuint, Ptr{Cuint}, Ptr{Cuint}),
          dpy, which_screen, width, height, width_return, height_return)

XQueryBestTile(dpy::Ptr{Display}, which_screen::Drawable, width::Integer, height::Integer, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}) =
    ccall((:XQueryBestTile, _XLIB), Status,
          (Ptr{Display}, Drawable, Cuint, Cuint, Ptr{Cuint}, Ptr{Cuint}),
          dpy, which_screen, width, height, width_return, height_return)

XQueryColor(dpy::Ptr{Display}, colormap::Colormap, def_in_out::Ptr{XColor}) =
    ccall((:XQueryColor, _XLIB), Cint,
          (Ptr{Display}, Colormap, Ptr{XColor}),
          dpy, colormap, def_in_out)

XQueryColors(dpy::Ptr{Display}, colormap::Colormap, defs_in_out::Ptr{XColor}, ncolors::Integer) =
    ccall((:XQueryColors, _XLIB), Cint,
          (Ptr{Display}, Colormap, Ptr{XColor}, Cint),
          dpy, colormap, defs_in_out, ncolors)

XQueryExtension(dpy::Ptr{Display}, name::Ptr{Cchar}, major_opcode_return::Ptr{Cint}, first_event_return::Ptr{Cint}, first_error_return::Ptr{Cint}) =
    ccall((:XQueryExtension, _XLIB), _Bool,
          (Ptr{Display}, Ptr{Cchar}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}),
          dpy, name, major_opcode_return, first_event_return, first_error_return)

XQueryKeymap(dpy::Ptr{Display}, keys::Cbuf32char) =
    ccall((:XQueryKeymap, _XLIB), Cint, (Ptr{Display}, Cbuf32char), dpy, keys)

XQueryPointer(dpy::Ptr{Display}, w::Window, root_return::Ptr{Window}, child_return::Ptr{Window}, root_x_return::Ptr{Cint}, root_y_return::Ptr{Cint}, win_x_return::Ptr{Cint}, win_y_return::Ptr{Cint}, mask_return::Ptr{Cuint}) =
    ccall((:XQueryPointer, _XLIB), _Bool,
          (Ptr{Display}, Window, Ptr{Window}, Ptr{Window}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cuint}),
          dpy, w, root_return, child_return, root_x_return, root_y_return, win_x_return, win_y_return, mask_return)

XQueryTextExtents(dpy::Ptr{Display}, font_ID::XID, string::Ptr{Cchar}, nchars::Integer, direction_return::Ptr{Cint}, font_ascent_return::Ptr{Cint}, font_descent_return::Ptr{Cint}, overall_return::Ptr{XCharStruct}) =
    ccall((:XQueryTextExtents, _XLIB), Cint,
          (Ptr{Display}, XID, Ptr{Cchar}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{XCharStruct}),
          dpy, font_ID, string, nchars, direction_return, font_ascent_return, font_descent_return, overall_return)

XQueryTextExtents16(dpy::Ptr{Display}, font_ID::XID, string::Ptr{XChar2b}, nchars::Integer, direction_return::Ptr{Cint}, font_ascent_return::Ptr{Cint}, font_descent_return::Ptr{Cint}, overall_return::Ptr{XCharStruct}) =
    ccall((:XQueryTextExtents16, _XLIB), Cint,
          (Ptr{Display}, XID, Ptr{XChar2b}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{XCharStruct}),
          dpy, font_ID, string, nchars, direction_return, font_ascent_return, font_descent_return, overall_return)

XQueryTree(dpy::Ptr{Display}, w::Window, root_return::Ptr{Window}, parent_return::Ptr{Window}, children_return::Ptr{Ptr{Window}}, nchildren_return::Ptr{Cuint}) =
    ccall((:XQueryTree, _XLIB), Status,
          (Ptr{Display}, Window, Ptr{Window}, Ptr{Window}, Ptr{Ptr{Window}}, Ptr{Cuint}),
          dpy, w, root_return, parent_return, children_return, nchildren_return)

XRaiseWindow(dpy::Ptr{Display}, w::Window) =
    ccall((:XRaiseWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XReadBitmapFile(dpy::Ptr{Display}, d::Drawable, filename::Ptr{Cchar}, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}, bitmap_return::Ptr{Pixmap}, x_hot_return::Ptr{Cint}, y_hot_return::Ptr{Cint}) =
    ccall((:XReadBitmapFile, _XLIB), Cint,
          (Ptr{Display}, Drawable, Ptr{Cchar}, Ptr{Cuint}, Ptr{Cuint}, Ptr{Pixmap}, Ptr{Cint}, Ptr{Cint}),
          dpy, d, filename, width_return, height_return, bitmap_return, x_hot_return, y_hot_return)

XReadBitmapFileData(filename::Ptr{Cchar}, width_return::Ptr{Cuint}, height_return::Ptr{Cuint}, data_return::Ptr{Ptr{Cuchar}}, x_hot_return::Ptr{Cint}, y_hot_return::Ptr{Cint}) =
    ccall((:XReadBitmapFileData, _XLIB), Cint,
          (Ptr{Cchar}, Ptr{Cuint}, Ptr{Cuint}, Ptr{Ptr{Cuchar}}, Ptr{Cint}, Ptr{Cint}),
          filename, width_return, height_return, data_return, x_hot_return, y_hot_return)

XRebindKeysym(dpy::Ptr{Display}, keysym::KeySym, list::Ptr{KeySym}, mod_count::Integer, string::Ptr{Cuchar}, bytes_string::Integer) =
    ccall((:XRebindKeysym, _XLIB), Cint,
          (Ptr{Display}, KeySym, Ptr{KeySym}, Cint, Ptr{Cuchar}, Cint),
          dpy, keysym, list, mod_count, string, bytes_string)

XRecolorCursor(dpy::Ptr{Display}, cursor::Cursor, foreground_color::Ptr{XColor}, background_color::Ptr{XColor}) =
    ccall((:XRecolorCursor, _XLIB), Cint,
          (Ptr{Display}, Cursor, Ptr{XColor}, Ptr{XColor}),
          dpy, cursor, foreground_color, background_color)

XRefreshKeyboardMapping(event_map::Ptr{XMappingEvent}) =
    ccall((:XRefreshKeyboardMapping, _XLIB), Cint, (Ptr{XMappingEvent},), event_map)

XRemoveFromSaveSet(dpy::Ptr{Display}, w::Window) =
    ccall((:XRemoveFromSaveSet, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XRemoveHost(dpy::Ptr{Display}, host::Ptr{XHostAddress}) =
    ccall((:XRemoveHost, _XLIB), Cint, (Ptr{Display}, Ptr{XHostAddress}), dpy, host)

XRemoveHosts(dpy::Ptr{Display}, hosts::Ptr{XHostAddress}, num_hosts::Integer) =
    ccall((:XRemoveHosts, _XLIB), Cint,
          (Ptr{Display}, Ptr{XHostAddress}, Cint),
          dpy, hosts, num_hosts)

XReparentWindow(dpy::Ptr{Display}, w::Window, parent::Window, x::Integer, y::Integer) =
    ccall((:XReparentWindow, _XLIB), Cint,
          (Ptr{Display}, Window, Window, Cint, Cint),
          dpy, w, parent, x, y)

XResetScreenSaver(dpy::Ptr{Display}) =
    ccall((:XResetScreenSaver, _XLIB), Cint, (Ptr{Display},), dpy)

XResizeWindow(dpy::Ptr{Display}, w::Window, width::Integer, height::Integer) =
    ccall((:XResizeWindow, _XLIB), Cint,
          (Ptr{Display}, Window, Cuint, Cuint),
          dpy, w, width, height)

XRestackWindows(dpy::Ptr{Display}, windows::Ptr{Window}, nwindows::Integer) =
    ccall((:XRestackWindows, _XLIB), Cint,
          (Ptr{Display}, Ptr{Window}, Cint),
          dpy, windows, nwindows)

XRotateBuffers(dpy::Ptr{Display}, rotate::Integer) =
    ccall((:XRotateBuffers, _XLIB), Cint, (Ptr{Display}, Cint), dpy, rotate)

XRotateWindowProperties(dpy::Ptr{Display}, w::Window, properties::Ptr{Atom}, num_prop::Integer, npositions::Integer) =
    ccall((:XRotateWindowProperties, _XLIB), Cint,
          (Ptr{Display}, Window, Ptr{Atom}, Cint, Cint),
          dpy, w, properties, num_prop, npositions)

XScreenCount(dpy::Ptr{Display}) =
    ccall((:XScreenCount, _XLIB), Cint, (Ptr{Display},), dpy)

XSelectInput(dpy::Ptr{Display}, w::Window, event_mask::Integer) =
    ccall((:XSelectInput, _XLIB), Cint,
          (Ptr{Display}, Window, Clong),
          dpy, w, event_mask)

XSendEvent(dpy::Ptr{Display}, w::Window, propagate::Integer, event_mask::Integer, event_send::Ref{XEvent}) =
    ccall((:XSendEvent, _XLIB), Status,
          (Ptr{Display}, Window, _Bool, Clong, Ptr{XEvent}),
          dpy, w, propagate, event_mask, event_send)

XSetAccessControl(dpy::Ptr{Display}, mode::Integer) =
    ccall((:XSetAccessControl, _XLIB), Cint, (Ptr{Display}, Cint), dpy, mode)

XSetArcMode(dpy::Ptr{Display}, gc::GC, arc_mode::Integer) =
    ccall((:XSetArcMode, _XLIB), Cint,
          (Ptr{Display}, GC, Cint),
          dpy, gc, arc_mode)

XSetBackground(dpy::Ptr{Display}, gc::GC, background::Integer) =
    ccall((:XSetBackground, _XLIB), Cint,
          (Ptr{Display}, GC, Culong),
          dpy, gc, background)

XSetClipMask(dpy::Ptr{Display}, gc::GC, pixmap::Pixmap) =
    ccall((:XSetClipMask, _XLIB), Cint,
          (Ptr{Display}, GC, Pixmap),
          dpy, gc, pixmap)

XSetClipOrigin(dpy::Ptr{Display}, gc::GC, clip_x_origin::Integer, clip_y_origin::Integer) =
    ccall((:XSetClipOrigin, _XLIB), Cint,
          (Ptr{Display}, GC, Cint, Cint),
          dpy, gc, clip_x_origin, clip_y_origin)

XSetClipRectangles(dpy::Ptr{Display}, gc::GC, clip_x_origin::Integer, clip_y_origin::Integer, rectangles::Ptr{XRectangle}, n::Integer, ordering::Integer) =
    ccall((:XSetClipRectangles, _XLIB), Cint,
          (Ptr{Display}, GC, Cint, Cint, Ptr{XRectangle}, Cint, Cint),
          dpy, gc, clip_x_origin, clip_y_origin, rectangles, n, ordering)

XSetCloseDownMode(dpy::Ptr{Display}, close_mode::Integer) =
    ccall((:XSetCloseDownMode, _XLIB), Cint, (Ptr{Display}, Cint), dpy, close_mode)

XSetCommand(dpy::Ptr{Display}, w::Window, argv::Ptr{Ptr{Cchar}}, argc::Integer) =
    ccall((:XSetCommand, _XLIB), Cint,
          (Ptr{Display}, Window, Ptr{Ptr{Cchar}}, Cint),
          dpy, w, argv, argc)

XSetDashes(dpy::Ptr{Display}, gc::GC, dash_offset::Integer, dash_list::Ptr{Cchar}, n::Integer) =
    ccall((:XSetDashes, _XLIB), Cint,
          (Ptr{Display}, GC, Cint, Ptr{Cchar}, Cint),
          dpy, gc, dash_offset, dash_list, n)

XSetFillRule(dpy::Ptr{Display}, gc::GC, fill_rule::Integer) =
    ccall((:XSetFillRule, _XLIB), Cint,
          (Ptr{Display}, GC, Cint),
          dpy, gc, fill_rule)

XSetFillStyle(dpy::Ptr{Display}, gc::GC, fill_style::Integer) =
    ccall((:XSetFillStyle, _XLIB), Cint,
          (Ptr{Display}, GC, Cint),
          dpy, gc, fill_style)

XSetFont(dpy::Ptr{Display}, gc::GC, font::Font) =
    ccall((:XSetFont, _XLIB), Cint,
          (Ptr{Display}, GC, Font),
          dpy, gc, font)

XSetFontPath(dpy::Ptr{Display}, directories::Ptr{Ptr{Cchar}}, ndirs::Integer) =
    ccall((:XSetFontPath, _XLIB), Cint,
          (Ptr{Display}, Ptr{Ptr{Cchar}}, Cint),
          dpy, directories, ndirs)

XSetForeground(dpy::Ptr{Display}, gc::GC, foreground::Integer) =
    ccall((:XSetForeground, _XLIB), Cint,
          (Ptr{Display}, GC, Culong),
          dpy, gc, foreground)

XSetFunction(dpy::Ptr{Display}, gc::GC, func::Integer) =
    ccall((:XSetFunction, _XLIB), Cint,
          (Ptr{Display}, GC, Cint),
          dpy, gc, func)

XSetGraphicsExposures(dpy::Ptr{Display}, gc::GC, graphics_exposures::Integer) =
    ccall((:XSetGraphicsExposures, _XLIB), Cint,
          (Ptr{Display}, GC, _Bool),
          dpy, gc, graphics_exposures)

XSetIconName(dpy::Ptr{Display}, w::Window, icon_name::Ptr{Cchar}) =
    ccall((:XSetIconName, _XLIB), Cint,
          (Ptr{Display}, Window, Ptr{Cchar}),
          dpy, w, icon_name)

XSetInputFocus(dpy::Ptr{Display}, focus::Window, revert_to::Integer, time::Time) =
    ccall((:XSetInputFocus, _XLIB), Cint,
          (Ptr{Display}, Window, Cint, Time),
          dpy, focus, revert_to, time)

XSetLineAttributes(dpy::Ptr{Display}, gc::GC, line_width::Integer, line_style::Integer, cap_style::Integer, join_style::Integer) =
    ccall((:XSetLineAttributes, _XLIB), Cint,
          (Ptr{Display}, GC, Cuint, Cint, Cint, Cint),
          dpy, gc, line_width, line_style, cap_style, join_style)

XSetModifierMapping(dpy::Ptr{Display}, modmap::Ptr{XModifierKeymap}) =
    ccall((:XSetModifierMapping, _XLIB), Cint, (Ptr{Display}, Ptr{XModifierKeymap}), dpy, modmap)

XSetPlaneMask(dpy::Ptr{Display}, gc::GC, plane_mask::Integer) =
    ccall((:XSetPlaneMask, _XLIB), Cint,
          (Ptr{Display}, GC, Culong),
          dpy, gc, plane_mask)

XSetPointerMapping(dpy::Ptr{Display}, map::Ptr{Cuchar}, nmap::Integer) =
    ccall((:XSetPointerMapping, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cuchar}, Cint),
          dpy, map, nmap)

XSetScreenSaver(dpy::Ptr{Display}, timeout::Integer, interval::Integer, prefer_blanking::Integer, allow_exposures::Integer) =
    ccall((:XSetScreenSaver, _XLIB), Cint,
          (Ptr{Display}, Cint, Cint, Cint, Cint),
          dpy, timeout, interval, prefer_blanking, allow_exposures)

XSetSelectionOwner(dpy::Ptr{Display}, selection::Atom, owner::Window, time::Time) =
    ccall((:XSetSelectionOwner, _XLIB), Cint,
          (Ptr{Display}, Atom, Window, Time),
          dpy, selection, owner, time)

XSetState(dpy::Ptr{Display}, gc::GC, foreground::Integer, background::Integer, func::Integer, plane_mask::Integer) =
    ccall((:XSetState, _XLIB), Cint,
          (Ptr{Display}, GC, Culong, Culong, Cint, Culong),
          dpy, gc, foreground, background, func, plane_mask)

XSetStipple(dpy::Ptr{Display}, gc::GC, stipple::Pixmap) =
    ccall((:XSetStipple, _XLIB), Cint,
          (Ptr{Display}, GC, Pixmap),
          dpy, gc, stipple)

XSetSubwindowMode(dpy::Ptr{Display}, gc::GC, subwindow_mode::Integer) =
    ccall((:XSetSubwindowMode, _XLIB), Cint,
          (Ptr{Display}, GC, Cint),
          dpy, gc, subwindow_mode)

XSetTSOrigin(dpy::Ptr{Display}, gc::GC, ts_x_origin::Integer, ts_y_origin::Integer) =
    ccall((:XSetTSOrigin, _XLIB), Cint,
          (Ptr{Display}, GC, Cint, Cint),
          dpy, gc, ts_x_origin, ts_y_origin)

XSetTile(dpy::Ptr{Display}, gc::GC, tile::Pixmap) =
    ccall((:XSetTile, _XLIB), Cint,
          (Ptr{Display}, GC, Pixmap),
          dpy, gc, tile)

XSetWindowBackground(dpy::Ptr{Display}, w::Window, background_pixel::Integer) =
    ccall((:XSetWindowBackground, _XLIB), Cint,
          (Ptr{Display}, Window, Culong),
          dpy, w, background_pixel)

XSetWindowBackgroundPixmap(dpy::Ptr{Display}, w::Window, background_pixmap::Pixmap) =
    ccall((:XSetWindowBackgroundPixmap, _XLIB), Cint,
          (Ptr{Display}, Window, Pixmap),
          dpy, w, background_pixmap)

XSetWindowBorder(dpy::Ptr{Display}, w::Window, border_pixel::Integer) =
    ccall((:XSetWindowBorder, _XLIB), Cint,
          (Ptr{Display}, Window, Culong),
          dpy, w, border_pixel)

XSetWindowBorderPixmap(dpy::Ptr{Display}, w::Window, border_pixmap::Pixmap) =
    ccall((:XSetWindowBorderPixmap, _XLIB), Cint,
          (Ptr{Display}, Window, Pixmap),
          dpy, w, border_pixmap)

XSetWindowBorderWidth(dpy::Ptr{Display}, w::Window, width::Integer) =
    ccall((:XSetWindowBorderWidth, _XLIB), Cint,
          (Ptr{Display}, Window, Cuint),
          dpy, w, width)

XSetWindowColormap(dpy::Ptr{Display}, w::Window, colormap::Colormap) =
    ccall((:XSetWindowColormap, _XLIB), Cint,
          (Ptr{Display}, Window, Colormap),
          dpy, w, colormap)

XStoreBuffer(dpy::Ptr{Display}, bytes::Ptr{Cchar}, nbytes::Integer, buffer::Integer) =
    ccall((:XStoreBuffer, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cchar}, Cint, Cint),
          dpy, bytes, nbytes, buffer)

XStoreBytes(dpy::Ptr{Display}, bytes::Ptr{Cchar}, nbytes::Integer) =
    ccall((:XStoreBytes, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cchar}, Cint),
          dpy, bytes, nbytes)

XStoreColor(dpy::Ptr{Display}, colormap::Colormap, color::Ptr{XColor}) =
    ccall((:XStoreColor, _XLIB), Cint,
          (Ptr{Display}, Colormap, Ptr{XColor}),
          dpy, colormap, color)

XStoreColors(dpy::Ptr{Display}, colormap::Colormap, color::Ptr{XColor}, ncolors::Integer) =
    ccall((:XStoreColors, _XLIB), Cint,
          (Ptr{Display}, Colormap, Ptr{XColor}, Cint),
          dpy, colormap, color, ncolors)

XStoreName(dpy::Ptr{Display}, w::Window, window_name::Ptr{Cchar}) =
    ccall((:XStoreName, _XLIB), Cint,
          (Ptr{Display}, Window, Ptr{Cchar}),
          dpy, w, window_name)

XStoreNamedColor(dpy::Ptr{Display}, colormap::Colormap, color::Ptr{Cchar}, pixel::Integer, flags::Integer) =
    ccall((:XStoreNamedColor, _XLIB), Cint,
          (Ptr{Display}, Colormap, Ptr{Cchar}, Culong, Cint),
          dpy, colormap, color, pixel, flags)

XSync(dpy::Ptr{Display}, discard::Integer) =
    ccall((:XSync, _XLIB), Cint, (Ptr{Display}, _Bool), dpy, discard)

XTextExtents(font_struct::Ptr{XFontStruct}, string::Ptr{Cchar}, nchars::Integer, direction_return::Ptr{Cint}, font_ascent_return::Ptr{Cint}, font_descent_return::Ptr{Cint}, overall_return::Ptr{XCharStruct}) =
    ccall((:XTextExtents, _XLIB), Cint,
          (Ptr{XFontStruct}, Ptr{Cchar}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{XCharStruct}),
          font_struct, string, nchars, direction_return, font_ascent_return, font_descent_return, overall_return)

XTextExtents16(font_struct::Ptr{XFontStruct}, string::Ptr{XChar2b}, nchars::Integer, direction_return::Ptr{Cint}, font_ascent_return::Ptr{Cint}, font_descent_return::Ptr{Cint}, overall_return::Ptr{XCharStruct}) =
    ccall((:XTextExtents16, _XLIB), Cint,
          (Ptr{XFontStruct}, Ptr{XChar2b}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{XCharStruct}),
          font_struct, string, nchars, direction_return, font_ascent_return, font_descent_return, overall_return)

XTextWidth(font_struct::Ptr{XFontStruct}, string::Ptr{Cchar}, count::Integer) =
    ccall((:XTextWidth, _XLIB), Cint,
          (Ptr{XFontStruct}, Ptr{Cchar}, Cint),
          font_struct, string, count)

XTextWidth16(font_struct::Ptr{XFontStruct}, string::Ptr{XChar2b}, count::Integer) =
    ccall((:XTextWidth16, _XLIB), Cint,
          (Ptr{XFontStruct}, Ptr{XChar2b}, Cint),
          font_struct, string, count)

XTranslateCoordinates(dpy::Ptr{Display}, src_w::Window, dest_w::Window, src_x::Integer, src_y::Integer, dest_x_return::Ptr{Cint}, dest_y_return::Ptr{Cint}, child_return::Ptr{Window}) =
    ccall((:XTranslateCoordinates, _XLIB), _Bool,
          (Ptr{Display}, Window, Window, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Window}),
          dpy, src_w, dest_w, src_x, src_y, dest_x_return, dest_y_return, child_return)

XUndefineCursor(dpy::Ptr{Display}, w::Window) =
    ccall((:XUndefineCursor, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XUngrabButton(dpy::Ptr{Display}, button::Integer, modifiers::Integer, grab_window::Window) =
    ccall((:XUngrabButton, _XLIB), Cint,
          (Ptr{Display}, Cuint, Cuint, Window),
          dpy, button, modifiers, grab_window)

XUngrabKey(dpy::Ptr{Display}, keycode::Integer, modifiers::Integer, grab_window::Window) =
    ccall((:XUngrabKey, _XLIB), Cint,
          (Ptr{Display}, Cint, Cuint, Window),
          dpy, keycode, modifiers, grab_window)

XUngrabKeyboard(dpy::Ptr{Display}, time::Time) =
    ccall((:XUngrabKeyboard, _XLIB), Cint, (Ptr{Display}, Time), dpy, time)

XUngrabPointer(dpy::Ptr{Display}, time::Time) =
    ccall((:XUngrabPointer, _XLIB), Cint, (Ptr{Display}, Time), dpy, time)

XUngrabServer(dpy::Ptr{Display}) =
    ccall((:XUngrabServer, _XLIB), Cint, (Ptr{Display},), dpy)

XUninstallColormap(dpy::Ptr{Display}, colormap::Colormap) =
    ccall((:XUninstallColormap, _XLIB), Cint, (Ptr{Display}, Colormap), dpy, colormap)

XUnloadFont(dpy::Ptr{Display}, font::Font) =
    ccall((:XUnloadFont, _XLIB), Cint, (Ptr{Display}, Font), dpy, font)

XUnmapSubwindows(dpy::Ptr{Display}, w::Window) =
    ccall((:XUnmapSubwindows, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XUnmapWindow(dpy::Ptr{Display}, w::Window) =
    ccall((:XUnmapWindow, _XLIB), Cint, (Ptr{Display}, Window), dpy, w)

XVendorRelease(dpy::Ptr{Display}) =
    ccall((:XVendorRelease, _XLIB), Cint, (Ptr{Display},), dpy)

XWarpPointer(dpy::Ptr{Display}, src_w::Window, dest_w::Window, src_x::Integer, src_y::Integer, src_width::Integer, src_height::Integer, dest_x::Integer, dest_y::Integer) =
    ccall((:XWarpPointer, _XLIB), Cint,
          (Ptr{Display}, Window, Window, Cint, Cint, Cuint, Cuint, Cint, Cint),
          dpy, src_w, dest_w, src_x, src_y, src_width, src_height, dest_x, dest_y)

XWidthMMOfScreen(screen::Ptr{Screen}) =
    ccall((:XWidthMMOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XWidthOfScreen(screen::Ptr{Screen}) =
    ccall((:XWidthOfScreen, _XLIB), Cint, (Ptr{Screen},), screen)

XWindowEvent(dpy::Ptr{Display}, w::Window, event_mask::Integer, event_return::Ref{XEvent}) =
    ccall((:XWindowEvent, _XLIB), Cint,
          (Ptr{Display}, Window, Clong, Ptr{XEvent}),
          dpy, w, event_mask, event_return)

XWriteBitmapFile(dpy::Ptr{Display}, filename::Ptr{Cchar}, bitmap::Pixmap, width::Integer, height::Integer, x_hot::Integer, y_hot::Integer) =
    ccall((:XWriteBitmapFile, _XLIB), Cint,
          (Ptr{Display}, Ptr{Cchar}, Pixmap, Cuint, Cuint, Cint, Cint),
          dpy, filename, bitmap, width, height, x_hot, y_hot)

XSupportsLocale() =
    ccall((:XSupportsLocale, _XLIB), _Bool, (), )

XSetLocaleModifiers(modifier_list::Ptr{Cchar}) =
    ccall((:XSetLocaleModifiers, _XLIB), Ptr{Cchar}, (Ptr{Cchar},), modifier_list)

XOpenOM(dpy::Ptr{Display}, rdb::Ptr{XrmHashBucketRec}, res_name::Ptr{Cchar}, res_class::Ptr{Cchar}) =
    ccall((:XOpenOM, _XLIB), XOM,
          (Ptr{Display}, Ptr{XrmHashBucketRec}, Ptr{Cchar}, Ptr{Cchar}),
          dpy, rdb, res_name, res_class)

XCloseOM(om::XOM) =
    ccall((:XCloseOM, _XLIB), Status, (XOM,), om)

# FIXME: Ptr{Cchar} XSetOMValues(om::XOM, ...);

# FIXME: Ptr{Cchar} XGetOMValues(om::XOM, ...);

XDisplayOfOM(om::XOM) =
    ccall((:XDisplayOfOM, _XLIB), Ptr{Display}, (XOM,), om)

XLocaleOfOM(om::XOM) =
    ccall((:XLocaleOfOM, _XLIB), Ptr{Cchar}, (XOM,), om)

# FIXME: XOC XCreateOC(om::XOM, ...);

XDestroyOC(oc::XOC) =
    ccall((:XDestroyOC, _XLIB), Void, (XOC,), oc)

XOMOfOC(oc::XOC) =
    ccall((:XOMOfOC, _XLIB), XOM, (XOC,), oc)

# FIXME: Ptr{Cchar} XSetOCValues(oc::XOC, ...);

# FIXME: Ptr{Cchar} XGetOCValues(oc::XOC, ...);

XCreateFontSet(dpy::Ptr{Display}, base_font_name_list::Ptr{Cchar}, missing_charset_list::Ptr{Ptr{Ptr{Cchar}}}, missing_charset_count::Ptr{Cint}, def_string::Ptr{Ptr{Cchar}}) =
    ccall((:XCreateFontSet, _XLIB), XFontSet,
          (Ptr{Display}, Ptr{Cchar}, Ptr{Ptr{Ptr{Cchar}}}, Ptr{Cint}, Ptr{Ptr{Cchar}}),
          dpy, base_font_name_list, missing_charset_list, missing_charset_count, def_string)

XFreeFontSet(dpy::Ptr{Display}, font_set::XFontSet) =
    ccall((:XFreeFontSet, _XLIB), Void, (Ptr{Display}, XFontSet), dpy, font_set)

XFontsOfFontSet(font_set::XFontSet, font_struct_list::Ptr{Ptr{Ptr{XFontStruct}}}, font_name_list::Ptr{Ptr{Ptr{Cchar}}}) =
    ccall((:XFontsOfFontSet, _XLIB), Cint,
          (XFontSet, Ptr{Ptr{Ptr{XFontStruct}}}, Ptr{Ptr{Ptr{Cchar}}}),
          font_set, font_struct_list, font_name_list)

XBaseFontNameListOfFontSet(font_set::XFontSet) =
    ccall((:XBaseFontNameListOfFontSet, _XLIB), Ptr{Cchar}, (XFontSet,), font_set)

XLocaleOfFontSet(font_set::XFontSet) =
    ccall((:XLocaleOfFontSet, _XLIB), Ptr{Cchar}, (XFontSet,), font_set)

XContextDependentDrawing(font_set::XFontSet) =
    ccall((:XContextDependentDrawing, _XLIB), _Bool, (XFontSet,), font_set)

XDirectionalDependentDrawing(font_set::XFontSet) =
    ccall((:XDirectionalDependentDrawing, _XLIB), _Bool, (XFontSet,), font_set)

XContextualDrawing(font_set::XFontSet) =
    ccall((:XContextualDrawing, _XLIB), _Bool, (XFontSet,), font_set)

XExtentsOfFontSet(font_set::XFontSet) =
    ccall((:XExtentsOfFontSet, _XLIB), Ptr{XFontSetExtents}, (XFontSet,), font_set)

XmbTextEscapement(font_set::XFontSet, text::Ptr{Cchar}, bytes_text::Integer) =
    ccall((:XmbTextEscapement, _XLIB), Cint,
          (XFontSet, Ptr{Cchar}, Cint),
          font_set, text, bytes_text)

XwcTextEscapement(font_set::XFontSet, text::Ptr{Cwchar_t}, num_wchars::Integer) =
    ccall((:XwcTextEscapement, _XLIB), Cint,
          (XFontSet, Ptr{Cwchar_t}, Cint),
          font_set, text, num_wchars)

Xutf8TextEscapement(font_set::XFontSet, text::Ptr{Cchar}, bytes_text::Integer) =
    ccall((:Xutf8TextEscapement, _XLIB), Cint,
          (XFontSet, Ptr{Cchar}, Cint),
          font_set, text, bytes_text)

XmbTextExtents(font_set::XFontSet, text::Ptr{Cchar}, bytes_text::Integer, overall_ink_return::Ptr{XRectangle}, overall_logical_return::Ptr{XRectangle}) =
    ccall((:XmbTextExtents, _XLIB), Cint,
          (XFontSet, Ptr{Cchar}, Cint, Ptr{XRectangle}, Ptr{XRectangle}),
          font_set, text, bytes_text, overall_ink_return, overall_logical_return)

XwcTextExtents(font_set::XFontSet, text::Ptr{Cwchar_t}, num_wchars::Integer, overall_ink_return::Ptr{XRectangle}, overall_logical_return::Ptr{XRectangle}) =
    ccall((:XwcTextExtents, _XLIB), Cint,
          (XFontSet, Ptr{Cwchar_t}, Cint, Ptr{XRectangle}, Ptr{XRectangle}),
          font_set, text, num_wchars, overall_ink_return, overall_logical_return)

Xutf8TextExtents(font_set::XFontSet, text::Ptr{Cchar}, bytes_text::Integer, overall_ink_return::Ptr{XRectangle}, overall_logical_return::Ptr{XRectangle}) =
    ccall((:Xutf8TextExtents, _XLIB), Cint,
          (XFontSet, Ptr{Cchar}, Cint, Ptr{XRectangle}, Ptr{XRectangle}),
          font_set, text, bytes_text, overall_ink_return, overall_logical_return)

XmbTextPerCharExtents(font_set::XFontSet, text::Ptr{Cchar}, bytes_text::Integer, ink_extents_buffer::Ptr{XRectangle}, logical_extents_buffer::Ptr{XRectangle}, buffer_size::Integer, num_chars::Ptr{Cint}, overall_ink_return::Ptr{XRectangle}, overall_logical_return::Ptr{XRectangle}) =
    ccall((:XmbTextPerCharExtents, _XLIB), Status,
          (XFontSet, Ptr{Cchar}, Cint, Ptr{XRectangle}, Ptr{XRectangle}, Cint, Ptr{Cint}, Ptr{XRectangle}, Ptr{XRectangle}),
          font_set, text, bytes_text, ink_extents_buffer, logical_extents_buffer, buffer_size, num_chars, overall_ink_return, overall_logical_return)

XwcTextPerCharExtents(font_set::XFontSet, text::Ptr{Cwchar_t}, num_wchars::Integer, ink_extents_buffer::Ptr{XRectangle}, logical_extents_buffer::Ptr{XRectangle}, buffer_size::Integer, num_chars::Ptr{Cint}, overall_ink_return::Ptr{XRectangle}, overall_logical_return::Ptr{XRectangle}) =
    ccall((:XwcTextPerCharExtents, _XLIB), Status,
          (XFontSet, Ptr{Cwchar_t}, Cint, Ptr{XRectangle}, Ptr{XRectangle}, Cint, Ptr{Cint}, Ptr{XRectangle}, Ptr{XRectangle}),
          font_set, text, num_wchars, ink_extents_buffer, logical_extents_buffer, buffer_size, num_chars, overall_ink_return, overall_logical_return)

Xutf8TextPerCharExtents(font_set::XFontSet, text::Ptr{Cchar}, bytes_text::Integer, ink_extents_buffer::Ptr{XRectangle}, logical_extents_buffer::Ptr{XRectangle}, buffer_size::Integer, num_chars::Ptr{Cint}, overall_ink_return::Ptr{XRectangle}, overall_logical_return::Ptr{XRectangle}) =
    ccall((:Xutf8TextPerCharExtents, _XLIB), Status,
          (XFontSet, Ptr{Cchar}, Cint, Ptr{XRectangle}, Ptr{XRectangle}, Cint, Ptr{Cint}, Ptr{XRectangle}, Ptr{XRectangle}),
          font_set, text, bytes_text, ink_extents_buffer, logical_extents_buffer, buffer_size, num_chars, overall_ink_return, overall_logical_return)

XmbDrawText(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, text_items::Ptr{XmbTextItem}, nitems::Integer) =
    ccall((:XmbDrawText, _XLIB), Void,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Ptr{XmbTextItem}, Cint),
          dpy, d, gc, x, y, text_items, nitems)

XwcDrawText(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, text_items::Ptr{XwcTextItem}, nitems::Integer) =
    ccall((:XwcDrawText, _XLIB), Void,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Ptr{XwcTextItem}, Cint),
          dpy, d, gc, x, y, text_items, nitems)

Xutf8DrawText(dpy::Ptr{Display}, d::Drawable, gc::GC, x::Integer, y::Integer, text_items::Ptr{XmbTextItem}, nitems::Integer) =
    ccall((:Xutf8DrawText, _XLIB), Void,
          (Ptr{Display}, Drawable, GC, Cint, Cint, Ptr{XmbTextItem}, Cint),
          dpy, d, gc, x, y, text_items, nitems)

XmbDrawString(dpy::Ptr{Display}, d::Drawable, font_set::XFontSet, gc::GC, x::Integer, y::Integer, text::Ptr{Cchar}, bytes_text::Integer) =
    ccall((:XmbDrawString, _XLIB), Void,
          (Ptr{Display}, Drawable, XFontSet, GC, Cint, Cint, Ptr{Cchar}, Cint),
          dpy, d, font_set, gc, x, y, text, bytes_text)

XwcDrawString(dpy::Ptr{Display}, d::Drawable, font_set::XFontSet, gc::GC, x::Integer, y::Integer, text::Ptr{Cwchar_t}, num_wchars::Integer) =
    ccall((:XwcDrawString, _XLIB), Void,
          (Ptr{Display}, Drawable, XFontSet, GC, Cint, Cint, Ptr{Cwchar_t}, Cint),
          dpy, d, font_set, gc, x, y, text, num_wchars)

Xutf8DrawString(dpy::Ptr{Display}, d::Drawable, font_set::XFontSet, gc::GC, x::Integer, y::Integer, text::Ptr{Cchar}, bytes_text::Integer) =
    ccall((:Xutf8DrawString, _XLIB), Void,
          (Ptr{Display}, Drawable, XFontSet, GC, Cint, Cint, Ptr{Cchar}, Cint),
          dpy, d, font_set, gc, x, y, text, bytes_text)

XmbDrawImageString(dpy::Ptr{Display}, d::Drawable, font_set::XFontSet, gc::GC, x::Integer, y::Integer, text::Ptr{Cchar}, bytes_text::Integer) =
    ccall((:XmbDrawImageString, _XLIB), Void,
          (Ptr{Display}, Drawable, XFontSet, GC, Cint, Cint, Ptr{Cchar}, Cint),
          dpy, d, font_set, gc, x, y, text, bytes_text)

XwcDrawImageString(dpy::Ptr{Display}, d::Drawable, font_set::XFontSet, gc::GC, x::Integer, y::Integer, text::Ptr{Cwchar_t}, num_wchars::Integer) =
    ccall((:XwcDrawImageString, _XLIB), Void,
          (Ptr{Display}, Drawable, XFontSet, GC, Cint, Cint, Ptr{Cwchar_t}, Cint),
          dpy, d, font_set, gc, x, y, text, num_wchars)

Xutf8DrawImageString(dpy::Ptr{Display}, d::Drawable, font_set::XFontSet, gc::GC, x::Integer, y::Integer, text::Ptr{Cchar}, bytes_text::Integer) =
    ccall((:Xutf8DrawImageString, _XLIB), Void,
          (Ptr{Display}, Drawable, XFontSet, GC, Cint, Cint, Ptr{Cchar}, Cint),
          dpy, d, font_set, gc, x, y, text, bytes_text)

XOpenIM(dpy::Ptr{Display}, rdb::Ptr{XrmHashBucketRec}, res_name::Ptr{Cchar}, res_class::Ptr{Cchar}) =
    ccall((:XOpenIM, _XLIB), XIM,
          (Ptr{Display}, Ptr{XrmHashBucketRec}, Ptr{Cchar}, Ptr{Cchar}),
          dpy, rdb, res_name, res_class)

XCloseIM(im::XIM) =
    ccall((:XCloseIM, _XLIB), Status, (XIM,), im)

# FIXME: Ptr{Cchar} XGetIMValues(im::XIM, ...);

# FIXME: Ptr{Cchar} XSetIMValues(im::XIM, ...);

XDisplayOfIM(im::XIM) =
    ccall((:XDisplayOfIM, _XLIB), Ptr{Display}, (XIM,), im)

XLocaleOfIM(im::XIM) =
    ccall((:XLocaleOfIM, _XLIB), Ptr{Cchar}, (XIM,), im)

# FIXME: XIC XCreateIC(im::XIM, ...);

XDestroyIC(ic::XIC) =
    ccall((:XDestroyIC, _XLIB), Void, (XIC,), ic)

XSetICFocus(ic::XIC) =
    ccall((:XSetICFocus, _XLIB), Void, (XIC,), ic)

XUnsetICFocus(ic::XIC) =
    ccall((:XUnsetICFocus, _XLIB), Void, (XIC,), ic)

XwcResetIC(ic::XIC) =
    ccall((:XwcResetIC, _XLIB), Ptr{Cwchar_t}, (XIC,), ic)

XmbResetIC(ic::XIC) =
    ccall((:XmbResetIC, _XLIB), Ptr{Cchar}, (XIC,), ic)

Xutf8ResetIC(ic::XIC) =
    ccall((:Xutf8ResetIC, _XLIB), Ptr{Cchar}, (XIC,), ic)

# FIXME: Ptr{Cchar} XSetICValues(ic::XIC, ...);

# FIXME: Ptr{Cchar} XGetICValues(ic::XIC, ...);

XIMOfIC(ic::XIC) =
    ccall((:XIMOfIC, _XLIB), XIM, (XIC,), ic)

XFilterEvent(event::Ref{XEvent}, window::Window) =
    ccall((:XFilterEvent, _XLIB), _Bool, (Ptr{XEvent}, Window), event, window)

XmbLookupString(ic::XIC, event::Ptr{XKeyPressedEvent}, buffer_return::Ptr{Cchar}, bytes_buffer::Integer, keysym_return::Ptr{KeySym}, status_return::Ptr{Status}) =
    ccall((:XmbLookupString, _XLIB), Cint,
          (XIC, Ptr{XKeyPressedEvent}, Ptr{Cchar}, Cint, Ptr{KeySym}, Ptr{Status}),
          ic, event, buffer_return, bytes_buffer, keysym_return, status_return)

XwcLookupString(ic::XIC, event::Ptr{XKeyPressedEvent}, buffer_return::Ptr{Cwchar_t}, wchars_buffer::Integer, keysym_return::Ptr{KeySym}, status_return::Ptr{Status}) =
    ccall((:XwcLookupString, _XLIB), Cint,
          (XIC, Ptr{XKeyPressedEvent}, Ptr{Cwchar_t}, Cint, Ptr{KeySym}, Ptr{Status}),
          ic, event, buffer_return, wchars_buffer, keysym_return, status_return)

Xutf8LookupString(ic::XIC, event::Ptr{XKeyPressedEvent}, buffer_return::Ptr{Cchar}, bytes_buffer::Integer, keysym_return::Ptr{KeySym}, status_return::Ptr{Status}) =
    ccall((:Xutf8LookupString, _XLIB), Cint,
          (XIC, Ptr{XKeyPressedEvent}, Ptr{Cchar}, Cint, Ptr{KeySym}, Ptr{Status}),
          ic, event, buffer_return, bytes_buffer, keysym_return, status_return)

# FIXME: XVaNestedList XVaCreateNestedList(unused::Cint, ...);

# Internal connections for IMs

XRegisterIMInstantiateCallback(dpy::Ptr{Display}, rdb::Ptr{XrmHashBucketRec}, res_name::Ptr{Cchar}, res_class::Ptr{Cchar}, callback::XIDProc, client_data::XPointer) =
    ccall((:XRegisterIMInstantiateCallback, _XLIB), _Bool,
          (Ptr{Display}, Ptr{XrmHashBucketRec}, Ptr{Cchar}, Ptr{Cchar}, XIDProc, XPointer),
          dpy, rdb, res_name, res_class, callback, client_data)

XUnregisterIMInstantiateCallback(dpy::Ptr{Display}, rdb::Ptr{XrmHashBucketRec}, res_name::Ptr{Cchar}, res_class::Ptr{Cchar}, callback::XIDProc, client_data::XPointer) =
    ccall((:XUnregisterIMInstantiateCallback, _XLIB), _Bool,
          (Ptr{Display}, Ptr{XrmHashBucketRec}, Ptr{Cchar}, Ptr{Cchar}, XIDProc, XPointer),
          dpy, rdb, res_name, res_class, callback, client_data)

# FIXME:
# typedef Void (*XConnectionWatchProc)(
# dpy::Ptr{Display},
# client_data::XPointer,
# fd::Cint,
# opening::Integer, # open or close flag
# watch_data::Ptr{XPointer}# open sets, close uses
# );
const XConnectionWatchProc = Cfunc

XInternalConnectionNumbers(dpy::Ptr{Display}, fd_return::Ptr{Ptr{Cint}}, count_return::Ptr{Cint}) =
    ccall((:XInternalConnectionNumbers, _XLIB), Status,
          (Ptr{Display}, Ptr{Ptr{Cint}}, Ptr{Cint}),
          dpy, fd_return, count_return)

XProcessInternalConnection(dpy::Ptr{Display}, fd::Integer) =
    ccall((:XProcessInternalConnection, _XLIB), Void, (Ptr{Display}, Cint), dpy, fd)

XAddConnectionWatch(dpy::Ptr{Display}, callback::XConnectionWatchProc, client_data::XPointer) =
    ccall((:XAddConnectionWatch, _XLIB), Status,
          (Ptr{Display}, XConnectionWatchProc, XPointer),
          dpy, callback, client_data)

XRemoveConnectionWatch(dpy::Ptr{Display}, callback::XConnectionWatchProc, client_data::XPointer) =
    ccall((:XRemoveConnectionWatch, _XLIB), Void,
          (Ptr{Display}, XConnectionWatchProc, XPointer),
          dpy, callback, client_data)

XSetAuthorization(name::Ptr{Cchar}, namelen::Integer, data::Ptr{Cchar}, datalen::Integer) =
    ccall((:XSetAuthorization, _XLIB), Void,
          (Ptr{Cchar}, Cint, Ptr{Cchar}, Cint),
          name, namelen, data, datalen)

_Xmbtowc(wstr::Ptr{Cwchar_t}, str::Ptr{Cchar}, len::Integer) =
    ccall((:_Xmbtowc, _XLIB), Cint,
          (Ptr{Cwchar_t}, Ptr{Cchar}, Cint),
          wstr, str, len)

_Xwctomb(str::Ptr{Cchar}, wc::Cwchar_t) =
    ccall((:_Xwctomb, _XLIB), Cint, (Ptr{Cchar}, Cwchar_t), str, wc)

XGetEventData(dpy::Ptr{Display}, cookie::Ptr{XGenericEventCookie}) =
    ccall((:XGetEventData, _XLIB), _Bool, (Ptr{Display}, Ptr{XGenericEventCookie}), dpy, cookie)

XFreeEventData(dpy::Ptr{Display}, cookie::Ptr{XGenericEventCookie}) =
    ccall((:XFreeEventData, _XLIB), Void, (Ptr{Display}, Ptr{XGenericEventCookie}), dpy, cookie)
