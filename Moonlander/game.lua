require "vector"
require "terrain"
require "spaceship"
require "sky"
require "collision"

GameState = {
    NOT_STARTED = 1,
    ACTIVE = 2,
    FINISHED = 3,
    SHOWING_RESULTS = 4
}

Game = {}
Game.__index = Game

function Game:create()
    local game = {}
    setmetatable(game, Game)
    math.randomseed(os.clock())

    game.fontName = '/res/AtariClassic.ttf'

    game.score = 0
    game.fuel = 800

    
    game.lowFuelMark = 100
    game.lowFuelPlayed = false
    
    game.state = GameState.NOT_STARTED
    
    game.terrain = Terrain:create()
    game.spaceship = Spaceship:create(Vector:create(math.random(math.floor(width * 0.1), math.floor(width * 0.8)),
    math.floor(height * 0.2)))
    game.sky = Sky:create()
    
    game.explosionSound = love.audio.newSource('/res/explosion.wav', 'static')
    game.engineSound = love.audio.newSource('/res/engineSound.wav', 'stream')
    game.lowOnFuelSound = love.audio.newSource('/res/alarm.wav', 'static')
    
    game.terrain:generate()
    game.sky:init()
    game.sky:generateStars(game.terrain)
    
    game:init()

    return game
end

function Game:init()
    self.spaceship:init()

    self.lowFuelPlayed = false

    self.state = GameState.NOT_STARTED
end

function Game:reset()
    self.score = 0
    self.fuel = 800
end

function Game:draw()
    self.terrain:draw()
    self.sky:draw()
    self.spaceship:draw()
    self:drawInfo()
    
    if self.state == GameState.NOT_STARTED then
        self:drawCenteredText("Press ENTER to start the game", 26)
    end
    
    if self.state == GameState.SHOWING_RESULTS then
        if self.spaceship.landingStatus == LandingStatus.FAILURE then
            self:drawCenteredText("Fail!  Press ENTER to try again.", 20)
        else
            self:drawCenteredText("Success!  Press ENTER to try again.", 20)
        end
    end

    if self.fuel < self.lowFuelMark and self.state ~= GameState.SHOWING_RESULTS then
        self:drawCenteredText("Low fuel", 14)
    end
end

function Game:update(dt)

    if love.keyboard.isDown('return') and
        (
        self.state == GameState.NOT_STARTED or self.state == GameState.FINISHED or
            self.state == GameState.SHOWING_RESULTS) then
        self:init()

        if self.fuel == 0 then
            self:reset()
        end

        self.state = GameState.ACTIVE
    end

    if love.keyboard.isDown('escape') then
        if self.state == GameState.NOT_STARTED or self.state == GameState.FINISHED then
            love.event.quit()
        else
            self.state = GameState.NOT_STARTED
        end
    end

    if self.state == GameState.ACTIVE then
        if love.keyboard.isDown('up') then
            if self.fuel > 0 then
                local x = 0.06 * dt * math.sin(self.spaceship.angle)
                local y = -0.04 * dt * math.cos(self.spaceship.angle)

                if not self.engineSound:isPlaying() then
                    self.engineSound:play()
                end

                self.spaceship:toggleActivity(true)
                self.spaceship:applyForce(Vector:create(x, y))

                if 10 * dt > self.fuel then
                    self.fuel = 0
                    self.engineSound:stop()
                    self.spaceship:toggleActivity(false)
                else
                    self.fuel = self.fuel - 10 * dt
                end

                if self.fuel < self.lowFuelMark and not self.lowFuelPlayed then
                    self.lowFuelPlayed = true
                    self:playSound(self.lowOnFuelSound)
                end
            end
        else
            self.engineSound:stop()
            self.spaceship:toggleActivity(false)
        end

        if love.keyboard.isDown('left') then
            self.spaceship:rotate(-2 * dt)
        elseif love.keyboard.isDown('right') then
            self.spaceship:rotate(2 * dt)
        end

        self.spaceship:applyForce(Vector:create(0, 0.02 * dt))

        self.spaceship:update(dt)

        if self.spaceship:checkForCollision(self.terrain) then
            self.state = GameState.SHOWING_RESULTS
            self.engineSound:stop()

            if self.spaceship.landingStatus == LandingStatus.FAILURE then
                self:playSound(self.explosionSound)
            else
                self.score = self.score + 100
            end
        end
    end
end

function Game:drawInfo()

    local font = love.graphics.newFont(self.fontName, 14)
    love.graphics.setFont(font)
    local textHeight = font:getHeight()
    local gap = 10

    love.graphics.print("Score " .. self.score, 40, 40)

    love.graphics.print("Fuel  " .. math.floor(self.fuel), 40, 40 + textHeight + gap)

    love.graphics.print("Hor. speed " ..
        math.abs(math.floor(self.spaceship.velocity.x * 200)), width - 220, 40)

    love.graphics.print("Ver. speed " .. math.floor(self.spaceship.velocity.y * 200), width - 220,
        40 + textHeight + gap)

end

function Game:playSound(source)
    love.audio.play(source)
end

function Game:drawCenteredText(text, fontSize)
    local linesAmount = 1

    for i = 1, #text do
        if text:sub(i, i) == '\n' then
            linesAmount = linesAmount + 1
        end
    end

    local font = love.graphics.newFont(self.fontName, fontSize)
    love.graphics.setFont(font)

    local textWidth  = font:getWidth(text)
    local textHeight = font:getHeight(text) * linesAmount

    love.graphics.print(text, width / 2, height / 2, 0, 1, 1, textWidth / 2,
        textHeight / 2)
end
