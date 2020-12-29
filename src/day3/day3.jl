module Day3

export day3

function check_slope(terrain, a, b)
    counter = 0
    n = length(terrain[1])
    for (x,row) in enumerate(terrain)
        (q,r) = divrem(a*(x-1), b)
        if r == 0
            y = q+1
            d = mod(y,n)
            y = d == 0 ? n : d
            if row[y] == '#'
                counter += 1
            end
        end
    end
   counter
end

function day3(::Val{:a}, filename)
    terrain = readlines(filename)
    check_slope(terrain, 3,1)
end

function day3(::Val{:b}, filename)
    terrain = readlines(filename)
    slopes = [(1,1), (3,1), (5,1), (7,1), (1,2)]
    result = UInt(1)
    for (a,b) in slopes
        result *= check_slope(terrain, a,b)
    end
    result
end

end
