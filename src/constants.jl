#
# constants.jl --
#
# Constant definitions for Julia wrapper of X11 library.
#
#-------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
# All rights reserved.
#

const X_PROTOCOL          = Cint(11) # current protocol version
const X_PROTOCOL_REVISION = Cint(0)  # current minor version


###############################################################################
# RESERVED RESOURCE AND CONSTANT DEFINITIONS
#------------------------------------------------------------------------------

const None            = Clong(0) # universal null resource or null atom
const ParentRelative  = Clong(1) # background pixmap in CreateWindow
const CopyFromParent  = Clong(0) # border pixmap in CreateWindow
const PointerWindow   = Clong(0) # destination window in SendEvent
const InputFocus      = Clong(1) # destination window in SendEvent
const PointerRoot     = Clong(1) # focus window in SetInputFocus
const AnyPropertyType = Clong(0) # special Atom, passed to GetProperty
const AnyKey          = Clong(0) # special Key Code, passed to GrabKey
const AnyButton       = Clong(0) # special Button Code, passed to GrabButton
const AllTemporary    = Clong(0) # special Resource ID passed to KillClient
const CurrentTime     = Clong(0) # special Time
const NoSymbol        = Clong(0) # special KeySym


###############################################################################
# EVENT DEFINITIONS
#------------------------------------------------------------------------------

# Input Event Masks. Used as event-mask window attribute and as arguments to
# Grab requests.  Not to be confused with event names.

const NoEventMask              = Clong(0)
const KeyPressMask             = Clong(1)<<0
const KeyReleaseMask           = Clong(1)<<1
const ButtonPressMask          = Clong(1)<<2
const ButtonReleaseMask        = Clong(1)<<3
const EnterWindowMask          = Clong(1)<<4
const LeaveWindowMask          = Clong(1)<<5
const PointerMotionMask        = Clong(1)<<6
const PointerMotionHintMask    = Clong(1)<<7
const Button1MotionMask        = Clong(1)<<8
const Button2MotionMask        = Clong(1)<<9
const Button3MotionMask        = Clong(1)<<10
const Button4MotionMask        = Clong(1)<<11
const Button5MotionMask        = Clong(1)<<12
const ButtonMotionMask         = Clong(1)<<13
const KeymapStateMask          = Clong(1)<<14
const ExposureMask             = Clong(1)<<15
const VisibilityChangeMask     = Clong(1)<<16
const StructureNotifyMask      = Clong(1)<<17
const ResizeRedirectMask       = Clong(1)<<18
const SubstructureNotifyMask   = Clong(1)<<19
const SubstructureRedirectMask = Clong(1)<<20
const FocusChangeMask          = Clong(1)<<21
const PropertyChangeMask       = Clong(1)<<22
const ColormapChangeMask       = Clong(1)<<23
const OwnerGrabButtonMask      = Clong(1)<<24


# Event names.  Used in "type" field in XEvent structures.  Not to be confused
# with event masks above.  They start from 2 because 0 and 1 are reserved in
# the protocol for errors and replies.

const KeyPress         = Cint( 2)
const KeyRelease       = Cint( 3)
const ButtonPress      = Cint( 4)
const ButtonRelease    = Cint( 5)
const MotionNotify     = Cint( 6)
const EnterNotify      = Cint( 7)
const LeaveNotify      = Cint( 8)
const FocusIn          = Cint( 9)
const FocusOut         = Cint(10)
const KeymapNotify     = Cint(11)
const Expose           = Cint(12)
const GraphicsExpose   = Cint(13)
const NoExpose         = Cint(14)
const VisibilityNotify = Cint(15)
const CreateNotify     = Cint(16)
const DestroyNotify    = Cint(17)
const UnmapNotify      = Cint(18)
const MapNotify        = Cint(19)
const MapRequest       = Cint(20)
const ReparentNotify   = Cint(21)
const ConfigureNotify  = Cint(22)
const ConfigureRequest = Cint(23)
const GravityNotify    = Cint(24)
const ResizeRequest    = Cint(25)
const CirculateNotify  = Cint(26)
const CirculateRequest = Cint(27)
const PropertyNotify   = Cint(28)
const SelectionClear   = Cint(29)
const SelectionRequest = Cint(30)
const SelectionNotify  = Cint(31)
const ColormapNotify   = Cint(32)
const ClientMessage    = Cint(33)
const MappingNotify    = Cint(34)
const GenericEvent     = Cint(35)
const LASTEvent        = Cint(36)     # must be bigger than any event


