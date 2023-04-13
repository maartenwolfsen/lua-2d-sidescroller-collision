require "Core"
require "Core/Map"
require "Colliders"

local TICKRATE = 1/144

function love.load()
	player = {
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

	Colliders.load()

	w, h = love.graphics.getDimensions()
end

function love.draw()
	for index, object in pairs(Map.getObjects()) do
		local transform = object.components.transform

		love.graphics.rectangle(
			"fill",
			transform.x,
			transform.y,
			transform.w,
			transform.h
		)
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

	local mX, mY = love.mouse.getPosition()

	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("fill", mX - 2, mY - 22, 4, 20)
	love.graphics.rectangle("fill", mX - 2, mY + 2, 4, 20)
	love.graphics.rectangle("fill", mX - 22, mY - 2, 20, 4)
	love.graphics.rectangle("fill", mX + 2, mY - 2, 20, 4)
	love.graphics.setColor(255, 255, 255)

	if player.hook.shot then
		love.graphics.setColor(255, 255, 0)
		love.graphics.circle("fill", player.hook.x, player.hook.y, player.hook.w)
		love.graphics.setColor(255, 255, 255)
	end

	if player.hook.hooked then
		love.graphics.setColor(255, 255, 0)
		love.graphics.line(player.x + player.w / 2, player.y + player.h / 2, player.hook.hX, player.hook.hY)
		love.graphics.setColor(255, 255, 255)
	end
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

	player.x = math.ceil(player.x + player.velocity.x)
	player.y = math.ceil(player.y + player.velocity.y)

	-- HOOKSHOT
	if player.hook.shot then
		local hookCollider = Colliders.isColliding("full", player.hook)

		if hookCollider then
			player.hook.hX = player.hook.x
			player.hook.hY = player.hook.y
			player.hook.shot = false
			player.hook.hooked = true
		end

		player.hook.x = player.hook.x
            + -math.sin(player.hook.angle)
            * player.hook.speed
        player.hook.y = player.hook.y
            + -math.cos(player.hook.angle)
            * player.hook.speed
	end

	if love.keyboard.isDown("e") and player.hook.hooked then
		player.x = player.x
            + -math.sin(Core.getAngleOfTwoPoints(
            	{
	            	x = player.x,
	            	y = player.y
            	},
            	{
            		x = player.hook.x,
            		y = player.hook.y
            	}
        	))
            * player.speed
        player.y = player.y
            + -math.cos(Core.getAngleOfTwoPoints(
            	{
	            	x = player.x,
	            	y = player.y
            	},
            	{
            		x = player.hook.x,
            		y = player.hook.y
            	}
        	))
            * player.speed
	end
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

	if key == "q" then
		player.hook.hooked = false
	end
end

function love.mousepressed(x, y, button)
	if button == 1 and not player.hook.shot then
		player.hook.x = player.x + player.w / 2
		player.hook.y = player.y + player.h / 2
		player.hook.angle = Core.getAngleOfTwoPoints(
			{
				x = player.x,
				y = player.y
			},
			{
				x = x,
				y = y
			}
		)
		player.hook.shot = true
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
