module Day8

export day8a, day8b

using CombinedParsers
import CombinedParsers.Regexp: word, whitespace_maybe

mutable struct Instruction
    instr::String
    value::Int
end

Instruction(t::NamedTuple{(:instr,:value), Tuple{String,Int}}) =
    Instruction(t[:instr], t[:value])

function parseline(str)
    instruction = Sequence(2, CombinedParsers.Regexp.whitespace_maybe, CombinedParsers.Regexp.word, CombinedParsers.Regexp.whitespace_maybe)

    line = Sequence(:instr => instruction, :value => Numeric(Int), CombinedParsers.Regexp.whitespace_maybe)

    str |> line
end

function day8a(filename)
    code = Vector{NamedTuple{(:instr,:value),Tuple{String,Int}}}()
    for line in readlines(filename)
        push!(code, parseline(line)) 
    end
    visited_lines = Set{Int}()
    current_line = 1
    acc = 0
    while !in(current_line, visited_lines)
        t = code[current_line]
        push!(visited_lines, current_line)
        if t[:instr] == "nop"
            current_line += 1
        elseif t[:instr] == "acc"
            current_line += 1
            acc += t[:value]
        elseif t[:instr] == "jmp"
            current_line += t[:value]
        else
            println("Unknown instruction!")
        end
    end
    acc        
end

function day8b(filename)
    code = Vector{Instruction}()
    for line in readlines(filename)
        t::NamedTuple{(:instr, :value), Tuple{String, Int}} = parseline(line)
        push!(code, Instruction(t)) 
    end

    for i in initrun(code)
        if code[i].instr == "acc"
            continue
        elseif code[i].instr == "jmp"
            code[i].instr = "nop"
            val = runcode(code)
            if !isnothing(val)
                return val
            else
                code[i].instr = "jmp"
            end
        else
            code[i].instr = "jmp"
            val = runcode(code)
            if !isnothing(val)
                return val
            else
                code[i].instr = "nop"
            end
        end
    end    
end

function runcode(code)
    visited_lines = Set{Int}()
    current_line = 1
    last_line = length(code)
    acc = 0
    while !in(current_line, visited_lines)
        t = code[current_line]
        push!(visited_lines, current_line)
        if t.instr == "nop"
            current_line += 1
        elseif t.instr == "acc"
            current_line += 1
            acc += t.value
        elseif t.instr == "jmp"
            current_line += t.value
        else
            println("Unknown instruction!")
        end
        if current_line > last_line
            return acc
        end
    end
    return nothing
end

function initrun(code)
    visited_lines = Set{Int}()
    current_line = 1
    last_line = length(code)
    acc = 0
    while !in(current_line, visited_lines)
        t = code[current_line]
        push!(visited_lines, current_line)
        if t.instr == "nop"
            current_line += 1
        elseif t.instr == "acc"
            current_line += 1
            acc += t.value
        elseif t.instr == "jmp"
            current_line += t.value
        else
            println("Unknown instruction!")
        end
    end
    return visited_lines 
end

end
