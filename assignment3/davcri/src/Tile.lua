--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color  -- accepted values: [1, 18]
    self.variety = variety -- accepted values: [1, 6]
    self.shiny = math.random(1,100) < 10  -- 10% chance of spawning shiny

    -- init particle system
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(1, 0.9)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2
    self.psystem:setLinearAcceleration(0, 0, 0, -1)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setAreaSpread('normal', 6, 6)

    Timer.every(0.1, function()
        self.psystem:emit(2)
    end)
end

function Tile:update(dt)
    if self.shiny then
        self.psystem:setColors(
            255,
            255,
            250,
            90,
            255,
            255,
            205,
            0
        )
        self.psystem:update(dt)
    end
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end

function Tile:renderParticles(x, y)
    if self.shiny then
        love.graphics.draw(self.psystem, x + self.x + 16, y + self.y + 16)
    end
end