module Day7

export day7a, day7b, parsebags

using CombinedParsers
import CombinedParsers.Regexp: word, whitespace_maybe

function keepwords(str, n)
    join(split(str, " ")[1:n], " ")    
end

function separate(str)
    if str[1:2] == "no"
        (0, "")
    else
        v = split(str, " ")
        (parse(Int, v[1]), join(v[2:3], " "))
    end
end
    
function parsebags(filename)
    bags = Dict{String, Vector{Tuple{Int, String}}}()
    for line in readlines(filename)
        v = split(line, "contain")
        outer = strip(keepwords(v[1],2))
        bags[outer] = []
        for content in split(v[2], ',')
            content = strip(content)
            push!(bags[outer], separate(content))
        end
    end
    bags
end

function parsebagsreverse(filename)
    bags = Dict{String, Vector{String}}()
    for line in readlines(filename)
        v = split(line, "contain")
        outer = keepwords(v[1],2)
        for content in split(v[2], ',')
            content = strip(content)
            inner = separate(content)[2]
            if !isempty(inner)
                push!(get!(bags, inner, Vector{String}()), outer)
            end
        end
    end
    bags
end

function day7a(filename)
    target = "shiny gold"
    bags = parsebagsreverse(filename)
    good = Set{String}()
    totry = Set{String}([target])
    finished = Set{String}()
    while !isempty(totry)
        current = pop!(totry)
        push!(finished, current)
        for bag in get(bags, current, [])
            if !in(bag, finished)
                push!(totry, bag)
            end
            push!(good, bag)
        end        
    end
    length(good)
end

function day7b(filename)
    current = "shiny gold"
    bags = parsebags2(filename)
    totry = Set{Tuple{Int, String}}([(1, current)])
    count = 0
    while !isempty(totry)
        (n, current) = pop!(totry)
        count += n
        for (m, bag) in get(bags, current, [])
            push!(totry, (m*n, bag))
        end
    end
    println(count-1)
end



end
