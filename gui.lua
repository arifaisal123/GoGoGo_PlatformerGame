local GUI = {}
local Player = require("player")

-- Loads the GUI items
function GUI:load()
    self.cookies = {}
    self.cookies.img = love.graphics.newImage("assets/cookie.png")
    self.cookies.width = self.cookies.img:getWidth()
    self.cookies.height = self.cookies.img:getHeight()
    self.cookies.scale = 3
    self.cookies.x = love.graphics.getWidth() - 200
    self.cookies.y = 50

    self.hearts = {}
    self.hearts.img = love.graphics.newImage("assets/heart.png")
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 3
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 30


    self.font = love.graphics.newFont("assets/bit.ttf", 36)
end

function GUI:update()
end

-- Draws necessary GUI variables
function GUI:draw()
    self:displayCookies()
    self:displayCoinText()
    self:displayHearts()
end

-- Display hearts on the top left side of the screen
function GUI:displayHearts()
    for i = 1, Player.health.current do
        local x = self.hearts.x + self.hearts.spacing * i
        love.graphics.setColor(0,0,0,0.5) 
        love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
    end
end


-- Display cookies on the top right side of the screen
function GUI:displayCookies()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.draw(self.cookies.img, self.cookies.x + 2, self.cookies.y + 2, 0, self.cookies.scale, self.cookies.scale)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.cookies.img, self.cookies.x, self.cookies.y, 0, self.cookies.scale, self.cookies.scale)
end


-- Displays the text of the coin on the top right side of the screen
function GUI:displayCoinText()
    love.graphics.setFont(self.font)
    local x = self.cookies.x + self.cookies.width * self.cookies.scale
    local y = self.cookies.y + self.cookies.height / 2 * self.cookies.scale - self.font:getHeight() / 2
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.print(" : "..Player.cookies, x + 2, y + 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(" : "..Player.cookies, x, y)
end

return GUI