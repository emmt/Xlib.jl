/*
 * gendefs.c --
 *
 * Generate definitions for Xlib.jl.
 *
 *------------------------------------------------------------------------------
 *
 * Copyright (C) 2017, Éric Thiébaut.
 *
 * This file is part of Xlib.jl which is licensed under the MIT "Expat"
 * License.
 */

#include <string.h>
#include <stdio.h>
#include <X11/Xlib.h>

#define HOWMANY(a,b)       ((((b) - 1 + (a))/(b)))
#define ROUNDUP(a,b)       (HOWMANY(a,b)*(b))
#define OFFSET(T,M)        ((int)((char*)&((T)0)->M - (char*)0))
#define DISPLAY_OFFSET(M)  OFFSET(_XPrivDisplay,M)
#define SCREEN_OFFSET(M)   OFFSET(Screen*,M)

static void
unsafe_load(const char* func,
	    const char* arg,
	    const char* jtype,
	    const char* ctype,
	    int off)
{
  if (off != 0) {
    printf("%s(%s::Ptr{%s}) =\n    unsafe_load(Ptr{%s}(%s + %d))\n\n",
	   func, arg, jtype, ctype, arg, off);
  } else {
    printf("%s(%s::Ptr{%s}) =\n    unsafe_load(Ptr{%s}(%s))\n\n",
	   func, arg, jtype, ctype, arg);
  }
}


static void
fixed_size(const char* header, const char* name,
	   const char* ctype,
	   const char* letter, int n, int r)
{
  int i;

  if (header != NULL) {
    printf("%s", header);
  } else {
    printf("immutable %s%d", ctype, n);
  }
  for (i = 1; i <= n; ++i) {
    printf("%s%s%02d::%s",
	   ((i%r) == 1 ? "\n    " : "; "),
	   letter, i, ctype);
  }
  if (header != NULL) {
    printf("\n    (::Type{%s})() =\n        new(", name);
  } else {
    printf("\n    (::Type{%s%d})() =\n        new(", ctype, n);
  }
  for (i = 0; i < n; ++i) {
    printf("0%s",
	   (i == n - 1 ? ")\n" : ((i%r) == r - 1 ? ",\n            " : ", ")));
  }
  printf("end\n");
  printf("\n");
}

static void
gen_types()
{
  int n;

#if 0
  printf("\n# Basic types.\n");
  printf("\n");
#define INFO(T) printf("const %s = UInt%d\n", #T, (int)(8*sizeof(T)))
  INFO(XID);
  INFO(Mask);
  INFO(Atom);
  INFO(VisualID);
  INFO(Time);
#undef INFO
  printf("\n");
#endif

  printf("\n# Dummy structures with enough elements of a given type.\n");
  printf("\n");
  fixed_size(NULL, NULL, "Cchar",  "c", 32, 8);
  fixed_size(NULL, NULL, "Cchar",  "c", 20, 5);
  fixed_size(NULL, NULL, "Cshort", "s", 10, 5);
  fixed_size(NULL, NULL, "Clong",  "l",  5, 5);

  printf("\n# Abstract and generic types for events\n");
  printf("\n");
  printf("@compat abstract type AbstractXEvent end\n");
  printf("\n");

  n = HOWMANY(sizeof(XEvent), sizeof(int));
  fixed_size("immutable XEvent <: AbstractXEvent", "XEvent",
	     "Cint", "i", n, 6);
  printf("@assert isbits(XEvent)\n");
  printf("\n");

}

