require "const"
require "Core/Math"
require "Core/Editor/Ui"
require "Core/Map"
require "Colliders"
require "Player"

function love.load()
	Colliders.load()
	Ui.load()
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

	Player.draw()
	Ui.draw()
end

function love.update()
	Player.update()
	Ui.update()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if key == "w" then
		if Colliders.isColliding("top", Player) then
			return
		end

		if Player.velocity.grounded then
			Player.velocity.y = -Player.velocity.jump_force
		end

		if Player.velocity.walled and not Player.velocity.grounded and Player.velocity.y > 0 then
			Player.velocity.y = -Player.velocity.jump_force

			local colliderL = Colliders.isColliding("left", Player)
			local colliderR = Colliders.isColliding("right", Player)
			
			if colliderL then
				Player.velocity.x = Player.velocity.jump_force
			elseif colliderR then
				Player.velocity.x = -Player.velocity.jump_force
			end
		end

		Player.y = Player.y + Player.velocity.y
	end

	if key == "q" then
		Player.hook.hooked = false
	end
end

function love.mousepressed(x, y, button)
	Player.mousePress(x, y, button)
	Ui.mousePress(x, y, button)
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
