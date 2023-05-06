require "const"
require "Core/Map"
require "Core/Editor/Ui/Button"
require "Core/Editor/Ui/Input"
require "Core/Editor/Ui/UiGroup"

Ui = {
	objects = Map.getObjects(),
	inspector = {
		ui_objects = {},
		edit = false,
		selected_object = {
			name = "None"
		}
	}
}

Ui.load = function()
	local i = 1

	for index, object in pairs(Ui.objects) do
		local button = Button:new(
			index,
			WINDOW.w - 380,
			20 + 40 * i,
			{
				top = 5,
				right = 20,
				bottom = 5,
				left = 20
			},
			love.math.colorFromBytes(230, 105, 100, 255)
		)

		button:onClick(function()
			Ui.inspector.selected_object = object
			Ui.inspector.selected_object.name = index
			local inspector_i = 1

			for ui_index, o in pairs(Ui.inspector.ui_objects) do
				if o.__name == "UiGroup" then
					table.remove(
						Ui.inspector.ui_objects,
						ui_index
					)
				end
			end
			local margin = 0

			for index, component in pairs(Ui.inspector.selected_object.components) do
				local selected_ui_objects = {}
				local margin_item = margin

				for property, value in pairs(component) do
					table.insert(
						selected_ui_objects,
						Input:new(
							property,
							value,
							WINDOW.w - 740,
							margin_item + 40 + 50 * inspector_i,
							200,
							{
								top = 5,
								right = 10,
								bottom = 5,
								left = 10
							}
						)
					)
					inspector_i = inspector_i + 1
				end

				table.insert(
					Ui.inspector.ui_objects,
					UiGroup:new(
						index,
						selected_ui_objects
					)
				)

				margin = margin + 40
			end
		end)

		table.insert(
			Ui.inspector.ui_objects,
			button
		)

		i = i + 1
	end
end

Ui.update = function()
	local mX, mY = love.mouse.getPosition()

	for i, o in pairs(Ui.inspector.ui_objects) do
		if o.__name == "Button" then
			if mX > o.x and mX < o.x + o.w and mY > o.y
				and mY < o.y + o.h and not o:getHover() then
				o:setHover(true)
			else
				if o:getHover() then
					o:setHover(false)
				end
			end
		end
	end
end

Ui.draw = function()
	if MODE == MODE_EDITOR then
		-- DRAW UI OBJECTS
		for i, o in pairs(Ui.inspector.ui_objects) do
			if o.__name == "UiGroup" then
				local margin = -20

				for i_c, o_c in pairs(o.children) do
					if margin ~= 0 then
						love.graphics.print(
							o.id,
							o_c.x + margin,
							o_c.y + margin
						)
					end

					margin = 0

					o_c:draw()
				end
			else
				o:draw()
			end
		end

		-- OBJECTS
		love.graphics.rectangle("line", WINDOW.w - 400, 0, 400, WINDOW.h)
		love.graphics.print("Objects", WINDOW.w - 380, 20)
		love.graphics.line(WINDOW.w - 380, 40, WINDOW.w - 20, 40)

		-- COMPONENTS
		love.graphics.rectangle("line", WINDOW.w - 800, 0, 400, WINDOW.h)
		love.graphics.print("Selected component:", WINDOW.w - 780, 20)
		love.graphics.print(Ui.inspector.selected_object.name, WINDOW.w - 640, 20)
		love.graphics.line(WINDOW.w - 780, 40, WINDOW.w - 420, 40)

		if Ui.inspector.selected_object.name ~= "None" then
			--[[local i = 1

			for index, component in pairs(Ui.inspector.selected_object.components) do
				love.graphics.print(index, WINDOW.w - 780, 40 + 20 * i)
				i = i + 1

				for index, property in pairs(component) do

					love.graphics.print(index .. ": " .. property, WINDOW.w - 740, 40 + 20 * i)
					i = i + 1
				end
			end]]--
		end

		-- EDIT
		love.graphics.rectangle("line", WINDOW.w - 800, WINDOW.h - 100, 400, 100)
		love.graphics.print("Edit value: ", WINDOW.w - 780, WINDOW.h - 80)
	end

	-- MOUSE CROSSHAIR
	local mX, mY = love.mouse.getPosition()
	love.graphics.print("Mouse: {x: " .. mX .. "; y: " .. mY .. "}", 20, WINDOW.h - 20)
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
	for index, o in pairs(Ui.inspector.ui_objects) do
		if o.__name == "UiGroup" then
			return
		end

		if x > o.x and x < o.x + o.w and y > o.y and y < o.y + o.h then
			o.click()
		end
	end
end
