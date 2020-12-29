module Day6

export day6

function answersbygroup(filename)
    groups = Vector{Vector{String}}()
    group = Vector{String}()
    for line in readlines(filename)
        line = strip(line)
        if line == ""
            push!(groups, group)
            group = String[]
        else
            push!(group, line)
        end        
    end
    push!(groups, group)
    groups
end

function day6(::Val{:a}, filename)
    groups = answersbygroup(filename)
    sum(length(unique(join(group))) for group in groups)
end

function check(c, group)
    all(in(c,str) for str in group)
end

function day6(::Val{:b}, filename)
    groups = answersbygroup(filename)    
    sum(filter(c -> check(c,group), group[1]) |> unique |> length for group in groups)
end

end
