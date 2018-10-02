--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Room = Class{}

function Room:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self.objects = {}
    self:generateWallsAndFloors()

    -- entities in the room
    self.entities = {}
    self:generateEntities()

    -- game objects in the room
    self:generateObjects()

    -- doorways that lead to other dungeon rooms
    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))
    table.insert(self.doorways, Doorway('bottom', false, self))
    table.insert(self.doorways, Doorway('left', false, self))
    table.insert(self.doorways, Doorway('right', false, self))

    -- reference to player for collisions, etc.
    self.player = player

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    self.player:goInvulnerable(1.5)

    self.projectiles = {}
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, rnd(MAX_ENTITY_NUMBER) do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = 16,
            height = 16,

            health = 1
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i], self) end,
            ['idle'] = function() return EntityIdleState(self.entities[i], self) end
        }

        self.entities[i]:changeState('walk')
    end
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    local switch = GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    )

    table.insert(self.objects, switch)

    -- CS50: added pots
    for i = 1, rnd(MAX_POTS_NUMBER) do

        local pot = GameObjectThrowable(
            GAME_OBJECT_DEFS['pot'],
            math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                        VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                        VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
        )

        table.insert(self.objects, pot)
    end

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'
            
            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end

            gSounds['door']:play()
        end
    end
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
            table.insert(self.objects, GameObject(
                GAME_OBJECT_DEFS['top-left-wall'],
                MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
            ))
            elseif x == 1 and y == self.height then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['bottom-left-wall'],
                    MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                    MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
                ))
            elseif x == self.width and y == 1 then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['top-right-wall'],
                    MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                    MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
                ))
            elseif x == self.width and y == self.height then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['bottom-right-wall'],
                    MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                    MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
                ))
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['left-wall'],
                    MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                    MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
                ))
            elseif x == self.width then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['right-wall'],
                    MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                    MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
                ))
            elseif y == 1 then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['top-wall'],
                    MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                    MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
                ))
            elseif y == self.height then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['bottom-wall'],
                    MAP_RENDER_OFFSET_X + x*TILE_SIZE - TILE_SIZE,
                    MAP_RENDER_OFFSET_Y + y*TILE_SIZE - TILE_SIZE
                ))
            end
            id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0
        if entity.health <= 0 then
            entity.dead = true
            if not entity.dropped then
               if rnd(10) == 1 then 
                    table.insert(self.objects, GameObjectConsumable(GAME_OBJECT_DEFS['heart'], entity.x, entity.y)) 
                end
                entity.dropped = true
            end
        elseif not entity.dead then
            entity:processAI({room = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the room
        if not entity.dead and not entity.projectile and self.player:collides(entity) and not self.player.invulnerable then
            gSounds['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                gStateMachine:change('game-over')
            end
        end
    end

    for k, object in pairs(self.objects) do
        object:update(dt)

        -- trigger collision callback on object
        if self.player:collides(object) then
            object:onCollide()
            if object.type == 'consumable' then object:onConsume(self, k) end
        end
    end

    for k, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        for k, entity in pairs(self.entities) do
            if projectile.projectile and entity:collides(projectile) then
                projectile:destroy()
                entity:damage(1)
            end
        end

        for k, obj in pairs(self.objects) do
            if obj.type == 'switch' and obj:collides(projectile) then
                obj:onCollide()
            end
        end
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, projectile in pairs(self.projectiles) do
        projectile:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - 6,
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)
    
    if self.player then
        self.player:render()
    end

    love.graphics.setStencilTest()
end