--[[
    GD50
    Legend of Zelda

    PlayerCarryIdleState

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerCarryIdleState = Class{__includes = BaseState}

function PlayerCarryIdleState:init(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon

    self.room = self.dungeon.currentRoom

    self.entity:changeAnimation('carry-idle-' .. self.entity.direction)
end

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerCarryIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carry')
    end

    --CS50: begin item lifting
    if love.keyboard.wasPressed('return') then
        self.entity.carriedObject.x = self.entity.x 
        self.entity.carriedObject.y = self.entity.y + 8
        self.entity:throwObject(self.entity.carriedObject, self.room, self.entity.direction)
        self.entity:changeState('idle')
    end
end

function PlayerCarryIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

    local carriedObject = self.entity.carriedObject

    if carriedObject ~= nil then
        love.graphics.draw(gTextures[carriedObject.texture], gFrames[carriedObject.texture][(carriedObject.states[carriedObject.state].frame or carriedObject.frame)],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.height + 16))
    end
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end