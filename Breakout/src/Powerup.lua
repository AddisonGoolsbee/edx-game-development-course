Powerup = Class{}

function Powerup:init(x, y, typePow)
	self.x = x
	self.y = y
	self.size = 16
	-- 1 is multi-ball, 2 is key
	self.typePow = typePow == 'balls' and 1 or 2


end

function Powerup:update(dt)
	self.y = self.y + POWERUP_SPEED * dt
end

function Powerup:render()
	love.graphics.draw(gTextures['main'], gFrames['powerups'][self.typePow],
        self.x, self.y)
end

function Powerup:collides(target)
	if self.x > target.x + target.width or target.x > self.x + self.size then
		return false
	end

	if self.y > target.height + target.y or target.y > self.size + self.y then
		return false
	end

	return true
end