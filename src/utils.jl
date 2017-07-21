#
# utils.jl --
#
# Utilities for the Julia wrapper of X11 library.
#
#------------------------------------------------------------------------------
#
# Copyright (C) 2017, Éric Thiébaut.
#
# This file is part of Xlib.jl which is licensed under the MIT "Expat" License.
#

"""
    EventType(evt)

yields the type of event `evt`.
"""
EventType(evt::AbstractXEvent) = evt._type
EventType{T<:AbstractXEvent}(evt::Ref{T}) = EventType(evt[])

generateexports() = generateexports(STDOUT)

generateexports(name::String) = open(generateexports, name, "w")

function generateexports(io::IO)
    list = Array{String}(0)
    for sym in names(Xlib, true, false)
        str = string(sym)
        c = str[1]
        if c == '_'
            if length(str) < 2 || str == "_XLIB" || str == "_XGC"
                continue
            end
            c = str[2]
        end
        if 'A' ≤ c ≤ 'Z'
            push!(list, str)
        end
    end
    sort!(list)
    println(io, "#")
    println(io, "# exports.jl --")
    println(io, "#")
    println(io, "# Exported symbols for the Julia wrapper of X11 library.")
    println(io, "#")
    println(io, "#------------------------------------------------------------------------------")
    println(io, "#")
    println(io, "# Copyright (C) 2017, Éric Thiébaut.")
    println(io, "#")
    println(io, "# This file is part of Xlib.jl which is licensed under the MIT \"Expat\" License.")
    println(io, "#")
    println(io, "")
    println(io, "export")
    n = length(list)
    for i in 1:length(list)-1
        println(io, "    ", list[i], ",")
    end
    println(io, "    ", list[end])
end
