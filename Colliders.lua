require "Core/Map"

Colliders = {
	objects = {}
}

Colliders.load = function()
	for index, object in pairs(Map.getObjects()) do
		local collider = object.components.collider
		local x = collider.x
		local y = collider.y
		local w = collider.w
		local h = collider.h
		
		if collider.x == "origin" then x = object.components.transform.x end
		if collider.y == "origin" then y = object.components.transform.y end
		if collider.w == "origin" then w = object.components.transform.w end
		if collider.h == "origin" then h = object.components.transform.h end

		Colliders.add({
			type = collider.type,
			x = x,
			y = y,
			w = w,
			h = h
		})
	end
end

Colliders.add = function(collider)
	table.insert(
		Colliders.objects,
		collider
	)
end

Colliders.isColliding = function(direction, col1)
	for index, collider in pairs(Colliders.objects) do
		if Colliders.collides(direction, col1, collider) then
			return collider
		end
	end

	return nil
end

Colliders.collides = function(direction, col1, col2)
	if direction == "top" then
		return col1.x + col1.w > col2.x
			and col1.x < col2.x + col2.w
			and col1.y - col1.velocity.jump_force < col2.y + col2.h
			and col1.y > col2.y
	elseif direction == "right" then
		return col1.x + col1.w < col2.x + col2.w
			and col1.x + col1.w + col1.speed > col2.x
			and col1.y + col1.h > col2.y
			and col1.y < col2.y + col2.h
	elseif direction == "bottom" then
		return col1.x + col1.w > col2.x
			and col1.x < col2.x + col2.w
			and col1.y + col1.h + col1.velocity.jump_force > col2.y
			and col1.y + col1.h < col2.y + col2.h
	elseif direction == "left" then
		return col1.x > col2.x
			and col1.x - col1.speed < col2.x + col2.w
			and col1.y + col1.h > col2.y
			and col1.y < col2.y + col2.h
	elseif direction == "full" then
		return col1.x + col1.w > col2.x
			and col1.x < col2.x + col2.w
			and col1.y + col1.h > col2.y
			and col1.y < col2.y + col2.h
	else
		error("Direction " + tostring(direction) + " not available.")
	end
end
