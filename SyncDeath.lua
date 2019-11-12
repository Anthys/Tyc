-- next: Fix the dying animation, problem should be caused by interactions with other animations.
-- Make squads instead of people
-- Add the counter attack type, where the monster give back 50% of the attack
-- Leadboards


LENX = 240
LENY = 136

game = {
  s=1
}

--palette: 0black 15white 1text 2-3mnst 5-6-7-8player 9-10selec 11-12background 
t=0
tt=0

circle = {
  ok = false
}

cols = {5, 6, 7}

spd = 7
--"intro", "initio", 
ST = {"prepo","duo", "endo"}


function rnd1(n)
  return math.random(n)
end

BIB = {
  MONST={
    {"vampire", "scary scary", 1, {1, 2}, 9},
    {"void witch", "tenebrous", 2, {1, 2}, 9},
    {"skekleton", "noisy", 3, {1, 2}, 9},
    {"dead pumpkin", "ded", 4, {1, 2}, 9}
    --{"name", "description", "shape", "attacks list", "pv"}
  },
  MSTATT={
    {"claw", 1, "att", 1},
    {"fireball", 2, "att", 5, true},
    {"sneaky jump", 1, "def", 100},
    {"give back", 1, "def", 50}
    --{"name", "preptime int", "type", "value", "stopable bool false default"}
  },
  PL = {
    {"michel", "warrior of the void", 6, {1,2,3}, 6},
    {"steven", "strongest man aliv", 7, {1,4,5}, 11},
    {"elodie", "i don't really know her", 8, {2,3,6}, 8},
    {"lucile", "also called kevin", 5, {4, 5, 6}, 7},
    {"philip", "a handsome boi", 6, {1,4,6}, 9},
    {"janine", "queen of everything", 6, {1,4,6}, 9},
    {"nadine", "came back from hell", 6, {1,4,6}, 9}
  },
  SP = {
    {"Sword", "Sword attack", "att", 3},
    {"Axe", "Axe attack", "att", 4},
    {"Feint", "Feint", "def", 3},
    {"Shield", "Shield", "def", 4},
    {"BluePo", "Blue Potion", "heel", 1},
    {"VeryBluePo", "Potion that is very blue", "heel", 3}
    --{"name str", "description str", "type str (att, def, heel)", "value int", "optio"}
  }
}


debug = false

HER = {}

sm_st = 0

--game.s = 4
monstpack={}
prepsq = {}

