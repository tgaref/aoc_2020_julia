module Day23

export day23

mutable struct GameState
    current::Int
    next::Dict{Int, Int}
end

function destination(state)
    n = length(state.next)
    candidate = state.current > 1 ? state.current - 1 : n
    slice = Vector{Int}()
    c = state.current
    for i in 1:3
        c = state.next[c]
        push!(slice,c)        
    end
    while in(candidate, slice)
        candidate = candidate > 1 ? candidate - 1 : n
    end
    candidate, slice
end

function step!(state)
    (dest, slice) = destination(state)
    state.next[state.current] = state.next[slice[3]]
    tmp = state.next[dest]
    state.next[dest] = slice[1]
    state.next[slice[3]] = tmp
    state.current = state.next[state.current]    
end

function day23(::Val{:a})
    input = [7,8,4,2,3,5,9,1,6]
    #    input = [3,8,9,1,2,5,4,6,7]
    next = Dict{Int, Int}()
    for i in 1:length(input)-1
        next[input[i]] = input[i+1]
    end
    next[input[end]] = input[1]
    state = GameState(input[1],next)
    for i in 1:100
        step!(state)
    end
    answer = Vector{String}()
    c = 1
    for i in 1:length(input)-1
        push!(answer, string(state.next[c]))
        c = state.next[c]
    end
    join(answer)
end

function day23(::Val{:b})
    input = [7,8,4,2,3,5,9,1,6]
    # input = [3,8,9,1,2,5,4,6,7]
    next = Dict{Int, Int}()
    for i in 1:length(input)-1
        next[input[i]] = input[i+1]
    end
    next[input[end]] = length(input) + 1
    for k in length(input)+1:10^6-1
        next[k] = k+1
    end
    next[10^6] = input[1]
    state = GameState(input[1],next)
    for i in 1:10^7
        step!(state)
    end
    a = state.next[1]
    b = state.next[a]
    a * b 
end

end
