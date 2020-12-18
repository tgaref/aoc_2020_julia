module Day16

export day16a, day16b

struct Ticket
    fields::Vector{Int}
end

struct Rule
    name::String
    range1::UnitRange
    range2::UnitRange
end

using CombinedParsers
using CombinedParsers.Regexp: words, whitespace_maybe

function parserule(str)
    line = Sequence(:name => CombinedParsers.Regexp.words, ": ", :first => Numeric(Int), '-', :second => Numeric(Int), " or ", :third => Numeric(Int), '-', :fourth =>Numeric(Int))
    t = str |> line
    Rule(t[:name], UnitRange(t[:first],t[:second]), UnitRange(t[:third],t[:fourth]))
end

function parseticket(str)
    fields = join(Repeat(Numeric(Int)), ',')
    str |> fields
end

function parseinput(filename)
    rules = Dict{String,Tuple{UnitRange,UnitRange}}()
    myticket = Ticket(Int[])
    tickets = Vector{Ticket}()
    mode = :rules
    for line in readlines(filename)
        if line == "your ticket:"
            mode = :myticket
            continue
        elseif line == "nearby tickets:"
            mode = :tickets
            continue
        elseif line |> strip == ""
            continue
        end
        if mode == :rules
            rule = parserule(line)
            rules[rule.name] = (rule.range1, rule.range2)
        elseif mode == :myticket
            myticket = Ticket(parseticket(line))
        elseif mode == :tickets
            push!(tickets, Ticket(parseticket(line)))
        end
    end

    (rules, myticket, tickets)
end

function iscompletelyinvalid(rules, n)
    for t in values(rules)
        if in(n, t[1]) || in(n, t[2])
            return 0                
        end
    end
    n
end

function day16a(filename)
    (rules, myticket, tickets) = parseinput(filename)

    suma = 0
    for ticket in tickets
        for n in ticket.fields
            suma += iscompletelyinvalid(rules, n)
        end 
    end
    suma
end

isvalid(rules, ticket) = Base.all(Base.any(in(n, t[1]) || in(n, t[2]) for t in values(rules)) for n in ticket.fields)

function correct!(labels, rules, ticket)
    for (i,n) in enumerate(ticket.fields)
        for (name, t) in rules
            if !in(n, t[1]) && !in(n, t[2])
                delete!(labels[i], name)
            end
        end
    end
end

function day16b(filename)
    (rules, myticket, tickets) = parseinput(filename)
<<<<<<< HEAD
    # Find the valid tickets
=======
>>>>>>> aad768e7e2f8e6851e480b654d45699c21691849
    valid_tickets = Ticket[]
    for ticket in tickets
        if isvalid(rules, ticket)
            push!(valid_tickets, ticket)
        end
    end
<<<<<<< HEAD
    # Initialize labels: every field may have any label
=======
>>>>>>> aad768e7e2f8e6851e480b654d45699c21691849
    labels = Dict{Int, Set{String}}()
    for field in 1:length(myticket.fields)
        labels[field] = Set(keys(rules))
    end

<<<<<<< HEAD
    # Remove labels from fields that cannot have the
    # label due to range constraints
=======
>>>>>>> aad768e7e2f8e6851e480b654d45699c21691849
    for ticket in valid_tickets
        correct!(labels, rules, ticket)
    end

<<<<<<< HEAD
    # Start with fields with only one possibility.
    # Remove this possibility from the other field's
    # label set. Continue until all fields have a
    # unique label    
=======
>>>>>>> aad768e7e2f8e6851e480b654d45699c21691849
    label = Dict{Int, String}()
    todo = Set(1:length(myticket.fields))
    while !isempty(todo)
        for (n,s) in labels
            if length(s) == 1
                l = pop!(s)
                label[n] = l
                for (m,t) in labels
                    delete!(t, l) 
                end
                delete!(todo, n)
            end
        end
    end

    pr = 1
    for (i,n) in enumerate(myticket.fields)
        if length(label[i]) < 9
            continue
        elseif label[i][1:9] == "departure"
            pr *= n
        end
    end
    pr
end

end
