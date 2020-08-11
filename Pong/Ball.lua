Ball = Class{}

function Ball:init(x,y,size)
	self.x = x
	self.y = y
	self.size = size
	self.dx = 0
	self.dy = 0
end

function Ball:render()
	love.graphics.rectangle('fill',self.x,self.y,self.size,self.size)
end

function Ball:update(dt)
	self.x = self.x+self.dx*dt
	self.y = self.y+self.dy*dt
end

function Ball:collides(paddle)
	if self.x > paddle.x + paddle.w or paddle.x > self.x + self.size then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.h or paddle.y > self.y + self.size then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

