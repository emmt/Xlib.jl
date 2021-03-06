#
# types.jl --
#
# Type definitions for Julia wrapper of X11 library.
#
#------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
#
# This file is part of Xlib.jl which is licensed under the MIT "Expat" License.
#

# Basic types as defined for the client in `X.h` (also in `Xdefs.h`) and
# `Xlib.h`.

const Atom     = Culong
const Mask     = Culong
const Time     = Culong
const VisualID = Culong
const XID      = Culong
const KeyCode  = Cuchar
const _Bool    = Cint    # renamed to avoid conflicts
const XPointer = Ptr{Cchar}
const Status   = Cint


# Resources

const Colormap = XID
const Cursor   = XID
const Drawable = XID
const Font     = XID
const GContext = XID
const KeySym   = XID
const Pixmap   = XID
const Window   = XID

include("../deps/types.jl")

# Other basic types introduced to deal with Julia/C conversion.

const Opaque = Void       # so that only a pointer of this can be retrieved
const Cfunc = Ptr{Void}   # for C-functions
const XPrivate = Opaque
const XrmHashBucketRec = Opaque


# Extensions need a way to hang private data on some structures.

type XExtData
    number::Cint           # number returned by XRegisterExtension
    next::Ptr{XExtData}    # next item on list of data for structure
    free_private::Cfunc    # called to free private storage
    private_data::XPointer # data private to this extension.
end


# This file contains structures used by the extension mechanism.

immutable XExtCodes    # public to extension, cannot be changed
    extension::Cint    # extension number
    major_opcode::Cint # major op-code assigned by server
    first_event::Cint  # first event number for the extension
    first_error::Cint  # first error number for the extension
end


# Data structure for retrieving info about pixmap formats.

type XPixmapFormatValues
    depth::Cint
    bits_per_pixel::Cint
    scanline_pad::Cint
end


# Data structure for setting graphics context.

type XGCValues
    _function::Cint           # logical operation
    plane_mask::Culong        # plane mask
    foreground::Culong        # foreground pixel
    background::Culong        # background pixel
    line_width::Cint          # line width
    line_style::Cint          # LineSolid, LineOnOffDash, LineDoubleDash
    cap_style::Cint           # CapNotLast, CapButt, CapRound, CapProjecting
    join_style::Cint          # JoinMiter, JoinRound, JoinBevel
    fill_style::Cint          # FillSolid, FillTiled, FillStippled, FillOpaeueStippled
    fill_rule::Cint           # EvenOddRule, WindingRule
    arc_mode::Cint            # ArcChord, ArcPieSlice
    tile::Pixmap              # tile pixmap for tiling operations
    stipple::Pixmap           # stipple 1 plane pixmap for stipping
    ts_x_origin::Cint         # offset for tile or stipple operations
    ts_y_origin::Cint
    font::Font                # default text font for text operations
    subwindow_mode::Cint      # ClipByChildren, IncludeInferiors
    graphics_exposures::_Bool # boolean, should exposures be generated
    clip_x_origin::Cint       # origin for clipping
    clip_y_origin::Cint
    clip_mask::Pixmap         # bitmap clipping; other calls for rects
    dash_offset::Cint         # patterned/dashed line information
    dashes::Cchar
end


# Graphics context.  The contents of this structure are implementation
# dependent.  A GC should be treated as opaque by application code.

immutable _XGC
    ext_data::Ptr{XExtData} # hook for extension to hang data
    gid::GContext           # protocol ID for graphics context
    # FIXME: there is more to this structure, but it is private to Xlib
end

const GC = Ptr{_XGC}


# Visual structure; contains information about colormapping possible.

immutable Visual
    ext_data::Ptr{XExtData} # hook for extension to hang data
    visualid::VisualID      # visual id of this visual
    class::Cint             # class of screen (monochrome, etc.)
    red_mask::Culong        # red mask
    green_mask::Culong      # green mask
    blue_mask::Culong       # blue mask
    bits_per_rgb::Cint      # log base 2 of distinct color values
    map_entries::Cint       # color map entries
end


# Depth structure; contains information for each possible depth.

immutable Depth
    depth::Cint          # this depth (Z) of the depth
    nvisuals::Cint       # number of Visual types at this depth
    visuals::Ptr{Visual} # list of visuals possible at this depth
