--Jyss.lua


-- B Ball G Gripper L Lasor F Floater
-- spawn one new every room finished
ORDERS = {
    [1]="BBBBBBBBB"
}


function solid(x,y)
    if x == 120 then x = 119
    elseif x>(240//2)-1 then x=240-x end --or 239
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
    br={}
    tab.breaker = 0
    tab.inbreaker = 0
    tab.posbreak = {}
    for i=(game.t%8)*30+game.part*15,(game.t%8)*30+game.part*15+14 do
        for j=(game.t//8)*17,(game.t//8)*17+16 do
            if mget(i,j) == 15 then p.x = ((i-game.part*15)%30)*8 p.y = j%17*8 end
            if mget(i,j) == 36 then tab.breaker=tab.breaker+2 tab.inbreaker=tab.inbreaker+2 end
        end
    end
    if #ball<=tl(game.numdone) then table.insert(ball, {
        x=nposball(),
        y=0,
        vx=0,
        vy=1
    }) end
end

function nposball()
    local done=false
    while not done do
        x=math.random(0, 240)
        done=true
        for i,j in pairs(ball) do
            if RectIsct({x=x,y=0,w=16,h=16},{x=j.x, y=j.y,w=16,h=16}) then done=false end
        end
    end
    return x
end

function tl(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


JUMP_DY={-3,-3,-3,-3,-2,-2,-2,-2,
  -1,-1,0,0,0,0,0}
function init()
    solids={[1]=true,[17]=true}
    t=0
    br={}
    p={
        dx=0,
        dy=0,
    x=120,
    y=68,
    vx=0, --Velocity X
    vy=0, --Velocity Y
    tp = false,
    grounded = false,
    jump = 0,
    jumpseq=JUMP_DY
    }
    game={
        t=0,
        part=1,
        coldone = {},
        ccol = 14,
        numdone = {}
    }
    tab={
        breaker=0,
        inbreaker=0,
        posbreak={}
    }
    game["cin"] = peek(0x03FC0 + 0x3*game.ccol)
    ball = {
        {
            x=math.random(0, 240),
            y=0,
            vx=0,
            vy=1
        }
    }
    
    spawnplayer()
end

function UpdatePlayer()

    if not IsOnGround() then return end

end


init()
function TIC()
    local env = 7

    --[[

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
    
    if p.vy==0 and btnp(0) then p.vy=-2.5 end

    if p.vy<0 and (solid(p.x+p.vx,p.y+p.vy) or solid(p.x+env+p.vx,p.y+p.vy)) then
        p.vy=0
    end   

    --if p.vy > 4 then p.vy =4 end

    checkjump()

    p.x=p.x+p.vx
    p.y=p.y+p.vy
    ]]--
    if p.x>240 then p.x=0
    elseif p.x<0 then p.x=240
    end
    if p.y>136 then p.y=0
    elseif p.y<0 then p.y=136
    end

    
    cls()
    makemap()
    
    local speedlight = 2
    --[[
    local temp = pos2map(p.x, p.y)
    if mget(temp[1], temp[2])==20 or mget(temp[1]+lor(), temp[2])==20 then
        p.tp = true
        local val = peek(0x03FC0 + 0x3*game.ccol)
        if val<255-speedlight and val<255-tab.breaker*((255-game.cin)/tab.inbreaker) then poke(0x03FC0 + 0x3*game.ccol, val+speedlight)
        elseif val<255-speedlight then print(tab.breaker .. " remains",0, 130)
        end
    else 
        p.tp=false
        local val = peek(0x03FC0 + 0x3*game.ccol)
        if val>148-speedlight*2 then poke(0x03FC0 + 0x3*game.ccol, val-speedlight/10) end
    end
    ]]
    updateplr()
    
    progress()
    if peek(0x03FC0 + 0x3*game.ccol)>255-speedlight-1 then print("Ready to teleport") end
    if tab.breaker==0 and not game.numdone[game.t*2+game.part+1] then game.numdone[game.t*2+game.part+1]=true end
    
    renderbr()
    renderp()
    checkinput()
    rooms()
    timer()
    t=t+1
    balls()
    checkcoll()
    floatest()
    lastest()
    --if t%60%2==0 then floatest() end
end

function teleporter(bol)
    local speedlight = 2
    if bol then
        local val = peek(0x03FC0 + 0x3*game.ccol)
        if val<255-speedlight and val<255-tab.breaker*((255-game.cin)/tab.inbreaker) then poke(0x03FC0 + 0x3*game.ccol, val+speedlight)
        elseif val<255-speedlight then print(tab.breaker .. " remains",0, 130) elseif val>255-speedlight-1 then print("Ready to teleport") p.tp=true return
        end
        p.tp=false
    else 
        p.tp=false
        local val = peek(0x03FC0 + 0x3*game.ccol)
        if val>148-speedlight*2 then poke(0x03FC0 + 0x3*game.ccol, val-speedlight/10) end
    end
end



function respawn(obj)
    obj.x = nposball()
    obj.y = 0
end

thex=0
fx=0
fy=0


l1=0
l2=0
function lastest()
    if t%60==0 then l1=math.random(0, 240) l2=math.random(0, 240) end
    if t%60>0 and t%60<30 and t%60%10>4 then rect(l1,0,3,3,8) rect(l2, 132, 3, 3, 8) end
    if t%60>30 and t%60<50 then line(l1, 0, l2, 136,8) rect(l1,0,3,3,8) rect(l2, 132, 3, 3, 8) end
end

function floatest()
    local waves=4
    thex=thex+0.5
    if thex==240 then thex=0 end
    local x = thex
    fy=math.sin(x/240*math.pi*waves)*(136//2)+136//2
    spr(358, x, fy, 0)
end

function balls()
    for i,j in pairs(ball) do

        --[[
        if solid(j.x+j.vx,j.y+j.vy) or solid(j.x+7+j.vx,j.y+j.vy) or solid(j.x+j.vx,j.y+j.vy) or solid(j.x+7+j.vx,j.y+7+j.vy) then
            j.vx=-j.vx
        end
        
        if solid(j.x,j.y+8+j.vy) or solid(j.x+7,j.y+8+j.vy) then
            j.vy=-j.vy
        end
    
        if j.vy<0 and (solid(j.x+j.vx,j.y+j.vy) or solid(j.x+7+j.vx,j.y+j.vy)) then
            j.vy=-j.vy
        end   
        ]]
        if not CanMoveEx(j.x, j.y, {x=0,y=0,w=16,h=16},0) then respawn(j) end
        if not CanMoveEx(j.x+j.vx, j.y+j.vy, {x=0,y=0,w=16,h=16},0) then j.vy=-j.vy end

        j.x=j.x+j.vx
        j.y=j.y+j.vy

        if j.x>240 then j.x=0
        elseif j.x<0 then j.x=240
        end
        if j.y>136 then j.y=0
        elseif j.y<0 then j.y=136
        end
        renderspr(352, j.x, j.y, 2, 2, 0)
        
        if RectIsct({x=p.x, y=p.y, w=8, h=8}, {x=j.x, y=j.y, w=16, h=16}) then eject(j.x, j.y) end

    end
end

function eject(x, y)
    local stren = 1.5
    p.vx = (p.x+4-x-8)*stren
    p.vy = (p.y+4-y-8)*stren
end

function renderspr(s, x, y, sx, sy, col)
    local cutx
    local cuty
    if x+(8*sx)>240 then cutx=true end
    if y+(sy*8)>136 then cuty=true end
    if cutx and cuty then
        spr(s, x, y, col, 1, 0, 0,sx, sy)
        spr(s,x, -136+y,col, 1, 0, 0,sx, sy)
        spr(s, x-240, y, col, 1, 0, 0,sx, sy)
        spr(s,x-240, -136+y, col, 1, 0, 0,sx, sy)
    elseif cutx then
        spr(s,x, y,col, 1, 0, 0,sx, sy)
        spr(s,x-240, y, col, 1, 0, 0,sx, sy)
    elseif cuty then
        spr(s,x, y, col, 1, 0, 0,sx, sy)
        spr(s,x, -136+y, col, 1, 0, 0,sx, sy)
    else
        spr(s,x, y, col, 1, 0, 0,sx, sy)
    end
end

function timer()
    print(9-t//60%10 .. "." .. 60-t%60, 110, 20)
end

function rooms()
    for i=1,9 do
        if i == game.t*2+game.part + 1 then spr(479+i, 240-10*8+i*8, 128, 0)
        elseif game.numdone[i] then spr(463+i, 240-10*8+i*8, 128, 0)
        else spr(495+i, 240-10*8+i*8, 128, 0) end
    end
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
    if (mget(pos2map(p.x, p.y)[1], pos2map(p.x, p.y)[2]) == 36 or mget(pos2map(p.x, p.y)[1] +lor(), pos2map(p.x, p.y)[2])==36) and ((not tab.posbreak[((p.x+8)//8)*30+p.y//8]) and (not tab.posbreak[(p.x//8)*30+p.y//8])) then
        local px = p.x + 8*int(mget(pos2map(p.x, p.y)[1] +lor(), pos2map(p.x, p.y)[2])==36)
        tab.posbreak[(px//8)*30+ p.y//8]=true
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
    if x>119 then x=239-x end
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

function renderbr()
    for i,j in pairs(br) do
        spr(j.id,j.x, j.y, -1)
    end
end

function checkcoll()
    local x=p.x
    local y=p.y
    local cr = GetPlrCr()

    local x1=x+cr.x
    local y1=y+cr.y
    local x2=x1+cr.w-1
    local y2=y1+cr.h-1

    local startC=x1//8
    local endC=x2//8
    local startR=y1//8
    local endR=y2//8

    local tdone=false

    for c=startC,endC do
    for r=startR,endR do
        local tile=maprev(c,r)
        if tile==36 and not(tab.posbreak[c*30+r]) then brbreak(c, r)
        elseif tile==17 then p.vy=p.vy-10 p.jump=0
        elseif tdone==false and tile==20 then tdone=true
        end
    end
    end
    teleporter(tdone)
end

function brbreak(c, r)
    table.insert(br, {x=c*8,y=r*8,id=271})
    tab.posbreak[c*30+r]=true
    tab.breaker=tab.breaker-1
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


function CanMove(x, y)
    local dy=y-p.y
    local pcr=GetPlrCr()
    local r=CanMoveEx(x, y, pcr, dy)
    if not r then return false end
    return true
end

function GetPlrCr()
    return {x=0,y=0,w=8,h=8}
end


function CanMoveEx(x, y, cr, dy)
    local x1=x+cr.x
    local y1=y+cr.y
    local x2=x1+cr.w-1
    local y2=y1+cr.h-1

    local startC=x1//8
    local endC=x2//8
    local startR=y1//8
    local endR=y2//8

    for c=startC,endC do
    for r=startR,endR do
        local sol=GetTileSol(maprev(c,r))
        if sol==SOL.FULL then return false 
        elseif sol==SOL.HALF then
            if y+cr.h>r*8+4 then return false end
        end
    end
    end
    return true
end
--(y+cr.h)%8>4 or (y+cr.h)%8==0
SOL={
    NOT=0,  -- not solid
    HALF=1, -- midtiles
    FULL=2, -- fully solid
}

function LvlTileAtPt(x,y)
    return LvlTile(x//C,y//C)
end

LVL_LEN=240

function maprev(x, y)
    if x==-1 then x=29
    elseif x==30 then x=0 end
    if x>14 then x=29-x end
    return mget(x+game.part*15+game.t*30, y)
end

function LvlTile(c,r)
    if c<0 or c>=LVL_LEN then return 0 end
    if r<0 then return 0 end
    -- bottom-most tile repeats infinitely
    -- below (to allow player to swim
    -- when bottom tile is water).
    if r>=ROWS then r=ROWS-1 end
    return mget(c,r)
end

function trymoveby(dx,dy)
    if CanMove(p.x+dx,p.y+dy) then
     p.x=p.x+dx
     p.y=p.y+dy
     return true
    end
    return false
   end

bumped=0
wasground=0

function updateplr()
    local oldx=p.x
    local oldy=p.y

    local vel = 2

    local drag = 0.5
    --trace("s")
    --trace(p.vy)
    if not trymoveby(p.vx, p.vy) then bumped = 3 p.vy=0 p.vx=0 end
    --if p.vx>-drag and p.vx<drag then p.vx=0 end
    if p.vx ~=0 then p.vx = p.vx +sign(p.vx)*-drag end
    --if p.vy>-drag and p.vy<drag then p.vy=0 end
    if p.vy ~=0 then p.vy = p.vy +sign(p.vy)*-drag end
    
    --if p.vy<0 then if(trymoveby(0, p.vy)) then p.vy=p.vy+0.2 else p.vy=0 end end
    print(p.vy, 0, 8)
    print(p.vx)
    --trace(p.vy)
    if p.jump==0 and not IsOnGround() and bumped<1 then
        if not trymoveby(0, vel+1) then trymoveby(0, 1) end
    elseif bumped>0 then bumped=bumped-1
    end
    --trace(p.vy)
    local dx=0
    local dy=0
    if btn(2) then dx=-vel elseif btn(3) then dx=vel  end
    if not trymoveby(dx, 0) then trymoveby(sign(dx), 0) end
    --trace(p.vy)
    p.grounded=IsOnGround()
    --jump saver
    if wasground>0 then wasground=wasground-1 end
    if p.grounded then wasground=5 end
    --trace(p.vy)
    
    if btnp(4) and (p.grounded or wasground~=0) then
        p.jump=1
        p.jumpseq=JUMP_DY
    end
    if p.jump>=#p.jumpseq then
        p.jump=0
    elseif p.jump>0 then
        local ok=trymoveby(0, p.jumpseq[p.jump])
        p.jump=ok and p.jump+1 or 0
        --jump helper
        if not ok then p.vy=0 bumped = 3 p.y= p.y//8*8 end
    end

    p.dx=p.dx-oldx
    p.dy=p.y-oldy
end

T={
    EMPTY=0,
    -- platform that's only solid when
    -- going down, but allows upward move
    HPLAF=17,
    
    SURF=16,
    WATER=32,
    WFALL=48,
   
    TARMAC=52, -- (where plane can land).
   
    -- sprite id above which tiles are
    -- non-solid decorative elements
    FIRST_DECO=80,
   
    -- level-end gate components
    GATE_L=110,GATE_R=111,
    GATE_L2=142,GATE_R=143,
   
    -- tile id above which tiles are
    -- representative of entities, not bg
    FIRST_ENT=128,
    
    -- tile id above which tiles have special
    -- meanings
    FIRST_META=240,
    
    -- number markers (used for level
    -- packing and annotations).
    META_NUM_0=240,
      -- followed by nums 1-9.
    
    -- A/B markers (entity-specific meaning)
    META_A=254,
    META_B=255
   }

TSOL={
    [T.EMPTY]=SOL.NOT,
    [T.HPLAF]=SOL.HALF,
}

function GetTileSol(t)
    local s=TSOL[t]
    -- see if an override is present.
    if s~=nil then return s end
    -- default:
    return Iif(t>=3,SOL.NOT,SOL.FULL)
end

function Iif(cond,t,f)
    if cond then return t else return f end
   end

function IsOnGround()
return not CanMove(p.x,p.y+1)
end

function RectIsct(r1,r2)
    return
     r1.x+r1.w>r2.x and r2.x+r2.w>r1.x and
     r1.y+r1.h>r2.y and r2.y+r2.h>r1.y
   end

function RectXLate(r,dx,dy)
return {x=r.x+dx,y=r.y+dy,w=r.w,h=r.h}
end

function sign(h)
    if h>=0 then return 1 else return -1 end
    end