VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
	self.paddle = params.paddle
	self.level = params.level
	self.score = params.score
	self.health = params.health
	self.balls = params.balls
	self.highScores = params.highScores
	self.paddleInc = params.paddleInc
end

function VictoryState:update(dt)
	self.paddle:update(dt)

	self.balls[1].x = self.paddle.x + self.paddle.width/2 - self.balls[1].size/2
	self.balls[1].y = self.paddle.y - self.balls[1].size

	if love.keyboard.wasPressed('return') then
		gStateMachine:change('serve', {
			level = self.level + 1,
			paddle = self.paddle,
			health = self.health,
			score = self.score,
			highScores = self.highScores,
			bricks = LevelMaker.createMap(self.level + 1),
			paddleInc = self.paddleInc
		})
	end
end

function VictoryState:render()
	self.paddle:render()
	self.balls[1]:render()
	renderHealth(self.health)
	renderScore(self.score)

	love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end

