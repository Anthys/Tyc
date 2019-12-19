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

function Player:new(spr,x,y)
  local tmp = {}
  setmetatable(tmp,Player)
  tmp.x=x or 0
  tmp.y=y or 0
  tmp.vx = 0
  tmp.vy = 0
  tmp.dirx = 0
  tmp.diry = 0
  tmp.spr = spr or 1
  return tmp
end

p1,p2 = Player:new(1), Player:new(3)

cur_player = 1

players = {p1,p2}

function TIC()
  _G[ST[game.s]]()
  t=t+1
end

function intro()
  local theplayer = players[cur_player]
  tt=tt+1
  cls(0)
  print(1)
  render_m()
  get_input(theplayer)
  physics_p(theplayer)
  for i,v in pairs(players) do
    render_p(v)
  end
  debug()
  if tt%100 == 0 then alternate() end
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
  spr(p.spr,p.x,p.y,0,1,0,0,2,2)
end