re1 = r"^\s*(?:#|$)"
println( typeof(re1) )

# regex 檢測規則
println(occursin(r"^\s*(?:#|$)", "# a comment"))

m = match(r"^\s*(?:#|$)", "# a comment")
if m === nothing
    println("not a comment")
else
    println("blank or comment")
end

m2 = match(r"[0-9]","aaaa1aaaa2aaaa3",6)

m3 = match(r"(a|b)(c)?(d)", "acd")
println(m3.match)
println(m3.captures)
println(m3.offset)
println(m3.offsets)

# 字串取代
println(replace("first second", r"(\w+) (?<agroup>\w+)" => s"\g<agroup> \1"))
println(replace("a", r"." => s"\g<0>1"))