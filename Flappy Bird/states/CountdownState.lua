CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > 0.75 then
        self.count = self.count-1
        self.timer = self.timer%0.75
    end
    if self.count == 0 then
        gStateMachine:change('play')
    end
end

function CountdownState:render()
    love.graphics.setFont(scoreFont)
    love.graphics.printf(tostring(self.count), 0, VH/2-27, VW, 'center')
end
