--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ErrorState = Class{__includes = BaseState}

function ErrorState:init()
    self.message = "generic error message"
end

function ErrorState:enter(params)
    self.message = params.message
end

function ErrorState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ErrorState:render()
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.printf(self.message, 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('Press Enter to play anyway', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
end