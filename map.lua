local bump = require'libs.bump.bump'
local Entities = require'entities'
-- print("Entities = "..tostring(Entities))
local Class = require'libs.hump.class'
local Timer = require'libs.hump.timer'
local sti = require'libs.Simple-Tiled-Implementation.sti'
-- local cartographer = require'libs.cartographer.cartographer'
local lg = love.graphics
Map = {}
Map.__index = Map

LAST_SECTION = nil; -- idk if i want sections yet

function Map.create(level, map)
    local self = setmetatable({}, Map)  
    self.levelNumber = level
    self.mapNumber = map
    self.assets = img["level_"..tostring(self.levelNumber)]
        ["map_"..tostring(self.mapNumber)]


    -- todo fixme
    -- we want the maps to be like this
    -- but first i need to get map loading working
    -- maps
    -- |         |        |
    -- \level_0  \level_1 \level_2
    --  |         |        |
    --  \ room_0  \ room_0 \ room_0
    --    room_1    room_1   room_2
    local levelFileName = "maps/map"..level..".lua";

    self.mapData = sti(levelFileName, { 'bump' })
    -- set layer objects on to the self obj
    self:prepLayers(self.mapData.layers)

    self.width = self.mapData.width
    self.height = self.mapData.height

    self.world = bump.newWorld(32) 
    self.hitBoxWorld = bump.newWorld(32)
    self.mapData:bump_init(self.world)
    -- TODO FIXME, figure out if this is good or bad!
    self.mapData:bump_init(self.hitBoxWorld)

    self.entities = Entities(self)
    self.hitBoxes = Entities(self)
    self.triggers = Entities(self)
    self.objects = {}
    self.particles = {}
    self.enemies = {}
    self.npcs = {}
    self.items = {}

    self.screenShake = false

    self:populate()
    return self
end

function Map:prepLayers(layers)
    -- obj layers
    self.levelTriggers = self.mapData.layers['level_triggers']
    self.spawnPoints = self.mapData.layers['spawn_points'];
    -- sprite layers
    self.frontLayer = self.mapData.layers['front_sprite']
    self.foreGroundLayer = self.mapData.layers['foreground_sprite']
    self.backGroundLayer = self.mapData.layers['background_sprite']
    self.farBackGroundLayer = self.mapData.layers['far_background_sprite']
    self.furtherMostBackGroundLayer = self.mapData.layers['further_most_background_sprite']
end

function Map:get(x,y)
    if x < 0 or y < 0 or x > self.width or y > self.height then
        return 0
    else
        return self.mapData[y*self.width+x+1]
    end
end

function Map:addEntityToWorld(entity)
    self.entities:add(entity)
    -- print("entity.name = "..entity.name)
    self.world:add(
        entity,
        entity.x, entity.y,
        entity.w, entity.h
    )
end

function Map:addEntityToHitBoxWorld(hitBox)
    self.hitBoxes:add(hitBox)
    self.hitBoxWorld:add(
        hitBox,
        hitBox.x, hitBox.y,
        hitBox.w, hitBox.h
    )
end

function Map:getTriggerToSpawn(triggerName)
    local trigs = {
        MapEnd = function(x,y,w,h)
            self.MapEnd = MapEnd(x,y,w,h)
            -- print("mapend = "..tostring(self.MapEnd))
            self.triggers:add(self.MapEnd)
            return self.MapEnd
        end,
        EnemyCollision = function(x,y,w,h)
            local enColl = EnemyCollision(x,y,w,h)
            self.triggers:add(enColl)
            self.world:add(
                enColl,
                enColl.x, enColl.y,
                enColl.w, enColl.h
            )
        end
    }
    local returnTrigger = trigs[triggerName]
    -- print("return Trigger = "..tostring(returnTrigger))

    if not returnTrigger then
        return function()
            return nil
        end
    else
        return returnTrigger
    end
end

