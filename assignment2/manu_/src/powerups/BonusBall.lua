BonusBall = Class{__includes = Powerup}

function BonusBall:init(x, y)
    self.type = 8
    self.x = x
    self.y = y
    self.height = 16
    self.width = 16
    self.dy = 25
    self.active = false
end

function BonusBall:activate(playState)
    if not active then
        self:addBall(playState)
        self.active = true
    end
end