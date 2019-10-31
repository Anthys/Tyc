
LENX = 240
LENY = 136

game = {
  s=1
}

t=0
tt=0

circle = {
  ok = false
}

cols = {5, 6, 7}

spd = 7

ST = {"intro", "initio", "duo", "prepo"}

BIB = {
  MONST={
    {"vampire", "scary scary", 1, {1, 2}, 9},
    {"void witch", "tenebrous", 2, {1, 2}, 9},
    {"skekleton", "noisy", 3, {1, 2}, 9},
    {"dead pumpkin", "ded", 4, {1, 2}, 9}
    --{"name", "description", "shape", "attacks list", "pv"}
  },
  MSTATT={
    {"claw", 2, "att", 2},
    {"fireball", 2, "att", 5, true},
    {"sneaky jump", 1, "def", 100}
    --{"name", "preptime int", "type", "value", "stopable bool false default"}
  },
  PL = {
    {"michel", "oui", 6, {1,2,3}, 10},
    {"steven", "non", 7, {1,4,5}, 10},
    {"gilbert", "jsp", 8, {2,3,6}, 10},
    {"kevin", "benkevinquoi", 9, {4, 5, 6}, 11}
  },
  SP = {
    {"Sword", "Sword attack", "att", 3},
    {"Axe", "Axe attack", "att", 5},
    {"Feint", "Feint", "def", 100},
    {"Shield", "Shield", "def", 4},
    {"BluePo", "Blue Potion", "heel", 2},
    {"VeryBluePo", "Potion that is very blue", "heel", 4}
    --{"name str", "description str", "type str (att, def, heel)", "value int", "optio"}
  }
}



HER = {}

splbl = {}

sm_st = 0

game.s = 4

