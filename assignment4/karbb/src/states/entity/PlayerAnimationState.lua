--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerAnimationState Class --
    Author: Karbb
]]

PlayerAnimationState = Class{__includes = BaseState}

function PlayerAnimationState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
    self.player.currentAnimation = self.animation
end

function PlayerAnimationState:update(dt)
    self.player.currentAnimation:update(dt)
    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    self.player.x = self.player.x + PLAYER_WALK_SPEED * dt

    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    -- if we get a collision beneath us, go into either walking or idle
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then

        if(self.animation.frames ~= {10,11}) then
            self.animation = Animation {
                frames = {10, 11},
                interval = 1
            }
            self.player.currentAnimation = self.animation
        end

        self.player.dy = 0
    
        self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height
        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        self.gravity = 1

        self.player.win = true

        Timer.after(3, function () 
            gStateMachine:change('play') 
        end)
    end

end