end


# Information about the screen.  The contents of this structure are
# implementation dependent.  A Screen should be treated as opaque by
# application code.

immutable Screen
    ext_data::Ptr{XExtData}  # hook for extension to hang data
    display::Ptr{Opaque}     # FIXME: back pointer to display structure
    root::Window             # Root window id.
    width::Cint              # width of screen
    height::Cint             # height of screen
    mwidth::Cint             # width of screen in millimeters
    mheight::Cint            # height of screen in millimeters
    ndepths::Cint            # number of depths possible
    depths::Ptr{Depth}       # list of allowable depths on the screen
    root_depth::Cint         # bits per pixel
    root_visual::Ptr{Visual} # root visual
    default_gc::GC           # GC for the root root visual
    cmap::Colormap           # default color map
    white_pixel::Culong      # White pixel value
    black_pixel::Culong      # Black pixel value
    max_maps::Cint           # max color maps
    min_maps::Cint           # min color maps
    backing_store::Cint      # Never, WhenMapped, Always
    save_unders::_Bool
    root_input_mask::Clong   # initial root input mask
end


# Format structure; describes ZFormat data the screen will understand.

immutable ScreenFormat
    ext_data::Ptr{XExtData} # hook for extension to hang data
    depth::Cint             # depth of this image format
    bits_per_pixel::Cint    # bits/pixel at this depth
    scanline_pad::Cint      # scanline must padded to this multiple
end


# Data structure for setting window attributes.

type XSetWindowAttributes
    background_pixmap::Pixmap     # background or None or ParentRelative
    background_pixel::Culong      # background pixel
    border_pixmap::Pixmap         # border of the window
    border_pixel::Culong          # border pixel value
    bit_gravity::Cint             # one of bit gravity values
    win_gravity::Cint             # one of the window gravity values
    backing_store::Cint           # NotUseful, WhenMapped, Always
    backing_planes::Culong        # planes to be preseved if possible
    backing_pixel::Culong         # value to use in restoring planes
    save_under::_Bool             # should bits under be saved? (popups)
    event_mask::Clong             # set of events that should be saved
    do_not_propagate_mask::Culong # set of events that should not propagate
    override_redirect::_Bool      # boolean value for override-redirect
    colormap::Colormap            # color map to be associated with window
    cursor::Cursor                # cursor to be displayed (or None)
end

type XWindowAttributes
    x::Cint; y::Cint              # location of window
    width::Cint; height::Cint     # width and height of window
    border_width::Cint            # border width of window
    depth::Cint                   # depth of window
    visual::Ptr{Visual}           # the associated visual structure
    root::Window                  # root of screen containing window
    class::Cint                   # InputOutput, InputOnly
    bit_gravity::Cint             # one of bit gravity values
    win_gravity::Cint             # one of the window gravity values
    backing_store::Cint           # NotUseful, WhenMapped, Always
    backing_planes::Culong        # planes to be preserved if possible
    backing_pixel::Culong         # value to be used when restoring planes
    save_under::_Bool             # boolean, should bits under be saved?
    colormap::Colormap            # color map to be associated with window
    map_installed::_Bool          # boolean, is color map currently installed
    map_state::Cint               # IsUnmapped, IsUnviewable, IsViewable
    all_event_masks::Clong        # set of events all people have interest in
    your_event_mask::Clong        # my event mask
    do_not_propagate_mask::Culong # set of events that should not propagate
    override_redirect::_Bool      # boolean value for override-redirect
    screen::Ptr{Screen}           # back pointer to correct screen
end


# Data structure for host setting; getting routines.

type XHostAddress
    family::Cint        # for example FamilyInternet
    length::Cint        # length of address, in bytes
    address::Ptr{Cchar} # pointer to where to find the bytes
end


# Data structure for ServerFamilyInterpreted addresses in host routines

type XServerInterpretedAddress
    typelength::Cint                # length of type string, in bytes
    valuelength::Cint       # length of value string, in bytes
    _type::Ptr{Cchar}           # pointer to where to find the type string
    value::Ptr{Cchar}           # pointer to where to find the address
end


# Data structure for "image" data, used by image manipulation routines.

