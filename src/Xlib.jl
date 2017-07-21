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

__precompile__(true)

module Xlib

using Compat

const _XLIB = "libX11.so" # FIXME: should be set in ../deps

include("exports.jl")
include("constants.jl")
include("types.jl")
include("../deps/accessors.jl")
include("methods.jl")
include("utils.jl")

end
