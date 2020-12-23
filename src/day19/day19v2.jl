module Day19v2

export day19

using CombinedParsers
using CombinedParsers.Regexp: whitespace_maybe

struct Input
    rules::Dict{Int,Union{AbstractString,Vector{Vector{Int}}}}
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
    rules = Dict{Int,Union{AbstractString,Vector{Vector{Int}}}}()
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
                rules[result[:no]] = result[:rules]
            else
                rules[result[:no]] = result[:rules]
            end
        else
            push!(messages, strip(line))
        end
    end
    Input(rules, messages)
end

get_re(r::AbstractString, rules) = r
get_re(r::Int, rules) = get_re(rules[r], rules)

function get_re(list, rules)
    rr = Either{Any}(Any[])
    for rule in list
        inner = [get_re(r, rules) for r in rule]
        push!(rr, Sequence(inner...))
    end
    rr       
end

function day19(::Val{:a}, filename)
    input = parseinput(filename)
    re = AtStart() * get_re(input.rules[0], input.rules) * AtEnd()
    count = 0
    for message in input.messages
        if !isnothing(match(re, message))
            count += 1
        end
    end
    count
end

function day19(::Val{:b}, filename)
    input = parseinput(filename)
    re42 = get_re(input.rules[42], input.rules)
    re31 = get_re(input.rules[31], input.rules)
    count = 0
    for message in input.messages
        for i in 2:9, j in 1:i-1
                rr = AtStart() * Sequence([re42 for k in 1:i]...) * Sequence([re31 for l in 1:j]...) * AtEnd()
                if !isnothing(match(rr, message))
                    count += 1
                    break
                end
        end
    end        
    count
end         

end
