PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
	self.paddle = params.paddle
	self.health = params.health
	self.score = params.score
	self.bricks = params.bricks
	self.level = params.level
	self.highScores = params.highScores
	self.recoverPoints = 3000
	self.paddleInc = params.paddleInc
	self.extraBalls = math.random(25)
	self.extraBallsCounter = 1
	self.powerup = nil
	self.powerupSpawned = false
	self.key = nil
	self.numBalls = 1
	self.balls = params.balls

	self.balls[1].dx = math.random(-200, 200)
	self.balls[1].dy = math.random(-80, -90)

	if keyExists then
		self.keySpawned = false
		self.keySpawn = math.random(1)
		self.keySpawnCounter = 1
		keyBlockState = 'locked'
	end
end

function PlayState:update(dt)
	if self.paused then
		if love.keyboard.wasPressed('space') then
			self.paused = false
			gSounds['pause']:play()
		else
			return
		end
	elseif love.keyboard.wasPressed('space') then
		self.paused = true
		gSounds['pause']:play()
		return
	end

	self.paddle:update(dt)
	for k, b in pairs(self.balls) do
		b:update(dt)
	end

	if self.powerupSpawned then
		self.powerup:update(dt)
	end

	if self.keySpawned then
		self.key:update(dt)
	end

	for i = 1, #self.balls do
		if self.balls[i]:collides(self.paddle) then
			self.balls[i].y = self.paddle.y-self.balls[i].size
	        self.balls[i].dy = -self.balls[i].dy
	        gSounds['paddle-hit']:play()

	        if self.balls[i].x < self.paddle.x + self.paddle.width/2 and self.paddle.dx < 0 then
	        	self.balls[i].dx = -50 + -(8 * math.abs(self.paddle.x + self.paddle.width/2 - self.balls[i].x))
	        elseif self.balls[i].x > self.paddle.x + self.paddle.width/2 and self.paddle.dx > 0 then
	        	self.balls[i].dx = 50 + 8 * math.abs(self.paddle.x + self.paddle.width/2 - self.balls[i].x)
	        end
	    end
	end

	for i = 1, #self.balls do
	    for k, brick in pairs(self.bricks) do
	    	
			if brick.inPlay and self.balls[i]:collides(brick) then
				if keyBlockState == 'gone' then
					self.score = self.score + brick.tier * 200 + brick.color * 25
					brick:hit()
				elseif brick == self.bricks[keyLoc] then
					if keyBlockState == 'unlocked' then
						self.score = self.score + 2000
						brick.inPlay = false
						gSounds['brick-hit-1']:play()
						keyBlockState = 'gone'
					elseif keyBlockState == 'locked' then
						gSounds['brick-hit-2']:play()
					end
				else
					self.score = self.score + brick.tier * 200 + brick.color * 25
					brick:hit()
				end

				if self.extraBallsCounter == self.extraBalls then
					self.powerup = Powerup(brick.x + brick.width/4, brick.y + brick.height/4, 'balls')
					self.powerupSpawned = true
				end

				self.extraBallsCounter = self.extraBallsCounter + 1

				if keyBlockState == 'locked' and keyExists then
					if self.keySpawnCounter == self.keySpawn then
						self.key = Powerup(brick.x + brick.width/4, brick.y + brick.height/4, 'key')
						self.keySpawned = true
					end
					self.keySpawnCounter = self.keySpawnCounter + 1
				end


				self.extraBallsCounter = self.extraBallsCounter + 1

				if self.score > self.recoverPoints then
	                self.health = math.min(3, self.health + 1)
	                self.recoverPoints = math.min(100000, self.recoverPoints * 2)
	                self.recoverPoints = self.recoverPoints*2
	                gSounds['recover']:play()
	            end

	            if self.score > self.paddleInc then
	            	self.paddle:changeSize(true)
	            	self.paddleInc = self.paddleInc * 2
	            end
				
				if self.balls[i].x < brick.x and self.balls[i].dx > 0 then
					self.balls[i].dx = -self.balls[i].dx
					self.balls[i].x = brick.x - 8
				elseif self.balls[i].x + self.balls[i].size > brick.x + brick.width and self.balls[i].dx < 0 then
					self.balls[i].dx = -self.balls[i].dx
					self.balls[i].x = brick.x + brick.width
				elseif self.balls[i].y < brick.y then
					self.balls[i].dy = -self.balls[i].dy
					self.balls[i].y = brick.y - 8
				else
					self.balls[i].dy = -self.balls[i].dy
					self.balls[i].y = brick.y + brick.height 
				end
				
				self.balls[i].dy = self.balls[i].dy * 1.015

				break
			end	
		end
	end	

	for i = 1, 1 do
		if self.balls[i].y >= VIRTUAL_HEIGHT then
			if #self.balls > 1 then
				gSounds['hurt']:play()
				table.remove(self.balls, i)
			else
				self.health = self.health-1
				if self.health == 0 then
					gStateMachine:change('end', {
						score = self.score,
						highScores = self.highScores
					})
				else
					self.paddle:changeSize(false)
					gStateMachine:change('serve', {
						score = self.score,
						paddle = self.paddle,
						bricks = self.bricks,
						health = self.health,
						highScores = self.highScores,
						level = self.level,
						recoverPoints = self.recoverPoints,
						paddleInc = self.paddleInc
					})
				end
			end
		end
	end

	if self.powerupSpawned then
		if self.powerup.y >= VIRTUAL_HEIGHT then
			self.powerupSpawned = false
		elseif self.powerup:collides(self.paddle) then
			self.powerupSpawned = false
			gSounds['recover']:play()
			self:spawnBalls()
		end
	end

	if self.keySpawned then
		if self.key.y >= VIRTUAL_HEIGHT then
			self.keySpawned = false
			self.keySpawn = self.keySpawnCounter + 3
		elseif self.key:collides(self.paddle) then
			self.keySpawned = false
			gSounds['recover']:play()
			keyExists = false
			self.bricks[keyLoc].tier = 0
			keyBlockState = 'unlocked'
		end
	end
	
	for k, brick in pairs(self.bricks) do
		brick:update(dt)
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

	if self:checkVictory() then
		gSounds['victory']:play()
		gStateMachine:change('victory', {
			score = self.score,
			paddle = self.paddle,
			health = self.health,
			level = self.level,
			balls = {[1] = self.balls[1]},
			highScores = self.highScores,
			paddleInc = self.paddleInc
		})
	end

