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

    if math.random(100) <= 10 then
        self.shiny = true-- set our Timer class to turn cursor highlight on and off
        self.lighted = false
        Timer.every(0.5, function()
            self.lighted = not self.lighted
        end)
    else
        self.shiny = false
    end

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color  -- accepted values: [1, 18]
    self.variety = variety -- accepted values: [1, 6]
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)


    if self.shiny then
        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        if self.lighted then
            love.graphics.setColor(0, 0, 0, 255)
        else
            love.graphics.setColor(255, 255, 255, 255)
        end

        love.graphics.rectangle('fill', (self.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),(self.gridY - 1) * 32 + 16,  32, 32, 2)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end
        
    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    
end