# Key masks. Used as modifiers to GrabButton and GrabKey, results of
# QueryPointer, state in various key-, mouse-, and button-related events.

const ShiftMask   = Cint(1)<<0
const LockMask    = Cint(1)<<1
const ControlMask = Cint(1)<<2
const Mod1Mask    = Cint(1)<<3
const Mod2Mask    = Cint(1)<<4
const Mod3Mask    = Cint(1)<<5
const Mod4Mask    = Cint(1)<<6
const Mod5Mask    = Cint(1)<<7


# Modifier names.  Used to build a SetModifierMapping request or to read a
# GetModifierMapping request.  These correspond to the masks defined above.

const ShiftMapIndex   = Cint(0)
const LockMapIndex    = Cint(1)
const ControlMapIndex = Cint(2)
const Mod1MapIndex    = Cint(3)
const Mod2MapIndex    = Cint(4)
const Mod3MapIndex    = Cint(5)
const Mod4MapIndex    = Cint(6)
const Mod5MapIndex    = Cint(7)


# Button masks.  Used in same manner as Key masks above. Not to be confused
# with button names below.

const Button1Mask = Cint(1)<<8
const Button2Mask = Cint(1)<<9
const Button3Mask = Cint(1)<<10
const Button4Mask = Cint(1)<<11
const Button5Mask = Cint(1)<<12

const AnyModifier = Cint(1)<<15  # used in GrabButton, GrabK


# Button names. Used as arguments to GrabButton and as detail in ButtonPress
# and ButtonRelease events.  Not to be confused with button masks above.  Note
# that 0 is already defined above as "AnyButton".

const Button1 = Cint(1)
const Button2 = Cint(2)
const Button3 = Cint(3)
const Button4 = Cint(4)
const Button5 = Cint(5)


# Notify modes

const NotifyNormal       = Cint(0)
const NotifyGrab         = Cint(1)
const NotifyUngrab       = Cint(2)
const NotifyWhileGrabbed = Cint(3)

const NotifyHint         = Cint(1) # for MotionNotify events


# Notify detail

const NotifyAncestor         = Cint(0)
const NotifyVirtual          = Cint(1)
const NotifyInferior         = Cint(2)
const NotifyNonlinear        = Cint(3)
const NotifyNonlinearVirtual = Cint(4)
const NotifyPointer          = Cint(5)
const NotifyPointerRoot      = Cint(6)
const NotifyDetailNone       = Cint(7)


# Visibility notify

const VisibilityUnobscured        = Cint(0)
const VisibilityPartiallyObscured = Cint(1)
const VisibilityFullyObscured     = Cint(2)


# Circulation request

const PlaceOnTop    = Cint(0)
const PlaceOnBottom = Cint(1)


# protocol families

const FamilyInternet  = Cint(0) # IPv4
const FamilyDECnet    = Cint(1)
const FamilyChaos     = Cint(2)
const FamilyInternet6 = Cint(6) # IPv6

# authentication families not tied to a specific protocol

const FamilyServerInterpreted = Cint(5)


# Property notification

const PropertyNewValue  = Cint(0)
const PropertyDelete    = Cint(1)


# Color Map notification

const ColormapUninstalled = Cint(0)
const ColormapInstalled   = Cint(1)


# GrabPointer, GrabButton, GrabKeyboard, GrabKey Modes

const GrabModeSync  = Cint(0)
const GrabModeAsync = Cint(1)


# GrabPointer, GrabKeyboard reply status

const GrabSuccess     = Cint(0)
const AlreadyGrabbed  = Cint(1)
const GrabInvalidTime = Cint(2)
const GrabNotViewable = Cint(3)
const GrabFrozen      = Cint(4)


# AllowEvents modes

const AsyncPointer   = Cint(0)
const SyncPointer    = Cint(1)
const ReplayPointer  = Cint(2)
const AsyncKeyboard  = Cint(3)
const SyncKeyboard   = Cint(4)
const ReplayKeyboard = Cint(5)
const AsyncBoth      = Cint(6)
const SyncBoth       = Cint(7)


# Used in SetInputFocus, GetInputFocus

const RevertToNone        = Cint(None)
const RevertToPointerRoot = Cint(PointerRoot)
const RevertToParent      = Cint(2)


###############################################################################
# ERROR CODES
#------------------------------------------------------------------------------

