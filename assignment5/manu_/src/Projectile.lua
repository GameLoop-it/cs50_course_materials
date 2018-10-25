--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__include = GameObject}

function Projectile:init(def, dx, dy)
    self.bumped = false

    -- string identifying this object type
    self.type = "projectile"

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = true

    self.destructible = def.destructible

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- velocity
    self.dx = dx
    self.dy = dy
        
end

function Projectile:onCollide(entity)
    entity:damage(2)
    self.bumped = true
end

function Projectile:update(dt)
    if self.bumped == false then
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
        
        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
                + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
            self.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.bumped = true
        elseif self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
            self.bumped = true
        elseif self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then 
            self.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
            self.bumped = true
        elseif self.y + self.height >= bottomEdge then
            self.y = bottomEdge - self.height
            self.bumped = true
        end
    end
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end

function Projectile:collides(target)
    if self.solid == true then
        return not (self.x + self.width < target.x or self.x > target.x + target.width or
                    self.y + self.height < target.y or self.y > target.y + target.height)
    end
    return false
end