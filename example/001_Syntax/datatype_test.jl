using Test

# 數值型別
function list_number_type()

    for T in [Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128,Bool,Float16,Float32,Float64]
       println("$(lpad(T,7)): $(lpad(sizeof(T),3))Bits, [$(typemin(T)),$(typemax(T))]")
    end
end


abstract type Animal 

end

struct Dog <: Animal
    name::String
    Dog(name) = new(name)
end

attack(d::Dog, magic_name) = "$(d.name) use $(magic_name)"


struct Point{T}
    x::T
    y::T
end

summary(p::Point{Int}) = "$(p.x)+$(p.y)=$(p.x+p.y)"
summary(p::Point{String}) = "$(p.x) and $(p.y) is string"

const a = 1
@testset "Test" begin
    @testset "bool" begin
        @test true == 1
        @test false == 0
        
        @test (true | true) == true
        @test (false | true) == true
        @test (true | false) == true
        @test (false | false) == false
        
        @test (true & true) == true
        @test (false & true) == false
        @test (true & false) == false
        @test (false & false) == false
    end

    # 類似 NULL
    @testset "missing" begin
        @test (missing + 1) === missing
        @test ("a" * missing) === missing
        @test abs(missing) === missing
        @test (missing == 1) === missing
        @test (missing == missing) === missing
        @test (missing < 1) === missing
        
        @test !(missing === 1)

        @testset "Logical Operations" begin
            @test (true | missing) 
            @test (missing | true) 
            
            @test (false | missing) === missing
            @test (missing | false) === missing
            
            @test (true & missing) === missing
            @test (missing & true) === missing
            
            @test (false & missing) == false
            @test (missing & false) == false
        end
        
        @testset "Short-Circuiting Operations" begin
            @test (true && missing) === missing
            @test (false && missing) == false
            
            @test_throws TypeError (missing || false)
            @test_throws TypeError (missing && false)
        end
        
        @testset "union missing" begin
            f(x::Union{Missing, Int}) = if x === missing 
                0
            else
                x*2
            end
            
            @test f(missing) == 0
            @test f(10) == 20
        end
        
        @testset "skipmissing" begin
            data = [1, missing]
            @test sum(data) === missing
            @test sum(skipmissing(data)) == 1 
        end
        
        @testset "Logical Operations on Arrays" begin
            @test ([1, missing] == [1, missing]) === missing
            @test ([1, missing] == [2, missing]) == false
            @test ([1, 2, missing] == [1, missing, 2]) === missing
        end
        
        @testset "isless" begin
            @test isless(1, missing)
            @test isless(Inf, missing)
            @test !isless(missing, missing)
        end
        
        @testset "isqueal" begin
            @test !(isequal(missing, 1))
            @test isequal(missing, missing)
        
            @test isequal([1, missing], [1, missing])
            @test !isequal([1, 2, missing], [1, missing, 2])
        end
        
        @testset "all" begin
            @test all([true, missing]) === missing
            @test all([false, missing]) == false
        end
        
        @testset "any" begin
            @test any([true, missing]) == true
            @test any([false, missing]) === missing
        end
    end
    
    @testset "struct" begin
        d = Dog("yyy")
        @test d.name == "yyy"
        @test attack(d, "fire") == "yyy use fire"

        p1 = Point(3,4)
        @test summary(p1) == "3+4=7"
        
        p2 = Point("a","b")
        @test summary(p2) == "a and b is string"
    end
    
    @testset "tuple" begin
        t1 = (2,3)
        @test typeof(t1) == Tuple{Int,Int}
        
        @test t1[1] == 2
        @test t1[2] == 3
        
        @test t1[1:2] == (2,3)
        
        (a,b) = t1
        @test a == 2
        @test b == 3
    end
    
    @testset "Dict" begin
        d = Dict("one"=>1, "two" => 2, "three" => 3)
        @test Set(keys(d)) == Set(["one", "two", "three"])
        @test Set(values(d)) == Set([1,2,3])
        @test typeof(d) == Dict{String, Int}
        
        @test d["one"] == 1
        
        d2 = Dict(x => i for (i,x) in enumerate(["one", "two", "three"]))
        @test d2["two"] == 2
        
        
        @test get(d, "two", 99) == 2
        @test get(d, "none", 99) == 99
        
        @test haskey(d, "none") == false
        @test in(("two"=>2), d)
        
        delete!(d, "two")
        @test haskey(d, "two") == false
        
        ret = Set()
        for (key,val) in d
            push!(ret, "$(key):$(val)")
        end
        @test ret == Set(["one:1", "three:3"])
        
        @test merge(Dict("a"=>1, "b"=>2), Dict("b"=>2, "c"=>3)) == Dict("a"=>1, "b"=>2, "c"=>3)
        
    end
    
    @testset "Set" begin
        s1 = Set([1,2,2,3,4])
        @test length(s1) ==4
        
        push!(s1, 4)
        @test length(s1) ==4
        
        push!(s1, 99)
        @test length(s1) ==5
        
        s2 = Set([1,2,100])
        
        @test intersect(s1, s2) == Set([1,2])
        @test intersect(s2, s1) == Set([1,2])
        
        @test setdiff(s1, s2) == Set([3,4,99])
        @test setdiff(s2, s1) == Set([100])
        
        @test union(s1, s2) == Set([1,2,3,4,99,100])
        @test union(s2, s1) == Set([1,2,3,4,99,100])
        
        
    end
    
    @testset "Comprehension" begin
        @test [x for x in 1:3] == [1, 2, 3]
        @test [x*y for x in 1:3, y in 2:3] == [2 3; 4 6; 6 9]
        @test [x for x in 1:4 if x % 2 == 0] == [2, 4]
    end
    
    @testset "Matrix" begin
        @test zeros(Int8, 2, 3) == [0 0 0 ;0 0 0]
        @test ones(Int8, 2, 3) == [1 1 1; 1 1 1]
        @test trues(2, 3) == [true true true; true true true]
        # @test eye(3) == [1 0 0; 0 1 0; 0 0 1]
        
        @test ndims([0 0 0 ;0 0 0]) == 2
        @test size([0 0 0 ;0 0 0]) == (2,3)
        
        @test size(rand(2,3)) == (2,3)
        
        m1 = [
          1 2
          3 4
        ]
        
        @test m1' == [
          1 3
          2 4
        ]
        
        @test typeof(m1) == Array{Int, 2}
        @test typeof(Int64[]) == Array{Int64, 1}
        @test typeof([1,2,3]) == Array{Int,1}
        
        a = [1]
        push!(a, 100)
        @test a[end] == 100
        
        append!(a, 200)
        @test a[end] == 200
        
        @test pop!(a) == 200
        
        @test sort!([3,99,1]) == [1,3,99]
        @test collect(1:3) == [
         1
         2
         3
        ]
        
        m2 = [
          1 2
          3 4
        ]
        m2[2,2]=100
        
        
        @test m2 == [
          1 2 
          3 100
        ]
        
        @test m2.+m2 == [
          2 4
          6 200
        ]
        
        @test m2.*m2 == [
          1 4
          9 10000
        ]
    end
    
    @testset "Complex Number" begin
        v = 3+4im
        # 取實部
        @test 3 == real(v)
        # 取虛部
        @test 4 == imag(v)
        # 取共軛
        @test conj(v) == 3-4im
        # 取幅角
        @test angle(3+3im)/pi*180 == 45.0
        # 取模
        @test 5 == abs(v)
        #println(norm(v))
        
        @test ((1+2im)+(3-4im)) == (4-2im)
        @test ((1+2im)-(3-4im)) == (-2+6im)
        @test ((1+2im)*(3-4im)) == (11+2im)
        # @test ((-4+3im)^(2+1im)) ≈ (1.950+0.651im)
    end

    @testset "data type convert" begin
        @testset "string to number" begin
            @test parse(Int8, "1") == 1
            v = parse(Float64, "3.14")
            @test v >= 3.14 && v<3.15
        end

        @testset "number to string" begin
            @test string(100) == "100"
            @test string(3.14) == "3.14"
        end
    end

    @testset "Rational" begin
        @test typeof(1//2) == Rational{Int}
        @test 2//3 == 2//3
        @test -6//12 == -1//2
        @test 5//-20 == -1//4
        @test 5//0 == 1//0
        r = (2//10)
        @test r.num == 1 
        @test r.den == 5
        
        @test (2//4+1//7) == 9//14
        @test (3//10*6//9) == 1//5
        
        f = float(r)
        @test f == 0.2
    end
    
    @testset "number" begin
        data1 = [1,2,3]
        @test sum(data1) == 6
        @test maximum(data1) == 3
        @test minimum(data1) == 1
    end
end




