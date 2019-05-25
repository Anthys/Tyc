function sign(n) return n>0 and 1 or n<0 and -1 or 0 end
function lerp(a,b,t) return (1-t)*a + t*b end

function init()
 t=0 --frame count or time
 p={x=120,y=64,spr=256} --player
 cam={x=120,y=64}
 l="\n"
 s=" "
end

init()
function TIC()
  cls(1)
  cam.x=math.min(120,lerp(cam.x,120-p.x,0.05))
  cam.y=math.min(64,lerp(cam.y,64-p.y,0.05))
  --cam.x=math.min(120,120-p.x)
  --cam.y=math.min(64,64-p.y)

  dx,dy=cam.x-120,cam.y-64
  local ccx=cam.x/8+(cam.x%8==0 and 1 or 0)
  local ccy=cam.y/8+(cam.y%8==0 and 1 or 0)
  map(15-ccx,8-ccy,31,18,(cam.x%8)-8,(cam.y%8)-8,0)

  if btn(0) then p.y=p.y-1 end
  if btn(1) then p.y=p.y+1 end
  if btn(2) then p.x=p.x-1 end
  if btn(3) then p.x=p.x+1 end
  
  spr(p.spr,p.x+cam.x,p.y+cam.y)
  rect(cam.x-120+8,cam.y-64+8,8,8,2)

  line(0,68,240,68,15)
  line(120,0,120,136,15)
end