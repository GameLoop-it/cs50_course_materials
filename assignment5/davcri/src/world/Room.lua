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

    -- table containing the ids of the tiles to draw. The ids are object with a single 'id' property
    -- eg: {id = 1}
    self.tiles = {}
    self:generateWallsAndFloors()

    -- entities in the room
    self.entities = {}
    self:generateEntities()

    -- game objects in the room
    self.objects = {}
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

    -- handle player's interaction with objects
    Event.on('playerActionAtPosition', function(objectHitbox)
        for k, obj in pairs(self.objects) do 
            -- if the object is a pot and is inside the player's reach
            if obj.type == 'pot' and objectHitbox:collides(obj) then
                -- set the player to the idle-pot state
                self.player:changeState('idle-pot', {pot = obj})
                -- remove the pot from the room objects
                table.remove(self.objects, k)
            end
        end
    end)

    Event.on('pot-thrown', function(params)
        local pot = params.pot
        local distance = 4*16 -- 4 tiles length
        local finalX, finalY = pot.x, pot.y 
        local offset = 18

        if params.direction == 'up' then
            offset = 24
            pot.x, pot.y = pot.x, pot.y - offset
            finalY = pot.y - distance
        elseif params.direction == 'down' then
            offset = 24
            pot.x, pot.y = pot.x, pot.y + offset
            finalY = pot.y + distance
        elseif params.direction == 'left' then
            pot.x, pot.y = pot.x - offset, pot.y
            finalX = pot.x - distance
        elseif params.direction == 'right' then
            pot.x, pot.y = pot.x + offset, pot.y
            finalX = pot.x + distance
        end

        pot = GameObject(
            GAME_OBJECT_DEFS['pot'],
            pot.x,
            pot.y
        )
        -- update the state 
        pot.state = 'thrown'
        -- tween the attributes
        Timer.tween(1, {
            [pot] = {x = finalX, y = finalY}
        })
        :finish(function()
            pot.state = 'idle'
        end)
        -- add the pot to the objects table
        table.insert(self.objects, pot)

        --   NOTE: non ho capito perché se uso la variabile params.pot (senza istanziare un nuovo oggetto) 
        --   il pot non cambiat la sua posizione:
        -- table.insert(self.objects, params.pot)
        --   probabilmente è perché l'oggetto params.pot è modificato da qualche altra classe
    end)
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, 10 do
        local type = types[math.random(#types)]

        enemy = Enemy {
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
        }

        table.insert(self.entities, enemy)

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    -- GameObject: switch
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    ))
    -- get a reference to the switch
    local switch = self.objects[1]
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

    --GameObject: pots
    -- set a random number of pots to spawn
    local potsCount = math.random(5)
    -- for every pot
    for i = 1, potsCount do
        -- insert it into the objects table
        table.insert(self.objects, GameObject(
            GAME_OBJECT_DEFS['pot'],
            math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                        VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                        VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
        ))
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
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:spawnHeart(x, y)
    table.insert(self.objects, GameObject(GAME_OBJECT_DEFS['heart'], x, y))
end

function Room:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- if entity is dead, skip the next code block
        if not entity.dead then
            -- if entity has been just defeated
            if entity.health <= 0 then
                -- mark entity as dead
                entity.dead = true
                -- spawn a heart with 10% probability
                if math.random(10) <= 7 then
                    self:spawnHeart(entity.x, entity.y)
                end
            -- if entity has not been defeated yet
            else 
                entity:processAI({room = self}, dt)
                entity:update(dt)
            end

            -- collision between the player and entities in the room
            if self.player:collides(entity) and not self.player.invulnerable then
                gSounds['hit-player']:play()
                self.player:damage(1)
                self.player:goInvulnerable(1.5)
    
                if self.player.health == 0 then
                    gStateMachine:change('game-over')
                end
            end
        end
    end

    for k, object in pairs(self.objects) do
        object:update(dt)

        -- trigger collision callback on object
        if self.player:collides(object) then
            if object.type == 'heart' then
                Event.dispatch('heartCollected')
            end
            object:onCollide()
            if object.consumable then
                table.remove(self.objects, k)
            end
        end

        if object.type == 'pot' and object.state == 'thrown' then
            -- wall collision check
            if self:wallsCollideWith(object) then
                table.remove(self.objects, k)
            end
 
            -- foreach entity (enemy)
            for i = #self.entities, 1, -1 do
                local entity = self.entities[i]
                -- if entity is dead, skip the next code block
                if not entity.dead then
                    if entity:collides(object) then
                        -- pot collided with enemy, so deal damage
                        entity:damage(1)
                        -- and destroy the pot, removing it from the objects table
                        table.remove(self.objects, k)
                    end
                end
            end
        end
    end
    Timer.update(dt)
end

function Room:wallsCollideWith(obj) 
    if obj.x <= TILE_SIZE or obj.x >= TILE_SIZE*self.width
       or obj.y <= TILE_SIZE or obj.y >= TILE_SIZE*self.height then
        return true
    end

    return false
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