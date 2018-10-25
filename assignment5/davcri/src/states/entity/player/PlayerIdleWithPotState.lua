--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleWithPotState = Class{__includes = EntityIdleState}

function PlayerIdleWithPotState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    if params then
        self.pot = params.pot -- pot is a GameObject
    end

    self.entity:changeAnimation('idle-pot-' .. self.entity.direction)
end

function PlayerIdleWithPotState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleWithPotState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk-pot', {pot = self.pot})
    end

    if love.keyboard.wasPressed('space') then
        Event.dispatch('pot-thrown', {pot = self.pot, direction = self.entity.direction})
        self.entity:changeState('idle')
    end

    self.pot.x, self.pot.y = self.entity.x, self.entity.y
end

function PlayerIdleWithPotState:render()
    EntityIdleState.render(self)

    -- if self.pot then
    self.pot:render(0, -12)
    -- end
end