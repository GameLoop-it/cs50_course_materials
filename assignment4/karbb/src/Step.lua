--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Karbb
    cogden@cs50.harvard.edu
]]

Step = Class{}

function Step:init(x, y, dx, dy, direction, state, score, hasKey, removed)
    self.x = x
    self.y = y

    self.dx = dx
    self.dy = dy

    self.direction = direction
    self.state = state

    self.isState = false

    self.score = score
    self.hasKey = hasKey

    self.removed = removed
end