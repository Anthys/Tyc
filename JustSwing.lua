LENX = 240
LENY = 136

game = {
 s=1
}

t=0

ST = {'intro', 'segundo','tertio'}

debug = false

function TIC()
 _G[ST[game.s]]()
 t=t+1
end

cos = math.cos
sin = math.sin
abs = math.abs

center = {x = LENX//2, y = LENY//2}

function intro()
  local l = 10
  cls()
  mx,my,mp = mouse()
  pix(center.x, center.y,5)
  local theta = (angle_coord(center.x,center.y,mx,my))
  print(theta)
  local vectx, vecty = l*math.sin(theta), l*math.cos(theta)
  line(mx,my,mx-vectx,my-vecty,5)
  line(mx,my,mx-vectx,my,2)
  line(mx,my,mx,my-vecty,3)
  --print(math.atan((mx-center.x)/(my-center.y)), 0,10)
end

game.s = #ST

function segundo()
  cls()
  print(cos(t/32))
  local l = 20
  local theta = t/32
  local x = cos(theta)*l+LENX//2
  local y = sin(theta)*l+LENY//2
  rect(x,y,8,8,1)
end

pends = {}
mouselock = false

function tertio()
  cls()
  pendule()
  --pendule(nil,nil,nil,nil,math.pi,-math.pi/2)
  pendule(nil,nil,nil,nil,nil,-math.pi/2)
  mx,my,mp = mouse()
  print(angle_coord(LENX//2,LENY//2,mx,my))
  if mp and not mouselock then 
    local a =(angle_coord(LENX//2,LENY//2,mx,my)-math.pi/2)/(math.pi/2)
    if abs(a)>1 then trace(a) else pends[#pends+1]={t=t,x=mx,y=my,alpha=math.acos((angle_coord(LENX//2,LENY//2,mx,my))/(math.pi/2))} end
    mouselock = true
  end
  if #pends>=1 then
    for i=1,#pends do
      pendule(nil,nil,nil,nil,pends[i].alpha,nil,nil,(t-pends[i].t)/32)
    end
  end
  if not mp then mouselock = false end
end

function pendule(xs,ys,amp,w0,alpha,decal,l,tim,noline,col)
  local Amp = amp or math.pi/2
  local w0 = w0 or 1
  local alpha = alpha or 0
  local t = tim or t/32
  local l = l or 20
  local xs = xs or LENX//2
  local ys = ys or LENY//2
  local col = col or 1
  local theta = Amp*cos(w0*t+alpha)+(decal or math.pi/2)
  local x = cos(theta)*l + xs
  local y = sin(theta)*l + ys
  circ(x,y,2,col)
  if not dline then line(xs,ys,x,y,col) end
end

function angle_coord(x1,y1,x2,y2)
  --return math.atan2(y2 - y1, x2 - x1)
  return math.atan2(x2 - x1, y2 - y1)
end