static void
gen_offsets()
{
  printf("\n# Offsets in Display structure.\n\n");
#define INFO(M) printf("const _display_%s_offset = %d\n", #M, DISPLAY_OFFSET(M))
  INFO(ext_data);
  INFO(private1);
  INFO(fd);
  /*INFO(private2);*/
  INFO(proto_major_version);
  INFO(proto_minor_version);
  INFO(vendor);
  /*INFO(private3);*/
  /*INFO(private4);*/
  /*INFO(private5);*/
  /*INFO(private6);*/
  INFO(resource_alloc);
  INFO(byte_order);
  INFO(bitmap_unit);
  INFO(bitmap_pad);
  INFO(bitmap_bit_order);
  INFO(nformats);
  INFO(pixmap_format);
  /*INFO(private8);*/
  INFO(release);
  /*INFO(private9);*/
  /*INFO(private10);*/
  INFO(qlen);
  INFO(last_request_read);
  INFO(request);
  /*INFO(private11);*/
  /*INFO(private12);*/
  /*INFO(private13);*/
  /*INFO(private14);*/
  INFO(max_request_size);
  INFO(db);
  /*INFO(private15);*/
  INFO(display_name);
  INFO(default_screen);
  INFO(nscreens);
  INFO(screens);
  INFO(motion_buffer);
  /*INFO(private16);*/
  INFO(min_keycode);
  INFO(max_keycode);
  /*INFO(private17);*/
  /*INFO(private18);*/
  /*INFO(private19);*/
  INFO(xdefaults);
#undef INFO

  printf("\n\n# Offsets in Screen structure.\n\n");
#define INFO(M) printf("const _screen_%s_offset = %d\n", #M, SCREEN_OFFSET(M))
  INFO(ext_data);
  INFO(display);
  INFO(root);
  INFO(width);
  INFO(height);
  INFO(mwidth);
  INFO(mheight);
  INFO(ndepths);
  INFO(depths);
  INFO(root_depth);
  INFO(root_visual);
  INFO(default_gc);
  INFO(cmap);
  INFO(white_pixel);
  INFO(black_pixel);
  INFO(max_maps);
  INFO(min_maps);
  INFO(backing_store);
  INFO(save_unders);
  INFO(root_input_mask);
#undef INFO
  printf("\n");
}

