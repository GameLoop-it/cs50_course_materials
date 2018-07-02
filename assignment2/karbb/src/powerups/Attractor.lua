--[[
    CS50
    -- Powerup Class --

    Represents a powerup which will randomly spawn after a brick is hit, descending 
    toward the bottom. If the paddle will pick up it, it will gains a new
    temporary power.
]]

Attractor = Class{__includes = Powerup}

function Attractor:init(x, y)
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16

    self.x = x
    self.y = y

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = POWERUP_GRAVITY
    self.dx = 0

    self.timer = 0

    self.frame = gFrames['powerups'][8]

    self.type = "attractor"
end

function Attractor:activate(game)
    local refreshedDuration = false;
    if #game.paddle.power > 0 then
        for k, power in pairs(game.paddle.power) do 
            if game.paddle.power[k].type == "attractor" then
                table.remove(game.paddle.power, k)
                refreshedDuration = not refreshedDuration
                table.insert(game.paddle.power, { type = self.type, timer = love.timer.getTime() } )
            end
        end
    end
    if not refreshedDuration then
        table.insert(game.paddle.power, { type = self.type, timer = love.timer.getTime() } )
    end
end