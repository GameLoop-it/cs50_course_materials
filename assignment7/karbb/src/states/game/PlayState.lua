--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.level = Level()

    gSounds['field-music']:setLooping(true)
    gSounds['field-music']:play()

    self.dialogueOpened = false
end

function PlayState:update(dt)
    if not self.dialogueOpened and love.keyboard.wasPressed('p') then
        
        -- heal player pokemon
        gSounds['heal']:play()
        self.level.player.party.pokemon[1].currentHP = self.level.player.party.pokemon[1].HP
        
        -- show a dialogue for it, allowing us to do so again when closed
        gStateStack:push(DialogueState('Your Pokemon has been healed!',
    
        function()
            self.dialogueOpened = false
        end))
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local entity = self.level.player
        local toX, toY = entity.mapX, entity.mapY

        if entity.direction == 'left' then
            toX = toX - 1
        elseif entity.direction == 'right' then
            toX = toX + 1
        elseif entity.direction == 'up' then
            toY = toY - 1
        else
            toY = toY + 1
        end

        if self.level.grassLayer.tiles[toY][toX].id == TILE_IDS['grass-ball'] then
            self.level:pickUpBall(toX, toY)
        end
    end

    self.level:update(dt)
end

function PlayState:render()
    self.level:render()
end