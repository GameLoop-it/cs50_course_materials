--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}


keyActive = false


--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.powerups = {}
    self.balls = {}
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores

    self.containsLockedBrick = params.containsLockedBrick
    self.bonusSpawnTime = math.random(5, 10)
    keyActive = params.keyActive
    self.bonusSpawnTimer = 0


    local ball = params.ball
    self.level = params.level
    self.recoverPoints = 5000
    ball.dx = math.random(-200, 200)
    ball.dy = math.random(-50, -60)
    ball.inPlay = true
    table.insert(self.balls, ball)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    if self.bonusSpawnTimer >= self.bonusSpawnTime then
        self.bonusSpawnTimer = 0
        self.bonusSpawnTime = math.random(5, 10)
        self:spawnRandomPowerUp()
    else
        self.bonusSpawnTimer = self.bonusSpawnTimer + dt
    end

    for  k, ball in pairs(self.balls) do
            ball:update(dt)
            if ball:collides(self.paddle) then
                -- raise ball above paddle in case it goes below it, then reverse dy
                ball.y = self.paddle.y - 8
                ball.dy = -ball.dy
        
                --
                -- tweak angle of bounce based on where it hits the paddle
                --
        
                -- if we hit the paddle on its left side while moving left...
                if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                    ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                
                -- else if we hit the paddle on its right side while moving right...
                elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                    ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
                end
        
                gSounds['paddle-hit']:play()
            end

            for k, brick in pairs(self.bricks) do

                -- only check collision if we're in play
                if brick.inPlay and ball:collides(brick) then
        
                    -- add to score
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
        
                    -- trigger the brick's hit function, which removes it from play
                    brick:hit()
        
                    -- if we have enough points, recover a point of health
                    if self.score > self.recoverPoints then
                        -- can't go above 3 health
                        self.health = math.min(3, self.health + 1)
        
                        -- multiply recover points by 2
                        self.recoverPoints = math.min(100000, self.recoverPoints * 2)
        
                        -- play recover sound effect
                        gSounds['recover']:play()
                    end
        
                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds['victory']:play()
                        self.paddle:grow()
        
                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = Ball(math.random(7)),
                            recoverPoints = self.recoverPoints,
                            keyActive = false
                        })
                    end
        
                    --
                    -- collision code for bricks
                    --
                    -- we check to see if the opposite side of our velocity is outside of the brick;
                    -- if it is, we trigger a collision on that side. else we're within the X + width of
                    -- the brick and should check to see if the top or bottom edge is outside of the brick,
                    -- colliding on the top or bottom accordingly 
                    --
        
                    -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                    if ball.x + 2 < brick.x and ball.dx > 0 then
                        
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x - 8
                    
                    -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                        
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x + 32
                    
                    -- top edge if no X collisions, always check
                    elseif ball.y < brick.y then
                        
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y - 8
                    
                    -- bottom edge if no X collisions or top collision, last possibility
                    else
                        
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y + 16
                    end
        
                    -- slightly scale the y velocity to speed up the game, capping at +- 150
                    if math.abs(ball.dy) < 150 then
                        ball.dy = ball.dy * 1.02
                    end
        
                    -- only allow colliding with one brick, for corners
                    break
                end
            end
        
            -- if ball goes below bounds, revert to serve state and decrease health
            if ball.y >= VIRTUAL_HEIGHT then

                if #self.balls > 1 then
                    table.remove(self.balls, k)
                else
                    self.health = self.health - 1
                    gSounds['hurt']:play()
            
                    if self.health == 0 then
                        gStateMachine:change('game-over', {
                            score = self.score,
                            highScores = self.highScores
                        })
                    else
                        self.paddle:shrink()
                        gStateMachine:change('serve', {
                            paddle = self.paddle,
                            bricks = self.bricks,
                            health = self.health,
                            score = self.score,
                            
                            highScores = self.highScores,
                            level = self.level,
                            recoverPoints = self.recoverPoints
                        })
                    end
                end
            end
        end

    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)
        if powerup:collides(self.paddle) then
            powerup:activate(self)
            table.remove(self.powerups, k)
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()

    for k, ball in pairs(self.balls) do
        ball:render()
    end

    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end

function PlayState:spawnPowerup(type, x, y)
    if type == 10 then
        table.insert(self.powerups, Key(x,y))
    elseif type == 8 then
        table.insert(self.powerups, BonusBall(x, y))
    elseif type == 5 then
        table.insert(self.powerups, GrowPaddle(x, y))
    end
end

function PlayState:spawnRandomPowerUp()
    local rnd_x = math.random(16, VIRTUAL_WIDTH - 16)
    local rnd_y = math.random(32, VIRTUAL_HEIGHT / 2 + 16 )
    local powerup
    local rnd = math.random(100)
    if rnd <= 20 then
        powerup = GrowPaddle(rnd_x, rnd_y)
    elseif self.containsLockedBrick and not keyActive then
        powerup = Key(rnd_x, rnd_y)
    else
        powerup = BonusBall(rnd_x, rnd_y)
    end
    table.insert(self.powerups, powerup)
end