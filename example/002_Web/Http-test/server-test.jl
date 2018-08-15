using Pkg
Pkg.activate(".")

using HTTP

HTTP.listen(host="0.0.0.0", port=8000) do request::HTTP.Request
    try
        return HTTP.Response("Hello")
    catch e
        return HTTP.Response(404, "Error: $(e)")
    end
end