end

function PlayState:render()
	self.paddle:render()
	for k, b in pairs(self.balls) do
		b:render()
	end

	for k, brick in pairs(self.bricks) do
		brick:render()
	end

	if self.powerupSpawned then
		self.powerup:render()
	end

	if self.keySpawned then
		self.key:render()
	end

	for k, brick in pairs(self.bricks) do
		brick:renderParticles()
	end

	renderHealth(self.health)
	renderScore(self.score)

	if self.paused then
		love.graphics.setFont(gFonts['large'])
		love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT/2 - 16, VIRTUAL_WIDTH, 'center')
	end
end

function PlayState:checkVictory()
	for k, brick in pairs(self.bricks) do
		if brick.inPlay then
			return false
		end
	end
	return true
end

function PlayState:spawnBalls()
	skin = math.random(7)
	table.insert(self.balls, #self.balls + 1, Ball(skin))
	skin = math.random(7)
	table.insert(self.balls, #self.balls + 1, Ball(skin))

	for i = 2, 3 do
		self.balls[i].x = self.paddle.x + ((i-1)*self.paddle.width / 3) - self.balls[i].size/2
		self.balls[i].y = self.paddle.y - self.balls[i].size
		self.balls[i].dx = math.random(-200, 200)
		self.balls[i].dy = math.random(-80, -90)
	end
end