type XImage
    width::Cint            # height of image
    height::Cint           # width of image
    xoffset::Cint          # number of pixels offset in X direction
    format::Cint           # XYBitmap, XYPixmap, ZPixmap
    data::Ptr{Cchar}       # pointer to image data
    byte_order::Cint       # data byte order, LSBFirst, MSBFirst
    bitmap_unit::Cint      # quant. of scanline 8, 16, 32
    bitmap_bit_order::Cint # LSBFirst, MSBFirst
    bitmap_pad::Cint       # 8, 16, 32 either XY or ZPixmap
    depth::Cint            # depth of image
    bytes_per_line::Cint   # accelarator to next line
    bits_per_pixel::Cint   # bits per pixel (ZPixmap)
    red_mask::Culong       # bits in z arrangment
    green_mask::Culong
    blue_mask::Culong
    obdata::XPointer       # hook for the object routines to hang on

    # Image manipulation routines:
    create_image::Cfunc
    destroy_image::Cfunc
    get_pixel::Cfunc
    put_pixel::Cfunc
    sub_image::Cfunc
    add_pixel::Cfunc
end


# Data structure for XReconfigureWindow

type XWindowChanges
    x::Cint
    y::Cint
    width::Cint
    height::Cint
    border_width::Cint
    sibling::Window
    stack_mode::Cint
end


# Data structure used by color operations

immutable XColor
    pixel::Culong
    red::Cushort
    green::Cushort
    blue::Cushort
    flags::Cuchar  # do_red, do_green, do_blue
    pad::Cchar
    XColor(pixel, red, green, blue, flags) =
        new(pixel, red, green, blue, flags, zero(Cchar))
end


# Data structures for graphics operations.  On most machines, these are
# congruent with the wire protocol structures, so reformatting the data can
# be avoided on these architectures.

immutable XSegment
    x1::Cshort
    y1::Cshort
    x2::Cshort
    y2::Cshort
end

immutable XPoint
    x::Cshort
    y::Cshort
end

immutable XRectangle
    x::Cshort
    y::Cshort
    width::Cushort
    height::Cushort
end

immutable XArc
    x::Cshort
    y::Cshort
    width::Cushort
    height::Cushort
    angle1::Cshort
    angle2::Cshort
end


# Data structure for XChangeKeyboardControl

type XKeyboardControl
    key_click_percent::Cint
    bell_percent::Cint
    bell_pitch::Cint
    bell_duration::Cint
    led::Cint
    led_mode::Cint
    key::Cint
    auto_repeat_mode::Cint   # On, Off, Default
end


# Data structure for XGetKeyboardControl

type XKeyboardState
    key_click_percent::Cint
    bell_percent::Cint
    bell_pitch::Cuint
    bell_duration::Cuint
    led_mask::Culong
    global_auto_repeat::Cint
    auto_repeats::Cchar # FIXME: [32] of this;
end


# Data structure for XGetMotionEvents.

immutable XTimeCoord
    time::Time
    x::Cshort
    y::Cshort
end

# Data structure for X{Set,Get} ModifierMapping

type XModifierKeymap
    max_keypermod::Cint       # The server's max # of keys per modifier
    modifiermap::Ptr{KeyCode} # An 8 by max_keypermod array of modifiers
end


# Display datatype maintaining display specific data.  The contents of this
# structure are implementation dependent.  A Display should be treated as
# opaque by application code.

