module Day20

export day20, flipx, flipy, parseinput, matches, rotate, allpositions, up, down, left, right, test, chop, help

const Tile = Matrix{Char}

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
            temptiles[id] = vcat(get(temptiles,id,Vector{Char}()), collect(line))
        end            
    end
    tiles = Dict{Int,Tile}()    
    for (id,tile) in temptiles        
        tiles[id] = reshape(tile,10,10)
    end
    tiles        
end

function rotate(angle,m::Matrix{T}) where {T}
    if angle == 90
        rotr90(m)
    elseif angle == 180
        rot180(m)
    elseif angle == -90
        rotl90(m)
    else
        println("Rotation angle must be 90, 180 or -90.")
    end        
end

function flipy(m::Tile)
    res = fill(' ', size(m,1), size(m,2))
    for i in 1:size(m,1)
        res[i,:] = reverse(m[i,:])
    end
    res        
end

function flipx(m::Tile)
    res = fill(' ', size(m,1), size(m,2))
    for j in 1:size(m,2)
        res[:,j] = reverse(m[:,j])
    end
    res        
end


function allpositions(tile::Tile)
    positions = Set{Tile}([tile])
    for an in [90,180,-90]
        tmp = rotate(an, tile)
        push!(positions, tmp)
        push!(positions, flipx(tmp))
        push!(positions, flipy(tmp))
    end
    positions
end

up(m) = m[1,:]
down(m) = m[size(m,1),:]
left(m) = m[:,1]
right(m) = m[:,size(m,2)]

function sides(m::Matrix{T}) where {T}
    s = Vector{Vector{T}}()
    for op in [:up, :down, :left, :right]
        push!(s, eval(:($op($m))))
    end
    s
end

function matches(tile1, tile2)
    for s1 in sides(tile1)
        for s2 in sides(tile2)
            if s1 == s2 || s1 == reverse(s2)
                return true
            end
        end
    end
    false                
end

function getgrid(tiles)
    grid = Dict{Int, Set{Int}}()
    for (id1, tile1) in tiles
        for (id2, tile2) in tiles
            id1 == id2 && continue
            if matches(tile1, tile2)
                grid[id1] = push!(get(grid, id1, Set()), id2)
            end
        end
    end
    grid
end

function orient(source, target)
    for t in allpositions(target)
        if up(source) == down(t)
            return (t,-1,0)
        elseif down(source) == up(t)
            return (t,1,0)
        elseif left(source) == right(t)
            return (t,0,-1)
        elseif right(source) == left(t)
            return (t,0,1)
        end
    end
end


function check(mat, pat)
    for (i,j) in pat
        mat[i,j] != '#' && return false
    end
    true
end

function search(mat, pat)
    cnt = 0
    for i in 1:size(mat,1)-2, j in 1:size(mat,2)-19
        if check(mat[i:i+2, j:j+19], pat)
            println("Found monster at $((i,j))")
            cnt += 1
        end        
    end
    cnt
end

function flatten(m)
    ppp = vcat(m[:,1]...)
    for j in 2:size(m,2)
        ppp = hcat(ppp,vcat(m[:,j]...))
    end
    ppp
end

function expand(grid, tiles, id)
    pic = Dict{Tile, Tuple{Int, Int}}(tiles[id] => (0,0))
    queue = [(id, tiles[id])]
    seen = Set{Int}([id])
    while ! isempty(queue)
        (i,t) = pop!(queue)
        for j in grid[i]
            if ! in(j, seen)
                (s,x,y) = orient(t, tiles[j])
                pic[s] = (pic[t][1]+x, pic[t][2]+y)
                push!(queue, (j,s))
                push!(seen, j)
            end
        end
    end
    pic
end

chop(tile) = tile[2:end-1, 2:end-1]

function day20(::Val{:a}, file)
    tiles = parseinput(file)
    grid = getgrid(tiles)
    res = 1
    for (id, tiles) in grid
        if length(tiles) == 2
            res *= id
        end
    end
    res
end

function day20(::Val{:b}, file)
    tiles = parseinput(file)
    grid = getgrid(tiles)    
    pic = expand(grid, tiles, 1753)
    x = minimum(t -> t[1], values(pic))
    y = minimum(t -> t[2], values(pic))
    tmp = fill(tiles[1753], 12,12)
    for (t, (i,j)) in pic
        tmp[i-x+1, j-y+1] = chop(t)
    end
    picture = flatten(tmp)
    pat = [(1,19),
           (2,1),(2,6),(2,7),(2,12),(2,13),(2,18),(2,19),(2,20),
           (3,2),(3,5),(3,8),(3,11),(3,14),(3,17)]

    cnt = 0
    for p in allpositions(picture)
        cnt += search(p, pat)        
    end
    count(x -> x == '#', picture) - 15 * cnt

end

end
