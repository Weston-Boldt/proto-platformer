return {
    moving = false,
    canAttack = true,
    attackDir = AD_UP,
    needToLaunch = false,
    attacks = {},
    objType = 'Entity',
    name = 'Entity',

    collisions = {},
    friction = 0,

    launchAngle = nil,

    -- an entity has a good chance of having a hitbox
    hitBox = nil,
    -- singular attack
    attackHitBox = nil,

    attackTime = P_ATTACK_TIME_MAX,
    doRespawn = false,
    -- mutliple attacks ? todo fixme
    -- i don't know about this yet
    attackHitBoxes = nil,
    health = BASE_HEALTH,
    health_max = BASE_HEALTH,
    attackDamage = BASE_ATTACK,
    active = true,
    jumpTime = JUMP_TIME_MAX,

    attack_hit_box_w = SZ_TILE,
    attack_hit_box_h = SZ_DBL_TILE,

    launch_hit_box_w = SZ_DBL_TILE,
    launch_hit_box_h = SZ_DBL_TILE,

    gravity = NORMAL_GRAVITY + (NORMAL_GRAVITY / 4),
}
