--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Karbb
]]

GameObjectAnimable = Class{}

function GameObjectAnimable:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit

    self.animationFrames = def.animationFrames
    self.animation = Animation {
        frames = self.animationFrames,
        interval = 0.56
    }
    self.currentAnimation = self.animation
    self.currentFrame = self.animationFrames[0]
end

function GameObjectAnimable:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObjectAnimable:update(dt)
    self.currentAnimation:update(dt)
end

function GameObjectAnimable:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], self.x, self.y)
end