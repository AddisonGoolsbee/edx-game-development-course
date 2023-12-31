Ball = Class{}

function Ball:init(skin)
	self.size = 8
	self.dx = 0
	self.dy = 0
	self.skin = skin
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	if self.x <= 0 then
		self.x = 0
		self.dx = -self.dx
		gSounds['wall-hit']:play()
	end

	if self.x >= VIRTUAL_WIDTH - self.size then
		self.x = VIRTUAL_WIDTH - self.size
		self.dx = -self.dx
		gSounds['wall-hit']:play()
	end

	if self.y <= 0 then
		self.y = 0
		self.dy = -self.dy
		gSounds['wall-hit']:play()
	end

end

function Ball:render()
	love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin],
        self.x, self.y)
end

function Ball:reset()
	self.x = VIRTUAL_WIDTH/2 - self.size/2
	self.y = VIRTUAL_HEIGHT/2 - self.size/2

	self.dx = 0
	self.dy = 0
end

function Ball:collides(target)
	if self.x > target.x + target.width or target.x > self.x + self.size then
		return false
	end

	if self.y > target.height + target.y or target.y > self.size + self.y then
		return false
	end

	return true
end