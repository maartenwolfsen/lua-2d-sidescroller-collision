Button = {}
Button.__index = Button
Button.__name = "Button"

function Button:new(
	text,
	x,
	y,
	padding,
	color_r,
	color_g,
	color_b,
	color_a
)
	local button = {}

	setmetatable(button, Button)

	button.font = love.graphics.getFont()
	button.x = x
	button.y = y
	button.w = button.font:getWidth(text) + padding.right + padding.left
	button.h = button.font:getHeight(text) + padding.top + padding.bottom
	button.padding = padding
	button.text = text
	button.color = {
		r = color_r,
		g = color_g,
		b = color_b,
		a = color_a
	}
	button.color_hover = {
		r = color_r - 10,
		g = color_g - 10,
		b = color_b - 10,
		a = color_a
	}
	button.current_color = button.color
	button.hover = false

	table.insert(
		Ui,
		button
	)

	return button
end

function Button:getPosition()
	return self.x, self.y
end

function Button:getWidth()
	return self.w
end

function Button:getHeight()
	return self.h
end

function Button:getPadding()
	return self.padding
end

function Button:getText()
	return self.text
end

function Button:getCurrentColor()
	return self.current_color 
end

function Button:getHover()
	return self.hover
end

function Button:setHover(hover)
	self.hover = hover
	local cursor = "arrow"

	if hover then
		cursor = "hand"
	end

    love.mouse.setCursor(love.mouse.getSystemCursor(cursor))
end

function Button:draw()
	local color = self.color

	if self:getHover() then
		color = self.color_hover
	end

	love.graphics.setColor(color.r, color.g, color.b, color.a)
	love.graphics.rectangle(
		"fill",
		self.x,
		self.y,
		self:getWidth(),
		self:getHeight()
	)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(
		self:getText(),
		self.x + self.padding.left,
		self.y + self.padding.top
	)
	love.graphics.setColor(1, 1, 1)
end

function Button:onClick(callback)
	self.click = callback
end

function Button:click()
	self.click()
end
