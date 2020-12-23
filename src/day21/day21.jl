module Day21

export day21

using CombinedParsers
using CombinedParsers.Regexp: word, words, whitespace_maybe, whitespace_horizontal

function parseinput(filename)
    p = Sequence(:ingredients => join(Repeat(word), whitespace_maybe), " (contains " , :allergens => join(Repeat(word), ", "), ")")
    possibilities = Dict{String,Union{Set{String}, Nothing}}()
    ingredients = Set{String}()
    for line in readlines(filename)
        t = line |> p
        for allergen in t[:allergens]
            tmp = get!(possibilities, allergen, nothing)
            possibilities[allergen] = isnothing(tmp) ? Set(t[:ingredients]) : intersect(tmp, Set(t[:ingredients]))
            union!(ingredients, Set(t[:ingredients]))
        end        
    end
    (ingredients, possibilities)
end

function day21(::Val{:a}, filename)
    (all_ingredients, possibilities) = parseinput(filename)
    contains_allergen = Set{String}()
    changes = true
    while changes
        changes = false
        todo = Set{String}()
        for (allergen, ingredients) in possibilities
            if length(ingredients) == 1
                changes = true
                ingred = pop!(ingredients) 
                push!(todo, ingred)
                push!(contains_allergen, ingred)
                delete!(possibilities, allergen)
            end
        end
        for ingred in todo
            for allergen in keys(possibilities)
                delete!(possibilities[allergen], ingred)
            end
        end
    end
    allergen_free = setdiff(all_ingredients,contains_allergen)
    counts = Dict{String,Int}()
    for line in readlines(filename)
        words = split(line[1:findfirst('(', line)-1], ' ')
        for ingred in allergen_free
            if in(ingred, words)
                counts[ingred] = get(counts, ingred, 0) + 1
            end
        end
    end
    sum(values(counts))
end

function day21(::Val{:b}, filename)
    (all_ingredients, possibilities) = parseinput(filename)
    contained = Dict{String,String}()
    changes = true
    while changes
        changes = false
        todo = Set{String}()
        for (allergen, ingredients) in possibilities
            if length(ingredients) == 1
                changes = true
                ingred = pop!(ingredients) 
                push!(todo, ingred)
                contained[allergen] = ingred
                delete!(possibilities, allergen)
            end
        end
        for ingred in todo
            for allergen in keys(possibilities)
                delete!(possibilities[allergen], ingred)
            end
        end
    end
    allergens = sort(collect(keys(contained)))
    result = ""
    for allergen in allergens
        result *= "," * contained[allergen]
    end
    result[2:end]    
end

end
