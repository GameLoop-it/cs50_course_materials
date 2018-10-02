GrowPaddle = Class{__includes = Powerup}

function GrowPaddle:init(x, y)
    self.type = 5
    self.x = x
    self.y = y
    self.height = 16
    self.width = 16
    self.dy = 25
    self.active = false
end

function GrowPaddle:activate(playState)
    if not active then
        self:growPaddle(playState)
        self.active = true
    end
end