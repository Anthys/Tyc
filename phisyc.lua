LENX = 240
LENY = 136

game = {
 s=1
}


JUMP_DY={-3,-3,-3,-3,-2,-2,-2,-2,
  -1,-1,0,0,0,0,0}

t=0
tt=0

pA = {
  x = 0,
  y = 0
}

pB = {
  x=0,
  y=0,
 jmp=0, -- 0=not jumping, otherwise
 -- it's the cur jump frame
jmpSeq=JUMP_DY, -- set during jump
grounded = false,
lx = 8,
ly=8
}

pC = {
  jmp=0, -- 0=not jumping, otherwise
  -- it's the cur jump frame
  jmpSeq=JUMP_DY, -- set during jump

  x=0,
  y=0,
  dx=0,
  dy=0,
  ddx=0,
  ddy=0,
  grounded=false,
  lx=8,
  ly=8
}

ST = {'A', "B","C","D","E","F"}
names= {"Top down, no drag, no forces", "Credit to pandas, x is basic incrementation\ny is a set animation", "Forces for y, not for x\n+no collisions for x",
"forces+drag for x, forces for y", "forces + drag for x y", "drag for x y"}
debug = false

function TIC()
 _G[ST[game.s]](pC)
 t=t+1
 tt = tt +1
 if tt<100 then print(names[game.s], LENX//2 - print(names[game.s], -100,-100)//2, 0)
 elseif tt<140 then print(names[game.s], LENX//2 - print(names[game.s], -100,-100)//2, 0-(tt-100)/4) end
 if keyp(14) then game.s = (game.s)%#ST+1 tt = 0 end
end

game.s = #ST


function IsOnGround(p)
  for i=0,p.lx-1 do
    if blocked(p.x+i, p.y+p.ly) then
      return true
    end
  end
  return false
end

function blocked(x,y)
  return mget(x//8,y//8) == 1
end


function CanMove(p,x,y)
  for i=0,p.lx-1 do
    for j=0,p.ly-1 do
      if blocked(i+x,j+y) then
        return false
      end
    end
  end
  return true
end

function TryMoveBy(p,dx,dy)
  if CanMove(p,p.x+dx,p.y+dy) then
   p.x=p.x+dx
   p.y=p.y+dy
   return true
  end
  return false
 end

function A(pA)
  cls()
  map()
  get_input_A(pA)
  draw_player_A(pA)
end



function B(pB)
  cls()
  map()
  print(IsOnGround(pB), 0, 50,7)

  if (pB.jmp==0 and
   not IsOnGround(pB)) then
  -- fall
  pB.y=pB.y+1
 end

  if IsOnGround(pB) then pB.grounded = true else pB.grounded = false end
  if btn(0) then wantJmp = true else wantJmp = false end

  local canJmp=pB.grounded
 -- jump
 if wantJmp and canJmp then
  pB.jmp=1
  pB.jmpSeq=JUMP_DY
 end

 if pB.jmp>#pB.jmpSeq then
  -- end jump
  pB.jmp=0
 elseif pB.jmp>0 then
  local ok=TryMoveBy(pB,
    0,pB.jmpSeq[pB.jmp])
  -- if blocked, cancel jump
  pB.jmp=ok and pB.jmp+1 or 0
 end
 get_input_C(pB)
 draw_player_A(pB)
end

function C(pC)
  pC.dx = 0
  cls()
  map()
  if not IsOnGround(pC) then pC.dy = math.min(pC.dy+0.5,3) else pC.dy = 0 end
  if IsOnGround(pC) and btn(0) then print(1) pC.dy = pC.dy - 5 end
  if not TryMoveBy(pC,pC.dx,pC.dy) then pC.dy = pC.dy/2 end
  get_input_B(pC)
  draw_player_A(pC)
end

function D(pC)
  local dragx=0.1
  local dragy = 0.1
  cls()
  map()
  --if not IsOnGround(pC) then pC.dy = math.min(pC.dy+0.5,3) else pC.dy = 0 end
  if not IsOnGround(pC) then pC.dy = pC.dy+0.5 else pC.dy = 0 end
  if IsOnGround(pC) and btn(0) then print(1) pC.dy = pC.dy - 8 end
  pC.dy = pC.dy - sign(pC.dy)*dragy*math.abs(pC.dy)
  if not TryMoveBy(pC,0,pC.dy) then pC.dy = pC.dy/2 end
  get_input_D(pC)
  pC.dx = pC.dx - sign(pC.dx)*dragx*math.abs(pC.dx)
  if not TryMoveBy(pC,pC.dx,0) then pC.dx = pC.dx/2 end
  draw_player_A(pC)
end

function E(pC)
  local dragx=0.1
  local dragy = 0.1
  cls()
  map()
  if not IsOnGround(pC) then pC.dy = math.min(pC.dy+0.5,3) else pC.dy = 0 end
  if IsOnGround(pC) and btn(0) then print(1) pC.dy = pC.dy - 8 end
  --pC.dy = pC.dy - sign(pC.dy)*dragy*math.abs(pC.dy)
  if not TryMoveBy(pC,0,pC.dy) then pC.dy = pC.dy/2 end
  get_input_D(pC)
  pC.dx = pC.dx - sign(pC.dx)*dragx*math.abs(pC.dx)
  if not TryMoveBy(pC,pC.dx,0) then pC.dx = pC.dx/2 end
  draw_player_A(pC)
end

function F(pC)
  local dragx=0.1
  local dragy = 0.1
  cls()
  map()
  get_input_E(pC)
  pC.dx = pC.dx - sign(pC.dx)*dragx*math.abs(pC.dx)
  if not TryMoveBy(pC,pC.dx,0) then pC.dx = pC.dx/2 end
  
  pC.dy = pC.dy - sign(pC.dy)*dragy*math.abs(pC.dy)
  if not TryMoveBy(pC,0,pC.dy) then pC.dy = pC.dy/2 end
  draw_player_A(pC)
end


function get_input_A(p)
  if btn(0) then p.y = p.y -1 end
  if btn(1) then p.y = p.y +1 end
  if btn(2) then p.x = p.x -1 end
  if btn(3) then p.x = p.x +1 end
end

function get_input_B(p)
  if btn(2) then p.x = p.x -1 end
  if btn(3) then p.x = p.x +1 end
end

function get_input_C(p)
  if btn(2) then TryMoveBy(p,-1,0) end
  if btn(3) then TryMoveBy(p,1,0)  end
end


function get_input_D(p)
  local dd = 0.3
  if btn(2) then p.dx=p.dx-dd end
  if btn(3) then p.dx=p.dx+dd end
end

function get_input_E(p)
  local dd = 0.3
  if btn(0) then p.dy=p.dy-dd end
  if btn(1) then p.dy=p.dy+dd end
  if btn(2) then p.dx=p.dx-dd end
  if btn(3) then p.dx=p.dx+dd end
end

function sign(a)
  return a<0 and -1 or 1
end

function draw_player_A(p)
  print("a", p.x, p.y)
end

function draw_player_A(p)
  rect(p.x, p.y, 8,8,1)
end