const Success           = Cint(0)  # everything's okay
const BadRequest        = Cint(1)  # bad request code
const BadValue          = Cint(2)  # int parameter out of range
const BadWindow         = Cint(3)  # parameter not a Window
const BadPixmap         = Cint(4)  # parameter not a Pixmap
const BadAtom           = Cint(5)  # parameter not an Atom
const BadCursor         = Cint(6)  # parameter not a Cursor
const BadFont           = Cint(7)  # parameter not a Font
const BadMatch          = Cint(8)  # parameter mismatch
const BadDrawable       = Cint(9)  # parameter not a Pixmap or Window
const BadAccess         = Cint(10) # depending on context:
                                   # - key/button already grabbed
                                   # - attempt to free an illegal
                                   #   cmap entry
                                   # - attempt to store into a read-only
                                   #   color map entry.
                                   # - attempt to modify the access control
                                   #   list from other than the local host.
const BadAlloc          = Cint(11) # insufficient resources
const BadColor          = Cint(12) # no such colormap
const BadGC             = Cint(13) # parameter not a GC
const BadIDChoice       = Cint(14) # choice not in range or already used
const BadName           = Cint(15) # font or color name doesn't exist
const BadLength         = Cint(16) # Request length incorrect
const BadImplementation = Cint(17) # server is defective

const FirstExtensionError = Cint(128)
const LastExtensionError  = Cint(255)

###############################################################################
# WINDOW DEFINITIONS
#------------------------------------------------------------------------------

# Window classes used by CreateWindow
# Note that CopyFromParent is already defined as 0 above

const InputOutput = Cint(1)
const InputOnly   = Cint(2)


# Window attributes for CreateWindow and ChangeWindowAttributes

const CWBackPixmap       = Clong(1)<<0
const CWBackPixel        = Clong(1)<<1
const CWBorderPixmap     = Clong(1)<<2
const CWBorderPixel      = Clong(1)<<3
const CWBitGravity       = Clong(1)<<4
const CWWinGravity       = Clong(1)<<5
const CWBackingStore     = Clong(1)<<6
const CWBackingPlanes    = Clong(1)<<7
const CWBackingPixel     = Clong(1)<<8
const CWOverrideRedirect = Clong(1)<<9
const CWSaveUnder        = Clong(1)<<10
const CWEventMask        = Clong(1)<<11
const CWDontPropagate    = Clong(1)<<12
const CWColormap         = Clong(1)<<13
const CWCursor           = Clong(1)<<14

# ConfigureWindow structure

const CWX           = Cint(1)<<0
const CWY           = Cint(1)<<1
const CWWidth       = Cint(1)<<2
const CWHeight      = Cint(1)<<3
const CWBorderWidth = Cint(1)<<4
const CWSibling     = Cint(1)<<5
const CWStackMode   = Cint(1)<<6


# Bit Gravity

const ForgetGravity    = Cint(0)
const NorthWestGravity = Cint(1)
const NorthGravity     = Cint(2)
const NorthEastGravity = Cint(3)
const WestGravity      = Cint(4)
const CenterGravity    = Cint(5)
const EastGravity      = Cint(6)
const SouthWestGravity = Cint(7)
const SouthGravity     = Cint(8)
const SouthEastGravity = Cint(9)
const StaticGravity    = Cint(10)


# Window gravity + bit gravity above

const UnmapGravity = Cint(0)


# Used in CreateWindow for backing-store hint

const NotUseful  = Cint(0)
const WhenMapped = Cint(1)
const Always     = Cint(2)


# Used in GetWindowAttributes reply

const IsUnmapped   = Cint(0)
const IsUnviewable = Cint(1)
const IsViewable   = Cint(2)


# Used in ChangeSaveSet

const SetModeInsert = Cint(0)
const SetModeDelete = Cint(1)


# Used in ChangeCloseDownMode

const DestroyAll      = Cint(0)
const RetainPermanent = Cint(1)
const RetainTemporary = Cint(2)


# Window stacking method (in configureWindow)

const Above    = Cint(0)
const Below    = Cint(1)
const TopIf    = Cint(2)
const BottomIf = Cint(3)
const Opposite = Cint(4)

# Circulation direction

const RaiseLowest  = Cint(0)
const LowerHighest = Cint(1)


# Property modes

const PropModeReplace = Cint(0)
const PropModePrepend = Cint(1)
const PropModeAppend  = Cint(2)

