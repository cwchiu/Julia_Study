for T in [Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128,Bool,Float16,Float32,Float64]
   println("$(lpad(T,7)): $(lpad(sizeof(T),3))Bits, [$(typemin(T)),$(typemax(T))]")
end

print("""
=-=-=-=-=-=-=-=-
Hello
World
=-=-=-=-=-=-=-=-
""")

s = "hello world"
println(s[1])
println(s[end])
println(s[2:4])
println(length(s))

s2 = SubString(s, 1, 5)
println(s2)
println(typeof(s2))
println(length(s2))

for i = firstindex(s):lastindex(s)
   try
       println(s[i])
   catch
       # ignore the index error
   end
end

for c in s
    println(c)
end

foreach(display, s)

display(s)

i1, i2 = 10, 100

s3 = string("hello", " ", "world")
println(s3)

c1 = 'X'
println("c1 = $c1")
println("\$$c1")

println( findfirst(isequal('x'), "xylophone") )
println( findnext(isequal('o'), "xylophone", 1) )

println( occursin("world", "Hello, world.") )
println(repeat(".:Z:.", 10))
println(join(["apples", "bananas", "pineapples"], ", ", " and "))
