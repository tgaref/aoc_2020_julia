module Day25

export day25

function powmod(a::T,n::T,m::T) where T<:Integer
    q = a
    product = T(1)
    while n > T(0)
        n,r = divrem(n,2)
        if r == T(1)
            product = mod(product * q, m)
        end
        q = mod(q^2, m)
    end
    return product
end

function invmod(a::T,m::T) where T<:Integer
    t = gcdx(a,m)
    if t[1] != T(1)
        return error("No inverse exists!")
    end
    return mod(t[2],m)
end

function dlog(g, y, p)
    q = Int(floor(sqrt(p)))
    table = Dict{Int,Int}([1 => 0])
    gq = powmod(g,q,p)
    current_power = gq
    for i in 1:div(p,q)
        table[current_power] = i
        current_power = mod(current_power*gq, p)
    end
    ginv = invmod(g,p)
    current_key = y
    for j in 0:q-1
        if haskey(table, current_key)
            return table[current_key] * q + j
        end
        current_key = mod(current_key*ginv, p)
    end
end

function day25()
    card = 10604480
    door = 4126658
    p = 20201227
    g = 7

    b = dlog(g, door, p)
    powmod(card,b,p)
end

end
