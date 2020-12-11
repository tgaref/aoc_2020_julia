module Day9

export day9a, day9b

function update!(sums::Dict{Int,Int}, window, new)
    out = window[1]
    for number in window[2:end]
        sums[out+number] -= 1
        sums[new+number] = get(sums, new+number, 0) + 1
    end
    sums        
end

function initialize(window)
    sums = Dict{Int,Int}()
    @inbounds for i in 1:length(window)
        @inbounds for j in i+1:length(window)
            sums[window[i]+window[j]] = get(sums, window[i]+window[j], 0) + 1
        end
    end
    sums
end

function day9a(filename, prelen)
    input = Vector{Int}()
    for line in readlines(filename)
        push!(input, parse(Int, line))
    end
    sums = initialize(input[1:prelen])
    for i in 1:length(input)
        new = input[prelen+i]
        if get(sums, new, 0) == 0
            return new
        end
        window = input[i:prelen+i-1]
        update!(sums, window, new)
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
    sort!(window)
    window[1] + window[end]
end


end
