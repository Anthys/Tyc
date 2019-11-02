
t=0
s= math.sin
c=math.cos
function TIC()
  cls(0)
  t=t+1
  spiral()
end

function stars()
  for x=0,40 do
    y = c(x+t)*20
    pix(x+100,y+60,15)
  end
end

function tube()
  for x=0,40 do
    local t2=t/10
    y = c(x+ t/32)*30
    pix(x+100,y+60,15)
  end
end

function adn()
  for x=0,120 do
    local t2=t/10
    y = c(s(x/20)+ t/50)*c(x)*15
    pix(x+40,y+60,15)
  end
end

function spiral()
for x=0,120 do
  local t2=t/10
  y = c(s(x/20)+ t/50)*15*s(t/32)
  pix(x+40,y+60,15)
end
end

--[[
cls(12) a=1.62 b=3.14 c=0 s = math.sin co = math.cos
function TIC()
   r=1*math.pow(a,(2/b))
   cls(12)
for i=0,40 do
  for j=-6,6 do
    angley=c*c
    anglex=s(c)*0+1.5
    form=i*.1
    x=(j*r^2*co(c+(0.25*anglex)*form)*j)
    y=(j*r^2*s(c+(0.25*angley)*form)-j*5)
    circ(64+x,64+y,1,j)
end end
c=c+0.005
end]]