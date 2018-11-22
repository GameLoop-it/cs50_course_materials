--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState)
    self.battleState = battleState
    
    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 64,
        width = 160,
        height = 64,
        items = {
            {
                text = 'Fight',
                onSelect = function()
                    gStateStack:pop()
                    gStateStack:push(TakeTurnState(self.battleState))
                end
            },
            {
                text = 'Run',
                onSelect = function()
                    gSounds['run']:play()
                    
                    -- pop battle menu
                    gStateStack:pop()

                    -- show a message saying they successfully ran, then fade in
                    -- and out back to the field automatically
                    gStateStack:push(BattleMessageState('You fled successfully!',
                        function() 
                            Timer.after(0.5, function()
                                gStateStack:push(FadeInState({
                                    r = 255, g = 255, b = 255
                                }, 1,
                                
                                -- pop message and battle state and add a fade to blend in the field
                                function()
        
                                    -- resume field music
                                    gSounds['field-music']:play()
        
                                    -- pop battle state
                                    gStateStack:pop()
        
                                    gStateStack:push(FadeOutState({
                                        r = 255, g = 255, b = 255
                                    }, 1, function()
                                        -- do nothing after fade out ends
                                    end))
                                end))
                            end)
                        end), false)

                end
            },
            {
            text = 'Catch' .. 'x' .. self.battleState.player.glball,
                onSelect = function()
                    gStateStack:pop()
                    if self.battleState.player.glball < 1 then
                        gStateStack:push(BattleMessageState('GLBALL FINITE!',
                        function() 
                            gStateStack:push(BattleMenuState(self.battleState))
                        end), false)
                    else
                        gStateStack:push(CatchState(self.battleState))
                    end
                end
            }
        }
    }
end

function BattleMenuState:update(dt)
    self.battleMenu:update(dt)
end

function BattleMenuState:render()
    self.battleMenu:render()
end