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
			ceiled = false,
			gravity = 0.25,
			drag = 40,
			jump_force = 11
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
		y = 300,
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
	player.velocity.x = 0

	local colliderB = Colliders.isColliding("bottom", player)
	local colliderT = Colliders.isColliding("top", player)
	player.velocity.grounded = false

	if colliderT and player.velocity.y < 0 then
		player.y = colliderT.y + colliderT.h
		player.velocity.y = 0
	end

	if colliderB and player.velocity.y >= 0 then
		player.velocity.grounded = true
		player.velocity.y = 0
		player.y = colliderB.y - player.h
	else
		player.velocity.y = player.velocity.y + player.velocity.gravity

		if player.velocity.y > player.velocity.drag then
			player.velocity.y = player.velocity.drag
		end
	end

	-- GRAVITY
	if love.keyboard.isDown("a") then
		local collider = Colliders.isColliding("left", player)
		
		if collider ~= nil then
			player.x = collider.x + collider.w
		else
			player.velocity.x = -player.speed
		end
	end

	if love.keyboard.isDown("d") then
		local collider = Colliders.isColliding("right", player)

		if collider ~= nil then
			player.x = collider.x - player.w
		else
			player.velocity.x = player.speed
		end
	end

	-- JUMPING
	if love.keyboard.isDown("w")
		and player.velocity.grounded == true
		and colliderT == nil then
		player.velocity.y = -player.velocity.jump_force
	end

	player.x = player.x + player.velocity.x
	player.y = player.y + player.velocity.y
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
