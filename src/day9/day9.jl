module Day9

export day9a, day9b

function issumoftwo(window, number)
    for a in window
        if in(number-a, window)
            return true
        end
    end
    false
end

function day9a(filename, prelen)
    input = Vector{Int}()
    for line in readlines(filename)
        push!(input, parse(Int, line))
    end
    for i in 1:length(input)-prelen
        window = input[i:prelen+i-1]
        new = input[prelen+i]
        if !issumoftwo(window, new)
            return new
        end        
    end    
end

function findwindow(input, target)
    for i in 1:length(input)-1
        current_sum = input[i]
        for j in i+1:length(input)
            current_sum += input[j]
            if current_sum == target
                return input[i:j]
            end
        end
    end
end

function day9b(filename, prelen)
    input = Vector{Int}()
    for line in readlines(filename)
        push!(input, parse(Int, line))
    end
    target = day9a(filename, prelen)
    window = findwindow(input, target)
    (min, max) = reduce(window, init = (window[1],window[1])) do (min, max), n
        (n < min ? n : min, n > max ? n : max)
    end
    min + max
end

end
