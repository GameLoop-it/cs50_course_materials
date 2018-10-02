--[[
    GD50
    Legend of Zelda

    Author: Karbb
]]

GameObjectConsumable = Class{_includes = GameObject}

function GameObjectConsumable:init(def, x, y)
    GameObject.init(self, def, x, y)
    self.onConsume = def.onConsume
end

function GameObjectConsumable:update(dt)

end

function GameObjectConsumable:render()
    GameObject.render(self)
end