function prepo()
  cls(0)
  if sm_st==0 then
    --print("Synchronized \ndeath", 20, 20, 0, true, 2)
    spr(35, LENX//2-(11*16)//2, LENY//2-(10*16)//2, 0, 2, false, false, 12, 12)
    rect(0, 0, 33, LENY, 6)
    rect(LENX-33, 0, 33, LENY, 6)
    rect(((tt//1)%50)/50*90 + 70, 50, 2, 40, 0)
    rect(((tt+4//1)%80)/80*90 + 70, 50, 2, 40, 0)
    rect(((tt+4//1)%30)/30*90 + 70, 50, 2, 40, 0)
    if t==0 then 
      for i=1,40 do
        local theta = math.random()*2*math.pi
        local rx = math.random(50, 90)
        local ry = math.random(40, 80)
        prepsq[#prepsq+1] = {math.cos(theta)*rx + LENX//2, math.sin(theta)*ry + LENY//2}
      end
    end
    for i,v in pairs(prepsq) do
      rect(v[1],v[2],4,4,0)
    end
    table.remove(prepsq,1)
    local theta = math.random()*2*math.pi
    local rx = math.random(60, 100)
    local ry = math.random(50, 90)
    prepsq[#prepsq+1] = {math.cos(theta)*rx + LENX//2, math.sin(theta)*ry + LENY//2}
    print(tt//35%2==0 and "Start" or "", LENX//2-pxltxt("Start")//2, LENY//2+25, 15)
    for i=0,7 do
      if btnp(i) then sm_st=1 end
    end
  elseif sm_st==1 then --it would be better if they chose predefined squads instead of players directly
    rect(10, 10, LENX-20, LENY-20, 15)
    local txt = "Choose players: "
    print(txt,mid(txt),20,0)
    for i,v in pairs(BIB.PL) do
      print(v[1], 30, 30+i*10,0)
      if has(slct.pl, i)~=0 then rect(25, 30+i*10+2, 2, 2, 0) end
    end
    rect(80, 40, 1, LENY//2,0)
    local sl = BIB.PL[slct.chosh]
    rectb(30-2, 30+slct.chosh*10-2, pxltxt(sl[1])+4, 9, 0)
    txt = sl[2]
    print(txt,150-pxltxt(txt)//2, 100,0)
    txt = "Lifepoints : "..tostring(sl[5])
    print(txt,100, 40,0)
    print("Spels : ", 100, 50, 0)
    for i,v in pairs(sl[4]) do 
      print(BIB.SP[v][1],110,60-9+9*i, 0)
    end
    if #slct.pl==3 and tt%50<25 then
      txt = "Press A to start"
      print(txt, mid(txt), 115, 0)
    end
    if btnp(0) then slct.chosh = (slct.chosh-2)%#BIB.PL+1
    elseif btnp(1) then slct.chosh = (slct.chosh)%#BIB.PL+1 
    elseif btnp(6) and #slct.pl==3 then sm_st=2 tt=0
    elseif btnp(4) then
      local i = slct.chosh
      local ys = has(slct.pl, i)
      if ys~=0 then table.remove(slct.pl, ys) 
      elseif #slct.pl<3 then slct.pl[#slct.pl+1]=i end
    end
  elseif sm_st==2 then
    --should chose the world here
    monstpack = {1, 2, 3, 4}
    sm_st=3
  elseif sm_st==3 then
    HER={}
    cmonst={}
    for i,v in pairs(slct.pl) do
      HER[#HER+1] = Player(v, i)
    end
    for i=1,3 do
      cmonst[i]=Monst(monstpack[rnd1(#monstpack)], i)
    end
    sm_st=4
  elseif sm_st==4 then
    rect(10, 10, LENX-20, LENY-20, 15)
    backdim()
    local tm = tt<200 and tt or 200 
    name2(HER[1].name, TL[1].x, TL[1].y, tm)
    name1(HER[2].name, TL[2].x, TL[2].y, tm)
    name3(HER[3].name, TL[3].x, TL[3].y, tm)
    if tt>350 then sm_st=5 end
    for i=0,7 do
      if btnp(i) then sm_st=sm_st+1 end
    end
  elseif sm_st==5 then
    game.s = game.s+1
  end
end

function name1(txt, x, y, tt)
  if tt>=200 then
    for i,v in pairs(s2t(string.upper(txt))) do
      print(v, i%2==1 and x-25 or x+5, y-(#txt*18)//2+i*18, 0, false, 4)
    end
  end
  local txt = string.upper(txt)
  if #txt%2==0 then txt=txt.." "..txt end
  local m = math.floor(tt/200*#txt) + 1
  print(string.sub(txt,m,m), x-20, m%2==0 and y-20 or y+20, 0, false, 8)
  --Show the name of the player in a cool way at the start of the game
end


function name2(txt, x, y, tt)
  local txt = string.upper(txt)
  local tab = s2t(txt)
  for i,v in pairs(tab) do
    local theta = -i/#tab*3*math.pi/2 + tt/18
    r = {x=tt/200*20 +5,y=tt/200*35+5} 
    print(v, math.cos(theta)*r.x + x -7, math.sin(theta)*r.y + y, 0, false, 2)
  end
end

function name3(txt, x, y, tm)
  local txt = string.upper(txt)
  if tm >=200 then tm = #txt*10 end
  for i=1,8 do
    if tm//10%(2*#txt) < #txt then 
      print(string.sub(txt,0, tm//10%#txt), x-35, y + i*12-40, 0,false, 2)
    else
      print(string.sub(txt,0, #txt-((tm//10))%#txt), x-35, y + i*12-40, 0,false, 2)
    end
  end
  if tm//10 > #txt then
    local tab = s2t(txt)
    for i=1,4 do
      for j=1,(tm/10-#txt)//1%#tab + 1 do
        print(tab[j], x - 45 + i*14, y-35 + j*15, 15, false, 2)
      end
    end
  end
end

function s2t(s)
  local tb = {}
  s:gsub(".",function(c) table.insert(tb,c) end)
  return tb
end

function has(t, v)
  for i,h in pairs(t) do
    if h==v then return i end
  end
  return 0
end

slct = {chox=1, choxchox=1, act=0, chosh = 1, pl = {}, endm=''}
VIS={chox=false, choxchox=false, descsp=false}

SHP = {"circle_grow", "circle_cons"}
function mid(txt)
  return LENX//2 - pxltxt(txt)//2
end

function trace_table(tbl)
  local res = ""
  if type(tbl) ~= "table" then return tostring(tbl) end
  for i,v in pairs(tbl) do 
    res = res .. "," .. trace_table(v)
  end
  return res
end

function checkded()
  local sum = 0
  for i=1,3 do
    if HER[i].pv<=0 then
      HER[i].a=false
      sum=sum+1
    end
  end
  if sum==3 then
    game.s=game.s+1
  end
end

function initio()
  init_pm()
  game.s=game.s+1
end

endm = {"Nicely died.", "Succesfully failed.", "Perfection in the desynchronization."}
scor = {
  k=0,
  r=0
}

function endo()
  cls(0)
  if slct.endm == "" then slct.endm = endm[rnd1(#endm)] end
  local txt = slct.endm
  print(txt, mid(txt), 40)
  txt = "Kills: "..tostring(scor.k)
  print(txt, 40, 60)
  txt = "Rounds: "..tostring(scor.r)
  print(txt, 40, 70)
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
  for i,v in pairs(anims) do
    print(trace_table(v), 7, 20*3+10+10*i)
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
  rect(10,98,LENX-20,LENY-108, 0)
  rectb(10,98,LENX-20,LENY-108, 15)
end

TL = {
  {x=40, y=50},
  {x=120,y=50},
  {x=200,y=50}
}

cmonst = {}

SPR= {
  ["att"]=224,
  ["def"]=228,
  ["heel"]= 225
}

function show_choices()
  rect_choices()
  for d=1,3 do
    local cd = HER[d]
    for m,v in pairs(cd.spels) do 
      local tx = TL[d].x-pxltxt(v.name)//2
      local ty = TL[d].y+51+m*8-8
      print(v.name,tx,ty,cd.a and 15 or 10,false,1, false)
      local sprt = SPR[v.type]
      spr(sprt, tx-10, ty-1, 0)
    end
  end
end


function newmonst(monst, indx)
  cmonst[indx] = Monst(monst, indx)
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
  rectb(15, 91 + nm*8, LENX-30, 10, 9)
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
    rectb(16+(slct.choxchox-1)*70, 91 + nm*8, 60, 10, 10)
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

function pxltxt(txt)
  return print(txt, -100, -100, 0)
end

function show_monst()
  for i,v in pairs(cmonst) do
    print(v.name, TL[i].x-pxltxt(v.name)//2, TL[i].y-30, 1)
    local x = TL[i].x
    local y = TL[i].y
    rep_monst(v,x,y)
    local at = v.spels[v.c_att]
    local txt = "Preparing"
    print(txt, TL[i].x-pxltxt(txt)//2, TL[i].y+30, 1)
    print(at.name, TL[i].x-pxltxt(at.name)//2,TL[i].y+40, 1)
    if at.preptim>=2 then local txt = tostring(v.st_att+1).."/"..tostring(at.preptim) print(txt, TL[i].x-pxltxt(txt)//2,TL[i].y+50,1) end
  end
end

function rep_monst(m, x, y)
  if m.shape <= 2 then circle_grow(x, y, 20, m.shape==2 and true or false)
  elseif m.shape <= 4 then circle_cons(x,y,10,2, m.shape==4 and true or false) end
end

function Player(inx, i)
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
  m.maxpv = dp[5]
  m.c_att = 1
  m.def = 0
  m.a = true --alive
  m.th ='pl'
  m.i = i or 1
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

function Monst(inx, i)
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
  m.maxpv=dm[5]
  m.c_att = rnd1(#m.spels-1)
  m.st_att = 0
  m.def = 0
  m.a = true
  m.th = "monst"
  m.i = i or 1
  return m
end

function init_pm()
  for i=1,3 do
    HER[#HER+1] = Player(i)
    cmonst[#cmonst+1] = Monst(rnd1(4))
  end
end


function do_act(usr, act, tgt)
  if not usr.a then return end
  if act.type == "att" then attack(tgt, act.val)
  elseif act.type == "def" then usr.def = act.val 
  elseif act.type == "heel" then
    local v = usr.pv + act.val 
    local val = v<=usr.maxpv and v or usr.maxpv
    anims[#anims+1] = Anim(math.random(TL[usr.i].x-20, TL[usr.i].x+20), TL[usr.i].y+ (usr.th =="pl" and 65 or 0), "heel", 1, val-usr.pv)
    usr.pv = val
  end
end

function monster_def_turn()
  for im=1,3 do
    local mnst = cmonst[im]
    local c_at = mnst.spels[mnst.c_att]
    mnst.def = 0
    if c_at.type == "def" then 
      mnst.st_att = mnst.st_att + 1
      if mnst.st_att >= c_at.preptim and HER[im].a then 
      do_act(mnst, c_at, HER[im]) 
      mnst.st_att = 0
      mnst.c_att = rnd1(#mnst.spels-1) 
      end
    end
  end
end

function next_turn()
  monster_def_turn()
  player_turn(slct.act)
  monster_turn()
  checkded()
  scor.r=scor.r+1
end

function attack(tgt, v)
  if tgt.def < 100 then
    if v-tgt.def > 0 then
      tgt.pv = tgt.pv - v + tgt.def end
    if tgt.spels[tgt.c_att].stop == true then stop_attack(tgt) end
    if tgt.th ~= "ms" then
      anims[#anims+1]=Anim(math.random(TL[tgt.i].x-20, TL[tgt.i].x+20), TL[tgt.i].y+(tgt.th =="pl" and 65 or 0), "hit", inv, v)
      if v<=3 then anims[#anims+1]=Anim(TL[tgt.i].x, TL[tgt.i].y +(tgt.th =="pl" and 65 or 0), "slice", rnd0(1)*2-1) 
      else 
        local inv = rnd0(1)*2-1
        for j=0,5 do
          anims[#anims+1]=Anim(TL[tgt.i].x, TL[tgt.i].y+j+(tgt.th =="pl" and 65 or 0), "slice", inv)
        end
      end
    end
  end
end

function do_anims()
  for i,v in pairs(anims) do
    v.t = v.t+1
    if v.type=="slice" then
      if slice(v.t, v.x,v.y, v.inv) then table.remove(anims, i) end
    elseif v.type == "heel" then
      if anim_heal(v.t, v.x, v.y, v.val, v.inv) then table.remove(anims,i) end
    elseif v.type =="hit" then
      if anim_hit(v.t, v.x, v.y, v.val,v.inv) then table.remove(anims,i) end
    elseif v.type =="break" then
      if anim_break(v.t,v.x,v.y,v.val,v.inv) then table.remove(anims,i)end
    elseif v.type =="die" then
      if anim_die(v.t,v.x,v.y,v.val,v.val2) then table.remove(anims,i)end
    end
  end
end

function Anim(x,y,t, inv, val, val2)
  m={}
  m.x=x
  m.y=y
  m.t=0
  m.type = t
  m.inv = inv or 1
  m.val = val or 0
  m.val2 = val2 or 0
  return m
end

function anim_heal(tm, x, y, val, inv)
  local inv = inv or 1
  local x=x
  local y = y
  local fin = 20
  if tm>20 then return true end
  local tmm =  tm>=9 and 18-tm or tm
  spr(256 + 2*(tmm//3),x-9,y-4,0, 1, 0, 0,2, 2)
  if tm>6 and tm<16 then local txt = "+"..tostring(val) print(txt, x-pxltxt(txt)//2, y, 15, false, 1, true) end
end

function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = rnd1(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

tab1 = {}
for i=1,36 do
  tab1[#tab1+1]=i
end

diel = shuffle(tab1)

function anim_die(tm,x,y,m,c)
  local midtm = 60
  local xl = 35
  local yl = 40
  local nyl = yl+10
  if tm<36 then
    rect(x-xl,y-yl,xl*2,yl*2+10,c)
    rep_monst(m,x,y)
    for i=0,tm-1 do
      local i1=i+1--i1=2*i+1
      line(x-xl+diel[i1],y-yl,x-xl+diel[i1],y+nyl,c)
      line(x+diel[i1],y-yl,x+diel[i1],y+nyl,c)
    end
  elseif tm<midtm then
    rect(x-xl,y-yl,xl*2,yl*2+10,c)
  elseif tm<midtm+36 then
    --rect(x-xl,y-yl,xl*2,yl*2+10,c)
    local t2=tm-midtm
    for i=0,36-t2-1 do
      local i1=i+1--i1=2*i+1
      line(x-xl+diel[i1],y-yl,x-xl+diel[i1],y+nyl,c)
      line(x+diel[i1],y-yl,x+diel[i1],y+nyl,c)
    end
  else return true
  end
end




function anim_break(tm, x, y, val, inv)
  local inv = inv or 1
  local x=x
  local y=y
  local fin=20
  if tm<20 then print("Break!", x-pxltxt("Break!"),y,15)
  else return true end
end

function slice(t, x, y, inv)
  local inv = inv or 1
  local x = x-25
  local y = y-20
  local fin = 20
  local pn = 10
  local inv2 = (inv-1)*(-1)
  for i= t-pn<0 and 0 or t-pn, t<fin and t or fin do
    local te = inv*(t+i)
    local yt = math.pow(te/2,2)/10
    pix(x+te+25*inv2,y+yt,15)
  end
  if t>fin+pn then return true end
end

anims = {}

function anim_hit(tm, x, y, val, inv)
  local inv = inv or 1
  local x = x
  local y = y
  local fin = 20
  local te = tm*0.4
  local bib = {1,-1}
  if tm<15 then
    for i=2,5 do
      spr(262, x+te*bib[i//2],y+te*bib[(i%2)+1], 0)
    end
  end
  print("-"..tostring(val), x, y, 15, false, 1, true)
  if tm>30 then return true end
end

function player_turn(inx) 
  for i=1,3 do
    if HER[i].a then
      HER[i].def = 0 
      do_act(HER[i], HER[i].spels[inx], cmonst[i]) 
    end
  end
end

function monster_turn()
  for im=1,3 do
    local mnst = cmonst[im]
    local c_at = mnst.spels[mnst.c_att]
    if mnst.pv <= 0 then newmonst(monstpack[rnd1(#monstpack)], im) scor.k=scor.k+1 anims[#anims+1] = Anim(TL[mnst.i].x, TL[mnst.i].y, "die", 1, mnst, cols[mnst.i])
    elseif c_at.type ~= "def" then
      mnst.st_att = mnst.st_att + 1
      if mnst.st_att >= c_at.preptim and HER[im].a then 
        do_act(mnst, c_at, HER[im]) 
        mnst.st_att = 0 
        mnst.c_att = rnd1(#mnst.spels-1) 
      end
    end
  end
end

function stop_attack(mnst)
  mnst.st_att = 0
  mnst.c_att=#mnst.spels
  anims[#anims+1]=Anim(math.random(TL[mnst.i].x-20, TL[mnst.i].x+20), TL[mnst.i].y+(mnst.th =="pl" and 65 or 20), "break", 1)
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

function whitenoise(x,y,n)
  local n = n or 1
  for h=1,n do
    for i=1,10 do
      for j=1,18 do
        local sprt = 16*math.random(4,7) + math.random(0,1)
        spr(sprt, -8 +i*8 +x,-8+ j*8+y, 0)
      end
    end
  end
end

function duo()
  cls(0)
  backdim()
  show_monst()
  HUD_health()
  do_anims()
  if btnp(6) and not VIS.chox then VIS.chox = true 
  elseif (btnp(5) or btnp(6)) and not VIS.choxchox then VIS.chox = false end
  if slct.act ~= 0 then
    next_turn()
    slct.act = 0
    VIS.chox=false
  elseif VIS.chox then
    show_choices()
    selecti(slct.chox)
  end
  discoball()
end

function discoball()
  for i=1,3 do
    if not HER[i].a then
      whitenoise((i-1)*LENX//3,0,2)
      print("Disconnected", TL[i].x-pxltxt("Disconnected")//2, TL[i].y+60) 
    end
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
debug =true
if debug then
  game.s = 2
  HER = {Player(1, 1), Player(2, 2), Player(3, 3)}
  monstpack={1, 2, 3}
  cmonst = {Monst(1, 1), Monst(1, 2), Monst(1, 3)}
  anims[#anims+1]= Anim(TL[1].x, TL[1].y, "die", 1, cmonst[1], cols[1])
end