local px = 0
local py = 0

local render_offset = 0

local MAP_WIDTH, MAP_HEIGHT, PORT_WIDTH, PORT_HEIGHT, PLAYER_SZ, tide

local hole_d = {}
local hole_s = 0

-- given a point (x, y) on the map, returns if it's visible in the viewport
function visible(x, y)
	if y <= render_offset or y >= render_offset + PORT_HEIGHT then
		return false
	end
	
	return true
end

function love.load(a)
	MAP_WIDTH  = 750
	MAP_HEIGHT = 10000

	PORT_WIDTH  = 750
	PORT_HEIGHT = 800

	PLAYER_SZ = 50

	tide = 10

	-- sand
	love.graphics.setBackgroundColor(194, 178, 128)

	love.keyboard.setKeyRepeat(false)
end

function love.update(dt)
	-- move
	local pv = 100
	if love.keyboard.isDown("w") then
		py = py - pv * dt
	end

	if love.keyboard.isDown("a") then
		px = px - pv * dt
	end

	if love.keyboard.isDown("s") then
		py = py + pv * dt
	end

	if love.keyboard.isDown("d") then
		px = px + pv * dt
	end

	-- dig
	if love.keyboard.isDown("space") then
		hole_s = hole_s + 1
		hole_d[hole_s] = px
		hole_d[hole_s + 0.5] = py
	end

	-- fuck with render_offset
	-- if py is too close to edge, don't do shit
	-- otherwise, make player at center of screen vertically
	if py >= PORT_HEIGHT / 2 and py <= MAP_HEIGHT - PORT_HEIGHT / 2 then
		render_offset = py - PORT_HEIGHT / 2
	end
end

function love.draw()
	-- tide
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle('fill', PORT_WIDTH - tide, 0, tide, PORT_HEIGHT)
	
	-- holes
	love.graphics.setColor(128, 128, 128)
	for i = 1, hole_s do 
		local cx = hole_d[i]
		local cy = hole_d[i + 0.5]
		if visible(cx, cy) or visible(cx + PLAYER_SZ, cy + PLAYER_SZ) then
			love.graphics.rectangle('fill', cx, cy - render_offset, PLAYER_SZ, PLAYER_SZ)
		end
	end

	-- player
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', px, py - render_offset, PLAYER_SZ, PLAYER_SZ)
end
