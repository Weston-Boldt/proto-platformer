return {
    height = 32,
    width = 32,
    brake_speed = 350,
    max_speed = 50,
    jump_time_max = 0.5,
    attack_time_max = 0.5,
    base_acc = 45,
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
}
