--[[
    CS50
    -- Powerup Class --

    Represents a powerup which will randomly spawn after a brick is hit, descending 
    toward the bottom. If the paddle will pick up it, it will gains a new
    temporary power.
]]

BallMultiplier = Class{__includes = Powerup}

function BallMultiplier:init(x, y)
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16

    self.x = x
    self.y = y

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = POWERUP_GRAVITY
    self.dx = 0

    self.timer = 0

    self.frame = gFrames['powerups'][9]

    self.type = "ball_multiplier"
end

function BallMultiplier:activate(game)
        index = rnd(1, #game.balls)
        motherBall = game.balls[index]

        tempBall1 = Ball()
        lazyClone(motherBall, tempBall1)
        tempBall1.dy = tempBall1.dy - 20

        tempBall2 = Ball()
        lazyClone(motherBall, tempBall2)
        tempBall2.skin = math.random(7)

        table.insert(game.balls, tempBall1)
        table.insert(game.balls, tempBall2)
end

function lazyClone(ball, tempBall)
    tempBall.x = ball.x
    tempBall.y = ball.y
    tempBall.dx = ball.dx
    tempBall.dy = ball.dy
    tempBall.skin = math.random(7)

    if(tempBall.dy > 0) then
        tempBall.dy = - tempBall.dy
    end
end