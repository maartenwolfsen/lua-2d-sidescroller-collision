require "Core/File"
json = require "lib/json/json"

Map = {}

Map.getObjects = function()
	local map = json.decode(File.read("data/map.json"))
	
	return map.main.objects
end
