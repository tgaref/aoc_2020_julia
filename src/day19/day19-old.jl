module Day19

export day19a, day19b

using CombinedParsers
using CombinedParsers.Regexp: whitespace_maybe

struct Input
    rules::Dict{Int, Set{Any}}
    messages::Vector{String}
end

function parserule(str)
    numbers = join(Repeat(Numeric(Int)), ' ')
    indirect = join(numbers, " | ")
    direct = Either("a", "b")
    q = Either(indirect, direct)
    p = Sequence(:no => Numeric(Int), ": ", :rules => q )
    str |> p
end

function parseinput(filename)
    rules = Dict{Int,Set{Any}}()
    messages = Vector{String}()
    mode = :rule 
    for line in readlines(filename)
        if line == ""
            mode = :message
            continue
        end
        if mode == :rule
            result = parserule(line)
            if result[:rules] isa AbstractString                 
                rules[result[:no]] = Set([result[:rules]])
            else
                rules[result[:no]] = Set(result[:rules])
            end
        else
            push!(messages, strip(line))
        end
    end
    Input(rules, messages)
end

isfixed(v) = all(isa(x, AbstractString) for x in v)

function mymap(f, s::Set{T}) where {T}
    news = Set{T}()
    for x in s
        push!(news, f(x))
    end
    news              
end

function myreplace(vec::Vector, f, reps, max_len) #return a set of vectors
    positions = findall(x -> x == f, vec)
    vs = Set([vec])    
    for i in positions
        new_vs = Set()
        for v in vs
            for rep in reps
                w::Vector{Any} = copy(v)
                w[i] = rep
                if mylen(w) <= max_len
                    push!(new_vs, w)
                end
            end
        end
        vs = new_vs
    end
    vs
end

mylen(v) = sum(map(length,v))

function day19a(filename)
    input = parseinput(filename)
    max_len = maximum(length, input.messages)
    fixed = Set{Int}()
    remain = Set{Int}()
    
    for (n, v) in input.rules
        if isfixed(v)
            push!(fixed, n)
        else
            push!(remain, n)
        end
    end

    while !all(rule isa AbstractString for rule in input.rules[0])
        for f in fixed
            replacements = input.rules[f]
            for r in remain
                new_rules = Set()
                for v in input.rules[r]
                    union!(new_rules, myreplace(v, f, replacements, max_len))
                end

                if all(isfixed(rule) for rule in new_rules)
                    push!(fixed, r)
                    delete!(remain, r)
                    new_rules = mymap(join, new_rules)
                end
                input.rules[r] = new_rules
            end
        end
    end

    count = 0
    for message in input.messages
        if message in input.rules[0]
            count += 1
        end
    end
    count
end

function day19(::Val{:a}, filename)
    input = parseinput(filename)
    
end

end
