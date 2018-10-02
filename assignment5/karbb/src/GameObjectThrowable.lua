--[[
    GD50
    Legend of Zelda

    Author: Karbb
]]

GameObjectThrowable = Class{_includes = GameObject}

function GameObjectThrowable:init(def, x, y, room)
   
    self.onThrow = def.onThrow
    self.projectile = false
    self.maxDistance = 64
    self.distance = 0
    self.room = room

    GameObject.init(self, def, x, y)

    self.hitbox = Hitbox(self.x + 4, self.y + 4, self.width - 8, self.height - 8)
end

function GameObjectThrowable:update(dt)
    if self.projectile then
    
        local objectCollision = false
        for k, obj in pairs(self.room.objects) do

            if obj.solid and GameObject.collides(self, obj) then
                objectCollision = true
            end
        end

        if objectCollision or self.distance > self.maxDistance then
            self:destroy()
        end

        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
        self.distance = self.distance + OBJECT_MOV_SPEED*dt
    end
    
    self.hitbox = Hitbox(self.x + 4, self.y + 4, self.width - 8, self.height - 8)
end

function GameObjectThrowable:destroy()
    self.state = 'broken'
    self.projectile = false
end

function GameObjectThrowable:checkWallCollisions()
    local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

    if self.x < MAP_RENDER_OFFSET_X + TILE_SIZE or self.x > VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
        or self.y < MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 or  self.y > bottomEdge - self.height then
            return true
    end
    return false
end


function GameObjectThrowable:lift()
    self.state = 'throwed'
end

function GameObjectThrowable:fire(self, room, dx, dy)
    self.projectile = true
    self.room = room
    self.onThrow(self, room, dx, dy)
end

function GameObjectThrowable:render()
    GameObject.render(self)
end