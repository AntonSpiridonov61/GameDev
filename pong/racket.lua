Racket = {}
Racket.__index = Racket

function Racket:create(side)
    local racket = {}
    setmetatable(racket, Racket)

    racket.score = 0
    racket.side = side
    racket.length = 50
    racket.thickness = 10
    racket.position = WindowHeight / 2 - racket.length / 2
    racket.centerPos = racket.position + racket.length / 2

    return racket
end

function Racket:move(distance)

    local is_border = false
    if distance > 0 and self.position >= WindowHeight - self.length then
        is_border = true
    elseif distance < 0 and self.position <= 0 then
        is_border = true
    end

    if is_border == false then
        self.position = self.position + distance
        self.centerPos = self.position + self.length / 2
    end

end

function Racket:draw()
    local x = 0
    local y = self.position
    if self.side == "left" then
        x = self.thickness
    elseif self.side == "right" then
        x = WindowWidth - self.thickness * 2
    end

    love.graphics.rectangle("fill", x, y, self.thickness, self.length)
end

function Racket:reset()
    self.score = 0
    self.position = WindowHeight / 2 - self.length / 2
    self.centerPos = self.position + self.length / 2
end