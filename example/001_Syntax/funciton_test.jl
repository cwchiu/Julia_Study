using Test

function add(x,y)
   x + y
end

add2(a,b) = a+b

# 明確指定返回型別
function add3(a, b)::Int8
    return a+b
end


function f2()
    return 3,4
end

function f3()
    return (a=3,b=4)
end


function f4((a,b))
    return a+b
end
    

function f5(a,b=1)
    return a+b
end


Test.@testset "Test" begin
    Test.@testset "Basic Test" begin
        Test.@test (add(3,4) == 7)
        Test.@test (add2(3,4) == 7)
        Test.@test (add3(3,4) == 7)
        Test.@test (typeof(add3(3,4)) == Int8)
    end
    
    Test.@testset "匿名函數" begin
        ret1 = map(round, [1.2,3.5,1.7])

        Test.@test (ret1 == [1,4,2])
        
        ret2 = map(x -> x^2, [1,3,-1])
        Test.@test (ret2 == [1,9,1])
    end
    
    Test.@testset "Return Tuple" begin
        f2_a, f2_b = f2()
        Test.@test(f2_a == 3)
        Test.@test(f2_b == 4)
        
        f3_ret = f3()
        Test.@test(f3_ret.a == 3)
        Test.@test(f3_ret.b == 4)
    end
    
    Test.@testset "Argument destructuring" begin
        Test.@test( f4( (3,4) ) == 7 )
    end
    

    Test.@testset "Optional Arguments" begin
        Test.@test(f5(3) == 4)
    end
    
    Test.@testset "Do-Block Syntax for Function Arguments" begin
            
        ret1 = map(x->begin
                   if x < 0 && iseven(x)
                       return 0
                   elseif x == 0
                       return 1
                   else
                       return x
                   end
                end,
            [0, 100, -100, -3, 3])
        Test.@test ret1==[1,100,0,-3, 3]
            
        ret2 = map([0, 100, -100, -3, 3]) do x
            if x < 0 && iseven(x)
                return 0
            elseif x == 0
                return 1
            else
                return x
            end
        end
        
        Test.@test ret2 == [1,100,0,-3,3]
    end
    
    Test.@testset "Dot Syntax for Vectorizing Functions" begin
            
        ret1 = round.(sin.([1.0, 2.0, 3.0]) )
        
        Test.@test ret1 == [1,1,0]

        f(x,y) = 3x + 4y;

        A = [1, 2, 3]
        B = [4, 5, 6]
        ret2 = f.(A, B) 
        Test.@test ret2 == [19,26,33]
        
    end
    
    Test.@testset "Varargs Functions" begin

        bar(a,b,x...) = (a,b,x)
        ret1 = bar(1,2)
        Test.@test ret1[1] == 1
        Test.@test ret1[2] == 2
        Test.@test ret1[3] == ()
        
        ret2 = bar(1,2,3)
        
        Test.@test ret2[1] == 1
        Test.@test ret2[2] == 2
        Test.@test ret2[3] == (3,)
        
        ret3 = bar(1,2,3,4)
        
        Test.@test ret3[1] == 1
        Test.@test ret3[2] == 2
        Test.@test ret3[3] == (3,4,)
        
        x1 = [1,2,3,4]
        ret4 = bar(x1...)
        
        Test.@test ret4[1] == 1
        Test.@test ret4[2] == 2
        Test.@test ret4[3] == (3,4,)
    end

end


