--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ExpDialogueState = Class{__includes = BaseState}

function ExpDialogueState:init(battleState, statsIncrease, callBack)

    local pokemon = battleState.player.party.pokemon[1]
    
    self.expDialogue = TextboxFormatted(
        5,
        5,
        VIRTUAL_WIDTH/2 - 5,
        VIRTUAL_HEIGHT - 64 - 10,
        NEW_LINE ..
        "HP: " .. pokemon.HP-statsIncrease[1] .. " + " .. statsIncrease[1] .. " = " .. pokemon.HP .. NEW_LINE .. 
        "Attack: " .. pokemon.attack-statsIncrease[2] .. " + " .. statsIncrease[2] .. " = " .. pokemon.attack .. NEW_LINE ..
        "Defense: "  .. pokemon.defense-statsIncrease[3] .. " + " .. statsIncrease[3] .. " = " .. pokemon.defense .. NEW_LINE ..
        "Speed: " .. pokemon.speed-statsIncrease[4] .. " + " .. statsIncrease[4] .. " = " .. pokemon.speed .. NEW_LINE,
        gFonts['medium']
)

    self.callback = callback or function() end
end

function ExpDialogueState:update(dt)
    self.expDialogue:update(dt)

    if self.expDialogue:isClosed() then
        self.callback()
        gStateStack:pop()
    end
end

function ExpDialogueState:render()
    self.expDialogue:render()
end