static void
gen_accessors()
{

#define GET_SCREEN(F,T,M) unsafe_load(#F, "scr", "Screen", #T, SCREEN_OFFSET(M))
#define GET_DISPLAY(F,T,M) unsafe_load(#F, "dpy", "Display", #T, DISPLAY_OFFSET(M))
#define GET_DPYSCR(F, M) printf("%s(dpy::Ptr{Display}, scr::Integer) =\n", #F);	\
                         printf("    %s(ScreenOfDisplay(dpy, scr))\n\n", #M)

  printf("\n# Getting Display information.\n\n");
  GET_DISPLAY(ConnectionNumber, Cint, fd);
  GET_DISPLAY(DefaultScreen, Cint, default_screen);
  GET_DISPLAY(QLength, Cint, qlen);
  GET_DISPLAY(ScreenCount, Cint, nscreens);
  GET_DISPLAY(ServerVendor, Ptr{Cchar}, vendor);
  GET_DISPLAY(ProtocolVersion, Cint, proto_major_version);
  GET_DISPLAY(ProtocolRevision, Cint, proto_minor_version);
  GET_DISPLAY(VendorRelease, Ptr{Cchar}, release);
  GET_DISPLAY(DisplayString, Ptr{Cchar}, display_name);
  GET_DISPLAY(BitmapUnit, Cint, bitmap_unit);
  GET_DISPLAY(BitmapBitOrder, Cint, bitmap_bit_order);
  GET_DISPLAY(BitmapPad, Cint, bitmap_pad);
  GET_DISPLAY(ImageByteOrder, Cint, byte_order);
  printf("NextRequest(dpy::Ptr{Display}) =\n");
  printf("    unsafe_load(Ptr{Culong}(dpy + %d)) + 1\n",
	 DISPLAY_OFFSET(request));
  printf("\n");
  GET_DISPLAY(LastKnownRequestProcessed, Culong, last_request_read);

  printf("DefaultRootWindow(dpy::Ptr{Display}) =\n");
  printf("    RootWindowOfScreen(ScreenOfDisplay(dpy, DefaultScreen(dpy)))\n");
  printf("\n");
  GET_DPYSCR(RootWindow,      RootWindowOfScreen);
  GET_DPYSCR(DefaultVisual,   DefaultVisualOfScreen);
  GET_DPYSCR(DefaultGC,       DefaultGCOfScreen);
  GET_DPYSCR(BlackPixel,      BlackPixelOfScreen);
  GET_DPYSCR(WhitePixel,      WhitePixelOfScreen);
  GET_DPYSCR(DisplayWidth,    WidthOfScreen);
  GET_DPYSCR(DisplayHeight,   HeightOfScreen);
  GET_DPYSCR(DisplayWidthMM,  WidthMMOfScreen);
  GET_DPYSCR(DisplayHeightMM, HeightMMOfScreen);
  GET_DPYSCR(DisplayPlanes,   PlanesOfScreen);
  GET_DPYSCR(DisplayCells,    CellsOfScreen);
  GET_DPYSCR(DefaultDepth,    DefaultDepthOfScreen);
  GET_DPYSCR(DefaultColormap, DefaultColormapOfScreen);

  printf("\n");
  printf("# Methods for screen oriented applications (toolkit).\n");
  printf("\n");
  printf("ScreenOfDisplay(dpy::Ptr{Display}, scr::Integer) =\n");
  printf("    unsafe_load(Ptr{Ptr{Screen}}(dpy + %d), scr + 1)\n",
	 DISPLAY_OFFSET(screens));
  printf("\n");
  printf("DefaultScreenOfDisplay(dpy::Ptr{Display}) =\n");
  printf("    ScreenOfDisplay(dpy, DefaultScreen(dpy))\n");
  printf("\n");
  GET_SCREEN(DisplayOfScreen,         Ptr{Display}, display);
  GET_SCREEN(RootWindowOfScreen,      Window,       root);
  GET_SCREEN(BlackPixelOfScreen,      Culong,       black_pixel);
  GET_SCREEN(WhitePixelOfScreen,      Culong,       white_pixel);
  GET_SCREEN(DefaultColormapOfScreen, Colormap,     cmap);
  GET_SCREEN(DefaultDepthOfScreen,    Cint,         root_depth);
  GET_SCREEN(DefaultGCOfScreen,       GC,           default_gc);
  GET_SCREEN(DefaultVisualOfScreen,   Ptr{Visual},  root_visual);
  GET_SCREEN(WidthOfScreen,           Cint,         width);
  GET_SCREEN(HeightOfScreen,          Cint,         height);
  GET_SCREEN(WidthMMOfScreen,         Cint,         mwidth);
  GET_SCREEN(HeightMMOfScreen,        Cint,         mheight);
  GET_SCREEN(PlanesOfScreen,          Cint,         root_depth);
  GET_SCREEN(MinCmapsOfScreen,        Cint,         min_maps);
  GET_SCREEN(MaxCmapsOfScreen,        Cint,         max_maps);
  GET_SCREEN(DoesSaveUnders,          _Bool,        save_unders);
  GET_SCREEN(DoesBackingStore,        Cint,         backing_store);
  GET_SCREEN(EventMaskOfScreen,       Clong,        root_input_mask); /*FIXME:*/

  printf("CellsOfScreen(scr::Ptr{Screen}) =\n");
  printf("    unsafe_load(Ptr{Cint}(DefaultVisualOfScreen(scr) + %d))\n",
	 OFFSET(Visual*,map_entries));
  printf("\n");

#undef GET_SCREEN
#undef GET_DISPLAY
#undef GET_DPYSCR
}

int main(int argc, const char* argv[])
{
  int i;

  if (argc < 2) {
  usage:
    fprintf(stderr, "Usage: %s types|accessors|offsets ...\n",
	    argv[0]);
    return 1;
  }
  for (i = 1; i < argc; ++i) {
    if (strcmp(argv[i], "types") == 0) {
      gen_types();
    } else if (strcmp(argv[i], "accessors") == 0) {
      gen_accessors();
    } else if (strcmp(argv[i], "offsets") == 0) {
      gen_offsets();
    } else {
      fprintf(stderr, "%s: unknown argument \"%s\"\n", argv[0], argv[i]);
      goto usage;
    }
  }
  return 0;
}
