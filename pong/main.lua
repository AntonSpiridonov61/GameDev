require "racket"
require "ball"
require "screen"


function love.load()
    sizeFont = 22
    WindowWidth = love.graphics.getWidth()
    WindowHeight = love.graphics.getHeight()
    font = love.graphics.newFont("resources/AtariClassic-Regular.ttf", sizeFont)
    love.graphics.setFont(font)

    screen = Screen.create()
    
    racketLeft = Racket:create("left")
    racketRight = Racket:create("right")
    ball = Ball:create()

    pong = love.audio.newSource("resources/pong.wav", "static")
    win = love.audio.newSource("resources/victory.wav", "static")
    lose = love.audio.newSource("resources/gameover.wav", "static")
end

function love.update(dt)
    local speed = 350

    if ball.position.x < WindowWidth / 2 then
        if ball.position.y < racketLeft.position or 
            ball.position.y > racketLeft.position + racketLeft.length then
            if racketLeft.position > ball.position.y - racketLeft.length / 2 then
                racketLeft:move(-speed * dt)
            elseif racketLeft.position < ball.position.y - racketLeft.length / 2 then
                racketLeft:move(speed * dt)
            end
        end
    end

    if racketRight.isMoving == "up" then
        racketRight:move(-speed * dt)
    elseif racketRight.isMoving == "down" then
        racketRight:move(speed * dt)
    end

    local border = ball:checkBorder()
    if border == "right" then
        racketLeft.score = racketLeft.score + 1
        ball.speed = ball.speed + 20
        if racketLeft.score == 9 then
            screen.isGame = false
            screen.isEnd = true
            screen.whoWin = "left"
            ball.speed = 0
        end
    elseif border == "left" then
        racketRight.score = racketRight.score + 1
        ball.speed = ball.speed + 20
        if racketRight.score == 9 then
            screen.isGame = false
            screen.isEnd = true
            screen.whoWin = "right"
            ball.speed = 0
        end
    end

    if ball:checkRocket(racketLeft) then
        ball.direction.x = ball.speed
        ball.direction.y = ((ball.position.y - racketLeft.centerPos) / racketLeft.length) * ball.speed
    elseif ball:checkRocket(racketRight) then
        ball.direction.x = -ball.speed
        ball.direction.y = ((ball.position.y - racketRight.centerPos) / racketRight.length) * ball.speed
    end

    ball:move(dt)
end

function love.draw()
    if screen.isStart then
        screen:start()
    elseif screen.isGame then
        screen:game()
    elseif screen.isEnd then
        screen:finish()
    end     
end

function love.keypressed(key)
    if key == "up" then
        racketRight.isMoving = "up"
    elseif key == "down" then
        racketRight.isMoving = "down"
    elseif key == "escape" then
        love.event.quit()
    elseif screen.isStart or screen.isEnd and key == "return" then
        screen.isStart = false
        screen.isGame = true
        screen.isEnd = false
        racketRight:reset()
        racketLeft:reset()
        ball:reset()
    end
end

function love.keyreleased(key)
    if key == "up" and racketRight.isMoving == "up" then
        racketRight.isMoving = false
    elseif key == "down" and racketRight.isMoving == "down" then
        racketRight.isMoving = false
    end
end