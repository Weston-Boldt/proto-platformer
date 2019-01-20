local Class = require'libs.hump.class'

StPlayerAttacking = Class {
    __includes = StBase
}

function StPlayerAttacking:init(obj)
    self = StBase.init(self,obj)
    return self
end

function StPlayerAttacking:exit(obj)
    self.state = nil
end

function StPlayerAttacking:enter()
    local obj = self.obj
    if obj.state == 'psRun'
    or not self.canAttack
    or self.state == 'psLaunch' then
        return
    end

    obj.xspeed = 0
    obj.yspeed = 0
    Timer.after(0.8, function()
        obj.canAttack=true
        self:exit()
    end)

    if not obj.jumpTime == obj.jump_time_max then
        obj.letGoOfJump = true
        obj.jumpTime = 0
    end

    obj.state = PS_SHOOTING;

    obj.attackDir = obj:getAttackDir()

    local hbX = obj:getAttackHitBoxX()
    local hbY = obj:getAttackHitBoxY()
    local hbW, hbH = obj:getAttackHitBoxWH()

    obj.attackHitBox = HitBox(obj,
        hitBoxX, hitBoxY,
        hbW, hbH
    )

    obj.state = 'psAttack'
end

function StPlayerAttacking:update(dt)
    local obj = self.obj
    if obj.attackTime > (self.attack_time_max - (self.attack_time_max / self.attack_start_up_div)) then

        local attackDir = obj.getAttackDir()
        if obj.attackDir ~= attackDir then
            obj.attackDir = attackDir
        end

        if (keystate.left and obj.dir ~= LEFT)
        or (keystate.right and obj.dir ~= RIGHT) then
            obj.lastDir = obj.dir
            obj.dir = obj.dir * -1
            obj.attackHitBox.attack = false
            obj.attackHitBox.x = obj.getAttackHitBoxX()
        end
        obj.launchAngle = obj.getLaunchAngle()
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
        obj.detachHitBox('attackHitBox')

        obj.attackTime = self.attack_time_max
        if obj.needToLaunch then
            obj.launch(dt)
        else
            obj.state = PS_RUN
        end
    end
end
