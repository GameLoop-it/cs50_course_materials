PlayerLiftPotState = Class{__includes = BaseState}

function PlayerLiftPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- -- render offset for spaced character sprite
    -- self.player.offsetY = 5
    -- self.player.offsetX = 8

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction

    -- sword-left, sword-up, etc
    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerLiftPotState:update(dt)

    -- set a padding for a better feel
    local padding = 4

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.type == "pot" then
            if self.player.direction == "up" then
                if self.player.x - padding <= object.x and self.player.x + self.player.width + padding >= object.x + object.width 
                        and object.y + object.height - padding <= self.player.y and object.y >= self.player.y - object.height - padding then
                    self:pick(object, k)
                    break
                end
            elseif self.player.direction == "down" then
                if self.player.x - padding <= object.x and self.player.x + self.player.width + padding >= object.x + object.width
                    and self.player.y + self.player.height - padding <= object.y and self.player.y + self.player.height + object.height + padding >= object.y + object.height then
                    self:pick(object, k)
                    break
                end
            elseif self.player.direction == "left" then
                if math.abs(self.player.x - object.x) <= object.width + padding
                    and self.player.y - padding <= object.y and self.player.y + self.player.height + padding >= object.y + object.height then
                    self:pick(object, k)
                    break
                end
            else
                if math.abs(object.x - self.player.x) <= object.width + padding
                    and self.player.y - padding <= object.y and self.player.y + self.player.height + padding >= object.y + object.height then
                    self:pick(object, k)
                    break
                end
            end
        end
    end

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    -- allow us to change into this state afresh if we swing within it, rapid swinging
    if love.keyboard.wasPressed('space') then
        self.player:changeState('swing-sword')
    end
end

function PlayerLiftPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end

function PlayerLiftPotState:pick(object, k)
    object.solid = false
    self.player:changeState('pot-idle', {pot = object, potIndex = k})
end