immutable XDisplay
    ext_data::Ptr{XExtData}   # hook for extension to hang data
    private1::Ptr{XPrivate}
    fd::Cint                  # Network socket.
    private2::Cint
    proto_major_version::Cint # major version of server's X protocol
    proto_minor_version::Cint # minor version of servers X protocol
    vendor::Ptr{Cchar}        # vendor of the server hardware
    private3::XID
    private4::XID
    private5::XID
    private6::Cint
    resource_alloc::Ptr{Void}  # allocator function
    byte_order::Cint           # screen byte order, LSBFirst, MSBFirst
    bitmap_unit::Cint          # padding and data requirements
    bitmap_pad::Cint           # padding requirements on bitmaps
    bitmap_bit_order::Cint     # LeastSignificant or MostSignificant
    nformats::Cint             # number of pixmap formats in list
    pixmap_format::Ptr{ScreenFormat}  # pixmap format list
    private8::Cint
    release::Cint              # release of the server
    private9::Ptr{XPrivate}
    private10::Ptr{XPrivate}
    qlen::Cint                 # Length of input event queue
    last_request_read::Culong  # seq number of last event read
    request::Culong            # sequence number of last request.
    private11::XPointer
    private12::XPointer
    private13::XPointer
    private14::XPointer
    max_request_size::Cuint    # maximum number 32 bit words in request
    db::Ptr{XrmHashBucketRec}
    private15::Ptr{Void}
    display_name::Ptr{Cchar}   # "host:display" string used on this connect
    default_screen::Cint       # default screen for operations
    nscreens::Cint             # number of screens on this server
    screens::Ptr{Screen}       # pointer to list of screens
    motion_buffer::Culong      # size of motion buffer
    private16::Culong
    min_keycode::Cint          # minimum defined keycode
    max_keycode::Cint          # maximum defined keycode
    private17::XPointer
    private18::XPointer
    private19::Cint
    xdefaults::Ptr{Cchar}      # contents of defaults from server
    # FIXME: there is more to this structure, but it is private to Xlib
end


#
# Definitions of specific events.
#

type XKeyEvent <: AbstractXEvent
    _type::Cint           # of event
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window        # "event" window it is reported relative to
    root::Window          # root window that the event occurred on
    subwindow::Window     # child window
    time::Time            # milliseconds
    x::Cint
    y::Cint               # pointer x, y coordinates in event window
    x_root::Cint
    y_root::Cint          # coordinates relative to root
    state::Cuint          # key or button mask
    keycode::Cuint        # detail
    same_screen::_Bool    # same screen flag
end
const XKeyPressedEvent  = XKeyEvent
const XKeyReleasedEvent = XKeyEvent

type XButtonEvent <: AbstractXEvent
    _type::Cint           # of event
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window        # "event" window it is reported relative to
    root::Window          # root window that the event occurred on
    subwindow::Window     # child window
    time::Time            # milliseconds
    x::Cint
    y::Cint               # pointer x, y coordinates in event window
    x_root::Cint
    y_root::Cint          # coordinates relative to root
    state::Cuint          # key or button mask
    button::Cuint         # detail
    same_screen::_Bool    # same screen flag
end
const XButtonPressedEvent  = XButtonEvent
const XButtonReleasedEvent = XButtonEvent

type XMotionEvent <: AbstractXEvent
    _type::Cint           # of event
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window        # "event" window reported relative to
    root::Window          # root window that the event occurred on
    subwindow::Window     # child window
    time::Time            # milliseconds
    x::Cint
    y::Cint               # pointer x, y coordinates in event window
    x_root::Cint
    y_root::Cint          # coordinates relative to root
    state::Cuint          # key or button mask
    is_hint::Cchar        # detail
    same_screen::_Bool    # same screen flag
end
const XPointerMovedEvent = XMotionEvent

type XCrossingEvent <: AbstractXEvent
    _type::Cint           # of event
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window        # "event" window reported relative to
    root::Window          # root window that the event occurred on
    subwindow::Window     # child window
    time::Time            # milliseconds
    x::Cint
    y::Cint               # pointer x, y coordinates in event window
    x_root::Cint
    y_root::Cint          # coordinates relative to root
    mode::Cint            # NotifyNormal, NotifyGrab, NotifyUngrab
    detail::Cint          # NotifyAncestor, NotifyVirtual, NotifyInferior,
                          # NotifyNonlinear,NotifyNonlinearVirtual
    same_screen::_Bool    # same screen flag
    focus::_Bool          # boolean focus
    state::Cuint          # key or button mask
end
const XEnterWindowEvent = XCrossingEvent
const XLeaveWindowEvent = XCrossingEvent

type XFocusChangeEvent <: AbstractXEvent
    _type::Cint           # FocusIn or FocusOut
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window        # window of event
    mode::Cint            # NotifyNormal, NotifyWhileGrabbed,
                          # NotifyGrab, NotifyUngrab
    detail::Cint          # NotifyAncestor, NotifyVirtual, NotifyInferior,
                          # NotifyNonlinear,NotifyNonlinearVirtual, NotifyPointer,
                          # NotifyPointerRoot, NotifyDetailNone
end
const XFocusInEvent  = XFocusChangeEvent
const XFocusOutEvent = XFocusChangeEvent

