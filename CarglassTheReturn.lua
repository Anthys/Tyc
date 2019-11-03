f=circ
m=64

LENX = 240
LENY=136
nm=3
lm=nm*math.pi*32
--lm=180
--nm=3
a=100
c=math.cos
s=math.sin

function rnd(a)
  return math.random(a)
end

t=0
function TIC()
  t=t+1
  for k=0,200 do f(rnd(LENX),rnd(LENY),4,1) end
  for i=1,nm do
    circb(LENX//2,LENY//2,(t+(i*lm/nm)+5)%lm,15)
  end
  a=s(t/32)*70
  for i=1,50 do
    local p=t+i
    local x=a*c(p)/(s(p)*s(p)+1)--+LENX//2
    local y=a*c(p)*s(p)/(s(p)*s(p)+1)--+LENY//2
    local x2 = c(t/32)*x-y*s(t/32)+ LENX//2 + c(t/32)*40
    local y2 = s(t/32)*x+y*c(t/32) + LENY//2
    local x3 = c(-t/32)*x-y*s(-t/32)+ LENX//2 + c(t/32+math.pi)*40
    local y3 = s(-t/32)*x+y*c(-t/32) + LENY//2
    circ(x2,y2,(c((x2-LENX/2)/32)+1)*-5+10,14)
    circ(x3,y3,(c((x2-LENX/2)/32)+1)*-5+10,13)
  end

end

--[[
function TIC()
  t=t+1
  e=t/2
  v=8*math.sin(e)
  --circb(m,m,m*e%64,9)
  for k=0,150 do f(rnd(128),rnd(128),4,1) end
  for y=m,110+v do
    f(m,y,2,4)
  end
  for y=30,90,.5 do
  f(m+8*math.cos(e+y%1),y+2*math.sin(e+y%1)+v,8,14)
  end
  rect(m+8*math.cos(e),22+v,m+8*math.cos(e+.5),97+v,14)
end]]