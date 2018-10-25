Key = Class{__includes = Powerup}

function Key:init(x, y)
    self.type = 10
    self.x = x
    self.y = y
    self.height = 16
    self.width = 16
    self.dy = 25
    self.active = false
end

function Key:activate(playState)
    if not self.active then
        self:unlockLockedBrick(playState)
        self.active = true
    end
end