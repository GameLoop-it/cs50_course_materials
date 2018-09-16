--[[
    GD50
    Super Mario Bros. Remake

    -- Entity Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def)
    -- position
    self.x = def.x
    self.y = def.y

    -- velocity
    self.dx = 0
    self.dy = 0

    -- dimensions
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.stateMachine = def.stateMachine

    self.direction = 'left'

    -- reference to tile map so we can check collisions
    self.map = def.map

    -- reference to level for tests against other entities + objects
    self.level = def.level

    -- CS50: Array of step
    self.history = {}
end

function Entity:changeState(state, params)
    -- CS50: reference to state name
    self.state = state
    self.stateMachine:change(state, params)
end

function Entity:update(dt,rewinding)
    if rewinding then
        self.currentAnimation:update(dt)
        self:rewind()
    else
        self:addStep()
        self.stateMachine:update(dt)
    end
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end

function Entity:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1, 1, 8, 10)
end

function Entity:addStep()
    if #self.history > 101 then
        table.remove(self.history, 1)
    end
    
    table.insert(self.history, Step(self.x, self.y, self.dx, self.dy, self.direction, self.state, self.score, self.hasKey, self.removed))
end

function Entity:rewind()
    if #self.history > 0 then
        
        self.x = self.history[#self.history].x
        self.y = self.history[#self.history].y
        self.dx = self.history[#self.history].dx
        self.dy = self.history[#self.history].dy
        self.direction = self.history[#self.history].direction

        if #self.history == 1 then
            self:changeState(self.history[#self.history].state, {wait = math.random(5)})
        elseif self.history[#self.history].state ~= self.history[#self.history-1].state then
            self:changeState(self.history[#self.history].state, {wait = math.random(5)})
        end

        if self.history[#self.history].score ~= nil then
            self.score = self.history[#self.history].score
            self.hasKey = self.history[#self.history].hasKey
        end

        if self.history[#self.history].removed ~= nil then
            if self.history[#self.history].removed ~= self.history[#self.history-1].removed then
                table.insert(self.level.entities, self)
            end
        end

        table.remove(self.history, #self.history)
    end
end

function Entity:countHistory()
   return #self.history
end