###############################################################################
# GRAPHICS DEFINITIONS
#------------------------------------------------------------------------------

# Graphics functions, as in GC.alu

const GXclear        = Cint(0x0) # 0
const GXand          = Cint(0x1) # src AND dst
const GXandReverse   = Cint(0x2) # src AND NOT dst
const GXcopy         = Cint(0x3) # src
const GXandInverted  = Cint(0x4) # NOT src AND dst
const GXnoop         = Cint(0x5) # dst
const GXxor          = Cint(0x6) # src XOR dst
const GXor           = Cint(0x7) # src OR dst
const GXnor          = Cint(0x8) # NOT src AND NOT dst
const GXequiv        = Cint(0x9) # NOT src XOR dst
const GXinvert       = Cint(0xa) # NOT dst
const GXorReverse    = Cint(0xb) # src OR NOT dst
const GXcopyInverted = Cint(0xc) # NOT src
const GXorInverted   = Cint(0xd) # NOT src OR dst
const GXnand         = Cint(0xe) # NOT src OR NOT dst
const GXset          = Cint(0xf) # 1


# LineStyle

const LineSolid      = Cint(0)
const LineOnOffDash  = Cint(1)
const LineDoubleDash = Cint(2)


# capStyle

const CapNotLast    = Cint(0)
const CapButt       = Cint(1)
const CapRound      = Cint(2)
const CapProjecting = Cint(3)


# joinStyle

const JoinMiter = Cint(0)
const JoinRound = Cint(1)
const JoinBevel = Cint(2)


# fillStyle

const FillSolid          = Cint(0)
const FillTiled          = Cint(1)
const FillStippled       = Cint(2)
const FillOpaqueStippled = Cint(3)


# fillRule

const EvenOddRule = Cint(0)
const WindingRule = Cint(1)


# subwindow mode

const ClipByChildren   = Cint(0)
const IncludeInferiors = Cint(1)


# SetClipRectangles ordering

const Unsorted = Cint(0)
const YSorted  = Cint(1)
const YXSorted = Cint(2)
const YXBanded = Cint(3)


# CoordinateMode for drawing routines

const CoordModeOrigin   = Cint(0) # relative to the origin
const CoordModePrevious = Cint(1) # relative to previous point


# Polygon shapes

const _Complex  = Cint(0) # paths may intersect
const Nonconvex = Cint(1) # no paths intersect, but not convex
const Convex    = Cint(2) # wholly convex


# Arc modes for PolyFillArc

const ArcChord    = Cint(0) # join endpoints of arc
const ArcPieSlice = Cint(1) # join endpoints to center of arc


# GC components: masks used in CreateGC, CopyGC, ChangeGC, OR'ed into
# GC.stateChanges

const GCFunction          = Clong(1)<<0
const GCPlaneMask         = Clong(1)<<1
const GCForeground        = Clong(1)<<2
const GCBackground        = Clong(1)<<3
const GCLineWidth         = Clong(1)<<4
const GCLineStyle         = Clong(1)<<5
const GCCapStyle          = Clong(1)<<6
const GCJoinStyle         = Clong(1)<<7
const GCFillStyle         = Clong(1)<<8
const GCFillRule          = Clong(1)<<9
const GCTile              = Clong(1)<<10
const GCStipple           = Clong(1)<<11
const GCTileStipXOrigin   = Clong(1)<<12
const GCTileStipYOrigin   = Clong(1)<<13
const GCFont              = Clong(1)<<14
const GCSubwindowMode     = Clong(1)<<15
const GCGraphicsExposures = Clong(1)<<16
const GCClipXOrigin       = Clong(1)<<17
const GCClipYOrigin       = Clong(1)<<18
const GCClipMask          = Clong(1)<<19
const GCDashOffset        = Clong(1)<<20
const GCDashList          = Clong(1)<<21
const GCArcMode           = Clong(1)<<22

const GCLastBit           = Cint(22)


###############################################################################
# FONTS
#------------------------------------------------------------------------------

# used in QueryFont -- draw direction

const FontLeftToRight = Cint(0)
const FontRightToLeft = Cint(1)

const FontChange      = Cint(255)


###############################################################################
#  IMAGING
#------------------------------------------------------------------------------

# ImageFormat -- PutImage, GetImage

