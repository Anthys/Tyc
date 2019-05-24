-- title: Jyss
-- author: Anthys
-- desc: Platformer
-- script: lua


-- B Ball G Gripper L Lasor F Floater
-- spawn one new every room finished
ORDERS = {
    [1]="bbbbbbbbb",
    [2]="lfbblfbbb",
    [3]="ffbbflllb"
}

OBJECTS={["b"]="ball", ["f"]='floater', ["l"]="lasor"}

JUMP_DY={-3,-3,-3,-3,-2,-2,-2,-2,-2,
  -1,-1,0,0,0,0,0}

SOL={
    NOT=0,  -- not solid
    HALF=1, -- midtiles
    FULL=2, -- fully solid
}

T={
    EMPTY=0,
    -- platform that's only solid when
    -- going down, but allows upward move
    HPLAF=17
   }

   TSOL={
    [T.EMPTY]=SOL.NOT,
    [T.HPLAF]=SOL.HALF,
}


MENU={
    --[Indx sprite]={x, y, lineofmap(y), indxcolor}
    [87]={30, 50, 2, 14}, 
    [89]={80, 20, 1, 10}, 
    [91]={85, 90, 3, 12}, 
    [93]={160, 26, 4, 13}, 
    [117]={150, 80, 5, 11}
}

ST={[1]="startic",[2]= "menutic", [3]="maintic", [4]="finishtic"}

COLORS={
    --[Index color]={{originR, originG, originB},{targetR, targetG, targetB}}
    [14]={{0x8D, 44, 44}, {0xFF, 0, 44}},
    [13]={{55, 55, 75},{0xBE, 28, 0xFF}},
    [12]={{71, 65, 59},{0xFF, 0xD2, 0}},
    [11]={{24, 38, 0x1C}, {48, 0xDA, 0}},
    [10]={{14, 34, 55}, {14, 55, 0xFA}},
}

