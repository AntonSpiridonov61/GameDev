require "pipe"
require "bird"
require "screen"

local function updateScore(bird, pipe, thisPipe, otherPipe)
    if upcomingPipe == thisPipe and bird.posX > (pipe.posX + pipe.width) then
        score = score + 1
        point:play()
        upcomingPipe = otherPipe
        pipe1.speed = pipe1.speed + 10
        pipe2.speed = pipe2.speed + 10
    end
end

local function reload()
    if score > recordScore then
        recordScore = score
    end
    isHit = false
    score = 0
    upcomingPipe = 1
    bird:reload()
    pipe1:reload(WindowWidth)
    pipe2:reload(WindowWidth + ((WindowWidth + 50) / 2))
end

function love.load()
    sizeFont = 36
    BaseHeight = 50
    keyUpSpeed = -200
    attraction = 650

    score = 0
    recordScore = 0
    upcomingPipe = 1
    isHit = false

    WindowWidth = love.graphics.getWidth()
    WindowHeight = love.graphics.getHeight()
    font = love.graphics.newFont("resources/AtariClassic-Regular.ttf", sizeFont)
    love.graphics.setFont(font)

    
    bird = Bird:create()
    pipe1 = Pipe:create(WindowWidth)
    pipe2 = Pipe:create(WindowWidth + ((WindowWidth + 50) / 2))
    screen = Screen.create()

    bg = love.graphics.newImage("resources/sprites/background-day.png")
    bg:setWrap("repeat", "repeat")
    bgq = love.graphics.newQuad(0, 0, WindowWidth, WindowHeight, bg)

    base = love.graphics.newImage("resources/sprites/base.png")
    base:setWrap("repeat", "repeat")
    baseq = love.graphics.newQuad(0, 0, WindowWidth, BaseHeight, base)

    die = love.audio.newSource("resources/audio/die.wav", "static")
    hit = love.audio.newSource("resources/audio/hit.wav", "static")
    point = love.audio.newSource("resources/audio/point.wav", "static")
    swoosh = love.audio.newSource("resources/audio/swoosh.wav", "static")
    wing = love.audio.newSource("resources/audio/wing.wav", "static")
end

function love.update(dt)
    if screen.isGame then
        if bird:checkColliding(pipe1) or bird:checkColliding(pipe2) then
            if isHit == false then
                hit:play()
                isHit = true
                pipe1.speed = 0
                pipe2.speed = 0
            end
        end 
    
        if bird.posY + bird.height >= WindowHeight - BaseHeight then
            die:play()
            pipe1.speed = 0
            pipe2.speed = 0
            screen.isStart = false
            screen.isGame = false
            screen.isEnd = true
        end
    
        updateScore(bird, pipe1, 1, 2)
        updateScore(bird, pipe2, 2, 1)

        bird:update(dt)
        pipe1:update(dt)
        pipe2:update(dt)
    end
end

function love.draw()
    love.graphics.draw(bg, bgq)
    pipe1:draw()
    pipe2:draw()
    
    if screen.isStart then
        screen:start()
    elseif screen.isGame then
        screen:game()
    elseif screen.isEnd then
        screen:game()
        screen:gameover()
    end     

    love.graphics.draw(base, baseq, 0, WindowHeight - BaseHeight)
end

function love.mousepressed(x, y, button, istouch)
   if screen.isStart or screen.isEnd then
        swoosh:play()
        reload()

        screen.isStart = false
        screen.isGame = true
        screen.isEnd = false
    end

    if screen.isGame then
        if bird.posY > 0 and isHit == false then 
            bird.speed = keyUpSpeed
            wing:play()
        end
    end
end

function love.keypressed(key)

    if key == "escape" then
        love.event.quit()
    else
        if screen.isStart or screen.isEnd then
            swoosh:play()
            reload()

            screen.isStart = false
            screen.isGame = true
            screen.isEnd = false
        end

        if screen.isGame then
            if bird.posY > 0 and isHit == false then 
                bird.speed = keyUpSpeed
                wing:play()
            end
        end
    end
end

