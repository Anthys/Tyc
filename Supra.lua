function sqr(a) 
  return a*a
end

x1,y1=32,32
x2,y2=32,96
cos = math.cos
sin = math.sin
min = math.min
rnd = math.random

t=0


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

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

pall = {'#1f2ff4', '#292fea', '#3430e1', '#4031d8', '#4b32ce', '#5634c5', '#6235bc', '#6d36b3', '#7836a9', '#8437a0', '#8f3997', '#9a3a8e', '#a63b84', '#b13c7b', '#bc3d72', '#c83f6a'}

for i=1,#pall do
  r,g,b = hex2rgb(pall[i])
  pal(i-1,r,g,b)
end

LENX=240
LENY=136

function TIC()
  t=t+0.04
  x1=LENX//2+128*cos(t/4)
  y1=LENY//2+16*sin(t)

  --circ(x1,y1,5,1)
  --x2=64-128*0.5--cos(t/4)
  --y2=64-16*0.6--sin(t)
  x2=LENX//2+LENX//2*cos(t/2)
  y2=LENY//2+LENY//2*sin(t/2)
  --circ(x2,y2,5,2)

  for i=0,999 do
    x=rnd(LENX)
    y=rnd(LENY)

    l1=sqr((x-x1)/128)+sqr((y-y1)/128)
    v1=sqr(1-l1)
    l2=sqr((x-x2)/128)+sqr((y-y2)/128)
    v2=sqr(1-l2)

    v=v1+v2
    circ(x,y,1,min(v,1)*15.999)
  end

end

function TIC2()
  t=t+0.04

  x1=64+128*cos(t/4)
  y1=64+16*sin(t)

  --circ(x1,y1,5,1)
  --x2=64-128*0.5--cos(t/4)
  --y2=64-16*0.6--sin(t)
  x2=64+60*cos(t)
  y2=64+60*sin(t)
  --circ(x2,y2,5,2)

  for i=0,999 do
    x=rnd(128)
    y=rnd(128)

    l1=sqr((x-x1)/128)+sqr((y-y1)/128)
    v1=sqr(1-l1)
    l2=sqr((x-x2)/128)+sqr((y-y2)/128)
    v2=sqr(1-l2)

    v=v1+v2
    circ(x,y,1,min(v,1)*15.999)
  end

end