# generated on EnterWindow and FocusIn  when KeyMapState selected
type XKeymapEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    key_vector::Cbuf32char
end

type XExposeEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    x::Cint
    y::Cint
    width::Cint
    height::Cint
    count::Cint           # if non-zero, at least this many more
end

type XGraphicsExposeEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    drawable::Drawable
    x::Cint
    y::Cint
    width::Cint
    height::Cint
    count::Cint           # if non-zero, at least this many more
    major_code::Cint      # core is CopyArea or CopyPlane
    minor_code::Cint      # not defined in the core
end

type XNoExposeEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    drawable::Drawable
    major_code::Cint      # core is CopyArea or CopyPlane
    minor_code::Cint      # not defined in the core
end

type XVisibilityEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    state::Cint           # Visibility state
end

type XCreateWindowEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    parent::Window        # parent of the window
    window::Window        # window id of window created
    x::Cint
    y::Cint               # window location
    width::Cint
    height::Cint          # size of window
    border_width::Cint    # border width
    override_redirect::_Bool # creation should be overridden
end

type XDestroyWindowEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    event::Window
    window::Window
end

type XUnmapEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    event::Window
    window::Window
    from_configure::_Bool
end

type XMapEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    event::Window
    window::Window
    override_redirect::_Bool # boolean, is override set...
end

type XMapRequestEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    parent::Window
    window::Window
end

type XReparentEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    event::Window
    window::Window
    parent::Window
    x::Cint
    y::Cint
    override_redirect::_Bool
end

type XConfigureEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    event::Window
    window::Window
    x::Cint
    y::Cint
    width::Cint
    height::Cint
    border_width::Cint
    above::Window
    override_redirect::_Bool
end

type XGravityEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    event::Window
    window::Window
    x::Cint
    y::Cint
end

type XResizeRequestEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    width::Cint
    height::Cint
end

type XConfigureRequestEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    parent::Window
    window::Window
    x::Cint
    y::Cint
    width::Cint
    height::Cint
    border_width::Cint
    above::Window
    detail::Cint          # Above, Below, TopIf, BottomIf, Opposite
    value_mask::Culong
end

type XCirculateEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    event::Window
    window::Window
    place::Cint           # PlaceOnTop, PlaceOnBottom
end

type XCirculateRequestEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    parent::Window
    window::Window
    place::Cint           # PlaceOnTop, PlaceOnBottom
end

type XPropertyEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    atom::Atom
    time::Time
    state::Cint           # NewValue, Deleted
end

type XSelectionClearEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    selection::Atom
    time::Time
end

type XSelectionRequestEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    owner::Window
    requestor::Window
    selection::Atom
    target::Atom
    property::Atom
    time::Time
end

type XSelectionEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    requestor::Window
    selection::Atom
    target::Atom
    property::Atom        # ATOM or None
    time::Time
end

type XColormapEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    colormap::Colormap    # COLORMAP or None
    _new::_Bool
    state::Cint           # ColormapInstalled, ColormapUninstalled
end

type XClientMessageEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window
    message_type::Atom
    data::Cbuf5long
end

type XMappingEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window        # unused
    request::Cint         # one of MappingModifier, MappingKeyboard,
                          # MappingPointer
    first_keycode::Cint   # first keycode
    count::Cint           # defines range of change w. first_keycode
end

type XErrorEvent <: AbstractXEvent
    _type::Cint
    display::Ptr{Display} # Display the event was read from
    resourceid::XID       # resource id
    serial::Culong        # serial number of failed request
    error_code::Cuchar    # error code of failed request
    request_code::Cuchar  # Major op-code of failed request
    minor_code::Cuchar    # Minor op-code of failed request
end

type XAnyEvent <: AbstractXEvent
    _type::Cint
    serial::Culong        # # of last request processed by server
    send_event::_Bool     # true if this came from a SendEvent request
    display::Ptr{Display} # Display the event was read from
    window::Window        # window on which event was requested in event mask
end


#
# GenericEvent.  This event is the standard event for all newer extensions.
#

type XGenericEvent <: AbstractXEvent
    _type::Cint           # of event. Always GenericEvent
    serial::Culong        # # of last request processed
    send_event::_Bool     # true if from SendEvent request
    display::Ptr{Display} # Display the event was read from
    extension::Cint       # major opcode of extension that caused the event
    evtype::Cint          # actual event type.
