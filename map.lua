local Map = {}
local STI = require("sti")
local Cookie = require("cookie")
local Spike = require("spike")
local Stone = require("stone")
local Enemy1 = require("enemy1")
local Enemy2 = require("enemy2")
local Enemy3 = require("enemy3")
local Enemy4 = require("enemy4")
local Enemy5 = require("enemy5")
local Enemy6 = require("enemy6")
local Player = require("player")
local Deadlyflower = require("deadlyflower")

function Map:load()
    self.currentLevel = 1

    -- Creates World variable for physics module to be used, and initiates setCallbacks to be used to understand if the player or other object makes contact or not
    World = love.physics.newWorld(0,2000)
    World:setCallbacks(beginContact, endContact)

    self:init()
end


function Map:init()
    -- Loads the map specifying the path, and also implements the box2d Physics module
    self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})

    -- Initiates the box2d method, and creates collidable objects
    self.level:box2d_init(World)
      
    -- Making the collidable object, and entity invisible, so that only outer surface can be seen
    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.ground
    self.entityLayer = self.level.layers.entity
    
    self.solidLayer.visible = false
    self.entityLayer.visible = false
 
    MapWidth = self.groundLayer.width * 16
     
    self:spawnEntities()
end


function Map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1
    self:init()
    Player:resetPosition()
end


function Map:clean()
    self.level:box2d_removeLayer("solid")
    Cookie.removeAll()
    Enemy1.removeAll()
    Enemy2.removeAll()
    Enemy3.removeAll()
    Enemy4.removeAll()
    Enemy5.removeAll()
    Enemy6.removeAll()
    Stone.removeAll()
    Spike.removeAll()
    Deadlyflower.removeAll()
end

function Map:update()
    if Player.x > MapWidth - 16 then
        self:next()
    end
end

function Map:spawnEntities()
    for i,v in ipairs(self.entityLayer.objects) do
        if v.class == "spike" then
            Spike.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.class == "deadlyflower" then
            Deadlyflower.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.class == "stone" then
            Stone.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.class == "enemy1" then
            Enemy1.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.class == "enemy2" then
            Enemy2.new(v.x + v.width / 2, v.y + v.height / 2)      
        elseif v.class == "enemy3" then
            Enemy3.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.class == "enemy4" then
            Enemy4.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.class == "enemy5" then
            Enemy5.new(v.x + v.width / 2, v.y + v.height / 2)  
        elseif v.class == "enemy6" then
            Enemy6.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "cookie" then
			Cookie.new(v.x, v.y)      

        end
    end
end

return Map