Powerup = Class{}

function Powerup:init(type, x, y)
    self.type = type
    self.height = 16
    self.width = 16
    self.x = x
    self.y = y
    self.dy = 25
    self.active = false
end

function Powerup:collides(paddle)
        -- first, check to see if the left edge of either is farther to the right
        -- than the right edge of the other
        if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
            return false
        end

        -- then check to see if the bottom edge of either is higher than the top
        -- edge of the other
        if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
            return false
        end 

        -- if the above aren't true, they're overlapping
        return true
end

function Powerup:update(dt)
    if not self.active then
        self.y = self.y + self.dy * dt
    end
end

function Powerup:render()
    if not self.active then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type], self.x, self.y)
    end
end

function Powerup:activate() end

function Powerup:addBall(playState)
    local n = math.random(1, #(playState.balls))
    local ball_a = Ball(math.random(7), playState.balls[n].x, playState.balls[n].y)
    local ball_b = Ball(math.random(7), playState.balls[n].x, playState.balls[n].y)
    ball_a.dx = playState.balls[n].dx - 5
    ball_b.dx = -playState.balls[n].dx + 5
    ball_a.dy = playState.balls[n].dy
    ball_b.dy = playState.balls[n].dy
    table.insert(playState.balls, ball_a)
    table.insert(playState.balls, ball_b)
    table.remove(playState.balls, n)
end

function Powerup:growPaddle(playState)
    playState.paddle:grow()
end

function Powerup:shrinkPaddle(playState)
    playState.paddle:shrink()
end

function Powerup:unlockLockedBrick(playState)
    keyActive = true
end