Colliders = {
	objects = {}
}

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
	else
		error("Direction " + tostring(direction) + " not available.")
	end
end
