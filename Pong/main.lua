push = require 'push'
Class = require 'class'
require 'Ball'
require 'Paddle'

wwidth = 1280
wheight = 720

vwidth = 432
vheight = 243

pspeed = 200

function love.load()
	love.window.setTitle('Pong')
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	font1 = love.graphics.newFont('font.ttf',8)
	font2 = love.graphics.newFont('font.ttf',32)
	font3 = love.graphics.newFont('font.ttf',16)
	--love.graphics.setFont(font1)

	sounds = {['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'), ['score'] = love.audio.newSource('sounds/score.wav', 'static'), ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')}

	push:setupScreen(vwidth,vheight,wwidth,wheight,{
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	b = Ball(vwidth/2-2,vheight/2-2,4)
	b:render()

	p1 = Paddle(5,vheight/2,5,20)
	p2 = Paddle(vwidth-10,vheight/2,5,20)
	p1score = 0
	p2score = 0
	server = math.random(1,2)
	winner = 0

	gameState = 'start'	
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.update(dt)
	if gameState == 'serve' then
		b.dy = math.random(-50, 50)
		if server == 1 then
			b.dx = math.random(140, 200)
		else
			b.dx = math.random(-200, -140)
		end
	elseif gameState == 'play' then
		if b:collides(p1) then
			b.dx = -b.dx*1.05
			b.x = p1.x+5
			if b.dy < 0 then
                b.dy = -math.random(20, 150)
            else
                b.dy = math.random(20, 150)
            end
			sounds['paddle_hit']:play()
		elseif b:collides(p2) then
			b.dx = -b.dx*1.05
			b.x = p2.x-4
			if b.dy < 0 then
                b.dy = -math.random(20, 150)
            else
                b.dy = math.random(20, 150)
            end
			sounds['paddle_hit']:play()
		end

		if b.y <= 0 or b.y+b.size >= vheight then
			b.dy = -b.dy
			sounds['wall_hit']:play()
		end

		if b.x<0 then
			p2score = p2score + 1
			gameState = 'serve'
			b.x = vwidth/2-b.size/2
			b.y = vheight/2-b.size/2
			sounds['score']:play()
			server = 1
		elseif b.x+b.size>vwidth then
			p1score = p1score + 1
			gameState = 'serve'
			b.x = vwidth/2-b.size/2
			b.y = vheight/2-b.size/2
			sounds['score']:play()
			server = 2
		end

		if p1score == 10 then
			winner = 1
			gameState = 'done'
		elseif p2score == 10 then
			winner = 2
			gameState = 'done'
		end

		b:update(dt)
	end



	if love.keyboard.isDown('w') then
		p1.dy = -pspeed
	elseif love.keyboard.isDown('s') then
		p1.dy = pspeed
	else
		p1.dy = 0
	end

	if love.keyboard.isDown('up') then
		p2.dy = -pspeed
	elseif love.keyboard.isDown('down') then
		p2.dy = pspeed
	else
		p2.dy = 0
	end

	p1:update(dt)
	p2:update(dt)
end

function love.keypressed(key)
	if key=='escape' then
		love.event.quit()
	elseif key=='enter' or key=='return' then
		if gameState=='play' then
			
		elseif gameState=='start' then
			gameState='serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		else -- done
			gameState = 'serve'
			p1score = 0
			p2score = 0
			b.x = vwidth/2 - (b.size/2)
			b.y = vheight/2 - (b.size/2)
		end
	end
end

function love.draw()
	push:apply('start')
	--love.graphics.clear(40,45,52,255)
	--gameStates: start, serve, play, done
	if gameState == 'start' then
		love.graphics.setFont(font1)
		love.graphics.printf('PONG', 0, 10, vwidth, 'center')
		love.graphics.printf('Press Enter to Start', 0, 20, vwidth, 'center')
	elseif gameState == 'serve' then
		love.graphics.setFont(font1)
		love.graphics.printf('Press Enter to Serve', 0, 20, vwidth, 'center')
	elseif gameState == 'done' then
		love.graphics.setFont(font3)
		love.graphics.printf('Player'..tostring(winner)..' Wins!', 0, vheight/2, vwidth, 'center')
		love.graphics.setFont(font1)
		love.graphics.printf('Press Enter to Play Again', 0, 20, vwidth, 'center')
	end

	displayScore()
	p1:render()
	p2:render()
	b:render()

	push:apply('end')
end

function displayScore()
	love.graphics.setFont(font2)
	love.graphics.print(tostring(p1score), vwidth/2-75, 25)
	love.graphics.print(tostring(p2score), vwidth/2+55, 25)
end