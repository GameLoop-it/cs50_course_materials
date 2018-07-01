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

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level

    self.recoverPoints = 5000

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    -- CS50: powerup table
    self.powerups = {}

    --CS50: ball table
    self.balls = {}

    table.insert(self.balls, self.ball)

    self.lockedBrick = checkLockedBrick(self.bricks)
    self.keyPowerup = nil

    self.attractor = false
end

function PlayState:update(dt)

    -- pause functionality 
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

    -- key powerup spawning controller
    if self.lockedBrick and self.keyPowerup == nil then
        self.keyPowerup = KeyUnlock(rnd(1, VIRTUAL_WIDTH - 16), 0)
        table.insert(self.powerups, self.keyPowerup)
    end

    if #self.paddle.power > 0 then
        for k, power in pairs(self.paddle.power) do  
            if self.paddle.power[k].type == "key" then
                if (love.timer.getTime() - self.paddle.power[k].timer) < MAX_KEY_TIME then
                    self.lockedBrick = false;
                else
                    self.lockedBrick = true;
                    table.remove(self.paddle.power, k)
                    self.keyPowerup = nil
                end
            elseif self.paddle.power[k].type == "attractor" then
                if (love.timer.getTime() - self.paddle.power[k].timer) < MAX_ATTRACTOR_TIME then
                    self.attractor = true;
                else
                    self.attractor = false;
                    table.remove(self.paddle.power, k)
                end
            end
        end
    end

    if self.attractor and love.keyboard.wasPressed('z') then
       self.attractor = false
    end
    
    -- update positions based on velocity
    self.paddle:update(dt, self)

    if #self.balls > 0 then
        for k, ball in pairs(self.balls) do
            ball:update(dt, self.paddle)
        end
    end

    -- CS50: powerup update
    if #self.powerups > 0 then
        for k, powerup in pairs(self.powerups) do
            
            powerup:update(dt)

            -- POWERUP COLLISION LOGIC
            if powerup:collides(self.paddle) then
                table.remove(self.powerups, k)

            -- POWERUP ACTIVATION LOGIC
                powerup:activate(self)
            end

            if powerup.y > VIRTUAL_HEIGHT then
                table.remove(self.powerups, k)
                if(powerup.type == "key") then
                    self.keyPowerup = nil
                end
            end
        end
    end

    if #self.balls > 0 then
        for k, ball in pairs(self.balls) do
            if ball:collides(self.paddle) then
                ballPaddleCollision(ball, self.paddle, self.attractor)
            end
        end
    end
    
    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        if #self.balls > 0 then
            for j, ball in pairs(self.balls) do
                -- only check collision if we're in play
                if brick.inPlay and ball:collides(brick) then

                    -- add to score
                    if(brick.color ~= 6) then
                        self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    else
                        if(brick.tier == 1) then
                            self.score = self.score + (1000 + brick.color * 25)
                        end
                    end

                    -- trigger the brick's hit function, which removes it from play
                    brick:hit(self)

                    -- CS50: spawn a new powerup if possible
                    if brick.isSpawner then
                        if rnd() > 0.5 then
                            powerup = BallMultiplier(brick.x + brick.width / 2 - 8, brick.y)
                        else 
                            powerup = Attractor(brick.x + brick.width / 2 - 8, brick.y)
                        end
                        table.insert(self.powerups, powerup)
                    end

                    -- if we have enough points, recover a point of health
                    if self.score > self.recoverPoints then
                        -- can't go above 3 health
                        self.health = math.min(3, self.health + 1)

                        -- multiply recover points by 2
                        self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                        -- CS50: shrink paddle when a point of health is recovered
                        self.paddle:shrink()

                        -- play recover sound effect
                        gSounds['recover']:play()
                    end

                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = self.ball,
                            recoverPoints = self.recoverPoints
                        })
                    end

                    ballBrickCollision(ball, brick)
                    -- only allow colliding with one brick, for corners
                    break
                end
            end
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if #self.balls > 0 then
        for j, ball in pairs(self.balls) do
            if ball.y >= VIRTUAL_HEIGHT then
                if #self.balls == 1 then
                    self.health = self.health - 1

                    --CS50: grow the paddle when a point of health is lost
                    self.paddle:grow()

                    gSounds['hurt']:play()

                    if self.health == 0 then
                        gStateMachine:change('game-over', {
                            score = self.score,
                            highScores = self.highScores
                        })
                    else
                        self.paddle.power = {}
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
                else
                    table.remove(self.balls, j)
                    ball = nil
                end
            end
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt, self)
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

    if #self.balls > 0 then
        for k, ball in pairs(self.balls) do
            ball:render()
        end
    end

    -- CS50: powerup render
    if(#self.powerups > 0) then
        for k, powerup in pairs(self.powerups) do
            powerup:render()
        end
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

function ballPaddleCollision(ball, paddle, attractor)
    -- raise ball above paddle in case it goes below it, then reverse dy
        ball.y = paddle.y - 8
        ball.dy = -ball.dy

        --
        -- tweak angle of bounce based on where it hits the paddle
        --
        -- if we hit the paddle on its left side while moving left...
        if ball.x < paddle.x + (paddle.width / 2) and paddle.dx < 0 then
            ball.dx = -50 + -(8 * (paddle.x + paddle.width / 2 - ball.x))
        
        -- else if we hit the paddle on its right side while moving right...
        elseif ball.x > paddle.x + (paddle.width / 2) and paddle.dx > 0 then
            ball.dx = 50 + (8 * math.abs(paddle.x + paddle.width / 2 - ball.x))
        end

        ball.stuck = attractor

        gSounds['paddle-hit']:play()
end

function ballBrickCollision(ball, brick)
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
end

function checkLockedBrick(bricks)
    for k, brick in pairs(bricks) do
        if(brick.color == 6) then
            return true
        end
    end
    return false
end