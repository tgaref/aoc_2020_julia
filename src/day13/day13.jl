module Day13

export day13

using CombinedParsers
import CombinedParsers.Regexp: word, whitespace_maybe

function parseinput(filename)
    input = Vector{String}()
    for line in eachline(filename)
        push!(input, line)
    end
    earliest = parse(Int, input[1])
    buses = join(Repeat(Either('x', Numeric(Int))), ',')            
    (earliest, input[2] |> buses)
end 

# Bus with timestamp t arrives at dt = l*t - earliest.
# If earliest = k*t + r, then dt = (k+1)*t - earliest
# = t - r = t - mod(earliest, t)
function day13(::Val{:a}, filename)
    (earliest, buses::Vector{Union{Char,Int}}) = parseinput(filename)
    buses = filter(buses) do x
        isa(x, Int)
    end
    later = map(buses) do t
        r = mod(earliest, t)
        r == 0 ? 0 : t - r
    end
    (dt,ind) = findmin(later)         
    dt * buses[ind]
end 

# The time t is such that t = -i+1 mod n_i, where
# n_i is the timestamp of the i-th bus in the list
# including the 'x'. We solve using the CRT.
function day13(::Val{:b}, filename)
    (earliest, buses::Vector{Union{Char,Int}}) = parseinput(filename)
    N = prod(filter(c -> isa(c, Int), buses))
    suma = 0
    for (i,m) in enumerate(buses)
        if isa(m, Int)
            n = div(N,m)
            suma = mod(suma + (n * (-i+1) * gcdx(n,m)[2]), N)
        end
    end
    suma
end 

end
