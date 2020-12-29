module Day4

export day4

struct Passport
    byr::Union{Int,Nothing}
    iyr::Union{Int,Nothing}
    eyr::Union{Int,Nothing}
    hgt::Union{String,Nothing}
    hcl::Union{String,Nothing}
    ecl::Union{String,Nothing}
    pid::Union{String,Nothing}
    cid::Union{String,Nothing}
end

function read_data(filename)
    data_vec = Vector{String}()
    passports = Vector{Passport}()
    running = ""
    for line in readlines(filename)
        if strip(line) != ""
            running = join([running, strip(line)], ' ')
        elseif strip(running) != ""
                push!(data_vec, strip(running))
                running = ""
        end
    end

    push!(data_vec, strip(running))
    
    for pass_str in data_vec
        data = split(pass_str, ' ')
        byr = nothing
        iyr = nothing
        eyr = nothing
        hgt = nothing
        hcl = nothing
        ecl = nothing
        pid = nothing
        cid = nothing
        for item in data
            if item[1:3] == "byr"
                byr = parse(Int, item[5:end])
            elseif item[1:3] == "iyr"
                iyr = parse(Int, item[5:end])
            elseif item[1:3] == "eyr"
                eyr = parse(Int, item[5:end])
            elseif item[1:3] == "hgt"
                hgt = item[5:end]
            elseif item[1:3] == "hcl"
                hcl = item[5:end]
            elseif item[1:3] == "ecl"
                ecl = item[5:end]
            elseif item[1:3] == "pid"
                pid = item[5:end]
            elseif item[1:3] == "cid"
                cid = item[5:end]
            end
        end
        push!(passports, Passport(byr,iyr,eyr,hgt,hcl,ecl,pid,cid))
    end
    passports
end

function isvalid(pass)
    !isnothing(pass.byr) &&
        !isnothing(pass.iyr) &&
        !isnothing(pass.eyr) &&
        !isnothing(pass.hgt) &&
        !isnothing(pass.hcl) &&
        !isnothing(pass.ecl) &&
        !isnothing(pass.pid)
end

function day4(::Val{:a}, filename)
    passports = read_data(filename)
    count(isvalid, passports)
end

function validyears(pass)
        1920 <= pass.byr <= 2002 &&
        2010 <= pass.iyr <= 2020 &&
        2020 <= pass.eyr <= 2030
end

function valideyecolor(pass)
    pass.ecl == "amb" ||
        pass.ecl == "blu" ||
        pass.ecl == "brn" ||
        pass.ecl == "gry" ||
        pass.ecl == "grn" ||
        pass.ecl == "hzl" ||
        pass.ecl == "oth"
end

function validpid(pass)
    !isnothing(pass.pid) && length(pass.pid) == 9 && count(isdigit, pass.pid) == 9
end

function validhgt(pass)
    if isnothing(pass.hgt) || length(pass.hgt) < 4
        return false
    end
    
    if pass.hgt[end-1:end] == "cm"
        try
            h = parse(Int,pass.hgt[1:end-2])
            return 150 <= h <= 193
        catch ex
            return false
        end        
    elseif pass.hgt[end-1:end] == "in"
        try
            h = parse(Int,pass.hgt[1:end-2])
            return 59 <= h <= 76
        catch ex
            return false
        end 
    else
        false        
    end
end

function validhcl(pass)
    length(pass.hcl) == 7 && pass.hcl[1] == '#' && all(count(isxdigit, pass.hcl[2:end]) == 6)
end

function strictlyvalid(pass)
    isvalid(pass) &&
        validyears(pass) &&
        valideyecolor(pass) &&
        validpid(pass) &&
        validhgt(pass) &&
        validhcl(pass)
end

function day4(::Val{:b}, filename)
    passports = read_data(filename)
    count(strictlyvalid, passports)

end

end
