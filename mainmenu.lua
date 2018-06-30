mainmenu={}

function mainmenu.enter()
    state = STATE_MAIN_MENU
end

function mainmenu.update()
end

function mainmenu.draw() 
    love.graphics.print("hello world");
end

function mainmenu.keypressed(k, uni)
    if k == "return" or k == " " or k == "escape" then
        ingame.enter()
    end
end
