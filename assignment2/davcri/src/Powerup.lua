
Powerup = Class{}

function Powerup:init()
    self.x = math.random(20, VIRTUAL_WIDTH - 20)
    self.y = 120 + math.random(-30, 30)
    self.type = 8
    self.inPlay = false
    self.speed = 25
    self.width = 16
    self.height = 16
    self.timer = 0  --counter
    self.spawnTime = 1 -- seconds
    
    self.type = 1 -- 1 is "balls powerup", 2 is "key"
end

function Powerup:collides(target) 
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    self:reset()

    return true
end

function Powerup:reset()
    self.inPlay = false
    self.timer = 0
    self.x = math.random(20, VIRTUAL_WIDTH - 20)
    self.y = 120 + math.random(-30, 30)
    -- self.type = 1
end

function Powerup:update(dt)
    -- update position
    self.y = self.y + self.speed*dt

    if self.y > VIRTUAL_HEIGHT then
        self:reset()
    end
end

function Powerup:render()
    local frame = gFrames['powerups'][self.type]

    if self.inPlay then
        love.graphics.draw(gTextures['main'], frame, self.x, self.y)
    end
end