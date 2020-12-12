module Day11

export day11a, day11b

function parseinput(filename)
    grid = Vector{Char}()
    line = readline(filename)
    xsize = length(line)
    for line in readlines(filename)
        push!(grid, collect(line)...)
    end
    reshape(grid,(xsize, div(length(grid), xsize)))
end

function adjecent_neighbours(grid, x, y)
    adj = Vector{Tuple{Int, Int}}()
    (xsize, ysize) = size(grid)
    push!(adj, (x+1,y))
    push!(adj, (x-1,y))
    push!(adj, (x,y+1))
    push!(adj, (x,y-1))
    push!(adj, (x+1,y+1))
    push!(adj, (x+1,y-1))
    push!(adj, (x-1,y+1))
    push!(adj, (x-1,y-1))
    adj = filter(adj) do (a,b)
        a < 1 || a > xsize || b < 1 || b > ysize ? false : true
    end            

    count(adj) do (a,b)
        grid[a,b] == '#'
    end
end

function seen_neighbours(grid, x, y)
    seen = Vector{Tuple{Int,Int}}()
    for i in x+1:size(grid,1)
        if grid[i,y] != '.'
            push!(seen, (i,y))
            break
        end
    end
    for i in x-1:-1:1
        if grid[i,y] != '.'
            push!(seen, (i,y))
            break
        end
    end
    for j in y+1:size(grid,2)
        if grid[x,j] != '.'
            push!(seen, (x,j))
            break
        end
    end
    for j in y-1:-1:1
        if grid[x,j] != '.'
            push!(seen, (x,j))
            break
        end
    end
    for d in 1:min(size(grid,1)-x, size(grid,2)-y)
        if grid[x+d,y+d] != '.'
            push!(seen, (x+d,y+d))
            break
        end
    end
    for d in 1:min(x-1, y-1)
        if grid[x-d,y-d] != '.'
            push!(seen, (x-d,y-d))
            break
        end
    end
    for d in 1:min(size(grid,1)-x, y-1)
        if grid[x+d,y-d] != '.'
            push!(seen, (x+d,y-d))
            break
        end
    end
    for d in 1:min(x-1, size(grid,2)-y)
        if grid[x-d,y+d] != '.'
            push!(seen, (x-d,y+d))
            break
        end
    end
    count(seen) do (a,b)
        grid[a,b] == '#'
    end
end

function next(grid::Array{Char, 2}, neighbours, threshold)
    newgrid = copy(grid)
    changes = false
    for x in axes(grid,1)
        for y in axes(grid,2)
            n = neighbours(grid, x, y)
            state = grid[x,y]
            if state == 'L' && n == 0
                newgrid[x,y] = '#'
                changes = true
            elseif state == '#' && n >= threshold
                newgrid[x,y] = 'L'
                changes = true
            end
        end
    end
    (newgrid, changes)
end

function day11a(filename)
    grid = parseinput(filename)
    changes = true
    while changes
        (grid, changes) = next(grid, adjecent_neighbours, 4)
    end
    count(grid) do ch
        ch == '#'
    end
end

function day11b(filename)
    grid = parseinput(filename)
    changes = true
    while changes
        (grid, changes) = next(grid, seen_neighbours, 5)
    end
    count(grid) do ch
        ch == '#'
    end
end

end
