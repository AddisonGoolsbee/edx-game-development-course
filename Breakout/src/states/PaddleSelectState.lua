PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
	self.bricks = params.bricks
	self.highScores = params.highScores
	self.health = params.health
	self.score = params.score
	self.level = params.level
end

function PaddleSelectState:init()
	self.paddleSkin = 1
end

function PaddleSelectState:update(dt)
	if love.keyboard.wasPressed('right') then
		gSounds['select']:play()
		self.paddleSkin = self.paddleSkin == 4 and 1 or self.paddleSkin + 1
	elseif love.keyboard.wasPressed('left') then
		gSounds['select']:play()
		self.paddleSkin = self.paddleSkin == 1 and 4 or self.paddleSkin - 1
	end

	if love.keyboard.wasPressed('return') then
		gStateMachine:change('serve', {
			paddle = Paddle(self.paddleSkin),
			bricks = self.bricks,
			score = self.score,
			health = self.health,
			level = self.level,
			highScores = self.highScores,
			paddleInc = 10000
		})
	end

	if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function PaddleSelectState:render()
	love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your paddle with left and right!", 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("(Press Enter to continue!)", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
        
    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
   
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(255, 255, 255, 255)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(255, 255, 255, 255)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.paddleSkin - 1)],
        VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end
