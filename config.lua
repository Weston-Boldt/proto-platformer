config_keys = {
    up = "up",
    down = "down",
    left = "left",
    right = "right",
    jump = "d",
    shoot = "s",
    action = "a",
    respawn = "r",
}

keynames = {"up","down","left","right","jump","shoot","action"}

config_joykeys = {
    jump = 1, shoot = 3, action = 2, pause = 8
}

keystate = {
    up = false, down = false, left = false, right = false,
    jump = false, shoot = false, action = false,
    -- joystick stuff
    oldaxis = 0, oldaxis2 = 0
}
