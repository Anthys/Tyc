
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

SP = {
  {"Sword", "Sword attack", "att", "3"},
  {"Axe", "Axe attack", "att", "5"},
  {"Feint", "Feint", "def", "100"},
  {"Shield", "Shield", "def", "4"},
  {"BluePo", "Blue Potion", "heel", "2"},
  {"VeryBluePo", "Potion that is very blue", "heel", "4"}
  --{"name str", "description str", "type str (att, def, heel)", "value int", "optio"}
}

ST = {"intro", "duo"}

BIB = {
  MONST={
    {"vampire", "scary scary", 1, {1, 2}, 9}
    --{"name", "description", "shape", "attacks list", "pv"}
  },
  MSTATT={
    {"claw", "2", "att", "2"},
    {"fireball", "2", "att", "5", true},
    {"sneaky jump", "1", "def", "100"}
    --{"name", "preptime int", "type", "value", "stopable bool false default"}
  }
}



HER = {
  {
    spels = {1, 2, 3}
  },
  {
    spels = {1, 4, 5}
  },
  {
    spels = {2, 3, 6}
  }
}

splbl = {}

function trace_table(tbl)
  local res = ""
  if type(tbl) ~= "table" then return tbl end
  for i,v in pairs(tbl) do 
    res = res .. "," .. trace_table(v)
  end
  return res
end

function actu_spells()
  splbl = {}
  for v,i in pairs(HER) do
    table.insert(splbl,{})
    trace(i)
    for a,j in pairs(i.spels) do
      local f = SP[j][1]
      table.insert(splbl[#splbl], f)
    end end
  trace(trace_table(splbl))
end

function TIC()
  _G[ST[game.s]]()
  t=t+1
  tt=tt+1
  if keyp(14) then game.s = (game.s)%#ST + 1 end
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

game.s =2

function rect_choices()
  rect(10,100,LENX-20,LENY-110, 8)
  rectb(10,100,LENX-20,LENY-110, 0)
end

TL = {30, 100, 180}

cmonst = {}

function show_choices()
  rect_choices()

  local dic = splbl
  for d=1,#dic do
    cd = dic[d]
    for m= 1,#cd do 
      print(cd[m],TL[d],100+m*6,0,false,1, false)
    end
  end
end


function newmonst(monst, indx)
  cmonst[indx] = table.clone(BIB.MONST[monst])
  local at = cmonst[indx][4][1]
  cmonst[indx][#cmonst[indx]+1] = at
end

for i=1,3 do
  newmonst(1, i)
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
  rectb(20, 104-6 + nm*6, LENX-40, 9, 9)
  if not VIS.choxchox then
    rect(10, 10, 20, 10, 12)
    print("X to back, S to inspect", 10, 10)
    if btnp(0) then slct.chox = (slct.chox-2)%chs+1
    elseif btnp(1) then slct.chox = (slct.chox)%chs+1
    elseif btnp(7) then VIS.choxchox = true  
    end
  elseif not VIS.descp then
    rect(10, 10, 20, 10, 12)
    print("X to back, Z to inspect", 10, 10)
    if btnp(2) then slct.choxchox = (slct.choxchox-2)%3+1
    elseif btnp(3) then slct.choxchox = (slct.choxchox)%3+1
    elseif btnp(5) then VIS.choxchox = false
    elseif btnp(4) then VIS.descp = true
    end
    rectb(21+(slct.choxchox-1)*75, 104-6+1 + nm*6, 50-2, 9-2, 10)
  else
    rect(10, 10, 20, 10, 12)
    print("X to back", 10, 10) 
    show_descsp(slct.chox, slct.choxchox) 
    if btnp(5) then VIS.descp = false end 
  end
end

function show_descsp(a,b)
  rect(60, 40, 60, 40, 11)
  local v = HER[b].spels[a]
  print(SP[v][2], 65, 45)
end

slct = {chox=1, choxchox=1}
VIS={chox=false, choxchox=false, descsp=false}


function show_monst()
  for i,v in pairs(cmonst) do
    trace(trace_table(v))
    print(v[1 ], 10 -50+70*i, 30, 1)
    circle_grow(10 -30 + 70*i, 60, 20)
    local at = BIB.MSTATT[v[6]][1]
    print("Preparing \n"..at, 10-50+70*i, 90, 1) 
  end
end

function duo()
  cls(0)
  backdim()
  show_monst()
  print(VIS.choxchox)
  if btnp(6) then VIS.chox = true actu_spells() 
  elseif btnp(5) and not VIS.choxchox then VIS.chox = false end
  if VIS.chox then
    show_choices()
    selecti(slct.chox)
  end
end

function circle_cons(x, y, r, n, inv)
  local n = n or 2
  local inv = inv and -1 or 1
  pix(x, y, 1)
  local ecrt = 4
  if n == 4 then ecrt = r/3 end
  local theta = inv*((t/spd)%50/50)*2*math.pi
  print(math.cos(theta))
  circ(math.cos(theta)*r+x, math.sin(theta)*r+y, r-ecrt, 2)
  circ(math.cos(theta+math.pi)*r+x, math.sin(theta+math.pi)*r+y, r-ecrt, 2)
  if n==4 then circ(math.cos(theta+(math.pi/2))*r+x, math.sin(theta+(math.pi/2))*r+y, r-ecrt, 2) circ(math.cos(theta+(3*math.pi/2))*r+x, math.sin(theta+(3*math.pi/2))*r+y, r-ecrt, 2) end
end

function circle_grow_cons(x, y, r)
  local n = 2
  local inv = 1
  pix(x, y, 1)
  local ecrt = 4
  if n == 4 then ecrt = r/3 end
  local theta = inv*((t/spd)%50/50)*2*math.pi
  print(math.cos(theta))
  circle_grow(math.cos(theta)*r+x, math.sin(theta)*r+y, r-ecrt)
  circle_grow(math.cos(theta+math.pi)*r+x, math.sin(theta+math.pi)*r+y, r-ecrt)
  if n==4 then circ(math.cos(theta+(math.pi/2))*r+x, math.sin(theta+(math.pi/2))*r+y, r-ecrt, 2) circ(math.cos(theta+(3*math.pi/2))*r+x, math.sin(theta+(3*math.pi/2))*r+y, r-ecrt, 2) end
end


function circle_grow(x, y, r, inv)
  local tim = (t//spd)%(r*2)
  local colors = {1, 2}
  if tim>r then colors = {2, 1} tim = tim-r end
  circ(x,y,r,colors[1])
  if inv then circ(x,y,tim,colors[2]) else circ(x,y,r-tim,colors[2]) end
end