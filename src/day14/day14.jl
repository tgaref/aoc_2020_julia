module Day14

using CombinedParsers
using CombinedParsers.Regexp: whitespace_maybe

export day14a, day14b

function parsemem(str)
    mem = Sequence("mem[", :ind => Numeric(Int), "] = ", :value => Numeric(Int))
    str |> mem    
end

function applytovalue(mask, value)
    result = 0
    for (m,v) in zip(mask, value)
        if m == 'X'
            result = result * 2 + v
        elseif m == '0'
            result = result * 2
        else
            result = result * 2 + 1
        end
    end
    result
end

function day14a(filename)
    mem = Dict{Int,Int}()
    mask = Char[]
    for line in readlines(filename)
        if line[1:4] == "mask"
            mask = collect(line[8:43])
        else
            data = parsemem(line)
            val = reverse(digits(data[:value], base = 2))
            mem[data[:ind]] = applytovalue(mask, vcat(zeros(Int, 36 - length(val)), val))
        end
    end
    values(mem) |> sum
end

function applytoaddress(mask, addr)
    indices = Int[0]
    for (m,v) in zip(mask, addr)
        new_indices = Int[]
        for ind in indices
            if m == '0'
                push!(new_indices, ind * 2 + v)
            elseif m == '1'
                push!(new_indices, ind * 2 + 1)
            else
                push!(new_indices, ind * 2)
                push!(new_indices, ind * 2 + 1)
            end
        end
        indices = copy(new_indices)
    end
    indices
end

function day14b(filename)
    mem = Dict{Int,Int}()
    mask = Char[]
    for line in readlines(filename)
        if line[1:4] == "mask"
            mask = collect(line[8:43])
        else
            data = parsemem(line)
            addr = reverse(digits(data[:ind], base = 2))
            indices = applytoaddress(mask, vcat(zeros(Int, 36 - length(addr)), addr))
            for ind in indices
                mem[ind] = data[:value]
            end
        end
    end
    values(mem) |> sum
end

end
