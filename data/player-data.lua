return {
    name = 'Player',
    h = 64,
    w = 32,
    xspeed = 0,
    yspeed = 0,
    max_speed = P_MAX_SPEED,
    jump_time_max = 0.5,
    attack_time_max = 0.5,
    health_max = 5,
    base_damage = 1,
    damage_time_max = 0.5,
    xacc = 35,
    friction = 8,
    jumpAcc = 22,

    launch_time = 2,

    -- see 16 in updateShooting def (ATTACK_TIME_MAX - (ATTACK_TIME_MAX / 16))
    start_up_divisor = 16,

    launch_speed = 500,

    attack_hit_box_w = 32,
    attack_hit_box_h = 64,

    launch_hit_box_w = 64,
    launch_hit_box_h = 64,

    gravity = NORMAL_GRAVITY,
    jumpTime = JUMP_TIME_MAX,
    letGoOfJump = false,

    onGround = false,
    lastDir = RIGHT,
    dir = RIGHT,

    upDir = NEUTRAL,

    jumping = false,
    state = PS_RUN,

    attackHitBox = false,
    launchHitBox = false,
    attackTime = P_ATTACK_TIME_MAX,
    doRespawn = false,

    health = 5,
    attackDmg = BASE_DAMAGE,
    canAttack = true,
    attackDir = AD_HORIZONTAL,
    needToLaunch = false,

    --[[
    some weirdness here:
        math.pi         (180 deg) == directly up 
        0     (360 deg) (0 deg)   == directly down
        math.pi / 2     (90 deg)  == directly right
        3 * math.pi / 2 (270 deg) == directly left
    --]]
}
