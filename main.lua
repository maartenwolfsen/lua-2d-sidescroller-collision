require "Colliders"

local TICKRATE = 1/144

function love.load()
	player = {
		x = 100,
		y = 100,
		w = 50,
		h = 50,
		speed = 4,
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

	-- BORDERS
	Colliders.add({
		x = 0,
		y = 0,
		w = 800,
		h = 20
	})
	Colliders.add({
		x = 780,
		y = 0,
		w = 20,
		h = 800
	})
	Colliders.add({
		x = 0,
		y = 580,
		w = 800,
		h = 20
	})
	Colliders.add({
		x = 0,
		y = 0,
		w = 20,
		h = 800
	})

	Colliders.add({
		x = 200,
		y = 400,
		w = 200,
		h = 200
	})

	Colliders.add({
		x = 400,
		y = 450,
		w = 200,
		h = 50
	})
	Colliders.add({
		x = 250,
		y = 100,
		w = 200,
		h = 20
	})
	Colliders.add({
		x = 250,
		y = 100,
		w = 20,
		h = 150
	})
	Colliders.add({
		x = 600,
		y = 150,
		w = 200,
		h = 10
	})

	w, h = love.graphics.getDimensions()
end

function love.draw()
	for index, platform in pairs(Colliders.objects) do
		love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
	end

	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
	love.graphics.setColor(255, 255, 255)

	love.graphics.print(tostring(player.velocity.grounded), 30, 30)
	love.graphics.print(tostring(player.velocity.y), 30, 50)

	if Colliders.isColliding("top", player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", player.x, player.y, player.w, 5)
		love.graphics.setColor(255, 255, 255)
	end

	if Colliders.isColliding("bottom", player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", player.x, player.y + player.h - 5, player.w, 5)
		love.graphics.setColor(255, 255, 255)
	end

	if Colliders.isColliding("left", player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", player.x, player.y, 5, player.h)
		love.graphics.setColor(255, 255, 255)
	end

	if Colliders.isColliding("right", player) ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", player.x + player.w - 5, player.y, 5, player.h)
		love.graphics.setColor(255, 255, 255)
	end

	love.graphics.print(tostring(player.x), player.x + 5, player.y + 5)
	love.graphics.print(tostring(player.y), player.x + 5, player.y + 20)
end

function love.update()
	-- PLAYER MOVEMENT
	local colliderT = Colliders.isColliding("top", player)
	local colliderR = Colliders.isColliding("right", player)
	local colliderB = Colliders.isColliding("bottom", player)
	local colliderL = Colliders.isColliding("left", player)

	if colliderB then
		player.velocity.x = 0
	end

	player.velocity.grounded = false
	player.velocity.walled = false

	if colliderT and player.velocity.y < 0 then
		player.y = colliderT.y + colliderT.h
		player.velocity.y = 0
	end

	if colliderB and player.velocity.y >= 0 then
		player.velocity.grounded = true
		player.velocity.y = 0
		player.y = colliderB.y - player.h
	else
		local falling_speed = player.velocity.gravity
		local falling_drag = player.velocity.drag

		if colliderL or colliderR then
			player.velocity.walled = true

			if player.velocity.y >= 0 then
				falling_speed = falling_speed / 10
				falling_drag = falling_drag
			end
		end

		player.velocity.y = player.velocity.y + falling_speed

		if player.velocity.y > falling_drag then
			player.velocity.y = falling_drag
		end
	end

	-- WALKING
	if love.keyboard.isDown("a") then
		if not player.velocity.walled then
			player.velocity.x = -player.speed
		end
	end

	if colliderL ~= nil then
		if player.velocity.x < 0 then
			player.velocity.x = 0
		end

		player.x = colliderL.x + colliderL.w
	end

	if love.keyboard.isDown("d") then
		if not player.velocity.walled then
			player.velocity.x = player.speed
		end
	end

	if colliderR ~= nil then
		if player.velocity.x > 0 then
			player.velocity.x = 0
		end

		player.x = colliderR.x - player.w
	end

	player.x = player.x + player.velocity.x
	player.y = player.y + player.velocity.y
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if key == "w" then
		if Colliders.isColliding("top", player) then
			return
		end

		if player.velocity.grounded then
			player.velocity.y = -player.velocity.jump_force
		end

		if player.velocity.walled and not player.velocity.grounded and player.velocity.y > 0 then
			player.velocity.y = -player.velocity.jump_force

			local colliderL = Colliders.isColliding("left", player)
			local colliderR = Colliders.isColliding("right", player)
			
			if colliderL then
				player.velocity.x = player.velocity.jump_force
			elseif colliderR then
				player.velocity.x = -player.velocity.jump_force
			end
		end

		player.y = player.y + player.velocity.y
	end
end

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end
 
    if love.load then love.load(arg) end
 
    local previous = love.timer.getTime()
    local lag = 0.0
    while true do
        local current = love.timer.getTime()
        local elapsed = current - previous
        previous = current
        lag = lag + elapsed
 
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end
 
        while lag >= TICKRATE do
            if love.update then love.update(TICKRATE) end
            lag = lag - TICKRATE
        end
 
        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw(lag / TICKRATE) end
            love.graphics.present()
        end
    end
end
