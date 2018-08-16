fn = PROGRAM_FILE
wordlist = String[]
open(fn) do fin
    for line in eachline(fin)
        words = split(line, r"\W")
        map(w -> push!(wordlist, lowercase(w)), words)
    end
    filter!(!isempty, wordlist)
end
# println(wordlist)
wordcounts = Dict{String,Int64}()
for word in wordlist
    wordcounts[word] = get(wordcounts, word, 0)+1
end
# println(wordcounts)
for word in sort(collect(keys(wordcounts)))
    println("$(word) => $(wordcounts[word])")
end

