LENX = 240
LENY = 136

game = {
   s=1
  }
  
t=0
tt=0

ST = {'intro'}

debug = false

Player = {}
Player.__index = Player

function Player:new(spr,x,y,lx,ly,col)
  local tmp = {}
  setmetatable(tmp,Player)
  tmp.x=x or 0
  tmp.y=y or 0
  tmp.dx = 0
  tmp.dy = 0
  tmp.dirx = 0
  tmp.diry = 0
  tmp.spr = spr or 1
  tmp.lx = lx or 8
  tmp.ly = ly or 8*2
  tmp.lines = {}
  tmp.col = col or 6
  return tmp
end

p1,p2 = Player:new(6,nil,nil,nil,nil,6), Player:new(7,nil,nil,nil,nil,2)

cur_player = 1

players = {p1,p2}

function TIC()
  _G[ST[game.s]]()
  t=t+1
  tt=tt +1
end

function get_others(p)
  local tmp = {}
  for i,v in pairs(players) do
    if v ~= p then tmp[#tmp+1]=v end
  end
  return tmp
end

function intro()
  local theplayer = players[cur_player]
  local others = get_others(theplayer)
  cls(0)
  print(1)
  render_m()
  --get_input(theplayer)
  --physics_p(theplayer)
  physics_d(theplayer)
  if tt%2==0 then 
    add_line(theplayer) 
    for i,v in pairs(others) do
      remove_line(v)
    end
  end
  for i,v in pairs(players) do
    render_p(v)
    draw_lines(v)
  end
  debug()
  if tt%100 == 0 then alternate() end
end

function remove_line(p)
  table.remove(p.lines, 1)
end

function add_line(p)
  p.lines[#p.lines+1] = {p.x+p.lx//2,p.y+p.ly//2}
end

function draw_lines(p)
  --print("yes")
  if #p.lines >= 2 then
    for i=1,#p.lines-1 do
      local v1,v2 = p.lines[i],p.lines[i+1]
      line(v1[1],v1[2],v2[1],v2[2],p.col)
    end
  end
end

function render_m()
  map()
end

CONSTS = {
  incx = 2,
  incy = 5
}

function get_input(p)
  local mx,my = CONSTS.incx, CONSTS.incy  
  if btnp(0) then p.diry = -my end
  if btnp(1) then p.diry = my end
  --if btn(2) then p.dirx = -mx end
  --if btn(3) then p.dirx = mx end
end

function debug()
  --print(p1.vx)
  --print(p1.vy, 0,10)
  print(tt%100)
end

function alternate()
  cur_player = (cur_player)%#players+1
end

function physics_p(p)
  local mx = CONSTS.incx
  p.vy = p.vy + 0.3
  p.vy = p.vy + p.diry
  p.vx = p.vx + p.dirx
  if can_move(p.x+p.vx,p.y+p.vy) then
    p.x = p.x+p.vx
    p.y = p.y+p.vy
  else
    --p.vx = 0
    p.vy = 0
  end
  local dx = 0
  if btn(2) then dx = -mx
  elseif btn(3) then dx = mx end
  if can_move(p.x+dx, p.y) then
    p.x = p.x + dx
  end
  p.vx = p.vx/2
  p.dirx=0
  p.diry=0
end



function can_move(x,y)
  if mget(x//8,y//8+2) ~= 65 then return true else return false end
end

function render_p(p)
  spr(p.spr,p.x,p.y,0,1,0,0,p.lx//8,p.ly//8)
end

--physics

function physics_d(pC)
  local dragx=0.1
  local dragy = 0.05
  --if not IsOnGround(pC) then pC.dy = math.min(pC.dy+0.5,3) else pC.dy = 0 end
  if not IsOnGround(pC) then pC.dy = pC.dy+0.5 else pC.dy = 0 end
  if IsOnGround(pC) and btn(0) then print(1) pC.dy = pC.dy - 8 end
  pC.dy = pC.dy - sign(pC.dy)*dragy*math.abs(pC.dy)
  if not TryMoveBy(pC,0,pC.dy) then pC.dy = pC.dy/2 end
  get_input_E(pC)
  pC.dx = pC.dx - sign(pC.dx)*dragx*math.abs(pC.dx)
  if not TryMoveBy(pC,pC.dx,0) then pC.dx = pC.dx/2 end
end

function get_input_D(p)
  local dd = 0.3
  if btn(2) then p.dx=p.dx-dd end
  if btn(3) then p.dx=p.dx+dd end
end

function get_input_E(p)
  local dd = 2
  if btn(2) then p.dx=-dd end
  if btn(3) then p.dx=dd end
end

function IsOnGround(p)
  for i=0,p.lx-1 do
    if blocked(p.x+i, p.y+p.ly) then
      return true
    end
  end
  return false
end

function blocked(x,y)
  return mget(x//8,y//8) == 65
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

function sign(a)
  return a<0 and -1 or 1
end
