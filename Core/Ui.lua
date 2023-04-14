require "const"
require "Core/Map"
Ui = {
	objects = Map.getObjects(),
	inspector = {
		edit = false,
		selected_object = {
			name = "None"
		}
	}
}

Ui.load = function()
end

Ui.update = function()
end

Ui.draw = function()
	if MODE == MODE_EDITOR then
		-- OBJECTS
		love.graphics.rectangle("line", WINDOW.w - 400, 0, 400, WINDOW.h)
		love.graphics.print("Objects", WINDOW.w - 380, 20)
		love.graphics.line(WINDOW.w - 380, 40, WINDOW.w - 20, 40)
		local i = 1

		for index, object in pairs(Ui.objects) do
			love.graphics.print(index, WINDOW.w - 380, 40 + 20 * i)
			i = i + 1
		end

		-- COMPONENTS
		love.graphics.rectangle("line", WINDOW.w - 800, 0, 400, WINDOW.h)
		love.graphics.print("Selected component:", WINDOW.w - 780, 20)
		love.graphics.print(Ui.inspector.selected_object.name, WINDOW.w - 640, 20)
		love.graphics.line(WINDOW.w - 780, 40, WINDOW.w - 420, 40)

		if Ui.inspector.selected_object.name ~= "None" then
			local i = 1

			for index, component in pairs(Ui.inspector.selected_object.components) do
				love.graphics.print(index, WINDOW.w - 780, 40 + 20 * i)
				i = i + 1

				for index, property in pairs(component) do
					love.graphics.print(index .. ": " .. property, WINDOW.w - 740, 40 + 20 * i)
					i = i + 1
				end
			end
		end

		-- EDIT
		love.graphics.rectangle("line", WINDOW.w - 800, WINDOW.h - 100, 400, 100)
		love.graphics.print("Edit value: ", WINDOW.w - 780, WINDOW.h - 80)
	end

	local mX, mY = love.mouse.getPosition()
	if mX <= EDITOR.w and mY <= EDITOR.h then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", mX - 2, mY - 22, 4, 20)
		love.graphics.rectangle("fill", mX - 2, mY + 2, 4, 20)
		love.graphics.rectangle("fill", mX - 22, mY - 2, 20, 4)
		love.graphics.rectangle("fill", mX + 2, mY - 2, 20, 4)
		love.graphics.setColor(255, 255, 255)
	end
end

Ui.mousePress = function(x, y, button)
	local i = 1
	for index, object in pairs(Ui.objects) do
		local ox = WINDOW.w - 380
		local oy = 40 + 20 * i

		if x > ox and x < ox + 340 and y > oy and y < oy + 20 then
			Ui.inspector.selected_object = object
			Ui.inspector.selected_object.name = index
		end

		i = i + 1
	end
end
