Particle = {}
Particle.__index = Particle

function Particle:create(location, size)
    local particle = {}
    setmetatable(particle, Particle)
    particle.location = location
    particle.acceleration = Vector:create(0, math.random(0, 0.5))
    particle.velocity = Vector:create(math.random(-3, 3), math.random(-2, 5))
    particle.size = size or 50
    return particle
end

function Particle:update(dt)
    self.velocity:add(self.acceleration)
    self.location:add(self.velocity)
    self.acceleration:mag(0)
end

function Particle:applyForce(force)
    self.acceleration:add(force)
end

function Particle:draw()
    love.graphics.rectangle("fill", self.location.x, self.location.y, self.size, self.size)
end


ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:create(location, n, cls)
    local system = {}
    setmetatable(system, ParticleSystem)
    system.location = location
    system.n = n or 100
    system.cls = cls or Particle
    system.particles = {}
    system.index = 1
    system.isPressed = false
    return system
end

function ParticleSystem:draw()
    for _, particle in pairs(self.particles) do
        particle:update()
        particle:draw()
    end
end

function ParticleSystem:update(dt)
    if self.isPressed then
        if #self.particles < self.n then
            self.particles[self.index] = self.cls:create(Vector:create(self.location:copy().x + 30, self.location:copy().y + 30), 20)
           self.index = self.index + 1
        end
    end
end

function ParticleSystem:applyForce(dt)
    for _, particle in pairs(self.particles) do
        particle:applyForce(Vector:create(0, love.math.random(0, 0.5) * dt))
    end
end