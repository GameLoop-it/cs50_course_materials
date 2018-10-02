--[[
    GD50
    Legend of Zelda
]]

Enemy = Class{__includes = Entity}

function Enemy:init(def)
    Entity.init(self, def)
end

function Enemy:update(dt)
    Entity.update(self, dt)
end