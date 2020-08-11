Pipe = Class{}

function Pipe:init(y, placement)
    self.x = VW+10
    self.y = y
    self.placement = placement
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.placement == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, (self.placement == 'top' and -1 or 1))
end