--[[
    GD50 2018
    Breakout Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle movement speed
PADDLE_SPEED = 200

-- CS50: power-up gravity
POWERUP_GRAVITY = 20

-- CS50: odds of powerup spawning
POWERUP_SPAWNING_ODDS = 1

-- CS50: ball base speed
BALL_SPEED = 100

-- CS50: key powerup duration
MAX_KEY_TIME = 5

-- CS50: key powerup duration
MAX_ATTRACTOR_TIME = 10

--CS50: locked brick spawning odds
LOCKED_BRICK_SPAWNING_ODDS = 1