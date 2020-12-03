module Day2

export day2a, day2b

struct PassWdRules
    range::Tuple{Int,Int}
    ch::Char
    passwd::String
end

function count(char, str)
    counter = 0
    for c in str
        if c == char
            counter += 1
        end
    end
    counter
end

function parse_rule(str)
    v = split(str,' ')
    r = map(t -> parse(Int,t), split(v[1],'-'))            
    PassWdRules(tuple(r...), v[2][1], strip(v[3]))
end

function day2a(filename)
    w = map(parse_rule, readlines(filename))
    counter = 0
    for p in w
        if p.range[1] <= count(p.ch, p.passwd) <= p.range[2]
            counter += 1
        end
    end
    counter
end

function day2b(filename)
    w = map(parse_rule, readlines(filename))
    counter = 0
    for p in w
        if xor(p.passwd[p.range[1]] == p.ch, p.passwd[p.range[2]] == p.ch)
            counter += 1
        end        
    end
    counter
end

end
