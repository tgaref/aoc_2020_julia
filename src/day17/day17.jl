module Day17

export day17

function parseinput(::Val{3}, filename)
    n = length(readline(filename))
    space = zeros(Int,n+16,n+16,n+16)
    for (i,line) in enumerate(readlines(filename))
        for (j,ch) in enumerate(line)
            if ch == '.'
                space[7+i,7+j,8] = 0
            else
                space[7+i,7+j,8] = 1
            end
        end
    end
    space
end

function parseinput(::Val{4}, filename)
    n = length(readline(filename))
    space = zeros(Int,n+16,n+16,n+16, n+16)
    for (i,line) in enumerate(readlines(filename))
        for (j,ch) in enumerate(line)
            if ch == '.'
                space[7+i,7+j,8,8] = 0
            else
                space[7+i,7+j,8,8] = 1
            end
        end
    end
    space
end

function count_neighbours(::Val{3}, space, x,y,z)
    count = - space[x,y,z]
    for i in -1:1, j in -1:1, k in -1:1
        count += space[x+i, y+j, z+k]
    end
    count
end

function count_neighbours(::Val{4}, space, x,y,z,w)
    count = - space[x,y,z,w]
    for i in -1:1, j in -1:1, k in -1:1, s in -1:1
        count += space[x+i, y+j, z+k, w+s]
    end
    count
end

function simulate(::Val{3}, space)
    new_space = copy(space)
    for x in 2:size(space,1)-1, y in 2:size(space,2)-1, z in 2:size(space,3)-1
        n = count_neighbours(Val(3),space,x,y,z)
        if space[x,y,z] == 1 && n != 2 && n != 3 
            new_space[x,y,z] = 0
        elseif space[x,y,z] == 0 && n == 3
            new_space[x,y,z] = 1
        end
    end
    new_space
end

function simulate(::Val{4}, space)
    new_space = copy(space)
    for x in 2:size(space,1)-1, y in 2:size(space,2)-1, z in 2:size(space,3)-1, w in 2:size(space,4)-1
        n = count_neighbours(Val(4),space,x,y,z,w)
        if space[x,y,z,w] == 1 && n != 2 && n != 3 
            new_space[x,y,z,w] = 0
        elseif space[x,y,z,w] == 0 && n == 3
            new_space[x,y,z,w] = 1
        end
    end
    new_space
end

function day17(filename, dim)
    space = parseinput(Val(dim), filename)
    for cycle in 1:6
        space = simulate(Val(dim), space)
    end
    sum(space)
end

end
