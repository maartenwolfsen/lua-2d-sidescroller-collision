Input = {}
Input.__index = Input
Button.__name = "Input"

function Input:new(label, value, x, y, w, padding)
	local input = {}

	setmetatable(input, Input)

	input.font = love.graphics.getFont()
	input.x = x
	input.y = y
	input.w = w + padding.left + padding.right
	input.h = input.font:getHeight(value) + padding.top + padding.bottom
	input.padding = padding
	input.label = label
	input.value = value

	table.insert(
		Ui,
		input
	)

	return input
end

function Input:getPosition()
	return self.x, self.y
end

function Input:getWidth()
	return self.w
end

function Input:getHeight()
	return self.h
end

function Input:getPadding()
	return self.padding
end

function Input:getValue()
	return self.value
end

function Input:draw()
	love.graphics.print(
		self.label,
		self.x,
		self.y
	)
	love.graphics.rectangle(
		"line",
		self.x,
		self.y + self.font:getHeight(self.label) + 5,
		self.w,
		self.h
	)
	love.graphics.print(
		tostring(self.value),
		self.x + self.padding.left,
		self.y + self.font:getHeight(self.label) + 5 + self.padding.top
	)
end
