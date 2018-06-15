--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 20

--[[ CS50: Bird gamestate
 - JUMPING_STATE: nothing pressed
 - CHARGING_STATE: spacebar or mouse is pressed
 - JUMPING_STATE: spacebar or mouse is released and bird is jumping
]]
local FALLING_STATE = 'falling'
local JUMPING_STATE = 'jumping'
local CHARGING_STATE = 'charging'

function Bird:init()
    self.image = love.graphics.newImage('assets/sprites/bird.png')
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0

    self.timer = 0;

    self.state = FALLING_STATE
    self.oldState = FALLING_STATE
    self.life = 2

-- CS50: invincibility attribute
    self.invicibility = 0
    self.flickering = false
end

-- CS50: function called to reset starting position when bird collides with top or bottom border
function Bird:reset()
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8
    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    --CS50: here keep track of the previous gamestate
    self.oldState = self.state

    self.dy = self.dy + GRAVITY * dt

    jumping = love.keyboard.isDown('space') or love.mouse.isDown(1);
    
    --[[ CS50: if jump buttons are pressed and bird is FALLING, change the state in CHARGING,
        otherwise gamestate is not changed ]]
    if(jumping) then
        if(self.state == FALLING_STATE) then
            self.state = CHARGING_STATE
        end
    end

    --CS50: if jump buttons are not pressed and bird was CHARGING last frame, change the state in JUMPING
    if(not jumping and self.oldState == CHARGING_STATE) then
        self.state = JUMPING_STATE
    end

    --CS50: if bird is CHARGING, keep track for how many frames is in this state
    if(self.state == CHARGING_STATE) then
        self.timer = self.timer + 0.5
    end

    --CS50: if bird is JUMPING, jump high as much as ( with an upper limit ) charged the jump
    if(self.state == JUMPING_STATE) then
        self.dy = -1 * math.min(self.timer, 8)
        sounds['jump']:play()
        self.state = FALLING_STATE
        self.timer = 0
    end

    --print('jumping: ' .. tostring(jumping), 'oldState: ' ..  self.oldState, 'state: ' .. self.state, 'timer: ' .. self.timer)
    self.y = self.y + self.dy

    -- CS50: invincibility countdown
    if(self.invicibility > 0) then
        self.invicibility = self.invicibility - dt
    end
end

function Bird:render()
    
    -- CS50: flickering rendering
    if(self.invicibility > 0) then
        flickeringBird(self)
    end
    
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.setColor(255, 255, 255, 255)
    
end

function flickeringBird(self)
    if(self.flickering) then
        love.graphics.setColor(255,255,255,0)
        self.flickering = not self.flickering
    else
        love.graphics.setColor(255, 255, 255, 255)
        self.flickering = not self.flickering
    end
end