-- todo fixme, this function is going to get
-- way out of hand and needs to be factored to be handled
-- i'm imagining there would be a player object check
-- and then some sort of base case depending on an object type
function Map:getObjectToSpawn(objName)
    -- print("objName = "..tostring(objName))
    objects = {
        Player = function (x, y)
            self.player = Player(x,y)
            self:addEntityToWorld(self.player)
            self:addEntityToHitBoxWorld(self.player.hitBox)
            -- print("player collisions = "..tostring(self.player.collisions))
            return self.player
        end,
        BaseEnemy = function (x, y)
            local baseEnemy = BaseEnemy(x,y)
            print("baseEnemy = "..tostring(baseEnemy))
            self:addEntityToWorld(baseEnemy)
            self:addEntityToHitBoxWorld(baseEnemy.hitBox)
            print("base_enemy collisions = "..tostring(baseEnemy.collisions))
        end,
    }
    local returnObject = objects[objName]
    -- didn't find a callable object
    -- return a closure with nil to avoid
    -- a lua err
    if not returnObject then
        return function ()
            return nil
        end
    else 
        return objects[objName]
    end
end

--[[
@description
    this function loads objects according to there
    placement on the tiled map

@future
    we will want to be getting towards this
        object = _G[type](arguments)
    as the if else 
    here is dirty and more than likely
    hard to imagine
@update 
    i actually prefer this way of adding entities for now, and im not
    super excited to move into the _G[type] method so i probably wont be
    using it 
--]]
function Map:populate()
    for key, value in pairs(
        self.spawnPoints.objects
    ) do
        local obj = value
        if obj.name then
            -- print("obj.name = "..tostring(obj.name))
            local new_entity = self:getObjectToSpawn(obj.name)(obj.x, obj.y)
            local get_result = self:get(obj.x, obj.y)
            -- print("get_result = "..tostring(get_result))
        end
    end

    for key, value in pairs(
        self.levelTriggers.objects
    ) do
        local trigger = value
        if trigger.name then
            -- print("trigger.name = "..tostring(trigger.name))
            local new_trigger = self:getTriggerToSpawn(trigger.name)(
                trigger.x,trigger.y,trigger.width,trigger.height,
                trigger.properties,
                self.map
            )
        end
    end
end


--[[
(RectA.Left < RectB.Right && RectA.Right > RectB.Left &&
     RectA.Top > RectB.Bottom && RectA.Bottom < RectB.Top ) 
-- dirty rect to avoid creating a "world"
--]]
--TODO broken
function Map:playerTriggerOverLap()
    local activateFn = function(player, obj)
        if not obj.pressable then
            obj.active = true
            print("activated a trigger via walking over it")
        else
            obj.active = player.doingAction
            if player.doingAction then
                print("activating a trigger via hitting the action button")
            end
        end
    end

    self:rectOverLap(
        self.triggers.entityList,
        self.player,
        activateFn
    )
end

function Map:rectOverLap(layer, checkObject, checkObjectFn)
    for key, obj in pairs(layer) do
        if
            collX(
                -- left
                checkObject.x,
                -- right
                checkObject.x + checkObject.w,
                -- left
                obj.x,
                -- right
                obj.x + obj.w
            ) 
        and
            collY(
                -- top
                checkObject.y,
                -- bottom
                checkObject.y + checkObject.h,
                -- top
                obj.y,
                -- bottom
                obj.y + obj.h
            )
        then
            -- lua will not complain if an argument
            -- is not specified in the function
            checkObjectFn(checkObject, obj)
        end
    end
end

-- self.foreGroundLayer
function Map:sensorOverLap()
    local OverLapFn = function()
    end
end

function Map:checkForRespawn()
    local collisionFilter = function(item, other)
        return 'cross'
    end

    if (self.player.Respawn) then
        self.doRespawn = false
        self.world:move(
            player,
            self.player.spawnX,
            self.player.spawnY,
            collisionFilter
        )
        self.hitBoxWorld:move(
            player.hitBox,
            self.player.hitBox.x,
            self.player.hitBox.y,
            collisionFilter
        )
    end

