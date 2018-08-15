#= 
猜拳遊戲
=#

T = [
0 -1 1;
1 0 -1;
-1 1 0
]

while true
    print("猜拳(1=布, 2=剪刀, 3=石頭, q:離開:")
    s = readline(stdin)
    if lowercase(s) == "q"
        break
    end
    
    x = 0
    try
        x = parse(Int, s)
    catch err
        println("input error")
        continue
    end
    
    if !(1<=x<=3)
        println("input error")
        continue
    end
    
    y = rand([1,2,3])
    result = T[x,y]
    if result == 0
        println("平手")
    elseif result == 1
        println("你贏")
    else 
        println("電腦贏")
    end
end
