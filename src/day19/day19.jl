module Day19

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
    "(" * join([join(get_re(r, rules) for r in rule) for rule in list], "|") * ")"
end

function day19(::Val{:a}, filename)
    input = parseinput(filename)
    rr = get_re(input.rules[0], input.rules)
    re = Regex("^" * rr * "\$")
    
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
    rr42 = get_re(input.rules[42], input.rules)
    rr31 = get_re(input.rules[31], input.rules)
    re42 = Regex(rr42)
    re31 = Regex(rr31)

    count = 0
    for message in input.messages
        for i in 2:9, j in 1:i-1
                rr = Regex("^"*join(rr42 for k in 1:i) * join(rr31 for l in 1:j)*"\$")
                if !isnothing(match(rr, message))
                    count += 1
                    break
                end
        end
    end        
    count
end         

end
