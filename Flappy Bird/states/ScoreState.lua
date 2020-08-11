ScoreState = Class{__includes = BaseState}

local BRONZE_MEDAL = love.graphics.newImage('bronze.png')
local SILVER_MEDAL = love.graphics.newImage('silver.png')
local GOLD_MEDAL = love.graphics.newImage('gold.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('count')
    end
end

function ScoreState:render()
    love.graphics.setFont(scoreFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VW, 'center')

    love.graphics.setFont(midFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VW, 'center')

    if self.score>14 then
        love.graphics.draw(GOLD_MEDAL, VW/2-BRONZE_MEDAL:getWidth()/2, 122)
    elseif self.score>9 then
        love.graphics.draw(SILVER_MEDAL, VW/2-BRONZE_MEDAL:getWidth()/2, 122)
    elseif self.score>4 then
        love.graphics.draw(BRONZE_MEDAL, VW/2-BRONZE_MEDAL:getWidth()/2, 122)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 175, VW, 'center')
end