-- Relative to finish
cmult=0
mm=255//2
mult={}
for i=0,7 do
    mult[i+1]={mm*(i%2),mm*(i//2%2),mm*(i//4%2)}
end
tt=0
altend = false
chaos=0
unordone={}
progrex=0
--game.coldone={[14]=false, [13]=false, [12]=false, [11]=false}


function init()
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
    jumpseq=JUMP_DY,
    bump=0,
    wasground=0
    }
    game={
        t=0,
        part=0,
        coldone = {},
        ccol = 14,
        numdone = {},
        t0=0,
        ord="",
        s=1 --state
    }
    tab={
        breaker=0,
        inbreaker=0,
        posbreak={}
    }
    ents={}
    spawnplayer()
end
   
function collisionLineRect(lx1,ly1,lx2,ly2,rx1,ry1,rx2,ry2)
    --debug visualization
        line(lx1,ly1,lx2,ly2,15)
    --accounts for endpoints; remove for infinite lines
    if math.max(rx1,rx2) < math.min(lx1,lx2) 
            or math.min(rx1,rx2) > math.max(lx1,lx2)
                    or math.max(ry1,ry2) < math.min(ly1,ly2) 
            or math.min(ry1,ry2) > math.max(ly1,ly2)
        then return false end

    p1_above = perpDot(lx2-lx1,ly2-ly1,rx1-lx1,ry1-ly1) > 0
    p2_above = perpDot(lx2-lx1,ly2-ly1,rx2-lx1,ry1-ly1) > 0
    p3_above = perpDot(lx2-lx1,ly2-ly1,rx1-lx1,ry2-ly1) > 0
    p4_above = perpDot(lx2-lx1,ly2-ly1,rx2-lx1,ry2-ly1) > 0
    
    --debug visualization
    --pix(rx1,ry1,p1_above and 11 or 6)
    --pix(rx2,ry1,p2_above and 11 or 6)
    --pix(rx1,ry2,p3_above and 11 or 6)
    --pix(rx2,ry2,p4_above and 11 or 6)
    
    if p1_above and p2_above and p3_above and p4_above then
    return false
    elseif not p1_above and not p2_above 
            and not p3_above and not p4_above then
    return false
    else
    return true
    end
end

function spawnplayer()
    local l=tl(game.numdone)
    if l==9 then game.s=4 game.coldone[game.ccol]= true return true end

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

    if #ents<=l then
        local o = string.sub(game.ord, l, l)
        o = OBJECTS[o]
        local p = nposent(o)
        table.insert(ents, {
        n=o,
        x=p.x,
        y=p.y,
        vx=math.random(0, 1),
        t=0,
    }) end
    local n = #ents
    local ra = math.random(0, 2)
    if ra==0 then ents[n].vx=0 ents[n].vy=mop() elseif ra==1 then ents[n].vx=mop() ents[n].vy=0 else ents[n].vx=mop() ents[n].vy=mop() end
    --if ents[n].vx==1 then ents[n].vy=0 else ents[n].vy=1 end
end

function nposent(en)
    local done=false
    while not done do
        x=math.random(0, 240)
        y=math.random(0, 136)
        done=true
        for i,j in pairs(getents(en)) do
            if RectIsct({x=x,y=0,w=16,h=16},{x=j.x, y=j.y,w=16,h=16}) then done=false end
        end
    end
    return {x=x, y=y}
end

function getents(en)
    local f={}
    for i,j in pairs(ents) do
        if j.n==en then table.insert(f, j) end
    end
    return f
end

function TIC()
    _G[ST[game.s]]()
    t=t+1
end

function maintic()
    if p.x>240 then p.x=0
    elseif p.x<0 then p.x=240
    end
    if p.y>136 then p.y=0
    elseif p.y<0 then p.y=136
    end

    cls()
    makemap()
    updateplr()
    progress()
    if tab.breaker==0 and not game.numdone[(game.t-game.t0)*2+game.part+1] then game.numdone[(game.t-game.t0)*2+game.part+1]=true end
    renderbr()
    renderp()
    checkinput()
    rooms()
    updents()
    checkcoll()
    if t%60==0 then cmult=(cmult)%8+1 for i=1,3 do poke(0x03FC0 + 0x3*4+i-1, mult[cmult][i]) end end
end

function startic()
    cls()
    local string="Press Enter"
    print("Jyss", (240-192)//2, (136-60)//2+5, 2, false, 8)
    if t%60<30 then print(string,120-10,82+5) end
    if keyp(50) then game.s=2 end
end


function menutic()
    local x,y,p=mouse()
    cls(1)
    for i, v in pairs(MENU) do
        spr(i, v[1], v[2], 0, 2, false, false, 2, 2)
        if x>v[1] and x<v[1]+16*2 and y>v[2] and y<v[2]+16*2 then rectb(v[1]-2,v[2]-2,32+4,32+4,9) 
        if p and not game.coldone[v[4]] then game.s=3 game.t0=(v[3]-1)*8 game.t=game.t0 game.ccol=v[4] game.numdone={} game.ord=rlist(ORDERS) for i=2,8 do
            game.numdone[i]=true
        end spawnplayer() elseif game.coldone[v[4]] then print("Illuminated", v[1]-12, v[2]+32+4, v[4]) end
        end
    end
end

function respawn(obj)
    local p = nposent(obj.n)
    obj.x = p.x
    obj.y = p.y
end



function lastest(las)
    las.t=las.t+1
    local tt=las.t
    if tt%60==0 then las.x=math.random(0, 240) las.vx=math.random(0, 240) end
    if tt%60>0 and tt%60<30 and tt%60%10>4 then rect(las.x,0,3,3,8) rect(las.vx, 132, 3, 3, 8) end
    if tt%60>30 and tt%60<50 then 
        if collisionLineRect(las.x,0,las.vx,136,p.x,p.y,p.x+7,p.y+7) then
        p.vx=20
        end rect(las.x,0,3,3,8) rect(las.vx, 132, 3, 3, 8) end
end


function floatest(floa)
    local fy
    local waves=4
    floa.x=floa.x+0.5
    if floa.x==240 then floa.x=0 end
    local x = floa.x
    fy=math.sin(x/240*math.pi*waves)*(136//2)+136//2
    floa.y=fy
    spr(358, x, fy, 0)
    if RectIsct({x=p.x, y=p.y, w=8, h=8}, {x=floa.x, y=floa.y, w=8, h=8}) then eject(floa.x, floa.y) end
end

function updents()
    for i,j in pairs(ents) do
        if j.n=="ball" then balls(j)    
        elseif j.n=="floater" then floatest(j)
        elseif j.n=="lasor" then lastest(j) end
    end
end

function balls(j)
        if not CanMoveEx(j.x, j.y, {x=0,y=0,w=16,h=16},0) then respawn(j) end
        if not CanMoveEx(j.x+j.vx, j.y+j.vy, {x=0,y=0,w=16,h=16},0) then j.vy=-j.vy j.vx=-j.vx end

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

function rooms()
    for i=1,9 do
        if i == game.t*2+game.part + 1 then spr(479+i, 240-10*8+i*8, 128, 0)
        elseif game.numdone[i] then spr(463+i, 240-10*8+i*8, 128, 0)
        else spr(495+i, 240-10*8+i*8, 128, 0) end
    end
end

function checkinput()
    if p.tp then
        local t0=game.t0
    if key(28) then game.t = t0 game.part = 0 spawnplayer()
    elseif key(29) then game.t = t0 game.part = 1 spawnplayer()
    elseif key(30) then game.t = t0+1 game.part = 0 spawnplayer()
    elseif key(31) then game.t = t0+1 game.part = 1 spawnplayer()
    elseif key(32) then game.t = t0+2 game.part = 0 spawnplayer()
    elseif key(33) then game.t = t0+2 game.part = 1 spawnplayer()
    elseif key(34) then game.t = t0+3 game.part = 0 spawnplayer()
    elseif key(35) then game.t = t0+3 game.part = 1 spawnplayer()
    elseif key(36) then game.t = t0+4 game.part = 0 spawnplayer()
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

function maprev(x, y)
    if keyp(01) then trace(game.part) end
    if x==-1 then x=29
    elseif x==30 then x=0 end
    if x>14 then x=29-x end
    if y>16 then y=0 end
    return mget(x+game.part*15+(game.t%8)*30, y+(game.t0//8)*17)
end

function trymoveby(dx,dy)
    if CanMove(p.x+dx,p.y+dy) then
     p.x=p.x+dx
     p.y=p.y+dy
     return true
    end
    return false
   end

function updateplr()
    local oldx=p.x
    local oldy=p.y

    local vel = 2

    local drag = 0.5
    --trace("s")
    --trace(p.vy)
    if not trymoveby(p.vx, p.vy) then if not trymoveby(p.vx/2, p.vy/2) then p.bump = 3 p.vy=0 p.vx=0 end end
    --if p.vx>-drag and p.vx<drag then p.vx=0 end
    if p.vx ~=0 then p.vx = p.vx +sign(p.vx)*-drag end
    --if p.vy>-drag and p.vy<drag then p.vy=0 end
    if p.vy ~=0 then p.vy = p.vy +sign(p.vy)*-drag end
    
    --if p.vy<0 then if(trymoveby(0, p.vy)) then p.vy=p.vy+0.2 else p.vy=0 end end
    --print(p.vy, 0, 8)
    --print(p.vx)
    --trace(p.vy)
    if p.jump==0 and not IsOnGround() and p.bump<1 then
        if not trymoveby(0, vel+1) then trymoveby(0, 1) end
    elseif p.bump>0 then p.bump=p.bump-1
    end
    --trace(p.vy)
    local dx=0
    local dy=0
    if btn(2) then dx=-vel elseif btn(3) then dx=vel  end
    if not trymoveby(dx, 0) then trymoveby(sign(dx), 0) end
    --trace(p.vy)
    p.grounded=IsOnGround()
    --jump saver
    if p.wasground>0 then p.wasground=p.wasground-1 end
    if p.grounded then p.wasground=5 end
    --trace(p.vy)
    
    if btnp(4) and (p.grounded or p.wasground~=0) then
        p.jump=1
        p.jumpseq=JUMP_DY
    end
    if p.jump>=#p.jumpseq then
        p.jump=0
    elseif p.jump>0 then
        local ok=trymoveby(0, p.jumpseq[p.jump])
        p.jump=ok and p.jump+1 or 0
        --jump helper
        if not ok then p.vy=0 p.bump = 3 p.y= p.y//8*8 end
    end

    p.dx=p.dx-oldx
    p.dy=p.y-oldy
end

function GetTileSol(t)
    local s=TSOL[t]
    -- see if an override is present.
    if s~=nil then return s end
    -- default:
    return Iif(t>=3,SOL.NOT,SOL.FULL)
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

function finishtic()
    tt=tt+1
    if tt==1 then
        unordone={}
        for i,v in pairs(game.coldone) do
            if v==true then table.insert(unordone, i) end
    end end
    if chaos==0 then
        local l=tl(game.coldone)
        if l==3 and (tt>60*2.5 and tt<60*3) then chaos=chaos else cls(0) end
        local s=0
        local coltab={}
        local turn=tt//60
        if turn>l then 
            turn=l
            if l==2 then print("Please stop", 52, 60) end
            if tt%130<80 then if l~=4 then print("Press any key to continue", 50, 130) else print("STOP IT NOW", 90, 130) end
            end
            if keyp() then 
                tt=0 
                if l~=2 then game.s=2 
                elseif l==2 then chaos=0.2
            end end
            if l>4 then chaos=1 tt=0
        end end
        for i=1,turn do
            table.insert(coltab,unordone[i])
        end
        if altend then l=#coltab end
        if l==3 and (tt>60*2.5 and tt<60*3) then
            local tex="Illllllllllllllllllllllllll" print(string.sub(tex,0, (tt-60*2.5)//2), 30, 50+((2-l/2+1)*16), math.random(0,15), false, 3)
        else 
            for j, i in pairs(coltab) do
                print("Illuminated", 30, 50+((s-l/2+1)*16), i, false, 3)
                s=s+1
              end
        end
    elseif chaos==0.2 then
        if tt<5 then cls(0) print("Please stop", 52, 60)
        else tt=0 game.s=2 chaos=0 end
    elseif chaos==1 and tt%60%5==0 then 
        if tt//60<8 then
            print("Illuminated", math.random(-50,240), math.random(-10,136), rlist(unordone), rlist({true, false}), math.random(4))
            if tt//60>=6 then for i=0,math.random(0, 5) do
                spr(rlist({1, 2, 17}), math.random(240), math.random(136))
                rect(math.random(240),math.random(136),math.random(0, 30),math.random(0, 30),0)
            end end
        elseif tt//60>=8 and tt//60<8+16 then 
            local text= 'What have you done, child?' 
            if tt//60<8+13 or (tt%2==1 and tt//60<8+15) or (tt%4==0)  then cls(math.random(0, 15)) else cls(0) end
            for i=0,math.random(0, 5) do
                spr(rlist({1, 2, 17}), math.random(240), math.random(136))
                rect(math.random(240),math.random(136),math.random(0, 30),math.random(0, 30),0)   
            end
            if tt>=10 then print(string.sub(text,0, math.min(math.max(tt//30-10*2, 0), string.len(text))),50, 60, 0) end
            if tt//60>=8+15 then print(text, math.random(-50,240), math.random(-10,136), 0, rlist({true, false}), math.random(4)) end
        elseif tt//60>=8+16 and tt//60<8+16+4 then cls(0)
        elseif tt//60>=8+16+4 then exit()
        end
    end
end

function teleporter(a)
    --trace("---")
    local alldone=0
    local speedlight = 2
    local indx=game.ccol
    local prog= 1
    --a= false(go away from target) or true (go to target)
    for i=1,3 do
        local pre=COLORS[indx][1][i]
        local last=COLORS[indx][2][i]
        local dir = pre<last
        local idir= Iif(dir, 1, -1)
        local val = peek(0x03FC0 + 0x3*indx+i-1)
        local pro = val<last
        if a then
            if infup(val, last-speedlight*idir, dir) and infup(val, last-idir*tab.breaker*(idir*(last-pre)/tab.inbreaker), dir) then poke(0x03FC0 + 0x3*indx+i-1, val+idir*speedlight)
            --if ((val<last-speedlight and dir) or (val>last-speedlight and not dir)) and val<last-tab.breaker*((last-pre)/tab.inbreaker) then poke(0x03FC0 + 0x3*indx+i-1, val+speedlight)
            elseif infup(val,last-speedlight*idir, dir) then print(tab.breaker .. " remains", 0, 130) 
            elseif infup(val,last-(speedlight+1)*idir,not dir) then alldone=alldone+1
            end
        else
            if infup(val,pre+idir*speedlight,not dir) then poke(0x03FC0 + 0x3*indx+i-1, val-idir*(speedlight/speedlight)) end
        end
        prog= math.min((val-pre)/(last-pre), prog)
    end
    progrex = prog
    if alldone==3 then print('Ready to teleport') p.tp=true else p.tp = false end
end

function progress()
    local lenprogress = 80
    local val = progrex*lenprogress
    rect(120-lenprogress//2, 130, val, 4, game.ccol)
end

--Have a palette slot reserved, for stages background. This slot will save the advancement of the level, as its illumination of the color. It will maybe used as background. Not to be confused with the color itself which reset to its origin value each part of the level.


--Utility

function mop()
    if math.random(0,1)==0 then return -1 else return 1 end
end

-- Get table length
function tl(T)
    local count = 0
    for i,j in pairs(T) do if j then count = count + 1 end end
    return count
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

function Iif(cond,t,f)
    if cond then return t else return f end
   end

function sign(h)
    if h>=0 then return 1 else return -1 end
end

function printlist(a)
    trace("--")
    for i,v in pairs(a) do
        trace(i)
        trace(v)
    end
end

function rlist(ta)
    return ta[math.random(#ta)]
end

function printcolo()
    trace("--")
    local indx=game.ccol
    for i=1,3 do
        trace(peek(0x03FC0 + 0x3*indx+i-1))
    end
end

function infup(a, b, bool)
    if bool then return a<b else return a>b end
end

function perpDot(x1,y1,x2,y2)
    return x1*y2-y1*x2
end

function altback()
    if t%2==0 then return end
    local a=0
    if t%180<60 then a=1 elseif t%180<120 then a=-1 end
    for i=0,3 do
    poke(0x03FC0 + 0x3*0+i, peek(0x03FC0 + 0x3*0+i)+a)
    end
end

init()