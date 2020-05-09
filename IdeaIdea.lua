LENX = 240
LENY = 136

game = {
 s=1
}

t=0

ST = {'intro'}

cos = math.cos
abs= math.abs
sin = math.sin
max = math.max
min = math.min

debug = false

colors = "black, white, red, blue, yellow, pink, purple, orange, brown, green"
shades = "dark, light"

places_population = "royal, bandit, wizard, thief, knight, witch, orc"
places_adj = "mechanical, overgrown, mystical, abandoned, secluded, quiet, cursed"
places_places = "camp, castle, town, village, sanctuary, outpost"

trucs = {"a","b","c","d", "e", "f", "g", "h",'i', 'j', 'k'}

function intro2()
    cls()
    size_y = 6
    on_screen = 4
    x0,y0 = 50,50
    rectb(x0,y0,50,20, 1)
    for i=1,on_screen do
        local temp = (i-1+math.floor(t/(10*size_y)))%#trucs+1
        trace(temp)
        local txt = trucs[temp]
        print(txt, 0,50+size_y*i+(t/10)%size_y)
    end
end

things = {}

function create_obj(x,y,txt,speedx,speedy,endx,endy)
    local temp = {}
    temp.x = x
    temp.y = y
    temp.txt = txt
    temp.speedx = speedx
    temp.speedy = speedy
    temp.endx = endx
    temp.endy = endy
    return temp
end

function intro()
    cls()
    size_y = 6
    on_screen = 4
    x0,y0 = 50,50
    x1,y1 = 80,80
    rectb(x0,y0,50,20, 1)
    speed = t/100
    if speed*t%8==0 then
        local xx = x0
        local yy = y0-size_y
        local temp = create_obj(xx,yy,"super",0,speed,x1,y1)
        things[#things+1] = temp
    end
    for i=#things, 1,-1 do
        local temp = things[i]
        temp.speedy = speed
        temp.x = temp.x + temp.speedx
        temp.y = temp.y + temp.speedy
        print(temp.txt, temp.x, temp.y)
        if temp.x > temp.endx or temp.y > temp.endy then table.remove(things,i) end
    end

end

function TIC()
 _G[ST[game.s]]()
 t=t+1
end