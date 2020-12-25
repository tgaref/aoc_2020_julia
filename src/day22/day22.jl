module Day22

export day22

function parseinput(filename)
    deck = Dict{Int,Vector{Int}}()
    player = 0
    for line in readlines(filename)
        if line == ""
            continue
        elseif length(line) >= 6
            player = parse(Int, line[8])
        else
            push!(get!(deck, player, Int[]), parse(Int, line))
        end            
    end
    deck
end

function day22(::Val{:a}, filename)
    deck = parseinput(filename)
    looser = maximum(deck[1]) > maximum(deck[2]) ? 2 : 1
    winner = maximum(deck[1]) > maximum(deck[2]) ? 1 : 2
    round = 1
    while !isempty(deck[looser])
        a = deck[1][1]
        deck[1] = deck[1][2:end]
        b = deck[2][1]
        deck[2] = deck[2][2:end]
        if a > b
            push!(deck[1],a)
            push!(deck[1],b)
        else
            push!(deck[2],b)
            push!(deck[2],a)
        end
        round += 1
    end
    foldl((acc, (i,x)) -> acc + i*x, enumerate(reverse(deck[winner])), init = 0)
end

function play(deck)
    seen_decks = Set{Tuple{Int,Vector{Int}}}()
    newdeck = Dict{Int,Vector{Int}}()
    winner = 0
    while length(deck[1]) != 0 && length(deck[2]) != 0
        
        if (1,deck[1]) in seen_decks || (2,deck[2]) in seen_decks
            return (1,deck)
        else
            a = deck[1][1]
            b = deck[2][1]
            if length(deck[1][2:end]) >= a && length(deck[2][2:end]) >= b
                newdeck[1] = copy(deck[1][2:1+a])
                newdeck[2] = copy(deck[2][2:1+b])
                (winner, ds) = play(newdeck)
            else
                winner = a > b ? 1 : 2
            end
            if winner == 1
                push!(deck[1],a)
                push!(deck[1],b)
            else
                push!(deck[2],b)
                push!(deck[2],a)
                
            end
            push!(seen_decks, (1, deck[1]))
            push!(seen_decks, (2, deck[2]))
            
            deck[1] = deck[1][2:end]
            deck[2] = deck[2][2:end]
            
        end
    end
    return (winner, deck)
end

function day22(::Val{:b}, filename)
    deck = parseinput(filename)

    (winner, deck) = play(deck)

    display(deck)

    foldl((acc, (i,x)) -> acc + i*x, enumerate(reverse(deck[winner])), init = 0)
end

end
