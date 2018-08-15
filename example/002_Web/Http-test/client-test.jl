using Pkg
Pkg.activate(".")

using HTTP

function http_get()
    r = HTTP.request("GET", "https://httpbin.org/get?name=arick")
    println(r.status)
    println(String(r.body))
end

function json_post()
    r = HTTP.request("POST", "https://httpbin.org/post?name=arick", ["x-name" => "test", "Context-Type" => "application/json"], """{"name":"arick"}""")
    println(r.status)
    println(String(r.body))
end

function xml_post()
    r = HTTP.request("POST", "https://httpbin.org/post?name=arick", ["Context-Type" => "application/xml"], """<xml><name>arick</name></xml>""")
    println(r.status)
    println(String(r.body))
end

function download()
    HTTP.open("GET", "https://httpbin.org/image/svg") do http
        println("#1")
        n = 0
        r = startread(http)
        # l = parse(Int, HTTP.header(r, "Context-Length"))
        open("test.svg", "w") do fout
            while !eof(http)
                bytes = readavailable(http)
                write(fout, bytes)
                # n += length(bytes)
                # println("$(n) bytes $(round(100*n/l))%")
            end
        end
    end
end

open("test.svg", "r") do io
    r = HTTP.request("POST", "https://httpbin.org/post?name=arick", [], io)
    println(r.status)
    println(String(r.body))
end