module Day15

export day15

function day15(input::Vector{Int}, upto::Int)    
    sequence = Dict{Int, Tuple{Int, Int}}()
    for (i,k) in enumerate(input)
        sequence[k] = (i,i)
    end
    last = input[end]
    for i in length(input)+1:upto
        (prev,prevprev) = sequence[last]
        last = prev - prevprev
        (a,b) = get(sequence, last, (i,i))
        sequence[last] = (i,a)
    end
    last
end

end
