using Pkg
Pkg.activate(".")

using CSV
using DataFrames
df = DataFrame(A = 1:4, B = ["M", "F", "F", "M"])

CSV.write("out.csv", df)

println(CSV.read("out.csv"; delim=','))