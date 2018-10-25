--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    -- hitbox used to detect objects 
    self.objectHitbox = Hitbox(self.x, self.y, 16, 16)

    -- on heartCollected, gain 2 HP
    Event.on('heartCollected', function()
        self.health = math.min(6, self.health + 2)
    end)
end

function Player:update(dt)
    Entity.update(self, dt)

    -- update objectHitbox position
    self.objectHitbox.x, self.objectHitbox.y = self.x, self.y
    if self.direction == 'left' then
        self.objectHitbox.x = self.objectHitbox.x - 16
    elseif self.direction == 'right' then
        self.objectHitbox.x = self.objectHitbox.x + 16
    elseif self.direction == 'up' then
        self.objectHitbox.y = self.objectHitbox.y - 16
    elseif self.direction == 'down' then
        self.objectHitbox.y = self.objectHitbox.y + 16
    end

    -- if player press the "pick" action ('e' key)
    if love.keyboard.wasPressed('e') then
        -- dispatch signal (Room object is listening for this)
        Event.dispatch('playerActionAtPosition', self.objectHitbox)
        -- if some object is in the hitbox, the room will dispatch an event
    end
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)

    -- debug for objectHitbox
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.objectHitbox.x, self.objectHitbox.y, self.objectHitbox.width, self.objectHitbox.height)
    love.graphics.setColor(255, 255, 255, 255)
end
