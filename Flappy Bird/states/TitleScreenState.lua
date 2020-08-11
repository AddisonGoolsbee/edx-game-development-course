TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('count')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(scoreFont)
    love.graphics.printf('Flappy Bird', 0, 100, VW, 'center')

    love.graphics.setFont(midFont)
    love.graphics.printf('Press Enter to Start', 0, 140, VW, 'center')
end