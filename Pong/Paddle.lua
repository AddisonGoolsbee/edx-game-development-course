Paddle = Class{}

function Paddle:init(x,y,w,h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.dy = 0
end

function Paddle:render()
	love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
end

function Paddle:update(dt)
	if self.y < 100 then
		self.y = math.max(0, self.y + self.dy*dt)
	else
		self.y = math.min(vheight-self.h, self.y + self.dy*dt)
	end
end