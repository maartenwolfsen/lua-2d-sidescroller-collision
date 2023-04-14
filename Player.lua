require "const"

Player = {
	x = 100,
	y = 100,
	w = 50,
	h = 50,
	speed = 4,
	hook = {
		x = 0,
		y = 0,
		w = 5,
		h = 5,
		angle = 0,
		speed = 5,
		shot = false,
		hooked = false,
		hX = 0,
		hY = 0
	},
	velocity = {
		x = 0,
		y = 0,
		grounded = false,
		walled = false,
		gravity = 0.25,
		drag = 10,
		jump_force = 10
	}
}

Player.update = function()
	-- Player MOVEMENT
	local colliderT = Colliders.isColliding("top", Player)
	local colliderR = Colliders.isColliding("right", Player)
	local colliderB = Colliders.isColliding("bottom", Player)
	local colliderL = Colliders.isColliding("left", Player)

	if colliderB then
		Player.velocity.x = 0
	end

	Player.velocity.grounded = false
	Player.velocity.walled = false

	if colliderT and Player.velocity.y < 0 then
		Player.y = colliderT.y + colliderT.h
		Player.velocity.y = 0
	end

	if colliderB and Player.velocity.y >= 0 then
		Player.velocity.grounded = true
		Player.velocity.y = 0
		Player.y = colliderB.y - Player.h
	else
		local falling_speed = Player.velocity.gravity
		local falling_drag = Player.velocity.drag

		if colliderL or colliderR then
			Player.velocity.walled = true

			if Player.velocity.y >= 0 then
				falling_speed = falling_speed / 10
				falling_drag = falling_drag
			end
		end

		Player.velocity.y = Player.velocity.y + falling_speed

		if Player.velocity.y > falling_drag then
			Player.velocity.y = falling_drag
		end
	end

	-- WALKING
	if love.keyboard.isDown("a") then
		if not Player.velocity.walled then
			Player.velocity.x = -Player.speed
		end
	end

	if colliderL ~= nil then
		if Player.velocity.x < 0 then
			Player.velocity.x = 0
		end

		Player.x = colliderL.x + colliderL.w
	end

	if love.keyboard.isDown("d") then
		if not Player.velocity.walled then
			Player.velocity.x = Player.speed
		end
	end

	if colliderR ~= nil then
		if Player.velocity.x > 0 then
			Player.velocity.x = 0
		end

		Player.x = colliderR.x - Player.w
	end

	Player.x = math.ceil(Player.x + Player.velocity.x)
	Player.y = math.ceil(Player.y + Player.velocity.y)

	-- HOOKSHOT
	if Player.hook.shot then
		local hookCollider = Colliders.isColliding("full", Player.hook)

		if hookCollider then
			Player.hook.hX = Player.hook.x
			Player.hook.hY = Player.hook.y
			Player.hook.shot = false
			Player.hook.hooked = true
		end

		Player.hook.x = Player.hook.x
            + -math.sin(Player.hook.angle)
            * Player.hook.speed
        Player.hook.y = Player.hook.y
            + -math.cos(Player.hook.angle)
            * Player.hook.speed
	end

	if Player.hook.hooked and not Player.velocity.grounded then
		Player.x = Player.x
            + -math.sin(Math.getAngleOfTwoPoints(
            	{
	            	x = Player.x,
	            	y = Player.y
            	},
            	{
            		x = Player.hook.x,
            		y = Player.hook.y
            	}
        	))
            * Player.speed
        Player.y = Player.y
            + -math.cos(Math.getAngleOfTwoPoints(
            	{
	            	x = Player.x,
	            	y = Player.y
            	},
            	{
            		x = Player.hook.x,
            		y = Player.hook.y
            	}
        	))
            * Player.speed
	end
end

Player.draw = function()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", Player.x, Player.y, Player.w, Player.h)
	love.graphics.setColor(255, 255, 255)

	love.graphics.print(tostring(Player.velocity.grounded), 30, 30)
	love.graphics.print(tostring(Player.velocity.y), 30, 50)

	if Colliders.isColliding("top", Player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", Player.x, Player.y, Player.w, 5)
		love.graphics.setColor(255, 255, 255)
	end

	if Colliders.isColliding("bottom", Player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", Player.x, Player.y + Player.h - 5, Player.w, 5)
		love.graphics.setColor(255, 255, 255)
	end

	if Colliders.isColliding("left", Player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", Player.x, Player.y, 5, Player.h)
		love.graphics.setColor(255, 255, 255)
	end

	if Colliders.isColliding("right", Player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", Player.x + Player.w - 5, Player.y, 5, Player.h)
		love.graphics.setColor(255, 255, 255)
	end

	love.graphics.print(tostring(Player.x), Player.x + 5, Player.y + 5)
	love.graphics.print(tostring(Player.y), Player.x + 5, Player.y + 20)
	
	if Player.hook.shot then
		love.graphics.setColor(255, 255, 0)
		love.graphics.circle("fill", Player.hook.x, Player.hook.y, Player.hook.w)
		love.graphics.setColor(255, 255, 255)
	end

	if Player.hook.hooked then
		love.graphics.setColor(255, 255, 0)
		love.graphics.line(Player.x + Player.w / 2, Player.y + Player.h / 2, Player.hook.hX, Player.hook.hY)
		love.graphics.setColor(255, 255, 255)
	end
end

Player.mousePress = function(x, y, button)
	if x > EDITOR.w or y > EDITOR.h then
		return
	end

	if button == 1 and not Player.hook.shot then
		Player.hook.x = Player.x + Player.w / 2
		Player.hook.y = Player.y + Player.h / 2
		Player.hook.angle = Math.getAngleOfTwoPoints(
			{
				x = Player.x,
				y = Player.y
			},
			{
				x = x,
				y = y
			}
		)
		Player.hook.shot = true
	end
end
