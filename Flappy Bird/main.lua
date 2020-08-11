push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

WW = 1280
WH = 720
VW = 512
VH = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
GROUND_SPEED = 60
local BACKGROUND_SPEED = 20
local backgroundLoop = 413
local groundHeight = ground:getHeight()

scrolling = true

function love.load()
    love.window.setTitle('Flappy Bird')
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    normalFont = love.graphics.newFont('flappy.ttf',8)
    scoreFont = love.graphics.newFont('flappy.ttf',28)
    countFont = love.graphics.newFont('flappy.ttf',56)
    midFont = love.graphics.newFont('flappy.ttf',14)

    push:setupScreen(VW,VH,WW,WH,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
    }

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['count'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }

    gStateMachine:change('title')

    love.keyboard.keysPressed = {}

end

function love.update(dt)

    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SPEED*dt)%backgroundLoop
        groundScroll = (groundScroll + GROUND_SPEED*dt)%VW
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.draw()
    push:start()

    love.graphics.draw(background,-backgroundScroll,0)
    gStateMachine:render()
    love.graphics.draw(ground,-groundScroll,VH-groundHeight)

    push:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


