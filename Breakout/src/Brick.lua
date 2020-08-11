Brick = Class{}

particleColors = {
	[1] = {
		['r'] = 99,
		['g'] = 155,
		['b'] = 255
	},
	[2] = {
		['r'] = 106,
		['g'] = 190,
		['b'] = 47
	},
	[3] = {
		['r'] = 217,
		['g'] = 87,
		['b'] = 99
	},
	[4] = {
		['r'] = 215,
		['g'] = 123,
		['b'] = 186
	},
	[5] = {
		['r'] = 251,
		['g'] = 242,
		['b'] = 54
	}
}

function Brick:init(x, y)
	self.x = x
	self.y = y
	self.width = 32
	self.height = 16

	self.color = 1
	self.tier = 0
	self.inPlay = true

	self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
	self.psystem:setParticleLifetime(0.5,1)
	self.psystem:setLinearAcceleration(-15, 0, 15, 50)
	self.psystem:setAreaSpread('normal', 10, 10)
end

function Brick:hit()
	self.psystem:setColors(
		particleColors[self.color].r,
		particleColors[self.color].g,
		particleColors[self.color].b,
		55*(self.tier + 1),
		particleColors[self.color].r,
		particleColors[self.color].g,
		particleColors[self.color].b,
		0)
	self.psystem:emit(64)

	gSounds['brick-hit-2']:stop()
	gSounds['brick-hit-2']:play()

	if self.tier > 0 then
		if self.color > 1 then
			self.color = self.color - 1
		else
			self.color = 5
			self.tier = self.tier - 1
		end
	else
		if self.color > 1 then
			self.color = self.color - 1
		else
			self.inPlay = false
		end
	end

	if not self.inPlay then
		gSounds['brick-hit-1']:stop()
		gSounds['brick-hit-1']:play()
	end
end

function Brick:update(dt)
	self.psystem:update(dt)
end

function Brick:render()
	if self.inPlay then
		love.graphics.draw(gTextures['main'], 
			gFrames['bricks'][(self.color-1) * 4 + self.tier + 1], self.x, self.y)
	end
end

function Brick:renderParticles()
	love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end