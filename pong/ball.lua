Ball = {}
Ball.__index = Ball

function Ball:create()
    local ball = {}
    setmetatable(ball, Ball)

    ball.startSpeed = 250
    ball.speed = 420
    ball.radius = 7
    ball.position = {x = WindowWidth / 2, y = WindowHeight / 2}
    ball.direction = {x = ball.startSpeed, y = 0}

    return ball
end

function Ball:move(dt)
    self.position.x = self.position.x + self.direction.x * dt
    self.position.y = self.position.y + self.direction.y * dt
end

function Ball:draw()
    love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
end

function Ball:checkBorder()
    if self.position.x >= WindowWidth then
        self.position = { x = WindowWidth / 2,
                          y = WindowHeight / 2 }
        self.direction.y = 0
        self.direction.x = -self.startSpeed
        return "right"
    elseif self.position.x <= 0 then
        self.position = { x = WindowWidth / 2,
                          y = WindowHeight / 2 }
        self.direction.y = 0
        self.direction.x = self.startSpeed
        return "left"
    elseif self.position.y <= self.radius then
        self.direction.y = -self.direction.y
        return "_"
    elseif self.position.y >= WindowHeight - self.radius then
        self.direction.y = -self.direction.y
        return "_"
    end
end

function Ball:checkRocket(rocket)
    rocket.y = rocket.position
    if rocket.side == "left" then
        rocket.x = rocket.thickness + 10
    elseif rocket.side == "right" then
        rocket.x = WindowWidth - rocket.thickness - 10
    end

    local paddleTop = rocket.y
    local paddleBottom = rocket.y + rocket.length
    local paddleLeft = rocket.x
    local paddleRight = rocket.x + rocket.thickness

    local ballTop = self.position.y
    local ballBottom = self.position.y + self.radius * 2
    local ballLeft = self.position.x
    local ballRight = self.position.x + self.radius * 2

    if ballTop <= paddleBottom and
        ballBottom >= paddleTop and
        ballLeft <= paddleRight and
        ballRight >= paddleLeft 
    then
        if screen.isGame then
            pong:play()
        end
        return true
    end
end

function Ball:reset()
    self.speed = 400
    self.position = {x = WindowWidth / 2, y = WindowHeight / 2}
    self.direction = {x = ball.startSpeed, y = 0}
end