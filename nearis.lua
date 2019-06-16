-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua
-- input:  mouse
t=0
tt=0
indx=1
anims=1
game={
  n=false,
  nc=true, --cooldown
  ac=false, --cooldown
  s=2,
  lvl=1,
}
p={
  x=0,
  y=0,
  flp=0
}
cam={
  x=0,
  y=0,
  cx=0,
  cy=0,
  lx=120,
  ly=120
}
m={
  x=0,
  y=0,
  l=0,
  m=0,
  r=0,
}
ents={}


AN={
  SW={256, 257, 258, 259, 260, 261}
}
--For each level, tells wich rectangles are allowed (al) numbered from L->R U->D
LVL={
  {al={0, 1, 2, 8, 9, 16, 17, 24}}
}
ST={"intro", "level"}
STR={
  INTRO={
    "Note to myself:",
    "I've been trapped in a time loop.",
    "And I escaped it.",
    "...            ",
    "I hope.           "
  },
  THING1={
    "The person I'm closest is a vampire.",
    "And with this statement coexists the fact that vampire don't exist.",
    "",
    "When did my life stopped making any sense?"
  },
  THING2={
    "Am I...",
    "",
    "Am I still in the loop?",
  },
  THING3={
    "My head is spinning.",
    "How am I still in it?",
    "HOW IS IT POSSIBLE?"
  }
}

NTS={
  THING1="As crazy as it may seem, I believe he's trying to escape.",
  THING2="Stability is near breackdown. Just a little more effort."
}

function TIC()
  _G[ST[game.s]]()
  t=t+1
  tt=tt+1
end

function intro()
  if wr_messages(STR.INTRO) then
    game.s = game.s+1
  return
  end
end

--NOT USED
function contains(tab, val)
  for index, value in ipairs(tab) do
      if value==val then
          return true
      end
  end
  return false
end

