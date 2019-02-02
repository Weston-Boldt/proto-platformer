local Class = require'libs.hump.class'
local Timer = require'libs.hump.timer'

StPlayerAttacking = Class {
    __includes = StBase
}

function StPlayerAttacking:init(obj)
    self = StBase.init(self,obj)
    self.name = 'attack'
    return self
end

function StPlayerAttacking:enter()
    local obj = self.obj
    if not obj.canAttack
    or obj.state == 'launch' then
        print(obj.state)
        return
    end
    obj.canAttack = false
    obj.xspeed = 0
    obj.yspeed = 0
    Timer.after(0.8, function()
        obj.canAttack=true
    end)

    if not obj.jumpTime == obj.jump_time_max then
        obj.letGoOfJump = true
        obj.jumpTime = 0
    end

    obj.attackDir = obj:getAttackDir()

    local hbX = obj:getAttackHitBoxX()
    local hbY = obj:getAttackHitBoxY()
    local hbW, hbH = obj:getAttackHitBoxWH()

    obj.attackHitBox = HitBox(obj,
        hitBoxX, hitBoxY,
        hbW, hbH
    )

    obj.state = 'attack'
end

function StPlayerAttacking:update(dt)
    local obj = self.obj
    if obj.attackTime > (obj.attack_time_max - (obj.attack_time_max / obj.attack_start_up_div)) then
        if (keystate.left and obj.dir ~= LEFT)
        or (keystate.right and obj.dir ~= RIGHT) then
            obj.lastDir = obj.dir
            obj.dir = obj.dir * -1
        end

        obj.attackDir = obj:getAttackDir()
        obj.attackHitBox.x, obj.attackHitBox.y,
        obj.attackHitBox.w, obj.attackHitBox.h = obj:getAttackHitBoxRect()

        obj.launchAngle = obj:getLaunchAngle()
    else
        obj.attackHitBox.attack = true
    end

    if obj.attackTime > 0 then
        obj.attackTime = obj.attackTime - dt
    else
        -- print("about to detatch")
        -- detatch the hitbox off the object
        -- to get swept up and removed by the 
        -- print("before "..tostring(obj.attackHitBox.obj))
        obj:detachHitBox('attackHitBox')

        obj.attackTime = obj.attack_time_max
        if obj.needToLaunch then
            print('about to launch')
            obj:changeState('launch')
        else
            self:exit()
        end
    end
end
