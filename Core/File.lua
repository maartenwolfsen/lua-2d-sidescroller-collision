File = {}

File.read = function(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    
    f:close()

    return content
end

File.write = function(file, object)
    local f = io.open(file, "w")

    f:write(object)
    f:close()
end
