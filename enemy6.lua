-- Snake Enemy

local Enemy6 = {}
Enemy6.__index = Enemy6
local Player = require("player")

ActiveEnemys6 = {}

-- Removes object after each level
function Enemy6.removeAll()
    for i,v in ipairs(ActiveEnemys6) do
        v.physics.body:destroy()
    end
    ActiveEnemys6 = {}
end

-- Creates the location of the enemy6
function Enemy6.new(x, y)
    local instance = setmetatable({}, Enemy6)
    instance.x = x
    instance.y = y
    instance.offsetY = -8
    instance.r = 0

    instance.speed = 100
    instance.speedMod = 1
    instance.xVel = instance.speed

    instance.rageCounter = 0
    instance.rageTrigger = 3

    instance.damage = 1

    instance.state = "walk"

    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.run = {total = 4, current = 1, img = Enemy6.runAnim}
    instance.animation.walk = {total = 4, current = 1, img = Enemy6.walkAnim}
    instance.animation.draw = instance.animation.walk.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width * 0.4, instance.height * 0.75)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(25)
    table.insert(ActiveEnemys6, instance)
end

function Enemy6.loadAssets()
    Enemy6.runAnim = {}
    for i = 1, 4 do
        Enemy6.runAnim[i] = love.graphics.newImage("assets/enemy6/run/"..i..".png")
    end

    Enemy6.walkAnim = {}
    for i = 1, 4 do
        Enemy6.walkAnim[i] = love.graphics.newImage("assets/enemy6/walk/"..i..".png")
    end

    Enemy6.width = Enemy6.runAnim[1]:getWidth()
    Enemy6.height = Enemy6.runAnim[1]:getHeight()
end

function Enemy6:update(dt)
    self:syncPhysics()
    self:animate(dt)
end

function Enemy6:incrementRage()
    self.rageCounter = self.rageCounter + 1
    if self.rageCounter > self.rageTrigger then
        self.state = "run"
        self.speedMod = 3
        self.rageCounter = 0
    else
        self.state = "walk"
        self.speedMod = 1
    end
end


function Enemy6:flipDirection()
    self.xVel = -self.xVel
end


-- Animates the enemy6
function Enemy6:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

-- Set new images/ frames for the animation
function Enemy6:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end


function Enemy6:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel * self.speedMod, 100)
end


function Enemy6:draw()
    local scaleX = 3
    if self.xVel < 0 then
        scaleX = -3
    end
   
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r, scaleX, 3, self.width / 2, self.height / 2)
end

function Enemy6.updateAll(dt)
    for i, instance in ipairs(ActiveEnemys6) do
        instance:update(dt)
    end
end


function Enemy6.drawAll()
    for i, instance in ipairs(ActiveEnemys6) do
        instance:draw()
    end
end

function Enemy6.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveEnemys6) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
            end
            instance:incrementRage()
            instance:flipDirection()
        end
    end
end

return Enemy6