end

type XGenericEventCookie
    _type::Cint           # of event. Always GenericEvent
    serial::Culong        # # of last request processed
    send_event::_Bool     # true if from SendEvent request
    display::Ptr{Display} # Display the event was read from
    extension::Cint       # major opcode of extension that caused the event
    evtype::Cint          # actual event type.
    cookie::Cuint
    data::Ptr{Void}
end

#
# Per character font metric information.
#
type XCharStruct
    lbearing::Cshort    # origin to left edge of raster
    rbearing::Cshort    # origin to right edge of raster
    width::Cshort       # advance to next Cchar's origin
    ascent::Cshort      # baseline to top edge of raster
    descent::Cshort     # baseline to bottom edge of raster
    attributes::Cushort # per char flags (not predefined)
end

#
# To allow arbitrary information with fonts, there are additional properties
# returned.
#
type XFontProp
    name::Atom
    card32::Culong
end

type XFontStruct
    ext_data::Ptr{XExtData}    # hook for extension to hang data
    fid::Font                  # Font id for this font
    direction::Cuint           # hint about direction the font is painted
    min_char_or_byte2::Cuint   # first character
    max_char_or_byte2::Cuint   # last character
    min_byte1::Cuint           # first row that exists
    max_byte1::Cuint           # last row that exists
    all_chars_exist::_Bool     # flag if all characters have non-zero size
    default_char::Cuint        # char to print for undefined character
    n_properties::Cint         # how many properties there are
    properties::Ptr{XFontProp} # pointer to array of additional properties
    min_bounds::XCharStruct    # minimum bounds over all existing char
    max_bounds::XCharStruct    # maximum bounds over all existing char
    per_char::Ptr{XCharStruct} # first_char to last_char information
    ascent::Cint               # log. extent above baseline for spacing
    descent::Cint              # log. descent below baseline for spacing
end

#
# PolyText routines take these as arguments.
#
type XTextItem
    chars::Ptr{Cchar} # pointer to string
    nchars::Cint      # number of characters
    delta::Cint       # delta between strings
    font::Font        # font to print it in, None don't change
end

type XChar2b # normal 16 bit characters are two bytes
    byte1::Cuchar
    byte2::Cuchar
end

type XTextItem16
    chars::Ptr{XChar2b} # two byte characters
    nchars::Cint        # number of characters
    delta::Cint         # delta between strings
    font::Font          # font to print it in, None don't change
end

#
# All the members of `XEDataObject` defined as:
#
#     typedef union { Display *display;
#                     GC gc;
#                     Visual *visual;
#                     Screen *screen;
#                     ScreenFormat *pixmap_format;
#                     XFontStruct *font; } XEDataObject;
#
# are pointers so we aassume the following equivalence:
#
type XEDataObject
    ptr::Ptr{Opaque}
end

type XFontSetExtents
    max_ink_extent::XRectangle
    max_logical_extent::XRectangle
end

# typedef struct _XOM *XOM;
# typedef struct _XOC *XOC, *XFontSet;
const XOM = Ptr{Opaque}
const XOC = Ptr{Opaque}
const XFontSet = Ptr{Opaque}

type XmbTextItem
    chars::Ptr{Cchar}
    nchars::Cint
    delta::Cint
    font_set::XFontSet
end

type XwcTextItem
    chars::Ptr{Cwchar_t}
    nchars::Cint
    delta::Cint
    font_set::XFontSet
end

type XOMCharSetList
    charset_count::Cint
    charset_list::Ptr{Ptr{Cchar}}
end

# Equivalences for C-enumeration `XOrientation`:
const XOrientation = Cint
const XOMOrientation_LTR_TTB = XOrientation(0)
const XOMOrientation_RTL_TTB = XOrientation(1)
const XOMOrientation_TTB_LTR = XOrientation(2)
const XOMOrientation_TTB_RTL = XOrientation(3)
const XOMOrientation_Context = XOrientation(4)

type XOMOrientation
    num_orientation::Cint
    orientation::Ptr{XOrientation}  # Input Text description
end

type XOMFontInfo
    num_font::Cint
    font_struct_list::Ptr{Ptr{XFontStruct}}
    font_name_list::Ptr{Ptr{Cchar}}
