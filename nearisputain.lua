-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua
-- input:  mouse
t=0
tt=0
indx=1
game={
  n=false,
  nc=true,
  s=2,
  lvl=1,
}
p={
  x=0,
  y=0
}
cam={
  x=0,
  y=0,
  cx=0,
  cy=0,
  lx=40,
  ly=40
}
m={
  x=0,
  y=0,
  l=0,
  m=0,
  r=0,
}
ents={}

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
end

function update_player()
  if btn(0) then p.y=p.y-1 end
  if btn(1) then p.y=p.y+1 end
  if btn(2) then p.x=p.x-1 end
  if btn(3) then p.x=p.x+1 end
   
  spr(p.spr,p.x-cam.x,p.y-cam.y, 0)
end

yes= true
function check_input()
  if m.r and game.nc then for i=0,15 do negate(i) end game.n=not game.n game.nc=false end
  if not m.r then game.nc =true end
  if not game.n and m.l then yes=false else yes=true end
end

function block_cam(x, y)
  if mget(x,y) == 18 then return true else return false end
end

function update_camera()
  local clean = true
  for x=p.x//8-cam.lx//8//2,p.x//8+cam.lx//8//2 do
    trace("--")
    trace(cam.x)
    trace(p.x)
    trace(p.x+cam.x)
    trace((p.x+cam.x)//8)
    for a,y in pairs({p.y//8-cam.ly//8//2, p.y//8+cam.ly//8//2}) do
      if block_cam(x, y) then clean = false break end
    end
  end
  for y=p.y//8-cam.ly//8//2,p.y//8+cam.ly//8//2 do
    for a,x in pairs({p.x//8-cam.lx//8//2, p.x//8+cam.lx//8//2}) do
      if block_cam(x, y) then clean = false break end
    end
  end
  if yes then
  cam.x=math.min(p.x-120)--lerp(cam.x,p.x-120,0.05))
  cam.y=math.min(p.y-64)--lerp(cam.y,p.y-64,0.05))
  if cam.x<0 then cam.x=0 end
  if cam.y<0 then cam.y=0 end
  cam.cx=cam.x//8
  cam.cy=cam.y//8 end
  map(cam.cx,cam.cy,31,18,cam.x%8,0,0)
end

function update_ents()
  for k,l in pairs(ents.spawn) do
    print(l[1])
    spr(0, cam.x-120+l[1]*8, cam.y-64+l[2]*8) end
  for i,j in pairs(ents) do
    if i~="spawn" then spr(1, j[1]*8-cam.x, j[2]*8-cam.y) print(j[1]*8-cam.x, 10, 10) end 
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
  for i,j in pairs(LVL[game.lvl].al) do
    for x=j%8*30,j%8*30+30 do
      for y=j//8*17,j//8*17+17 do
        if mget(x, y) == 240 then table.insert(ents.spawn,{x,y,0}) end
      end
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