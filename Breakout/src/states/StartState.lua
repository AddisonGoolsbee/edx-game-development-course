StartState = Class{__includes = BaseState}

local startHighlighted = true
keyBlockState = 'gone'

function StartState:enter(params)
	self.highScores = params.highScores
end

function StartState:update(dt)
	if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
		gSounds['paddle-hit']:play()
		startHighlighted = not startHighlighted
	end

	if love.keyboard.wasPressed('return') then
		gSounds['confirm']:play()
		if startHighlighted then
			gStateMachine:change('paddle', {
				bricks = LevelMaker.createMap(1),
				health = 3,
				score = 0,
				level = 1,
				highScores = self.highScores
			})
		else
			gStateMachine:change('highscore', {
				highScores = self.highScores
			})
		end
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

end

function StartState:render()
	love.graphics.setFont(gFonts['large'])
	love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(gFonts['medium'])
	if not startHighlighted then
		love.graphics.setColor(100, 100, 150, 255)
	end
	love.graphics.printf('START', 0, 150, VIRTUAL_WIDTH, 'center')
	love.graphics.setColor(255,255,255,255)
	if startHighlighted then
		love.graphics.setColor(100, 100, 150, 255)
	end
	love.graphics.printf('HIGH SCORES', 0, 170, VIRTUAL_WIDTH, 'center')

	love.graphics.setColor(255,255,255,255)
end