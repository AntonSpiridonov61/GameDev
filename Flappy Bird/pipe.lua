Pipe = {}
Pipe.__index = Pipe

function Pipe:create(x)
    local pipe = {}
    setmetatable(pipe, Pipe)

    pipe.spaceHeight = 100
    pipe.spaceYMin = 50
    pipe.spaceY = love.math.random(
        pipe.spaceYMin, 
        WindowHeight - BaseHeight - pipe.spaceHeight - pipe.spaceYMin
    )
    pipe.posX = x
    pipe.texture = love.graphics.newImage("resources/sprites/pipe-green.png")
    pipe.width = pipe.texture:getWidth()

    pipe.speed = 220

    return pipe
end

function Pipe:draw()
    -- love.graphics.rectangle(
    --     'fill',
    --     self.posX,
    --     0,
    --     self.width,
    --     self.spaceY
    -- )
    -- love.graphics.rectangle(
    --     'fill',
    --     self.posX,
    --     self.spaceY + self.spaceHeight,
    --     self.width,
    --     WindowHeight - self.spaceY - self.spaceHeight
    -- )
    love.graphics.draw(
        self.texture,
        self.posX, 
        self.spaceY + self.spaceHeight
    )
    love.graphics.draw(
        self.texture,
        self.posX + self.width, 
        self.spaceY,
        3.14
    )
end

function Pipe:update(dt)
    self.posX = self.posX - (self.speed * dt)
    if (self.posX + self.width) < 0 then
        self:reset()
    end
end

function Pipe:reset()
    self.posX = WindowWidth
    self.spaceY = love.math.random(
        self.spaceYMin, 
        WindowHeight - BaseHeight - self.spaceHeight - self.spaceYMin
    )
end

function Pipe:reload(x)
    self.spaceY = love.math.random(
        self.spaceYMin, 
        WindowHeight - BaseHeight - self.spaceHeight - self.spaceYMin
    )
    self.posX = x
    self.speed = 220
end