PlayerPotIdleState = Class{__includes = EntityIdleState}

function PlayerPotIdleState:init(entity, dungeon)
    self.entity = entity

    self.dungeon = dungeon

    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function PlayerPotIdleState:enter(params)
    self.potIndex = params.potIndex
    self.pot = params.pot
end

function PlayerPotIdleState:update(dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk', {pot = self.pot, potIndex = self.potIndex})
    end

    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - 6

    if love.keyboard.isDown("space") then
        local dx = 0
        local dy = 0
        if self.entity.direction == "up" then
            dy = -PLAYER_WALK_SPEED
        elseif self.entity.direction == "down" then
            dy = PLAYER_WALK_SPEED
        elseif self.entity.direction == "left" then
            dx = -PLAYER_WALK_SPEED
        else
            dx = PLAYER_WALK_SPEED
        end
        local projectile = Projectile(self.pot, dx + dx/2, dy + dy/2)
        self.dungeon.currentRoom.objects[self.potIndex] = projectile
        self.entity:changeState("idle")
    end


end

function PlayerPotIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end