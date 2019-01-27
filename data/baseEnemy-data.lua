return {
    w = BASE_ENEMY_WIDTH,
    h = BASE_ENEMY_HEIGHT,
    xspeed = 0,
    yspeed = 0,

    xacc = 25,
    moving = true,
    onGround = false,
    lastDir = RIGHT,
    dir = RIGHT,
    friction = 10,
    gravity = NORMAL_GRAVITY,
    state = ENS_RUN,
    health = BASE_HEALTH,

    active = true,

    damageTime = DAMAGE_TIME_MAX,

}
