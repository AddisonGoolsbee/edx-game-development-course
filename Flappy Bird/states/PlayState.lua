PlayState = Class{__includes = BaseState}

PIPE_IMAGE = love.graphics.newImage('pipe.png')
PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

function PlayState:init()
    self.bird = Bird()
    self.timer = 0
    self.pipePairs = {}
    self.score = 0
    self.gapPosition = math.random(140, 240)
    self.pipeDistance = math.random(2,3)
end

function PlayState:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.pipeDistance then
        table.insert(self.pipePairs, PipePair(self.gapPosition))
        self.timer = self.timer % self.pipeDistance
        self.pipeDistance = math.random(2, 3)
        self.gapPosition = math.min(math.max(self.gapPosition + math.random(-30, 30), 140), 250)
    end

    for k, pair in pairs(self.pipePairs) do 
        if self.bird:collides(pair) then
            scrolling = false
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', {score = self.score})
        elseif not pair.scored then
            if self.bird.x > pair.x + PIPE_WIDTH then
                self.score = self.score + 1
                sounds['score']:play()
                pair.scored = true
            end
        end
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    if self.bird.y > VH - 35 then
        scrolling = false
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', {score = self.score})
    end

    self.bird:update(dt)
end

function PlayState:render()
    self.bird:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    love.graphics.setFont(scoreFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    scrolling = false
end
