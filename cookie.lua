local Cookie = {}
Cookie.__index = Cookie
local ActiveCookies = {}
local Player = require("player")

-- Creates the location of the cookie
function Cookie.new(x, y)
    local instance = setmetatable({}, Cookie)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/cookie.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1
    instance.randomTimeOffset = math.random(0, 100)
    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveCookies, instance)
end

-- Removes the cookie from the screen once collected
function Cookie:remove()
    for i, instance in ipairs(ActiveCookies) do
        if instance == self then
            Player:incrementCookies()
            print(Player.cookies)
            self.physics.body:destroy()
            table.remove(ActiveCookies, i)
        end
    end
end


-- Removes object after each level
function Cookie.removeAll()
    for i,v in ipairs(ActiveCookies) do
        v.physics.body:destroy()
    end
    ActiveCookies = {}
end


-- Updates cookies
function Cookie:update(dt)
    self:spin(dt)
    self:checkRemove()
end


-- Checks condition for removal
function Cookie:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end


-- Spins the cookies
function Cookie:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end


-- Draws the cookies
function Cookie:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end


function Cookie.updateAll(dt)
    for i, instance in ipairs(ActiveCookies) do
        instance:update(dt)
    end
end


function Cookie.drawAll()
    for i, instance in ipairs(ActiveCookies) do
        instance:draw()
    end
end


-- Checks if there is contact with the cookie and the player
function Cookie.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveCookies) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return Cookie