local Player = {}

function Player:load()
    -- Tracks player position
    self.x = 100
    self.y = 0

    -- Starting position of the player
    self.startX = self.x
    self.startY = self.y 

    -- Creates the dimension
    self.width = 20
    self.height = 60

    -- Velocity Variables; Requires to ensure movement of the player
    self.xVel = 0
    self.yVel = 100

    -- Determines how many pixels per second the player will be able to move
    self.maxSpeed = 200

    -- Increases/Decreases velocity of the player
    self.acceleration = 4000
    self.friction = 3500

    -- Creates gravity for the player
    self.gravity = 1500

    -- Creates the jump amount of the player
    self.jumpAmount = -500

    -- Counts cookies collected
    self.cookies = 0

    -- Declares health of the player
    self.health = {current = 3, max = 3}

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3
    }

    -- Gracetime for a better double/jump execution
    self.graceTime = 0
    self.graceDuration = 0.1

    -- Checks if player is alive
    self.alive = true
    -- Checks if player is on the ground or not
    self.grounded = false

    -- Checks if player can do a double jump
    self.hasDoubleJump = true

    -- Sets direction of the player
    self.direction = "right"

    -- Dictates the state of the player
    self.state = "idle"

    -- Loads assets for the player
    self:loadAssets()

    -- Stores the player's physical collision information
    self.physics = {}

    -- The body will be the first variable inside the physics table where the body will store position velocity, and rotation of the player. In other words, it will tell where the player is, and where it is going
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")

    -- By default, dynamic bodies can rotate, so the rotation has been fixed here
    self.physics.body:setFixedRotation(true)

    -- Define the shape of the physical body
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)

    -- Works as a connector between body and shape
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    -- Keeps the body unaffected by gravity
    self.physics.body:setGravityScale(0)
end

function Player:loadAssets()
    -- Sets the animation frame rate of the player character
    self.animation = {timer = 0, rate = 0.1}

    -- Runs the animation for the player while running
    self.animation.run = {total = 6, current = 1, img = {}}
    for i = 1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/run/"..i..".png")
    end

    -- Runs the animation for the player while idle
    self.animation.idle = {total = 4, current = 1, img = {}}
    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/"..i..".png")
    end

    -- Runs the animation for the player while in air
    self.animation.air = {total = 4, current = 1, img = {}}
    for i = 1, self.animation.air.total do
        self.animation.air.img[i] = love.graphics.newImage("assets/player/air/"..i..".png")
    end

    -- Draws the frame of the animation
    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

-- Handles player health
function Player:takeDamage(amount)
    self:tintRed()
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
    else
        self.health.current = 0
        self:die()
    end
    print("Player health: "..self.health.current)
end

-- Handles death of the player
function Player:die()
    print("Player died")
    self.alive = false
end

-- Respawns the player after death
function Player:respawn()
    if not self.alive then
        self:resetPosition()
        self.health.current = self.health.max
        self.alive = true
    end
end


-- Resets player position
function Player:resetPosition()
    self.physics.body:setPosition(self.startX, self.startY)
end

    
-- Changes player color when takes damage
function Player:tintRed()
    self.color.green = 0
    self.color.blue = 0
end

-- Increments the cookie counter
function Player:incrementCookies()
    self.cookies = self.cookies + 1
end

-- Updates functions/variables
function Player:update(dt)
    self:unTint(dt)
    self:respawn()
    self:setState()
    self:setDirection()
    self:animate(dt)
    self:decreaseGraceTime(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
end

-- Untints the player after being tinted
function Player:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end


-- Sets/Changes the state of the player
function Player:setState()
    if not self.grounded then
        self.state = "air"
    elseif self.xVel == 0 then
        self.state = "idle"
    else
        self.state = "run"
    end
end

-- Sets/ Changes direction of the player
function Player:setDirection()
    if self.xVel < 0 then
        self.direction = "left"
    elseif self.xVel > 0 then
        self.direction = "right"
    end
end

-- Animates the player
function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

-- Set new images/ frames for the animation
function Player:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end


-- Decreases GraceTime of the player
function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end


function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

-- Prompts the player to move left or right
function Player:move(dt)
    -- Checks if key is pressed
    if love.keyboard.isDown("d", "right") then
        -- Ensures the player does not cross the maxSpeed
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") then
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
    else
        self:applyFriction(dt)
    end
end

-- Applies friction during player movement
function Player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.max(self.xVel - self.friction * dt, 0)
    elseif self.xVel < 0 then
        self.xVel = math.min(self.xVel + self.friction * dt, 0)
    end
end

-- Syncs the physical body of the player with its x and y position
function Player:syncPhysics()
    self.x, self.y= self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

-- Confirms for contact/ collision
function Player:beginContact(a, b, collision)
    if self.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yVel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.yVel = 0
        end
    end
end

-- Confirms the player has landed after jump
function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
end

-- Initiates the jump of the player
function Player:jump(key)
    if (key == "w" or key == "up" or key == "space") then
        if self.grounded or self.graceTime > 0 then 
            self.yVel = self.jumpAmount
            self.grounded = false
            self.graceTime = 0
        elseif self.hasDoubleJump then
            self.hasDoubleJump = false 
            self.yVel = self.jumpAmount * 0.8
        end
    end
end

-- Confirms the end of contact/ collision
function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end


function Player:draw()
    -- 2 is used instead of 1 to scale up the player by 200%
    local scaleX = 2
    if self.direction == "left" then
        scaleX = -2
    end
    -- Draws the player and scales up by 200%
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 2, self.animation.width / 2, self.animation.height / 2)
    love.graphics.setColor(1, 1, 1, 1)
end

return Player