--[[
    GD50
    Legend of Zelda

    Author: Karbb
]]

PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    self.room = self.dungeon.currentRoom

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

     -- create hitbox based on where the player is and facing
     local direction = self.player.direction
    
     local hitboxX, hitboxY, hitboxWidth, hitboxHeight
 
     if direction == 'left' then
         hitboxWidth = 8
         hitboxHeight = 16
         hitboxX = self.player.x - hitboxWidth
         hitboxY = self.player.y + 2
     elseif direction == 'right' then
         hitboxWidth = 8
         hitboxHeight = 16
         hitboxX = self.player.x + self.player.width
         hitboxY = self.player.y + 2
     elseif direction == 'up' then
         hitboxWidth = 16
         hitboxHeight = 8
         hitboxX = self.player.x
         hitboxY = self.player.y - hitboxHeight
     else
         hitboxWidth = 16
         hitboxHeight = 8
         hitboxX = self.player.x
         hitboxY = self.player.y + self.player.height
     end
 
     self.carryHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
     self.player:changeAnimation('lift-' .. self.player.direction)
end

function PlayerLiftState:enter(params)
    self.player.currentAnimation:refresh()
end

function PlayerLiftState:update(dt)
    local direction = self.player.direction

    if self.player.currentAnimation.timesPlayed > 0 then
        -- check if hitbox collides with any entities in the scene
        for k, object in pairs(self.room.objects) do
            if object.type == 'liftable' and object.solid then
                if self.carryHitbox:collides(object) then
                    table.remove(self.room.objects, k)
                    self.player:pickObject(object)
                    self.player:changeState('carry')
                    return
                end
            end
        end
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerLiftState:checkObjCollision()
    if self.dungeon ~= nil then
    local objects = self.room.objects

        for k, obj in pairs(self.room.objects) do
            if obj.solid and obj.type == 'liftable' and self.player:collides(obj) then
                table.remove(self.room.objects, k)
                return true
            end
        end
    end
end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    --love.graphics.setColor(255, 0, 255, 255)
    --love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    --love.graphics.rectangle('line', self.carryHitbox.x, self.carryHitbox.y,
    --     self.carryHitbox.width, self.carryHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

