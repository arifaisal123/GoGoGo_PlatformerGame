-- Game created by arifaisal123 as a Final Project for Harvard's CS50 course
-- Game inspired by DevJeeper's tutorial (YT Channel: DevJeeper || URL: https://www.youtube.com/watch?v=XfIDHUyLpQ0)

-- Eliminates the aliasing which causes player character to be blurred
love.graphics.setDefaultFilter("nearest", "nearest")

-- Requirements of the game
local Player = require("player")
local Cookie = require("cookie")
local GUI = require("gui")
local Spike = require("spike")
local Deadlyflower = require("deadlyflower")
local Stone = require("stone")
local Camera = require("camera")
local Enemy1 = require("enemy1")
local Enemy2 = require("enemy2")
local Enemy3 = require("enemy3")
local Enemy4 = require("enemy4")
local Enemy5 = require("enemy5")
local Enemy6 = require("enemy6")
local Map = require("map")

function love.load()
    -- Assets credit
    -- https://itch.io/game-assets/
    -- https://dotstudio.itch.io/super-mario-1-remade-assets
    -- https://calciumtrice.tumblr.com/

    -- Loads Assets
    Enemy1.loadAssets()
    Enemy2.loadAssets()
    Enemy3.loadAssets()
    Enemy4.loadAssets()
    Enemy5.loadAssets()
    Enemy6.loadAssets()

    -- Loads map
    Map:load()

    -- Creates the background of the game
    background = love.graphics.newImage("assets/background.png")

    -- Loads music
    -- Sound credit: https://www.fesliyanstudios.com/royalty-free-music/downloads-c/8-bit-music/6?fbclid=IwAR397ZwJZcDTiO0w6KFjN861FUfZEMsb1irN64hUcPETBJBVnbtkNtRWPWA
    sounds = {}
    sounds.gamemusic = love.audio.newSource("assets/sounds/1.mp3", "stream")
    sounds.gamemusic:setLooping(true)

    sounds.gamemusic:play()

    -- Loads GUI, and Player
    GUI:load()
    Player:load()
end


function love.update(dt)
    -- Here dt refers to delta time, the time it takes to produce a frame.
    -- Updates the Map Constantly
    World:update(dt)
    Player:update(dt)
    Cookie.updateAll(dt)

    GUI:update(dt)
    Map:update(dt)
    Camera:setPosition(Player.x, 0)

    Enemy1.updateAll(dt)
    Enemy2.updateAll(dt)
    Enemy3.updateAll(dt)
    Enemy4.updateAll(dt)
    Enemy5.updateAll(dt)
    Enemy6.updateAll(dt)

    Stone.updateAll(dt)
    Spike.updateAll(dt)
    Deadlyflower.updateAll(dt)

end


function love.draw()
    -- Draws the background image of the game; It is drawn before the map so that it stays behind the map.
    love.graphics.draw(background)

    -- Draws the map, and scales it to 200% 
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

    Camera:apply()
    -- Draws assets of the game
    Player:draw()
    Enemy1.drawAll()
    Enemy2.drawAll()
    Enemy3.drawAll()
    Enemy4.drawAll()
    Enemy5.drawAll()
    Enemy6.drawAll()
    Cookie.drawAll()
    Spike.drawAll()
    Deadlyflower.drawAll()
    Stone.drawAll()

    Camera:clear()

    -- Draws GUI
    GUI:draw()
end


function love.keypressed(key)
    Player:jump(key)
end


function beginContact(a, b, collision)
    if Cookie.beginContact(a, b, collision) then return end
    if Spike.beginContact(a, b, collision) then return end
    if Deadlyflower.beginContact(a, b, collision) then return end
    Enemy1.beginContact(a, b, collision) 
    Enemy2.beginContact(a, b, collision)
    Enemy3.beginContact(a, b, collision)
    Enemy4.beginContact(a, b, collision)
    Enemy5.beginContact(a, b, collision)
    Enemy6.beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
end


function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end