--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 120
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    --CS50: initialize the heart image
    self.heart = love.graphics.newImage('assets/sprites/heart.png')

    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    -- CS50: initialize the first pipe to be spawned after 1.5 seconds
    self.spawnTime = 2

    -- CS50: initialize the bird lives
    self.lives = 2

    self.🎿🐶qty = 0
    self.🎿🐶bool = false
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    -- spawn a new pipe pair
    if self.timer > self.spawnTime then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - gapHeight - PIPE_HEIGHT))
        
        -- CS50: randomized the pipes spawn interval
        self.spawnTime = math.random(1, 3)

        --[[ CS50: 🎿🐶
            ACTIVATE SCICANE
        ]]
        if math.random(0, 100) > 85 and self.🎿🐶bool == false then
            self.🎿🐶bool = true
            self.🎿🐶qty = math.random(5, 15)
            self.🎿🐶direction = math.random(-1, 1)
        end

        --[[ CS50: 🎿🐶
            SPAWNING SCICANESSS
        ]]
        if(self.🎿🐶bool and self.🎿🐶qty > 0) then
            self.spawnTime = 0.5
            self.🎿🐶qty = self.🎿🐶qty - 1

            y = math.max(- PIPE_HEIGHT + 10, 
            math.min(self.lastY + (self.🎿🐶direction * 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))

            if(y == - PIPE_HEIGHT + 10 or y == VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT) then
                self.🎿🐶direction = self.🎿🐶direction * - 1
            end
        end

        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y, self.bird, self.🎿🐶bool))

        -- reset timer
        self.timer = 0
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                collisionHandler(self)
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        collisionHandler(self)
        self.bird:reset()
    end

    -- CS50: fixed THE bug. Added ceiling collision
    if self.bird.y < - 15 then
        collisionHandler(self)
        self.bird:reset()
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    -- CS50: Draw remaining lifes on screen as hearts
    for i = 0, self.lives - 1 do
        love.graphics.draw(self.heart, i * 64 + 10, VIRTUAL_HEIGHT - self.heart:getHeight() - 10    )
    end

    self.bird:render()
end

-- CS50: utility function to manage collision conseguences
function collisionHandler(self)

    -- remove heart when not invincible
    if self.bird.invicibility <= 0 then
        self.lives = self.lives - 1

        sounds['explosion']:play()
        sounds['hurt']:play()
      
        -- 0 lives --> score
        if(self.lives < 0) then
            gStateMachine:change('score', {
                score = self.score
            })
        else
            -- start invicibility period
            self.bird.invicibility = 2;
        end
    end
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end