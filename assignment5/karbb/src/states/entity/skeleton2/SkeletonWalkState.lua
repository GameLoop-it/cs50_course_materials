--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

SkeletonWalkState = Class{__includes = EntityWalkState}

function SkeletonWalkState:init(entity, room)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.room = room

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function SkeletonWalkState:update(dt)
    
    -- assume we didn't hit a wall
    self.bumped = false
    
    local oldX = self.entity.x
    local oldY = self.entity.y

    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        
        if self:checkObjCollision() then
            self.entity.x = oldX
            self.bumped = true
        end
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt

        if self:checkObjCollision() then
            self.entity.x = oldX
            self.bumped = true
        end
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt

        if self:checkObjCollision() then
            self.entity.y = oldY
            self.bumped = true
        end 
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt

        if self:checkObjCollision() then
            self.entity.y = oldY
            self.bumped = true
        end
    end
end

function SkeletonWalkState:checkObjCollision()
    if self.room ~= nil then
        local objects = self.room.objects

        for k, obj in pairs(self.room.objects) do
            if obj.solid and self.entity:collides(obj.hitbox) then
                return true
            end
        end
    end
end

function SkeletonWalkState:processAI(params, dt)
    local room = params.room
    local player = room.player

    local dx = math.abs(player.x - self.entity.x)
    local dy = math.abs(player.y - self.entity.y)

    if self.entity.x < player.x - 6 and dx > dy then
        self.entity.direction = 'right'
    elseif self.entity.x > player.x + 6 and dx > dy then
        self.entity.direction = 'left'
    elseif self.entity.y > player.y - 6 and dx < dy then
        self.entity.direction = 'up'
    elseif self.entity.y < player.y + 6 and dx < dy then
        self.entity.direction = 'down'
    else
        self.entity:changeState('idle')
    end
        
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
end