module Day18

export day18

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

# Parser of '+' surrounded by whitepsace
plus = Sequence(2, Repeat(CombinedParsers.Regexp.whitespace_maybe), '+', Repeat(CombinedParsers.Regexp.whitespace_maybe))
# Parser of '*' surrounded by whitepsace
times = Sequence(2, Repeat(CombinedParsers.Regexp.whitespace_maybe), '*', Repeat(CombinedParsers.Regexp.whitespace_maybe))
# Parser of '+' or '*' surrounded by whitepsace
plustimes = Sequence(2, Repeat(CombinedParsers.Regexp.whitespace_maybe), CharIn("+*"), Repeat(CombinedParsers.Regexp.whitespace_maybe)) 

@syntax subterma = Either{Int}(Any[TextParse.Numeric(Int)])

@syntax for parenthesis in subterma
    term = evaluate |> join(subterma, plustimes, infix=:prefix )
    Sequence(2,'(',term,')')
end

@syntax expra = term

@syntax subtermb = Either{Int}(Any[TextParse.Numeric(Int)])

@syntax for parenthesis in subtermb
    adds = evaluate |> join(subtermb, plus, infix=:prefix )
    mult = evaluate |> join(adds, times, infix=:prefix )
    Sequence(2,'(',mult,')')
end

@syntax exprb = mult

day18(::Val{:a}, filename) = sum(map(expra, readlines("input_day18.txt")))

day18(::Val{:b}, filename) = sum(map(exprb, readlines("input_day18.txt")))

end
