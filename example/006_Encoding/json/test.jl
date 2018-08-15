using Pkg
Pkg.activate(".")

using JSON
using Test

@testset "Test" begin
    @testset "encode" begin
        ret1 = JSON.json([2,3])
        @test ret1 == "[2,3]"
        
        @test JSON.json(["abc", "def"]) == """["abc","def"]"""
        @test JSON.json(Dict("name"=>"arick", "HP"=>100)) == """{"name":"arick","HP":100}"""
    end
    
    @testset "decode" begin
        @test JSON.parse("""["abc","def"]""") == ["abc", "def"]
        @test JSON.parse("""[2,3]""") == [2,3]
        @test JSON.parse("""{"name":"arick","HP":100}""") == Dict("name"=>"arick", "HP"=>100)
    end
end