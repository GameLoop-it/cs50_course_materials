--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

SkeletonIdleState = Class{__includes = EntityIdleState}

function SkeletonIdleState:init(entity, room)
    self.entity = entity

    self.room = room

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function SkeletonIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = 1
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end