Terrain = {}
Terrain.__index = Terrain

function Terrain:create()
    local terrain = {}
    setmetatable(terrain, Terrain)

    terrain.points = {}
    terrain.landingLine = {}
    terrain.collision = Collision:create()

    return terrain
end

local function map(v, omin, omax, gmin, gmax)
    return (v - omin) / (omax - omin) * (gmax - gmin) + gmin
end


function Terrain:generate()
    math.randomseed(os.clock())

    local step = 10
    local pointsCount = width / step
    local points = {}

    local xoff = love.math.random()

    for xi = 0, pointsCount do
        local y = love.math.noise(xoff * step, xoff)
        self.points[xi] = Vector:create(
            xi * step,
            map(y, -1, 1, math.floor(height * 0.5), height)
        )

        xoff = xoff + 0.01
    end

    self:addLandingLine(step)
end

function Terrain:addLandingLine(step)

    local lineWidth = 3
    local landingLineCount = math.random(4, 7)
    local tempPlatformIndices = {}

    for _ = 1, landingLineCount do
        tempPlatformIndices[math.random(5, #self.points - 5)] = true
    end

    for i = 1, #self.points do

        if tempPlatformIndices[i] then
            local y = self.points[i].y
            for j = 1, lineWidth do
                self.points[i+j].y = y
            end
            i = i + lineWidth
        end
    end
end


function Terrain:draw()
    for i = 1, #self.points - 1 do
        local point1 = self.points[i]
        local point2 = self.points[i+1]
        -- local w = love.graphics.getLineWidth()
        -- if point1.y == point2.y then
        --     love.graphics.setLineWidth(2)
        -- end
        love.graphics.line(point1.x, point1.y, point2.x, point2.y)
        -- love.graphics.setLineWidth(1)
    end
end


function Terrain:checkPolygonIncludesPoint(point)
    local intersectionsAmount = 0

    for i = 1, #self.points - 10 do
        local point1 = self.points[i]
        local point2 = self.points[i]

        if i == #self.points then
            -- closing polygon
            point2 = Vector:create(point1.x, height)
        else
            point2 = self.points[i + 1]
        end

        if point1.x > 0 and point2.x > 0 and point1.x < width and point2.x < width then
            -- checking if provided point is one of the polygon points
            if point1 == point or point2 == point then
                return true
            end
        end

        local exPoint = Vector:copy(point)
        exPoint.x = width * 2
        -- сhecking intersection with polygon segments
        if self.collision:hasIntersection(point1, point2, point, exPoint) then
            intersectionsAmount = intersectionsAmount + 1
        end
    end

    if intersectionsAmount == 0 then
        return false
    else
        return intersectionsAmount % 2 ~= 0
    end
end
