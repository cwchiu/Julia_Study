using Pkg
Pkg.activate(".")

using IniFile
using Test

function save_ini(fn)
    ini = Inifile()
    set(ini, "arick", "hp", 100)
    set(ini, "arick", "mp", 10)
    
    open(fn, "w") do fout
        write(fout, ini)
    end
end

function load_ini(fn)
    ini = read(Inifile(), fn)
    return (
        hp= parse(Int,get(ini, "arick", "hp", "10")),
        mp= parse(Int,get(ini, "arick", "mp", "1")),
        lv= parse(Int,get(ini, "arick", "lv", "1"))
    )
end

@testset "Test" begin
    fn = "test.ini"
    if  isfile(fn)
        rm(fn)
    end
    
    save_ini(fn)
    @test isfile(fn)
    
    cfg = load_ini("test.ini")
    @test cfg.hp == 100
    @test cfg.mp == 10
    @test cfg.lv == 1
end