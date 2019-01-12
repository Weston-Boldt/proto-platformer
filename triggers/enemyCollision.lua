local Class = require'libs.hump.class'
local Trigger = require'trigger'

EnemyCollision = Class{
    __includes = Trigger
}

function EnemyCollision:init(x,y,w,h,properties)
    Trigger:init(self,x,y,w,h)
    self.name = "EnemyCollision"
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.map = map
    self.properties = properties
    self.img = love.graphics.newImage(
        'assets/entity_stub.png'
    )
    self.pressable = true

    self.active = false
    return self
end

function EnemyCollision:handleCollisions()
    print("am i being called?")
end
