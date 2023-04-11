local Deadlyflower = {img = love.graphics.newImage("assets/deadlyflower.png")}
Deadlyflower.__index = Deadlyflower

Deadlyflower.width = Deadlyflower.img:getWidth()
Deadlyflower.height = Deadlyflower.img:getHeight()

ActiveDeadlyflowers = {}
local Player = require("player")

-- Removes object after each level
function Deadlyflower.removeAll()
    for i,v in ipairs(ActiveDeadlyflowers) do
        v.physics.body:destroy()
    end
    ActiveDeadlyflowers = {}
end

-- Creates the location of the deadly flower
function Deadlyflower.new(x, y)
    local instance = setmetatable({}, Deadlyflower)
    instance.x = x
    instance.y = y

    instance.damage = 1

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveDeadlyflowers, instance)
end

function Deadlyflower:update(dt)
end


function Deadlyflower:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Deadlyflower.updateAll(dt)
    for i, instance in ipairs(ActiveDeadlyflowers) do
        instance:update(dt)
    end
end


function Deadlyflower.drawAll()
    for i, instance in ipairs(ActiveDeadlyflowers) do
        instance:draw()
    end
end

-- Checks if there is contact between deadly flower and player or not
function Deadlyflower.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveDeadlyflowers) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                return true
            end
        end
    end
end

return Deadlyflower