module Day20

export day20

using CombinedParsers
using CombinedParsers.Regexp

function parseline(line)
    p = join(Repeat(CharIn(".#")), "")
    line |> p
end

function parseinput(filename)
    temptiles = Dict{Int,Vector{Char}}()
    id = 0
    for line in readlines(filename)
        line = strip(line)
        if line == ""
            continue
        elseif line[1:4] == "Tile"
            id = parse(Int, line[6:end-1])        
        else
            temptiles[id] = vcat(get(temptiles,id,Vector{Char}()), parseline(line))
        end            
    end

    tiles = Dict{Int,Vector{String}}()
    
    for (id,tile) in temptiles
        tmp = reshape(tile,10,10)
        tiles[id] = map(join, [tmp[1,:], tmp[:,end], tmp[end,:], tmp[:,1]])
    end
    tiles        
end

function match_against(side, tile)
    revside = reverse(side)
    for side1 in tile
        if side1 == side || side1 == revside
            return true
        end
    end
    false
end

function day20(::Val{:a}, filename)
    tiles = parseinput(filename)
    corners = Vector{Int}()
    for (id1,tile1) in tiles
        matched_sides = 0
        for side1 in tile1
            for (id2,tile2) in tiles
                if id1 != id2 && match_against(side1,tile2)
                    matched_sides += 1
                    break
                end
            end
        end
        if matched_sides <= 2
            push!(corners, id1)
        end
    end
    prod(corners)
end

end
