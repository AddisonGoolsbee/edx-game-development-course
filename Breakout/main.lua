require 'src/Dependencies'



function love.load()
	love.window.setTitle('Breakout')
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')

	gFonts = {
		['small'] = love.graphics.newFont('fonts/font.ttf', 8),
		['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
		['large'] = love.graphics.newFont('fonts/font.ttf', 32)
	}
	love.graphics.setFont(gFonts['small'])

	gTextures = {
		['background'] = love.graphics.newImage('graphics/background.png'),
		['main'] = love.graphics.newImage('graphics/breakout.png'),
		['arrows'] = love.graphics.newImage('graphics/arrows.png'),
		['hearts'] = love.graphics.newImage('graphics/hearts.png'),
		['particle'] = love.graphics.newImage('graphics/particle.png')
	}

	gFrames = {
		['paddles'] = generateQuadsPaddles(gTextures['main']),
		['balls'] = generateQuadsBalls(gTextures['main']),
		['bricks'] = generateQuadsBricks(gTextures['main']),
		['hearts'] = generateQuads(gTextures['hearts'], 10, 9),
		['arrows'] = generateQuads(gTextures['arrows'], 24, 24),
		['powerups'] = table.slice(generateQuads(gTextures['main'], 16, 16), 153)
	}

	gSounds = {
		['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav'),
        ['score'] = love.audio.newSource('sounds/score.wav'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav'),
        ['select'] = love.audio.newSource('sounds/select.wav'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav'),
        ['victory'] = love.audio.newSource('sounds/victory.wav'),
        ['recover'] = love.audio.newSource('sounds/recover.wav'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav'),
        ['pause'] = love.audio.newSource('sounds/pause.wav'),

        ['music'] = love.audio.newSource('sounds/music.wav')
	}

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

	

	gStateMachine = StateMachine {
		['start'] = function() return StartState() end,
		['play'] = function() return PlayState() end,
		['serve'] = function() return ServeState() end,
		['end'] = function() return GameOverState() end,
		['victory'] = function() return VictoryState() end,
		['highscore'] = function() return HighScoreState() end,
		['enterhighscore'] = function() return EnterHighScoreState() end,
		['paddle'] = function() return PaddleSelectState() end
	}
	gSounds['music']:play()
    gSounds['music']:setLooping(true)

	gStateMachine:change('start', {
		highScores = loadHighScores()
	})

	love.keyboard.keysPressed = {}

end

function love.update(dt)

	gStateMachine:update(dt)

	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
	push:resize(w,h)
end

function love.draw()
	push:start()

	local backgroundWidth = gTextures['background']:getWidth()
	local backgroundHeight = gTextures['background']:getHeight()

	love.graphics.draw(gTextures['background'], 0, 0, 0, 
		VIRTUAL_WIDTH/(backgroundWidth-1), VIRTUAL_HEIGHT/(backgroundHeight-1))

	gStateMachine:render()

	displayFPS()

	push:finish()
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function renderHealth(health)
	local healthX = VIRTUAL_WIDTH - 100
    
    -- render health left
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
	love.graphics.setFont(gFonts['small'])
	love.graphics.print('Score:', VIRTUAL_WIDTH-60, 5)
	love.graphics.printf(tostring(score), VIRTUAL_WIDTH-50, 5, 40, 'right')
end

function loadHighScores()
	love.filesystem.setIdentity('breakout')

	if not love.filesystem.exists('breakout.lst') then
		local scores = ''
		for i = 10, 1, -1 do
			scores = scores .. 'AAA\n'
			scores = scores .. tostring(i*1000) .. '\n'
		end

		love.filesystem.write('breakout.lst', scores)
	end

	name = true
	counter = 1

	scores = {}

	for i = 1, 10 do
		scores[i] = {
			name = nil,
			score = nil
		}
	end

	for line in love.filesystem.lines('breakout.lst') do
		if name then
			scores[counter].name = string.sub(line, 1, 3)
		else
			scores[counter].score = tonumber(line)
			counter = counter+1
		end
		name = not name
	end
	return scores
end

function displayFPS()
	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(0,255,0,255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
	love.graphics.setColor(255,255,255,255)
end