end

function Map:moveObjects(entityList,dt)
    local attackHbox = nil
    for key, obj in pairs(entityList) do
        local newX;
        local newY;
        local world;
        if obj.name == "HitBox" then
            if obj.attack then
                attackHbox = true
            end
            world = self.hitBoxWorld
        else
            world = self.world
        end

        newX, newY, collisions, len = world:move(
            obj,
            obj.x, obj.y,
            obj.getCollisionFilter
        )

        obj.x = newX
        obj.y = newY
        obj:handleCollisions(collisions,dt)
    end
end

function Map:checkForNewSpawningObject()
    local addHitBox = function(hitBox)
        if not self.hitBoxes:exists(hitBox) then
            self:addEntityToHitBoxWorld(hitBox)
        end
    end

    for key, obj in pairs(self.entities.entityList) do
        if obj.attackHitBox then
            addHitBox(obj.attackHitBox)
        end
        if obj.attackHitBoxes then
            for i, attackHitBox in ipairs(obj.attackHitBoxes) do
                addHitBox(attackHitBox)
            end
        end
    end

    for key, hitBox in pairs(self.hitBoxes.entityList) do
        -- does the hitbox no longer have a
        -- object reference?
        -- clear it off of the world
        if not hitBox.obj then
            print("found a hitbox without obj ref")
            self.hitBoxes:remove(hitBox)
            self.hitBoxWorld:remove(hitBox)
        end
    end
end

function Map:turnScreenShakeOff()
    self.screenShake = false
end

function Map:handleAttack(attack)
    local attacker = attack.attacker;
    local target = attack.target
    local healthAfterAtk = target.health - attacker.attackDmg
    target:setDamage(attacker.attackDmg)
    --[[ good spot for screen shake ]]--
    self.screenShake = true
    Timer.after(0.1, function() self.screenShake = false end)
end

function Map:handleAttacks()
    for _, object in ipairs(self.entities.entityList) do
        if not empty(object.attacks) then
            -- print('len of attacks before'..tostring(#object.attacks))
            for _, attack in ipairs(object.attacks) do
                self:handleAttack(attack)
            end
            object:clearAttacks()
            -- print('len of attacks after'..tostring(#object.attacks))
        end
    end
end

function Map:removeInactiveEntities()
    for index, object in pairs(self.entities.entityList) do
        if not object.active then
            print('object.active = '..tostring(object.active))
            object:destroy()
            self.entities:removeAt(index)
            self.world:remove(object)

            local hbox = object.hitBox
            if hbox then
                hbox.obj = nil
                self.hitBoxes:removeAt(index)
                self.hitBoxWorld:remove(hbox)
            end
        end
    end
end

function Map:update(dt)
    Timer.update(dt)
    self:checkForRespawn()
    self:removeInactiveEntities()
    -- print("self.player.doingAction = "..tostring(self.player.doingAction))
    self:playerTriggerOverLap()
    self.entities:update(dt)
    -- updated all of the data?
    -- time to move the stuff and then handle collisions
    -- hitBoxes will be updated by the entities that hold them
    self.triggers:update(dt)
    self.mapData:update(dt)

    self:checkForNewSpawningObject()

    -- two calls to moveObjects
    -- once for the entities, then the hitboxes
    self:moveObjects(self.entities.entityList, dt)
    self:moveObjects(self.hitBoxes.entityList, dt)

    self:handleAttacks()
end

function Map:draw(trans_x, trans_y)
    -- todo fixme, this can be handled a bit easier later on
    self.furtherMostBackGroundLayer:draw()
    self.farBackGroundLayer:draw()
    self.backGroundLayer:draw()
    self.foreGroundLayer:draw()
    self.frontLayer:draw()
    self.triggers:draw()
    self.entities:draw()
    return true
end
