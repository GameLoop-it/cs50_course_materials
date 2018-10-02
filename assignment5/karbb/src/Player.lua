--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    self.carriedObject = nil

    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:pickObject(object)
    self.carriedObject = object
    self.carriedObject:lift()
end

function Player:throwObject(object, room, direction)
    local dx, dy = 0, 0;
    if direction == "left" then
        dx = -OBJECT_MOV_SPEED
    elseif direction == "right" then
        dx = OBJECT_MOV_SPEED
    elseif direction == "up" then
        dy = -OBJECT_MOV_SPEED
    elseif direction == "down" then
        dy = OBJECT_MOV_SPEED
    end

    object:fire(object, room, dx, dy)
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end