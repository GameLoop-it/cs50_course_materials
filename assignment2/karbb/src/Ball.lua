--[[
    GD50
    Breakout Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]

Ball = Class{}

function Ball:init(skin)
    -- simple positional and dimensional variables
    self.width = 8
    self.height = 8

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    -- this will effectively be the color of our ball, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin

    --CS50: Ball attribute to check if is or not stuck because of attractor powerup
    self.stuck = false

    self.lastframeStuck = false
    self.frameStuck = false
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Ball:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt, paddle)
    self.lastframeStuck = self.frameStuck
    self.frameStuck = self.stuck
   
    --CS50: Attractor powerup change ball update function
    if self.stuck then
        if(self.x < 0) then
            self.y = paddle.y
            self.x = 0
        elseif (self.x + self.width > VIRTUAL_WIDTH) then
            self.y = paddle.y
            self.x = VIRTUAL_WIDTH - self.width
        else
            self.x = self.x + paddle.dx * dt
        end
        return
    end

    if(not self.stuck and self.lastframeStuck) then
        local mousex, mousey = push:toGame(love.mouse.getX(),love.mouse.getY())
       
        if(mousex == nil or mousey == nil) then
            print()
            angle = math.atan2(mousey - self.y + self.width / 2, mousex - self.x  + self.width / 2)
        
            self.dx = math.cos(angle) * 100
            -- negative sin because the system is based on ball, not on game coordinates
            self.dy = -math.sin(angle) * 100
        end
    end
    
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

function Ball:render()
    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin],
        self.x, self.y)
end