Bird = Class{}

gravity = 18

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VW/2-self.width/2
    self.y = VH/2-self.height/2
    self.dy = 0
end

function Bird:collides(pair)
    if self.x + self.width - 2 > pair.pipes['top'].x and self.x < pair.pipes['top'].x+PIPE_WIDTH then
        if self.y < pair.pipes['top'].y + PIPE_HEIGHT or self.y + self.height - 2> pair.pipes['bottom'].y then
            return true
        end 
    end
    return false
end

function Bird:update(dt)
    self.dy = self.dy + gravity * dt
    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end
    self.y = self.y + math.min(self.dy, 100)
end

function Bird:render()
    love.graphics.draw(self.image,self.x,self.y)
end