function prepo()
  cls(0)
  if sm_st==0 then
    --rect(10, 10, LENX-20, LENY-20, 15)
    --print("Synchronized \ndeath", 20, 20, 0, true, 2)
    spr(35, LENX//2-(11*16)//2, LENY//2-(10*16)//2, 0, 2, false, false, 12, 12)
    rect(0, 0, 33, LENY, 6)
    rect(LENX-33, 0, 33, LENY, 6)
    print(tt//35%2==0 and "Start" or "", 140, 50, 15)
  end
end



function trace_table(tbl)
  local res = ""
  if type(tbl) ~= "table" then return tostring(tbl) end
  for i,v in pairs(tbl) do 
    res = res .. "," .. trace_table(v)
  end
  return res
end

function initio()
  init_pm()
  game.s=game.s+1
end

function actu_spells()
  splbl = {}
  for v,i in pairs(HER) do
    table.insert(splbl,{})
    trace(i)
    for a,s in pairs(i.spels) do
      table.insert(splbl[#splbl], s.name)
    end end
  trace(trace_table(splbl))
end

function TIC()
  _G[ST[game.s]]()
  t=t+1
  tt=tt+1
  if keyp(14) then game.s = (game.s)%#ST + 1 end
  -- DEBUG
  if key(49) then show_debug() end
end

function show_debug()
  rect(5, 10, LENX-10, LENY-20, 0)
  for i=1,3 do
    local her = HER[i]
    print(trace_table({her.name, her.pv, her.c_att, her.def}), 7, 20*i, 1, false, 1, true)
    local m = cmonst[i]
    print(trace_table({m.name, m.pv, m.c_att, m.st_att, m.def}), 12, 20*i + 10)
  end
end

--UTILITIES
function table.clone(org)
  return {table.unpack(org)}
end

function intro()
  cls(0)
  circle_grow(160, 40, 30, true)
  circle_grow(200, 100, 30, false)
  --circle_cons(60, 60, 30, 4)
  circle_grow_cons(60, 60, 30)
  --circle_cons(160, 60, 30, 2, true)
end

function rect_choices()
  rect(10,100,LENX-20,LENY-110, 8)
  rectb(10,100,LENX-20,LENY-110, 0)
end

TL = {
  {x=40, y=50},
  {x=120,y=50},
  {x=200,y=50}
}

cmonst = {}

function show_choices()
  rect_choices()

  local dic = splbl
  for d=1,#dic do
    local cd = dic[d]
    for m= 1,#cd do 
      print(cd[m],TL[d].x-pxltxt(cd[m])//2,TL[d].y+55+m*6-6,0,false,1, false)
    end
  end
end


function newmonst(monst, indx)
  cmonst[indx] = Monst(monst)
end

function backdim()
  rect(0,0,LENX//3,LENY,cols[1])
  rect(LENX//3,0,LENX//3,LENY,cols[2])
  rect(2*(LENX//3),0,LENX//3,LENY,cols[3])
  rect(LENX//3-1,0,3,LENY,0)
  rect(2*(LENX//3)-1,0,3,LENY,0)
end

function selecti(nm)
  local chs = 3
  rectb(20, 104-7 + nm*6, LENX-40, 9, 9)
  if not VIS.choxchox then
    rect(8, 2, LENX-16, 9, 12)
    local txt = "X to back, S to inspect, Z to select"
    print(txt, LENX//2 - pxltxt(txt)//2, 4)
    if btnp(0) then slct.chox = (slct.chox-2)%chs+1
    elseif btnp(1) then slct.chox = (slct.chox)%chs+1
    elseif btnp(7) then VIS.choxchox = true
    elseif btnp(4) then slct.act= slct.chox end
  elseif not VIS.descp then
    rect(8, 2, LENX-16, 9, 12)
    local txt = "X to back, Z to inspect"
    print(txt, LENX//2-pxltxt(txt)//2, 4)
    if btnp(0) then slct.chox = (slct.chox-2)%chs+1
    elseif btnp(1) then slct.chox = (slct.chox)%chs+1 end
    if btnp(2) then slct.choxchox = (slct.choxchox-2)%3+1
    elseif btnp(3) then slct.choxchox = (slct.choxchox)%3+1
    elseif btnp(5) then VIS.choxchox = false
    elseif btnp(4) then VIS.descp = true
    end
    rectb(21+(slct.choxchox-1)*75, 104-7+1 + nm*6, 50-2, 9-2, 10)
  else
    rect(8, 2, LENX-16, 9, 12)
    local txt = "X to back"
    print(txt, LENX//2-pxltxt(txt)//2, 4)
    show_descsp(slct.chox, slct.choxchox) 
    if btnp(5) then VIS.descp = false end 
  end
end

function show_descsp(a,b)
  rect(LENX//2-50, 40, 100, 40, 11)
  rectb(LENX//2-50, 40, 100, 40, 0)
  local v = HER[b].spels[a]
  local txt = v.name
  print(txt, LENX//2-pxltxt(txt)//2, 45)
  rect(LENX//2-pxltxt(txt)//2, 51, pxltxt(txt), 1, 0)
  txt = "Type : " .. v.type
  print(txt, LENX//2-pxltxt(txt)//2, 54+5)
  txt = "Value : "..v.val
  print(txt, LENX//2-pxltxt(txt)//2, 63+5)
end

slct = {chox=1, choxchox=1, act=0}
VIS={chox=false, choxchox=false, descsp=false}

SHP = {"circle_grow", "circle_cons"}

function pxltxt(txt)
  return print(txt, -100, -100, 0)
end

function show_monst()
  for i,v in pairs(cmonst) do
    print(v.name, TL[i].x-pxltxt(v.name)//2, TL[i].y-30, 1)
    local x = TL[i].x
    local y = TL[i].y
    if v.shape <= 2 then circle_grow(x, y, 20, v.shape==2 and true or false)
    elseif v.shape <= 4 then circle_cons(x,y,10,2, v.shape==4 and true or false) end
    local at = v.spels[v.c_att].name
    print("Preparing \n"..at, TL[i].x-20,TL[i].y+30, 1) 
  end
end

function Player(inx)
  local dp = table.clone(BIB.PL[inx])
  local m = {}
  m.name = dp[1]
  m.desc = dp[2]
  m.col = dp[3]
  m.spels = table.clone(dp[4])
  for i,v in pairs(m.spels) do
    m.spels[i] = PlaySP(v)
  end
  m.pv = dp[5]
  m.c_att = 1
  m.def = 0
  return m
end


function MnstAtt(inx)
  local da = table.clone(BIB.MSTATT[inx])
  local m = {}
  m.name = da[1]
  m.preptim = da[2]
  m.type = da[3]
  m.val = da[4]
  m.stop = da[5] or false
  return m
end

function PlaySP(inx)
  local da = table.clone(BIB.SP[inx])
  local m = {}
  m.name = da[1]
  m.desc = da[2]
  m.type = da[3]
  m.val = da[4]
  m.stop=false
  return m
end

function Monst(inx)
  local dm = table.clone(BIB.MONST[inx])
  local m = {}
  m.name = dm[1]
  m.desc = dm[2]
  m.shape = dm[3]
  m.spels = table.clone(dm[4])
  for i,v in pairs(m.spels) do
    m.spels[i] = MnstAtt(v)
  end
  m.spels[#m.spels+1]={name="Failed attack",val=0,type="att",preptim=1}
  m.pv = dm[5]
  m.c_att = rnd1(#m.spels-1)
  m.st_att = 0
  m.def = 0
  return m
end 

function init_pm()
  for i=1,3 do
    HER[#HER+1] = Player(i)
    cmonst[#cmonst+1] = Monst(rnd1(4))
  end
end


function do_act(usr, act, tgt)
  if act.type == "att" then attack(tgt, act.val)
  elseif act.type == "def" then usr.def = act.val 
  elseif act.type == "heel" then usr.pv = usr.pv + act.val end
end


function next_turn()
  monster_turn()
end

function attack(tgt, v)
  if tgt.def < 100 then
    if v-tgt.def > 0 then
      tgt.pv = tgt.pv - v + tgt.def end
    if tgt.spels[tgt.c_att].stop == true then stop_attack(tgt) end
  end
end

function player_turn(inx) 
  for i=1,3 do HER[i].def = 0 do_act(HER[i], HER[i].spels[inx], cmonst[i]) end
end

function monster_turn()
  for im=1,3 do
    local mnst = cmonst[im]
    local c_at = mnst.spels[mnst.c_att]
    mnst.def = 0
    mnst.st_att = mnst.st_att + 1
    if mnst.st_att >= c_at.preptim then do_act(mnst, c_at, HER[im]) mnst.st_att = 0 mnst.c_att = rnd1(#mnst.spels-1) end
    if mnst.pv < 0 then newmonst(rnd1(4), im) end
  end
end

function stop_attack(mnst)
  mnst.st_att = 0
  mnst.c_att=#mnst.spels
end

function rnd1(n)
  return math.random(n)
end

function rnd0(n)
  return math.random(0,n)
end

function HUD_health()
  for i=1,3 do
    local p = HER[i]
    local m = cmonst[i]
    local txt = m.pv
    print(txt, TL[i].x +15, TL[i].y+17)
    txt = "PV : " .. tostring(p.pv)
    print(txt, TL[i].x-15, TL[i].y+78)
  end
end

function duo()
  cls(0)
  backdim()
  show_monst()
  HUD_health()
  if btnp(6) then VIS.chox = true actu_spells() 
  elseif btnp(5) and not VIS.choxchox then VIS.chox = false end
  if slct.act ~= 0 then
    trace("--")
    player_turn(slct.act)
    next_turn()
    slct.act = 0
    VIS.chox=false
  elseif VIS.chox then
    trace(trace_table(HER[1].spels))
    show_choices()
    selecti(slct.chox)
  end
end


--VISU

function circle_cons(x, y, r, n, inv)
  local n = n or 2
  local colors = {2,3}
  local inv = inv and -1 or 1
  pix(x, y, colors[2])
  local ecrt = 4
  if n == 4 then ecrt = r/3 end
  local theta = inv*((t/spd)%50/50)*2*math.pi
  circ(math.cos(theta)*r+x, math.sin(theta)*r+y, r-ecrt, colors[1])
  circ(math.cos(theta+math.pi)*r+x, math.sin(theta+math.pi)*r+y, r-ecrt, colors[1])
  if n==4 then circ(math.cos(theta+(math.pi/2))*r+x, math.sin(theta+(math.pi/2))*r+y, r-ecrt, colors[1]) circ(math.cos(theta+(3*math.pi/2))*r+x, math.sin(theta+(3*math.pi/2))*r+y, r-ecrt, colors[1]) end
end

function circle_grow_cons(x, y, r)
  local n = 2
  local inv = 1
  pix(x, y, 1)
  local ecrt = 4
  if n == 4 then ecrt = r/3 end
  local theta = inv*((t/spd)%50/50)*2*math.pi
  circle_grow(math.cos(theta)*r+x, math.sin(theta)*r+y, r-ecrt)
  circle_grow(math.cos(theta+math.pi)*r+x, math.sin(theta+math.pi)*r+y, r-ecrt)
  if n==4 then circ(math.cos(theta+(math.pi/2))*r+x, math.sin(theta+(math.pi/2))*r+y, r-ecrt, 2) circ(math.cos(theta+(3*math.pi/2))*r+x, math.sin(theta+(3*math.pi/2))*r+y, r-ecrt, 2) end
end


function circle_grow(x, y, r, inv)
  local tim = (t//spd)%(r*2)
  local colors = {2, 3}
  if tim>r then colors = {colors[2], colors[1]} tim = tim-r end
  circ(x,y,r,colors[1])
  if inv then circ(x,y,tim,colors[2]) else circ(x,y,r-tim,colors[2]) end
end