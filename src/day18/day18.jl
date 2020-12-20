module Day18

export day18a, day18b

using CombinedParsers
using TextParse

function evaluate((start, operation_values))
    aggregated_value::Int = start
    for (op,val) in operation_values
        aggregated_value = eval(Expr(:call, Symbol(op),
       			             aggregated_value, val))
    end
    return aggregated_value
end

@syntax subterma = Either{Int}(Any[TextParse.Numeric(Int)])

@syntax for parenthesis in subterma
    term = evaluate |> join(subterma, CharIn("*+"), infix=:prefix )
    Sequence(2,'(',term,')')
end

@syntax expra = term

@syntax subtermb = Either{Int}(Any[TextParse.Numeric(Int)])

@syntax for parenthesis in subtermb
    adds = evaluate |> join(subtermb, CharIn("+"), infix=:prefix )
    mult = evaluate |> join(adds, CharIn("*"), infix=:prefix )
    Sequence(2,'(',mult,')')
end

@syntax exprb = mult

day18a(filename) = sum(map(s -> join(split(s, ' ')) |> Day18.expra, readlines("input_day18.txt")))

day18b(filename) = sum(map(s -> join(split(s, ' ')) |> Day18.exprb, readlines("input_day18.txt")))

end
