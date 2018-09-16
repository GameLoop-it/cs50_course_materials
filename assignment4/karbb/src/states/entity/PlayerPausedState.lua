--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerPausedState Class --
    Author: Karbb
]]

PlayerPausedState = Class{__includes = BaseState}

function PlayerPausedState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerPausedState:update(dt)
end