const XYBitmap = Cint(0) # depth 1, XYFormat
const XYPixmap = Cint(1) # depth == drawable depth
const ZPixmap  = Cint(2) # depth == drawable depth


###############################################################################
#  COLOR MAP STUFF
#------------------------------------------------------------------------------

# For CreateColormap

const AllocNone = Cint(0)      # create map with no entries
const AllocAll  = Cint(1)      # allocate entire map writeable


# Flags used in StoreNamedColor, StoreColors

const DoRed   = Cint(1)<<0
const DoGreen = Cint(1)<<1
const DoBlue  = Cint(1)<<2


###############################################################################
# CURSOR STUFF
#------------------------------------------------------------------------------

# QueryBestSize Class

const CursorShape  = Cint(0) # largest size that can be displayed
const TileShape    = Cint(1) # size tiled fastest
const StippleShape = Cint(2) # size stippled fastest

###############################################################################
# KEYBOARD/POINTER STUFF
#------------------------------------------------------------------------------

const AutoRepeatModeOff     = Cint(0)
const AutoRepeatModeOn      = Cint(1)
const AutoRepeatModeDefault = Cint(2)

const LedModeOff            = Cint(0)
const LedModeOn             = Cint(1)


# masks for ChangeKeyboardControl

const KBKeyClickPercent     = Clong(1)<<0
const KBBellPercent         = Clong(1)<<1
const KBBellPitch           = Clong(1)<<2
const KBBellDuration        = Clong(1)<<3
const KBLed                 = Clong(1)<<4
const KBLedMode             = Clong(1)<<5
const KBKey                 = Clong(1)<<6
const KBAutoRepeatMode      = Clong(1)<<7

const MappingSuccess        = Cint(0)
const MappingBusy           = Cint(1)
const MappingFailed         = Cint(2)

const MappingModifier       = Cint(0)
const MappingKeyboard       = Cint(1)
const MappingPointer        = Cint(2)


###############################################################################
# SCREEN SAVER STUFF
#------------------------------------------------------------------------------

const DontPreferBlanking    = Cint(0)
const PreferBlanking        = Cint(1)
const DefaultBlanking       = Cint(2)

const DisableScreenSaver    = Cint(0)
const DisableScreenInterval = Cint(0)

const DontAllowExposures    = Cint(0)
const AllowExposures        = Cint(1)
const DefaultExposures      = Cint(2)


# for ForceScreenSaver

const ScreenSaverReset      = Cint(0)
const ScreenSaverActive     = Cint(1)

###############################################################################
# HOSTS AND CONNECTIONS
#------------------------------------------------------------------------------

# for ChangeHosts

const HostInsert = Cint(0)
const HostDelete = Cint(1)


# for ChangeAccessControl

const EnableAccess  = Cint(1)
const DisableAccess = Cint(0)


# Display classes used in opening the connection
# Note that the statically allocated ones are even numbered and the
# dynamically changeable ones are odd numbered

const StaticGray  = Cint(0)
const GrayScale   = Cint(1)
const StaticColor = Cint(2)
const PseudoColor = Cint(3)
const TrueColor   = Cint(4)
const DirectColor = Cint(5)


# Byte order  used in imageByteOrder and bitmapBitOrder

const LSBFirst = Cint(0)
const MSBFirst = Cint(1)

###############################################################################
# Constants from `Xlib.h`

const XlibSpecificationRelease        = Cint(6)
const X_HAVE_UTF8_STRING              = Cint(1)

const True                            = Cint(1)
const False                           = Cint(0)

const QueuedAlready                   = Cint(0)
const QueuedAfterReading              = Cint(1)
const QueuedAfterFlush                = Cint(2)

const AllPlanes                       = ~zero(Culong)

const XNRequiredCharSet               = "requiredCharSet"
const XNQueryOrientation              = "queryOrientation"
const XNBaseFontName                  = "baseFontName"
const XNOMAutomatic                   = "omAutomatic"
const XNMissingCharSet                = "missingCharSet"
const XNDefaultString                 = "defaultString"
const XNOrientation                   = "orientation"
const XNDirectionalDependentDrawing   = "directionalDependentDrawing"
const XNContextualDrawing             = "contextualDrawing"
const XNFontInfo                      = "fontInfo"

