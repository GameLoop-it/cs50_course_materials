--[[
    GD50
    Legend of Zelda

    Author: Karbb

]]

PlayerCarryState = Class{__includes = EntityWalkState}

function PlayerCarryState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.room = self.dungeon.currentRoom

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.entity:changeAnimation('carry-' .. self.entity.direction)
end


function PlayerCarryState:enter(params)
    self.entity.currentAnimation:refresh()
end

function PlayerCarryState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('carry-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('carry-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('carry-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('carry-down')
    else
        self.entity:changeState('carry-idle')
    end

    --CS50: begin item lifting
    if love.keyboard.wasPressed('return') then
        self.entity.carriedObject.x = self.entity.x
        self.entity.carriedObject.y = self.entity.y + 8
        self.entity:throwObject(self.entity.carriedObject, self.room, self.entity.direction)
        self.entity:changeState('idle')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
end

function PlayerCarryState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

    local carriedObject = self.entity.carriedObject

    if carriedObject ~= nil then
        love.graphics.draw(gTextures[carriedObject.texture], gFrames[carriedObject.texture][(carriedObject.states[carriedObject.state].frame or carriedObject.frame)],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.height + 16))
    end
end