end

# typedef struct _XIM *XIM;
const XIM = Ptr{Opaque}

# typedef struct _XIC *XIC;
const XIC = Ptr{Opaque}

# typedef void (*XIMProc)(XIM, XPointer, XPointer);
const XIMProc = Cfunc

# typedef Bool (*XICProc)(XIC, XPointer, Pointer);
const XICProc = Cfunc

# typedef void (*XIDProc)(Display*, XPointer, XPointer);
const XIDProc = Cfunc

const XIMStyle = Culong

type XIMStyles
    count_styles::Cushort
    supported_styles::Ptr{XIMStyle}
end

const XVaNestedList = Ptr{Void}

type XIMCallback
    client_data::XPointer
    callback::XIMProc
end

type XICCallback
    client_data::XPointer
    callback::XICProc
end

const XIMFeedback = Culong

type XIMText
    length::Cushort
    feedback::Ptr{XIMFeedback}
    encoding_is_wchar::_Bool
    string::Ptr{Void} # FIXME:
end

const XIMPreeditState = Culong

type XIMPreeditStateNotifyCallbackStruct
    state::XIMPreeditState
end

const XIMResetState = Culong

const XIMStringConversionFeedback = Culong

type XIMStringConversionText
    length::Cushort
    feedback::Ptr{XIMStringConversionFeedback}
    encoding_is_wchar::_Bool
    string::Ptr{Void} # FIXME:
end

const XIMStringConversionPosition = Cushort

const XIMStringConversionType = Cushort

const XIMStringConversionOperation = Cushort

# Equivalences for C-enumeration `XIMCaretDirection`:
const XIMCaretDirection = Cint
const XIMForwardChar      = XIMCaretDirection(0)
const XIMBackwardChar     = XIMCaretDirection(1)
const XIMForwardWord      = XIMCaretDirection(2)
const XIMBackwardWord     = XIMCaretDirection(3)
const XIMCaretUp          = XIMCaretDirection(4)
const XIMCaretDown        = XIMCaretDirection(5)
const XIMNextLine         = XIMCaretDirection(6)
const XIMPreviousLine     = XIMCaretDirection(7)
const XIMLineStart        = XIMCaretDirection(8)
const XIMLineEnd          = XIMCaretDirection(9)
const XIMAbsolutePosition = XIMCaretDirection(10)
const XIMDontChange       = XIMCaretDirection(11)

type XIMStringConversionCallbackStruct
    position::XIMStringConversionPosition
    direction::XIMCaretDirection
    operation::XIMStringConversionOperation
    factor::Cushort
    text::Ptr{XIMStringConversionText}
end

type XIMPreeditDrawCallbackStruct
    caret::Cint          # Cursor offset within pre-edit string
    chg_first::Cint      # Starting change position
    chg_length::Cint     # Length of the change in character count
    text::Ptr{XIMText}
end

# Equivalences for C-enumeration `XIMCaretStyle`:
const XIMCaretStyle = Cint
const XIMIsInvisible = XIMCaretStyle(0) # Disable caret feedback
const XIMIsPrimary   = XIMCaretStyle(1) # UI defined caret feedback
const XIMIsSecondary = XIMCaretStyle(2) # UI defined caret feedback

type XIMPreeditCaretCallbackStruct
    position::Cint               # Caret offset within pre-edit string
    direction::XIMCaretDirection # Caret moves direction
    style::XIMCaretStyle         # Feedback of the caret
end

# Equivalences for C-enumeration `XIMStatusDataType`:
const XIMStatusDataType = Cint
const XIMTextType = XIMStatusDataType(0)
const XIMBitmapType = XIMStatusDataType(1)

type XIMStatusDrawCallbackStruct
    _type::XIMStatusDataType
    data::Union{Ptr{XIMText},Pixmap} # FIXME:
end

type XIMHotKeyTrigger
    keysym::KeySym
    modifier::Cint
    modifier_mask::Cint
end

type XIMHotKeyTriggers
    num_hot_key::Cint
    key::Ptr{XIMHotKeyTrigger}
end

const XIMHotKeyState = Culong

type XIMValuesList
    count_values::Cushort
    supported_values::Ptr{Ptr{Cchar}}
end
