LENX = 240
LENY = 136

game = {
 s=1
}

ST={"intro"}

t=0

debug = false

all_units = {}
abs = math.abs

function TIC()
  t=t+1
  _G[ST[game.s]]()
  miss:draw()
end

function intro()
  cls(0)
end

Unit = {}
Unit.__index = Unit

function Unit:new(col, val, x, y)
   local tmp = {}
   setmetatable(tmp,Unit)
   tmp.col = col
   tmp.val = val
   tmp.x = x
   tmp.y=y
   return tmp
end

function Unit:draw()
  --print(abs(math.cos(t/64)*30))
  spr(1,30+abs(math.cos(t/32)*30),40)
  spr(1,30+abs(math.cos(t/32)*100),50)
  --print(self.col)
end

miss = Unit:new(1,1,1,1)
