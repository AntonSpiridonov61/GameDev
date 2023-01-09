require("vector")
require("particle")

function love.load()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	
	particles = {}
	systems = {}

	for i = 1, 6 do
		x = math.random(20, 600)
		y = math.random(20, 500)
		particles[i] = Particle:create(Vector:create(x, y), 60)
		systems[i] = ParticleSystem:create(Vector:create(x, y), 50)
	end

end


function love.update(dt)

	for _, system in pairs(systems) do
		system:applyForce(dt)
		system:update(dt)
	end
end

function love.draw()

	for _, system in pairs(systems) do
		system:draw()
	end

	for _, particle in pairs(particles) do
		particle:draw()
	end
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then 
		for i, _ in pairs(particles) do
            local top = particles[i].location.y
            local bottom = particles[i].location.y + particles[i].size
            local left = particles[i].location.x
            local right = particles[i].location.x + particles[i].size
			if x > left and x < right and y > top and y < bottom then
				systems[i].isPressed = true
                particles[i].size = 0
			end
		end
   end
end