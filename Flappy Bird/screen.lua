Screen = {}
Screen.__index = Screen

function Screen:create(side)
    local screen = {}
    setmetatable(screen, Screen)

    screen.isStart = true
    screen.isGame = false
    screen.isEnd = false
    screen.startImg = love.graphics.newImage("resources/sprites/message.png")
    screen.endImg = love.graphics.newImage("resources/sprites/gameover.png")
    screen.startQuad = love.graphics.newQuad(
        0, 0, 
        screen.startImg:getWidth(), 
        screen.startImg:getHeight(), 
        screen.startImg
    )
    screen.endQuad = love.graphics.newQuad(
        0, 0, 
        screen.endImg:getWidth(), 
        screen.endImg:getHeight(), 
        screen.endImg
    )

    return screen
end

function Screen:start()
    love.graphics.draw(screen.startImg, screen.startQuad, 
        0, 0, 0, 1, 1, 
        self.startImg:getWidth() / 2 - WindowWidth / 2,
        self.startImg:getHeight() / 2 - WindowHeight / 2
    )
end

function Screen:game()
    bird:draw()
    local textWidth  = font:getWidth(score)
    love.graphics.print(recordScore, 20, 20)
    love.graphics.print(score, WindowWidth - textWidth - 20, 20)
end

function Screen:gameover() 
    love.graphics.draw(screen.endImg, screen.endQuad, 
        0, 0, 0, 1, 1, 
        self.endImg:getWidth() / 2 - WindowWidth / 2,
        self.endImg:getHeight() / 2 - WindowHeight / 2
    )
end