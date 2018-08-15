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
    
    @testset "Array" begin
        @test zeros(Int8, 2, 3) == [0 0 0 ;0 0 0]
        @test ones(Int8, 2, 3) == [1 1 1; 1 1 1]
        @test trues(2, 3) == [true true true; true true true]
        # @test eye(3) == [1 0 0; 0 1 0; 0 0 1]
        
        @test ndims([0 0 0 ;0 0 0]) == 2
        @test size([0 0 0 ;0 0 0]) == (2,3)
        
        @test size(rand(2,3)) == (2,3)
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
        # string to int
        @test parse(Int8, "1") == 1
        v = parse(Float64, "3.14")
        @test v >= 3.14 && v<3.15
        
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
end




