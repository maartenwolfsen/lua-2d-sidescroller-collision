require "Core/File"
json = require "lib/json/json"

Map = {}

Map.getObjects = function()
	local map = json.decode(File.read("data/map.json"))
	
	return map.main.objects
end

Map.save = function(objects)
	File.write(
		"data/map.json",
		json.encode(
			{
				main = {
					objects = objects
				}
			}
		)
	)
end
