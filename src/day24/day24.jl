module Day24

export day24

using CombinedParsers
using CombinedParsers.Regexp: whitespace_maybe

abstract type Direction end

struct SE <: Direction end
struct SW <: Direction end
struct NE <: Direction end
struct NW <: Direction end
struct E <: Direction end
struct W <: Direction end

abstract type Color end

struct White <: Color end
struct Black <: Color end

function parseinput(filename)
    mapdir = Dict{String,Type{<:Direction}}(["se" => SE, "sw" => SW, "ne" => NE, "nw" => NW, "e" => E, "w" => W])
    p = join(Repeat("se" | "sw" | "ne" | "nw" | "e" | "w"),"")

    input = Vector{Vector{Type{<:Direction}}}()
    for line in readlines(filename)
        v = map(s -> mapdir[s], line |> p)
        push!(input, v)
    end
    input
end

function step(d::Type{<: Direction})
    if d == SE
        (0,-1)
    elseif d == SW
        (-1,-1)
    elseif d == NE
        (1,1)
    elseif d == NW
        (0,1)
    elseif d == E
        (1,0)
    else
        (-1,0)
    end
end

import Base.:+

function Base.:+(x::Tuple{<:Integer, <:Integer}, y::Tuple{<:Integer, <:Integer})
    (x[1] + y[1], x[2] + y[2])
end

function findtile(path)
    pos = (0,0)
    for direction in path
        pos += step(direction)
    end
    pos
end

flip(c::Type{<:Color}) = c == Black ? White : Black

function initialize(input)
    floor = Dict{Tuple{Int,Int}, Type{<:Color}}()
    for path in input
        tile = findtile(path)
        floor[tile] = flip(get(floor, tile, White))
    end
    floor
end

function day24(::Val{:a}, filename)
    input = parseinput(filename)
    floor = initialize(input)
    count(c -> c == Black, values(floor))
end

function neighbors(pos)
    (x,y) = pos
    Set{Tuple{Int,Int}}([(x,y+1), (x,y-1), (x-1,y), (x+1,y), (x+1,y+1), (x-1, y-1)])
end

function change(floor::Dict{Tuple{Int,Int}, Type{<:Color}})
    new_floor = copy(floor)
    cells = Set{Tuple{Int,Int}}(keys(floor))
    layout = copy(cells)
    for pos in cells
        union!(layout, neighbors(pos))
    end    
    for pos in layout
        blacks = 0
        for nei in neighbors(pos)
            blacks += get(floor, nei, White) == Black ? 1 : 0
        end
        if get!(floor,pos,White) == Black && (blacks == 0 || blacks > 2)
            new_floor[pos] = White
        end
        if get!(floor,pos,White) == White && blacks == 2
            new_floor[pos] = Black
        end
    end
    new_floor
end

function day24(::Val{:b}, filename)
    input = parseinput(filename)
    floor = initialize(input)
    for day in 1:100
        floor = change(floor)
    end
    count(c -> c == Black, values(floor))
end

end
