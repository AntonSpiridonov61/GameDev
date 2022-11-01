Screen = {}
Screen.__index = Screen

function Screen:create(side)
    local screen = {}
    setmetatable(screen, Screen)

    screen.isStart = true
    screen.isGame = false
    screen.isEnd = false
    screen.whoWin = ""

    return screen
end

function Screen:start()
    love.graphics.print(
        "Press Enter to start", 
        WindowWidth / 2 - font:getWidth("Press Enter to start") / 2, 
        WindowHeight / 2
    )
end

function Screen:game()
    for y=0, love.graphics.getHeight(), 50 do
        love.graphics.rectangle("fill", WindowWidth / 2, y, 3, 35)
    end
    love.graphics.print(racketLeft.score, WindowWidth / 2 - 40 - sizeFont, 10)
    love.graphics.print(racketRight.score, WindowWidth / 2 + 40, 10)

    racketLeft:draw()
    racketRight:draw()
    ball:draw()
end

function Screen:finish() 
    if self.whoWin == "right" then
        win:play()
        love.graphics.print(
            "You Win", 
            WindowWidth / 2 - font:getWidth("You Win") / 2, 
            WindowHeight / 2 - 60
        )
        love.graphics.print(
            "Press Enter to start", 
            WindowWidth / 2 - font:getWidth("Press Enter to start") / 2, 
            WindowHeight / 2
        )
    elseif self.whoWin == "left" then
        lose:play()
        love.graphics.print(
            "You Lose", 
            WindowWidth / 2 - font:getWidth("You Lose") / 2, 
            WindowHeight / 2 - 60
        )
        love.graphics.print(
            "Press Enter to start", 
            WindowWidth / 2 - font:getWidth("Press Enter to start") / 2, 
            WindowHeight / 2
        )
    end

end