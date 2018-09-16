--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height, state)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        -- CS50: Player never spawn on a empty space
        if math.random(7) == 1 and x > 3 and x < width - 3 then            
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            if x > 3 and x < width - 3 then
                -- chance to generate a pillar
                if math.random(8) == 1 then
                    blockHeight = 2

                    -- chance to generate bush on pillar
                    if math.random(8) == 1 then
                        table.insert(objects,
                            GameObject {
                                texture = 'bushes',
                                x = (x - 1) * TILE_SIZE,
                                y = (4 - 1) * TILE_SIZE,
                                width = 16,
                                height = 16,

                                -- select random frame from bush_ids whitelist, then random row for variance
                                frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                            }
                        )
                    end

                    -- pillar tiles
                    tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                    tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                    tiles[7][x].topper = nil

                    -- chance to generate bushes
                elseif math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (6 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end

                -- chance to spawn a block
                if math.random(10) == 1 then
                    table.insert(objects,
                        -- jump block
                        GameObject {
                            texture = 'jump-blocks',
                            x = (x - 1) * TILE_SIZE,
                            y = (blockHeight - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            -- make it a random variant
                            frame = math.random(#JUMP_BLOCKS),
                            collidable = true,
                            hit = false,
                            solid = true,

                            -- collision function takes itself
                            onCollide = function(obj)

                                -- spawn a gem if we haven't already hit the block
                                if not obj.hit then

                                    -- chance to spawn gem, not guaranteed
                                    if math.random(5) == 1 then

                                        -- maintain reference so we can set it to nil
                                        local gem = GameObject {
                                            texture = 'gems',
                                            x = (x - 1) * TILE_SIZE,
                                            y = (blockHeight - 1) * TILE_SIZE - 4,
                                            width = 16,
                                            height = 16,
                                            frame = math.random(#GEMS),
                                            collidable = true,
                                            consumable = true,
                                            solid = false,

                                            -- gem has its own function to add to the player's score
                                            onConsume = function(player, object)
                                                gSounds['pickup']:play()
                                                player.score = player.score + 100
                                            end
                                        }

                                        -- make the gem move up from the block and play a sound
                                        Timer.tween(0.1, {
                                            [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                        })
                                        gSounds['powerup-reveal']:play()

                                        table.insert(objects, gem)
                                    end

                                    obj.hit = true
                                end

                                gSounds['empty-block']:play()
                            end
                        }
                    )
                end

                -- CS50: platform spawning
                if math.random(20) == 1 then
                end
            end

        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles

    spawnLock(objects, width)

    return GameLevel(entities, objects, map)
end

--CS50: spawn lock and key
function spawnLock(objects, width)
    local rndBlock = math.random(#objects)

    while objects[rndBlock].texture ~= 'jump-blocks' do
        rndBlock = math.random(#objects)
    end

    local block = GameObject {
        texture = 'keys_and_locks',
        x = objects[rndBlock].x,
        y = objects[rndBlock].y,
        width = 16,
        height = 16,

        -- make it a random variant
        frame = LOCKS[math.random(#LOCKS)],
        collidable = false,
        hit = false,
        solid = true,
        onCollide = function(obj, player)
            if player.hasKey then
                for k, object in pairs(objects) do
                    if object.texture == 'keys_and_locks' then
                        table.remove(objects, k)
                    end
                end
                player.hasKey = false
                spawnGoal(objects, width)
            end
        end
    }

    objects[rndBlock] = block

    local rndBlockKey = math.random(#objects)

    while objects[rndBlockKey].texture == 'keys_and_locks' do
        rndBlockKey = math.random(#objects)
    end

    local blockKey = GameObject {
        texture = 'keys_and_locks',
        x = objects[rndBlockKey].x,
        y = objects[rndBlockKey].y,
        width = 16,
        height = 16,

        -- make it a random variant
        frame = KEYS[math.random(#KEYS)],
        collidable = true,
        consumable = true,
        solid = false,

        onConsume = function(player, object)
            gSounds['pickup']:play()
            player.hasKey = true
        end
    }

    objects[rndBlockKey] = blockKey
end

function spawnGoal(objects, gameWidth)
    local flag = GameObjectAnimable {
        texture = 'flags',
        x = (gameWidth - 2) * TILE_SIZE - 7,
        y = 3 * TILE_SIZE + 5,
        width = 16,
        height = 16,
        animationFrames = {7, 8, 9},
        collidable = false,
        consumable = false,
        solid = false
    }

    table.insert(objects, flag)

    local post = GameObject {
        texture = 'poles',
        x = (gameWidth - 3) * TILE_SIZE,
        y = 3 * TILE_SIZE,
        width = 16,
        height = 48,
        frame = 1,
        collidable = false,
        consumable = false,
        triggerable = true,
        solid = false,
        hit = false,
        -- CS50: trigger callback (no consume / no collide)
        onTrigger = function(obj, player)
            if not obj.hit then
                for k, object in pairs(objects) do
                    if object.texture == 'flags' then
                        obj.hit = true
                        player:changeState('pause')
                        Timer.tween(1, {
                            [object] = {y = 5 * TILE_SIZE}
                        }):finish(function()  
                            player:changeState('animation')
                        end)
                    end
                end
            end
        end
    }

    table.insert(objects, post)
end
