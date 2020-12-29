module Day10

using Combinatorics

export day10

function day10(::Val{:a}, filename)
    input = Vector{Int}()
    for line in readlines(filename)
        push!(input, parse(Int, line))
    end
    sort!(input)
    differences = Dict{Int, Int}([1 => 0, 2 => 0, 3 => 0])
    differences[input[1]] = 1
    @inbounds for i in 1:length(input)-1
        d = input[i+1] - input[i]
        differences[d] += 1
    end
    differences[3] += 1
    differences[1] * differences[3]
end

function choices(slice, before, after)
    if isempty(slice)
        return 1
    end
    count = after - before <= 3 ? 1 : 0
    for t in Base.Iterators.drop(powerset(slice),1)
        if (t[1] - before <= 3) && (after - t[end] <= 3) && isvalid(t)
            count += 1
        end
    end
    count
end

function isvalid(t)
    for i in 1:length(t)-1
        if t[i+1] - t[i] > 3
            return false
        end
    end
    true
end

function day10(::Val{:b}, filename)
    input = Vector{Int}()
    for line in readlines(filename)
        push!(input, parse(Int, line))
    end
    sort!(input)
    indices = Vector{Int}()
    if input[1] == 3
        push!(indices, 1)
    end
    for i in 2:length(input)
        if input[i] - input[i-1] == 3
            push!(indices, i)
            push!(indices, i-1)
        end
        if input[i] - input[i-1] == 2 && input[i+1] - input[1] == 2
            push!(indices, i)
        end
    end
    push!(indices, length(input))
    indices = sort(unique(indices))
    count = choices(input[1:indices[1]-1], 0, input[indices[1]])
    for i in 1:length(indices)-1
        count *= choices(input[indices[i]+1:indices[i+1]-1], input[indices[i]], input[indices[i+1]])
    end
    count
end

end
