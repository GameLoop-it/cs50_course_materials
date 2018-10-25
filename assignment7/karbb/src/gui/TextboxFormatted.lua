--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

TextboxFormatted = Class{}

function TextboxFormatted:init(x, y, width, height, text, font)
    self.panel = Panel(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.text = text
    self.font = font or gFonts['small']

    self.closed = false
end

function TextboxFormatted:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.closed = true
    end
end

function TextboxFormatted:isClosed()
    return self.closed
end

function TextboxFormatted:render()
    self.panel:render()
    
    love.graphics.setFont(self.font)
    
    love.graphics.print(self.text, self.x + 10, self.y + 10)
end