--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState 
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.randomTile = def.randomTile or false

    if self.randomTile then
        self.tileId = rnd(3)
    end

    -- default empty collision callback
    self.onCollide = function() end
    
    self.hitbox = Hitbox(self.x + 2, self.y + 2, self.width - 4, self.height - 4)
end

function GameObject:collides(target)
    return not (self.hitbox.x + self.hitbox.width < target.x or self.hitbox.x > target.x + target.width or
                self.hitbox.y + self.hitbox.height < target.y or self.hitbox.y > target.y + target.height)
end

function GameObject:update(dt)
    self.hitbox = Hitbox(self.x + 2, self.y + 2, self.width - 4, self.height - 4)
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)

    if not self.randomTile then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
            self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0))
    else
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame[self.tileId] or self.frame],
        self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0))
    end

    --[[
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.hitbox.x, self.hitbox.y, self.hitbox.width, self.hitbox.height)
    love.graphics.setColor(255, 255, 255, 255)
    ]]

end