function wr_messages(arr)
  cls()
  if tt//8>string.len(arr[indx]) then
    indx=indx+1
    tt=0
    if indx>#arr then
      indx = 0
      return true
    end
  end
  local t_txt=arr[indx]
  local color = 12
  print(string.sub(t_txt, 1, math.min(tt//5, string.len(t_txt))), 0, 0, color)
  print(indx, 10, 10)
  return false
end

function level()
  if tt==0 then init_lvl() end
  prx = p.x + 120
  pry = p.y + 64
  cls()
  update_camera()
  update_player()
  rect(cam.x-120+8,cam.y-64+8,8,8,2)
  m.x, m.y, m.l, m.m, m.r = mouse()
  --
  --if tt%60*2==0 then spawn_ents() end 
  --cls()
  update_ents()
  check_input()
  if game.n then update_sight() end
end

function update_sight()
  local tx, ty = (120-cam.x + m.x)//8, (64-cam.y + m.y)//8
  local tile = mget(tx, ty)
  if tile==38 or tile==44 then print("WOW") rectb(cam.x-120+tx*8, cam.y-64+ty*8, 18, 10, 12) end
  if game.ac and m.l then
    if tile == 38 then mset(tx, ty, 44) mset(tx+1, ty, 45)
    elseif tile == 44 then mset(tx, ty, 38) mset(tx+1, ty, 39)
    elseif tile == 241 then firestart(tx, ty) end
    game.ac = false
  end
  if not m.l then game.ac = true end
end

function update_player()
  flp = btn(3) and 0 or btn(2) and 1 or flp
  if btn(0) then try_move(0, -1) end
  if btn(1) then try_move(0, 1) end
  if btn(2) then try_move(-1, 0) end
  if btn(3) then try_move(1, 0) end
   
  spr(p.spr,p.x+cam.x,p.y+cam.y, 0, 1, flp)
end

function try_move(x, y)
  local yesyes=true
  for yx=((prx+x-2)//8), ((prx+x)//8)+1 do
    for yy=((pry+y-2)//8), ((pry+y)//8)+1 do
    if is_full(yx, yy) then yesyes=false end
    end
  end
  if yesyes then p.x=p.x+x p.y=p.y+y end
end

OVRR={[1]=true, [44]=false, [45]=false}

function is_full(x, y)
  local tile = mget(x,y)
  if OVRR[tile]~=nil then return OVRR[tile] end
  if tile>=38 and tile<240 then return true else return false end
end

yes= true
function check_input()
  if m.r and game.nc then for i=0,15 do negate(i) end game.n=not game.n game.nc=false end
  if not m.r then game.nc =true end
  if not game.n and m.l and anims==0 then anims=1 end
  if anims>0 then anim_s() end
end

function anim_s()
  if anims==7 then anims=0 end
  local tx,ty= m.x-p.x-cam.x, m.y-p.y-cam.y
  local tl = math.sqrt(tx*tx+ty*ty)
  tx, ty = tx/tl, ty/tl
  local rtt = 0
  local xa = math.acos(tx)*180/math.pi
  local ya = math.asin(ty)*180/math.pi, 0, 10
  xa= ya>0 and -xa or xa
  xa = xa//90
  if xa==0 then rtt=0 elseif xa==-1 then rtt=1 elseif xa==-2 then rtt=2 else rtt=3 end
  print(xa)
  print(ya, 0 ,10)
  tx,ty=(tx*15 +p.x+cam.x), (ty*15+p.y+cam.y)
  spr(AN.SW[anims], tx,ty, 0, 1, 0, rtt)
  if t%2==0 then anims=anims+1 end
end

function block_cam(x, y)
  if mget(x,y) == 1 then return true else return false end
end


function update_camera()
  local yx, yy = 0, 0
  local clean = true
  --[[
  for x=prx//8-cam.lx//8//2,prx//8+cam.lx//8//2 do
    for y = pry//8, pry//8+1 do
    if block_cam(x, y) then yx=x yy=y cam.x,cam.y = lerp(cam.x,120+(100-(-p.x-120+x*8))-p.x, 0.05), cam.y clean = true end
    end
  end
  for y=pry//8-cam.ly//8//2,pry//8+cam.ly//8//2 do
    for x = prx//8, prx//8+1 do
      if block_cam(x, y) then yx=x yy=y cam.x,cam.y = cam.x, lerp(cam.y,64+(50-(-p.y-64+y*8))-p.y, 0.05) clean = true end
    end
  end
  --]]
  --[[
  for x=prx//8-cam.lx//8//2,prx//8+cam.lx//8//2 do
    trace("--")]]--
    print(cam.x, 0, 30)
    print(240-cam.x)
    print(p.x + 120, 0, 10)
    --trace(p.x-cam.x+120)
    --trace((p.x+cam.x)//8)
    --[[
    for y=pry//8-cam.ly//8//2,pry//8+cam.ly//8//2 do
    --for a,y in pairs({pry//8-cam.ly//8//2, pry//8+cam.ly//8//2}) do
      if block_cam(x, y) then yx=x yy=y cam.x,cam.y = lerp(cam.x,120+(100-(-p.x-120+x*8))-p.x, 0.05), lerp(cam.y,64+(50-(-p.y-64+y*8))-p.y, 0.05) clean = true break end
    end
  end
  ]]--
  --for y=pry//8-cam.ly//8//2,pry//8+cam.ly//8//2 do
  --  for a,x in pairs({prx//8-cam.lx//8//2, prx//8+cam.lx//8//2}) do
  --    if block_cam(x, y) then clean = false break end
  --  end
  --end
  print(clean, 0, 20)
  
  if true then
  cam.x=math.min(120,lerp(cam.x,120-p.x,0.05))
  cam.y=math.min(64,lerp(cam.y,64-p.y,0.05))
  --if math.abs(240-cam.x-(120+p.x))<0.5 then cam.x = round(cam.x) end
  --if math.abs(128-cam.y-(64+p.y))<0.5 then cam.y = round(cam.y) end
  dx,dy=cam.x-120,cam.y-64
  cam.cx=cam.x/8+(cam.x%8==0 and 1 or 0)
  cam.cy=cam.y/8+(cam.y%8==0 and 1 or 0) end
  map(15-cam.cx,8-cam.cy,31,18,(cam.x%8)-8,(cam.y%8)-8,0)
  --rect(cam.x-120+yx*8, cam.y-64+yy*8, 2, 2, 12)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function update_ents()
  for k,l in pairs(ents.spawn) do
    if not game.n then spr(0, cam.x-120+l[1]*8, cam.y-64+l[2]*8) end end
  for a,b in pairs(ents) do
    if a~="spawn" and a~="fireplaces" then 
      for i,j in pairs(b) do
      spr(j[3], cam.x-120+j[1], cam.y-64+j[2], 0) print(j[1], 10, 10) end 
      end
  end
end

function spawn_ents()
  for i,j in pairs(ents.spawn) do
    if j[3]~=1 then j[3]=1 table.insert(ents,{j[1],j[2],50}) end
  end
end

function init_lvl()
  p={x=0,y=0,spr=496}
  ents.spawn={}
  ents.fireplaces={}
  for i,j in pairs(LVL[game.lvl].al) do
    for x=j%8*30,j%8*30+30 do
      for y=j//8*17,j//8*17+17 do
        local tile = mget(x,y)
        if tile == 240 or tile==241 then table.insert(ents.spawn,{x,y,0}) end
        if tile == 241 then make_places(x,y) end
      end
    end
  end
end

function firestart(x, y)
  local di = ents.fireplaces[x*100+y]
  trace("--")
  if not di[1] then
    di[1]=true
    ents[x*100+y] = {}
  for i,j in pairs(di) do
    if i~=1 then
    trace(j[1])
    table.insert(ents[x*100+y], {j[1]*8,j[2]*8, 265})
    end
  end
else ents[x*100+y]=nil di[1]=false
end
end

function make_places(x,y)
  ents.fireplaces[x*100+y]={false}
  for i=x-3,x+3 do
    for j=y+1,y+4 do
        if mget(i, j) == 7 then table.insert(ents.fireplaces[x*100+y], {i,j}) end
    end
  end
end

function pal(i,r,g,b)
	--sanity checks
	if i<0 then i=0 end
	if i>15 then i=15 end
	--returning color r,g,b of the color
	if r==nil and g==nil and b==nil then
		return peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
	else
		if r==nil or r<0 then r=0 end
		if g==nil or g<0 then g=0 end
		if b==nil or b<0 then b=0 end
		if r>255 then r=255 end
		if g>255 then g=255 end
		if b>255 then b=255 end
		poke(0x3fc0+(i*3)+2,b)
		poke(0x3fc0+(i*3)+1,g)
		poke(0x3fc0+(i*3),r)
	end
end

function lerp(a,b,t) return (1-t)*a + t*b end

function negate(i)
  r,g,b = 255-peek(0x3fc0+(i*3)),255-peek(0x3fc0+(i*3)+1),255-peek(0x3fc0+(i*3)+2)
  poke(0x3fc0+(i*3)+2,b)
	poke(0x3fc0+(i*3)+1,g)
  poke(0x3fc0+(i*3),r)
end