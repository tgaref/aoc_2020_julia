module Day12

export day12a, day12b

mutable struct Position{T}
    long::T # East-West
    lat::T  # North-South
end
    
function parseinput(T, filename)
    input = Vector{Pair{Char, T}}()
    for line in readlines(filename)
        push!(input, line[1] => parse(T, line[2:end]))
    end
    input
end

turn(facing, angle) = mod(facing + div(angle, 90), 4)    

function forward!(position, facing, distance)
    if facing == 0
        position.lat += distance
    elseif facing == 1
        position.long += distance
    elseif facing == 2
        position.lat -= distance
    else
        position.long -= distance
    end
    nothing
end

function day12a(filename)
    dir2num = Dict{Char, Int}(['N' => 0, 'E' => 1, 'S' => 2, 'W' => 3])
    input = parseinput(Int, filename)
    position = Position{Int}(0,0)
    facing = dir2num['E']
    for instruction in input
        if first(instruction) == 'N'
            position.lat += last(instruction)
        elseif first(instruction) == 'S'
            position.lat -= last(instruction)
        elseif first(instruction) == 'E'
            position.long += last(instruction)
        elseif first(instruction) == 'W'
            position.long -= last(instruction)
        elseif first(instruction) == 'R'
            facing = turn(facing, last(instruction))
        elseif first(instruction) == 'L'
            facing = turn(facing, -last(instruction))
        elseif first(instruction) == 'F'
            forward!(position, facing, last(instruction))
        end
    end
    abs(position.long) + abs(position.lat)
end

function turn_waypoint!(waypoint, bycos, bysin)
    x = waypoint.long
    y = waypoint.lat
    waypoint.long = x * bycos - y * bysin
    waypoint.lat = y * bycos + x * bysin
    nothing
end

function move!(position, waypoint, times)
    position.long += times * waypoint.long
    position.lat += times * waypoint.lat
    nothing
end

function day12b(filename)
    input = parseinput(Float64, filename)
    waypoint = Position(10.0,1.0)
    position = Position(0.0,0.0)
    for instruction in input
        if first(instruction) == 'N'
            waypoint.lat += last(instruction)
        elseif first(instruction) == 'S'
            waypoint.lat -= last(instruction)
        elseif first(instruction) == 'E'
            waypoint.long += last(instruction)
        elseif first(instruction) == 'W'
            waypoint.long -= last(instruction)
        elseif first(instruction) == 'R'
            facing = turn_waypoint!(waypoint, cos(last(instruction)*pi/180.0), -sin(last(instruction)*pi/180.0))
        elseif first(instruction) == 'L'
            facing = facing = turn_waypoint!(waypoint, cos(last(instruction)*pi/180.0), sin(last(instruction)*pi/180.0))
        elseif first(instruction) == 'F'
            move!(position, waypoint, last(instruction))
        end
    end
    abs(position.long) + abs(position.lat)
end

end
