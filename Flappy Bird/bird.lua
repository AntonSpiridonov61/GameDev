Bird = {}
Bird.__index = Bird

function Bird:create()
    local bird = {}
    setmetatable(bird, Bird)

    bird.texture = love.graphics.newImage("resources/sprites/redbird-midflap.png")
    bird.width = bird.texture:getWidth()
    bird.height = bird.texture:getHeight()
    bird.quad = love.graphics.newQuad(0, 0, bird.width, bird.height, bird.texture)
    bird.posY = 200
    bird.posX = 150
    bird.speed = 0
    bird.angle = 0
    bird.upAngle = math.rad(-40)
    bird.downAngle = math.rad(70)
    bird.upImg = love.graphics.newImage("resources/sprites/redbird-upflap.png")
    bird.midImg = love.graphics.newImage("resources/sprites/redbird-midflap.png")
    bird.downImg = love.graphics.newImage("resources/sprites/redbird-downflap.png")
    bird.countDt = 0
    bird.currentTexture = 2

    return bird
end

function Bird:draw()
    -- love.graphics.rectangle('fill', self.posX - self.width / 2, self.posY - self.height / 2, self.width ,self.height)
    love.graphics.draw(
        self.texture, self.quad, 
        self.posX, self.posY, 
        self.angle, 1, 1, 
        self.width / 2, 
        self.height / 2
    )
end

function Bird:update(dt)

    self.countDt = self.countDt + 1
    if self.countDt > 5 then
        if self.currentTexture == 4 then
            self.currentTexture = 1
        else
            self.currentTexture = self.currentTexture + 1
        end
        self.countDt = 0
        if self.currentTexture == 1 then
            self.texture = self.upImg
        elseif self.currentTexture == 2 or self.currentTexture == 4 then
            self.texture = self.midImg
        elseif self.currentTexture == 3 then
            self.texture = self.downImg
        end
    end

    local ratio = self.speed / keyUpSpeed
    if ratio > 1 then ratio = 1 elseif ratio < -1 then ratio = -1 end
    self.angle = ((-ratio + 1) / 2) * (self.downAngle - self.upAngle) + self.upAngle

    self.speed = self.speed + (attraction * dt)
    self.posY = self.posY + (self.speed * dt)
end

function Bird:checkColliding(pipe)
    return
        (self.posX - self.width / 2) < (pipe.posX + pipe.width) and
            (self.posX + self.width / 2) > pipe.posX and (
                (self.posY - self.height / 2) < pipe.spaceY or
                (self.posY + self.height / 2) > (pipe.spaceY + pipe.spaceHeight)
            )
end

function Bird:reload()
    self.posY = 200
    self.speed = 0
    self.angle = 0
    self.countDt = 0
    self.currentTexture = 2
end