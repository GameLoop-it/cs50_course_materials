LockedBrick = Class{__includes = Brick}

function LockedBrick:init(x, y)
    self.tier = 4
    self.color = 5
    
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    
    self.inPlay = true
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    self.psystem:setAreaSpread('normal', 10, 10)
end

function LockedBrick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['bricks'][22], self.x, self.y)
    end
end

function LockedBrick:hit()
    self.psystem:emit(64)

    self.psystem:setColors(
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        55,
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0
    )

    -- sound on hit
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()
    
    if keyActive then
        self.inPlay = false
    end

    -- play a second layer sound if the brick is destroyed
    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end