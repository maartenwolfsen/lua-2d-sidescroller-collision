File = {}

File.read = function(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    
    f:close()

    return content
end
