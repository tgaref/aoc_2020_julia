module Day5

export day5

function findposition(str, upper)
    reduce(str, init = 0) do acc c
        c == upper ? acc+1 : acc
    end
end

function day5(::Val{:a}, filename)
    highest = 0
    for line in readlines(filename)
        line = strip(line)
        row_position = line[1:7]
        seat_position = line[8:end]
        row = findposition(row_position, 'B')
        seat = findposition(seat_position, 'R')
        seatid = row * 8 + seat
        if seatid > highest
            highest = seatid
        end
    end
    highest
end

function day5(::Val{:b}, filename)
    seats = Set{Int}()
    for line in readlines(filename)
        line = strip(line)
        row_position = line[1:7]
        seat_position = line[8:end]
        row = findposition(row_position, 'B')
        col = findposition(seat_position, 'R')
        push!(seats, row * 8 + col)        
    end
    miss = setdiff(Set{Int}(0:127*8-1), seats)
    for seat in miss
        if in(seat-1, seats) && in(seat+1, seats)
            println(seat)
        end
    end    
end

end