const XIMPreeditArea                  = Clong(0x0001)
const XIMPreeditCallbacks             = Clong(0x0002)
const XIMPreeditPosition              = Clong(0x0004)
const XIMPreeditNothing               = Clong(0x0008)
const XIMPreeditNone                  = Clong(0x0010)
const XIMStatusArea                   = Clong(0x0100)
const XIMStatusCallbacks              = Clong(0x0200)
const XIMStatusNothing                = Clong(0x0400)
const XIMStatusNone                   = Clong(0x0800)

const XNVaNestedList                  = "XNVaNestedList"
const XNQueryInputStyle               = "queryInputStyle"
const XNClientWindow                  = "clientWindow"
const XNInputStyle                    = "inputStyle"
const XNFocusWindow                   = "focusWindow"
const XNResourceName                  = "resourceName"
const XNResourceClass                 = "resourceClass"
const XNGeometryCallback              = "geometryCallback"
const XNDestroyCallback               = "destroyCallback"
const XNFilterEvents                  = "filterEvents"
const XNPreeditStartCallback          = "preeditStartCallback"
const XNPreeditDoneCallback           = "preeditDoneCallback"
const XNPreeditDrawCallback           = "preeditDrawCallback"
const XNPreeditCaretCallback          = "preeditCaretCallback"
const XNPreeditStateNotifyCallback    = "preeditStateNotifyCallback"
const XNPreeditAttributes             = "preeditAttributes"
const XNStatusStartCallback           = "statusStartCallback"
const XNStatusDoneCallback            = "statusDoneCallback"
const XNStatusDrawCallback            = "statusDrawCallback"
const XNStatusAttributes              = "statusAttributes"
const XNArea                          = "area"
const XNAreaNeeded                    = "areaNeeded"
const XNSpotLocation                  = "spotLocation"
const XNColormap                      = "colorMap"
const XNStdColormap                   = "stdColorMap"
const XNForeground                    = "foreground"
const XNBackground                    = "background"
const XNBackgroundPixmap              = "backgroundPixmap"
const XNFontSet                       = "fontSet"
const XNLineSpace                     = "lineSpace"
const XNCursor                        = "cursor"
const XNQueryIMValuesList             = "queryIMValuesList"
const XNQueryICValuesList             = "queryICValuesList"
const XNVisiblePosition               = "visiblePosition"
const XNR6PreeditCallback             = "r6PreeditCallback"
const XNStringConversionCallback      = "stringConversionCallback"
const XNStringConversion              = "stringConversion"
const XNResetState                    = "resetState"
const XNHotKey                        = "hotKey"
const XNHotKeyState                   = "hotKeyState"
const XNPreeditState                  = "preeditState"
const XNSeparatorofNestedList         = "separatorofNestedList"

const XBufferOverflow                 = Cint(-1)
const XLookupNone                     = Cint(1)
const XLookupChars                    = Cint(2)
const XLookupKeySym                   = Cint(3)
const XLookupBoth                     = Cint(4)

const XIMReverse                      = Clong(1)
const XIMUnderline                    = Clong(1)<<1
const XIMHighlight                    = Clong(1)<<2
const XIMPrimary                      = Clong(1)<<5
const XIMSecondary                    = Clong(1)<<6
const XIMTertiary                     = Clong(1)<<7
const XIMVisibleToForward             = Clong(1)<<8
const XIMVisibleToBackword            = Clong(1)<<9
const XIMVisibleToCenter              = Clong(1)<<10
const XIMPreeditUnKnown               = Clong(0)
const XIMPreeditEnable                = Clong(1)
const XIMPreeditDisable               = Clong(1)<<1
const XIMInitialState                 = Clong(1)
const XIMPreserveState                = Clong(1)<<1

const XIMStringConversionLeftEdge     = Cint(0x00000001)
const XIMStringConversionRightEdge    = Cint(0x00000002)
const XIMStringConversionTopEdge      = Cint(0x00000004)
const XIMStringConversionBottomEdge   = Cint(0x00000008)
const XIMStringConversionConcealed    = Cint(0x00000010)
const XIMStringConversionWrapped      = Cint(0x00000020)
const XIMStringConversionBuffer       = Cint(0x0001)
const XIMStringConversionLine         = Cint(0x0002)
const XIMStringConversionWord         = Cint(0x0003)
const XIMStringConversionChar         = Cint(0x0004)
const XIMStringConversionSubstitution = Cint(0x0001)
const XIMStringConversionRetrieval    = Cint(0x0002)

const XIMHotKeyStateON                = Clong(0x0001)
const XIMHotKeyStateOFF               = Clong(0x0002)
