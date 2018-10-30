LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(def)
    --HPIncrease, attackIncrease, defenseIncrease, speedIncrease
    self.levelUpMenu = Menu {
        x = 4,
        y = 4,
        width = 256,
        height = 128,
        selectionable = false,
        items = {
            {
                text = 'HP: '.. def.HP .." + ".. def.HPIncrease .. " = " .. (def.HP+def.HPIncrease)
            },
            {
                text = 'attack: '.. def.attack .." + ".. def.attackIncrease .. " = " .. (def.attack+def.attackIncrease)
            },
            {
                text = 'defense: '.. def.defense .." + ".. def.defenseIncrease .. " = " .. (def.defense+def.defenseIncrease)            },
            {
                text = 'speed: '.. def.speed .." + ".. def.speedIncrease .. " = " .. (def.speed+def.speedIncrease)
            }
        }
    }
end

function LevelUpMenuState:update(dt)
    self.levelUpMenu:update(dt)
end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end