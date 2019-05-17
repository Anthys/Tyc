function solid(x,y)
    if x == 120 then x = 119
    elseif x>(240//2)-1 then x=240-x end
    --if y>136//2 then y=y-136//2 end
    --if game.part and x<240//2 then x=240-240//2-x end
    --if x<0 then x=240
    if x>240 then x=0 end
    if y<0 then y=136
    elseif y>136 then y=0 end
    local nul
    return solids[mget((x)//8+game.part*15+(game.t)*30,(y)//8)]
end

function spawnplayer()
    tab.breaker = 0
    tab.inbreaker = 0
    tab.posbreak = {}
    for i=(game.t%8)*30+game.part*15,(game.t%8)*30+game.part*15+14 do
        for j=(game.t//8)*17,(game.t//8)*17+16 do
            if mget(i,j) == 15 then p.x = ((i-game.part*15)%30)*8 p.y = j%17*8 end
            if mget(i,j) == 36 then tab.breaker=tab.breaker+2 tab.inbreaker=tab.inbreaker+2 end
        end
    end
end

function init()
    solids={[1]=true,[17]=true}
    p={
    x=120,
    y=68,
    vx=0, --Velocity X
    vy=0, --Velocity Y
    tp = false
    }
    game={
        t=0,
        part=0,
        coldone = {},
        ccol = 14,
    }
    tab={
        breaker=0,
        inbreaker=0,
        posbreak={}
    }
    game["cin"] = peek(0x03FC0 + 0x3*game.ccol)
    spawnplayer()
end

init()
function TIC()
    local env = 7

    if btn(2) then p.vx=-1
        elseif btn(3) then p.vx=1
        else p.vx=0
    end
    
    if solid(p.x+p.vx,p.y+p.vy) or solid(p.x+env+p.vx,p.y+p.vy) or solid(p.x+p.vx,p.y+env+p.vy) or solid(p.x+env+p.vx,p.y+env+p.vy) then
        p.vx=0
    end
    
    if solid(p.x,p.y+8+p.vy) or solid(p.x+env,p.y+8+p.vy) then
        p.vy=0
    else
        p.vy=p.vy+0.2
    end
    
    if p.vy==0 and btnp(4) then p.vy=-2.5 end

    if p.vy<0 and (solid(p.x+p.vx,p.y+p.vy) or solid(p.x+env+p.vx,p.y+p.vy)) then
        p.vy=0
    end   

    --if p.vy > 4 then p.vy =4 end

    checkjump()

    p.x=p.x+p.vx
    p.y=p.y+p.vy
    
    if p.x>240 then p.x=0
    elseif p.x<0 then p.x=240
    end
    if p.y>136 then p.y=0
    elseif p.y<0 then p.y=136
    end

    local speedlight = 2
    local temp = pos2map(p.x, p.y)
    if mget(temp[1], temp[2])==20 or mget(temp[1]+lor(), temp[2])==20 then
        p.tp = true
        local val = peek(0x03FC0 + 0x3*game.ccol)
        if val<255-speedlight and val<255-tab.breaker*((255-game.cin)/tab.inbreaker) then poke(0x03FC0 + 0x3*game.ccol, val+speedlight) end
    else 
        p.tp=false
        local val = peek(0x03FC0 + 0x3*game.ccol)
        if val>148-speedlight*2 then poke(0x03FC0 + 0x3*game.ccol, val-speedlight/10) end
    end

    cls()
    makemap()
    progress()
    if peek(0x03FC0 + 0x3*game.ccol)>255-speedlight-1 then print("Ready to teleport") end
    print(tab.breaker, 50, 50)
    renderp()
    checkinput()
end

function progress()
    local lenprogress = 80
    local val = (peek(0x03FC0 + 0x3*game.ccol) - game.cin)/(255-game.cin)*lenprogress
    rect(120-lenprogress//2, 130, val, 4, game.ccol)
end

function checkjump()
    --check jump and breaker
    if mget(pos2map(p.x, p.y)[1], pos2map(p.x, p.y)[2]+1) == 17 or mget(pos2map(p.x, p.y)[1] +lor(), pos2map(p.x, p.y)[2]+1) == 17 then
        p.vy = p.vy - 4
    end
    if (mget(pos2map(p.x, p.y)[1], pos2map(p.x, p.y)[2]) == 36 or mget(pos2map(p.x, p.y)[1] +lor(), pos2map(p.x, p.y)[2])==36) and ((not tab.posbreak[(p.x//8+1)*30+p.y//8]) and (not tab.posbreak[(p.x//8)*30+p.y//8])) then
        local px = p.x + 8*int(mget(pos2map(p.x, p.y)[1] +lor(), pos2map(p.x, p.y)[2])==36)
        tab.posbreak[(px//8)*30+ p.y//8]=true
        trace(px//8) trace(p.y//8)
        tab.breaker=tab.breaker-1
    end
end

function int(bool)
    if bool then return 1 else return 0 end
end

function lor()
    -- left or right
    if p.x<120 then return 1 else return -1 end
end

function pos2map(x, y)
    if x>119 then x=240-x end
    return {x//8 + 30*(game.t%8) + 15*game.part, y//8+17*(game.t//8)}
end

function checkinput()
    if p.tp then
    if key(28) then game.t = 0 game.part = 0 spawnplayer()
    elseif key(29) then game.t = 0 game.part = 1 spawnplayer()
    elseif key(30) then game.t = 1 game.part = 0 spawnplayer()
    elseif key(31) then game.t = 1 game.part = 1 spawnplayer()
    end
    end
    if key(32) then trace('j')
    for i,j in pairs(tab.posbreak) do trace(i) trace(j) end
end
end

function makemap()
    map((game.t%8)*30+game.part*15, (game.t//8)*17, 15*(game.part+1), 17*(game.part+1))
    map((game.t%8)*30+game.part*15, (game.t//8)*17, 15*(game.part+1), 17*(game.part+1), 240//2, 0, -1, 1, 
    function (tile, x, y)
        return mget((game.t%8)*30+15*(game.part+1)-x%15-1,y), 1
    end )
end

function renderp()
    local cutx
    local cuty
	if p.x+8>240 then cutx=true
    end
    if p.y+8>136 then cuty=true
    end
    if cutx and cuty then
        rect(p.x, p.y, 240-p.x, 136-p.y, 15)
        rect(p.x, 0, 240-p.x, p.y+8-136, 15)
        rect(0, 0, p.x+8-240, p.y+8-136, 15)
        rect(0, p.y, p.x+8-240, 136-p.y, 15)
    elseif cutx then
        rect(p.x, p.y, 240-p.x, 8, 15)
        rect(0, p.y, p.x+8-240, 8, 15)
    elseif cuty then
        rect(p.x, p.y, 8, 136-p.y, 15)
        rect(p.x, 0, 8, p.y+8-136, 15)
    else
        rect(p.x,p.y,8,8,15)
    end
end