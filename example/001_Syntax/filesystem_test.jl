using Test

function current_folder()
    cd("c:\\")
    @test pwd() == "c:\\"
end

function test_readdir()
    for folder in readdir("c:\\windows")
        println(folder)
    end
end

function test_walkdir()
    for (root, dirs, files) in walkdir(".")
            println(">> $(root)")
            
            for dir in dirs
                println("[$(dir)]")
            end
            
            for file in files
                println("- $(file)")
            end
    end
end


const folder1 = "c:\\a\\b"
mkpath(folder1)
dump(stat(folder1))
@test isdir(folder1)
@test !isfile(folder1)
rm(folder1, recursive=true)

try
    mkdir("arick")
catch SystemError

end    
dump(stat("arick"))
rm("arick", recursive=true)


cp(PROGRAM_FILE, ".\\a.jl")
mv(".\\a.jl", ".\\a-1.jl")
rm(".\\a-1.jl")

write("a.txt", "hello file")
download("https://httpbin.org/image/jpeg", "a.jpg")        

touch("a.1")
stat("a.1")
rm("a.1")

println(homedir())
println(tempdir())
@test dirname("c:\\windows\\system32\\driver") == "c:\\windows\\system32"
@test basename("c:\\windows\\system32\\driver") == "driver"
@test basename("c:\\windows\\system32\\driver.ini") == "driver.ini"
println(@__DIR__)
println(@__FILE__)
println(@__LINE__)

@test joinpath("c:\\windows", "system.ini") == "c:\\windows\\system.ini"

println(abspath("."))

dump(splitdir("c:\\windows\\system32\\driver"))
dump(splitdrive("c:\\windows\\system32\\driver"))
dump(splitext("c:\\windows\\system32\\driver.ini"))
# println(mktemp(tempdir()))
