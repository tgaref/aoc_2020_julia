module Day11

export day11

function parseinput(filename)
    grid = Vector{Char}()
    line = readline(filename)
    xsize = length(line)
    for line in readlines(filename)
        push!(grid, collect(line)...)
    end
    reshape(grid,(xsize, div(length(grid), xsize)))
end

function adjacent_neighbours(grid, x, y)
    count = 0
    for dx in -1:1
        for dy in -1:1
            a = x+dx
            b = y+dy
            if 1 <= a <= size(grid,1) && 1 <= b <= size(grid,2) && grid[a,b] == '#'
                count += 1
            end
        end
    end
    grid[x,y] == '#' ? count-1 : count
end
        
function occupied_in_direction(grid, x, y, dx, dy)
    x += dx
    y += dy
    while 1 <= x <= size(grid,1) && 1 <= y <= size(grid,2)
        if grid[x,y] == 'L'
            return false
        elseif grid[x,y] == '#'
            return true
        end
        x += dx
        y += dy
    end
    false
end

function seen_neighbours(grid, x, y)
    count = 0
    for dx in -1:1
        for dy in -1:1
            if dx == 0 && dy == 0
                continue
            end
            if occupied_in_direction(grid, x, y, dx, dy)
                count += 1
            end
        end
    end
    count
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

function day11(::Val{:a}, filename)
    grid = parseinput(filename)
    changes = true
    while changes
        (grid, changes) = next(grid, adjacent_neighbours, 4)
    end
    count(grid) do ch
        ch == '#'
    end
end

function day11(::Val{:b}, filename)
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
