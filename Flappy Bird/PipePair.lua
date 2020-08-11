PipePair = Class{}

function PipePair:init(y)
    self.scored = false
    self.remove = false
    self.x = VW+30
    self.y = y
    gapHeight = math.random(75,120)
    self.pipes = {
        ['bottom'] = Pipe(y, 'bottom'),
        ['top'] = Pipe(y-gapHeight-PIPE_HEIGHT, 'top')
    }
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - GROUND_SPEED * dt
        self.pipes['bottom'].x = self.x
        self.pipes['top'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pair in pairs(self.pipes) do
        pair:render()
    end
end