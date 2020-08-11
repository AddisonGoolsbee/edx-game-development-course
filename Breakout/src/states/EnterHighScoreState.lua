EnterHighScoreState = Class{__includes = BaseState}

chars = {
	[1] = 65,
	[2] = 65,
	[3] = 65

}

highlighted = 1

function EnterHighScoreState:enter(params)
	self.highScores = params.highScores
	self.score = params.score
	self.scoreIndex = params.scoreIndex
end

function EnterHighScoreState:update(dt)
	if love.keyboard.wasPressed('return') then

		local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

		for i = 10, self.scoreIndex, -1 do
			self.highScores[i+1] = {
				name = self.highScores[i].name,
				score = self.highScores[i].score
			}
		end

		self.highScores[self.scoreIndex].name = name
		self.highScores[self.scoreIndex].score = self.score

		scoreStr = ''

		for i = 1, 10 do
			scoreStr = scoreStr .. self.highScores[i].name .. '\n'
			scoreStr = scoreStr .. tostring(self.highScores[i].score) .. '\n'
		end

		love.filesystem.write('breakout.lst', scoreStr)

		gStateMachine:change('highscore', {
			highScores = self.highScores
		})
	end

	if love.keyboard.wasPressed('left') and highlighted > 1 then
		highlighted = highlighted - 1
		gSounds['select']:play()
	elseif love.keyboard.wasPressed('right') and highlighted < 3 then
		gSounds['select']:play()
		highlighted = highlighted + 1
	end

	if love.keyboard.wasPressed('up') then
		if chars[highlighted] >= 90 then
			chars[highlighted] = 65
		else
			chars[highlighted] = chars[highlighted] + 1
		end
	elseif love.keyboard.wasPressed('down') then
		if chars[highlighted] <= 65 then
			chars[highlighted] = 90
		else
			chars[highlighted] = chars[highlighted] - 1
		end
	end
end

function EnterHighScoreState:render()
	love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(100, 100, 150, 255)
    if highlighted == 1 then
        love.graphics.setColor(255, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(100, 100, 150, 255)

    if highlighted == 2 then
        love.graphics.setColor(255, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(100, 100, 150, 255)

    if highlighted == 3 then
        love.graphics.setColor(255, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
end