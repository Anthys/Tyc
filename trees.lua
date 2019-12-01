cls()
LENX=240
LENY=136
cos = math.cos
sin=math.sin
pi=math.pi

function rnd(mx)
  return math.random()*mx
end

cls()
p=0.111
m=0.7
function br(x1,y1,s,a,d)
  local x2,y2=x1+rnd(20)*cos(a),y1-rnd(s/m)*sin(a)
  line(x1,y1,x2,y2,8+(d/2))
  if d>0 then
    br(x2,y2,(s*m),(a-rnd(p)),d-1)
    br(x2,y2,(s*m),(a+rnd(p)),d-1)
  end
end

function branch(x1,y1,s,a,d,c1,c2,col)
  local col = col or 8
  local c1=c1 or ic1
  local c2=c2 or ic2
  local x2,y2 = x1+cos(a)*s,y1-sin(a)*s
  line(x1,y1,x2,y2,col)
  if d>0 then
    branch(x2,y2,s*c1,a+c2,d-1,c1,c2,col)
    branch(x2,y2,s*c1,a-c2,d-1,c1,c2,col)
  end
end

function branch2(x1,y1,s,a,d,c1,c2,col,coeff)
  local coeff = coeff or 0.5
  local col = col or 8
  local c1=c1 or ic1
  local c2=c2 or ic2
  local x2,y2 = x1+cos(a)*s,y1-sin(a)*s
  line(x1,y1,x2,y2,col)
  if d>0 then
    branch2(x2,y2,s*c1,a+c2,d-rnd(1)-coeff,c1,c2,col)
    branch2(x2,y2,s*c1,a-c2,d-rnd(1)-coeff,c1,c2,col)
  end
end

function branch3(x1,y1,s,a,d,c1,c2,col,coeff)
  local coeff = coeff or 0.5
  local col = col or 8
  local c1=c1 or ic1
  local c2=c2 or ic2
  local x2,y2 = x1+cos(a)*s+3+rnd(0.5)+5/(d+1),y1-sin(a)*s+2
  line(x1,y1,x2,y2,col)
  if d>0 then
    branch3(x2,y2,s*c1,a+c2,d-1,c1,c2,col)
    branch3 (x2,y2,s*c1,a-c2,d-1,c1,c2,col)
  end
end

ic2=0
ic1=0
iic2=pi/6
iic1=0.7
ix = LENX//2
iy = LENY
is = 24
ia = pi/2
id = 8
t=0
anim = 3

function tweak(val, range,speed, func)
  local func = func or sin
  local range = range or val/2
  local speed = speed or 1
  return val + func(t/32*speed)*range
end

ic1=0.925

function ocsill(a,b,t)
  local dist = (a+b)/2
  local ampl = a-dist
  return cos(t)*ampl+dist
end
function TIC()
  t=t+1
  if not (anim == 16 or anim == 17 or anim==18) then  cls() end
  if anim == 1 then
    for i,v in pairs({pi/2,pi,3/2*pi,0}) do
      branch(LENX//2,LENY//2,tweak(24),tweak(v),tweak(8),0.7,pi/6)
    end
  elseif anim==2 then 
    branch(LENX//2,LENY,24,pi/2,8,ic1,ic2)
    branch(LENX//2,0,24,3/2*pi,8,ic1,ic2,6)
    ic2=tweak(pi/6,pi/6)
    ic1=tweak(0.7, 0.7/90)
  elseif anim==3 then
    branch(ix,iy,is,ia,id,ic1,ic2)
    branch(ix,0,is,3/2*pi,id,ic1,ic2,6)
    --ic2=tweak(iic2,1,0.1,math.tanh)
    if t<120 then 
      ic1=math.tanh(t/32)
      ic2=pi/6
    elseif t<400 then
      ic1=1
      local tt= t-120
      local dist = (pi/3+pi/6)/2
      local h = pi/3-dist
      ic2=(math.tanh((tt-100)/32))*h+dist
    elseif t<600 then
      ic1=1
      local tt= t-400
      local dist = (pi/3+pi/6)/2
      local h = pi/6-dist
      ic2=(math.tanh((tt-100)/32))*h+dist
    else
      ic2=pi/6
      local tt= t-600
      ic1=(math.tanh((tt)/32))*-1 + 1
    end
    --if btn(0) then ic1=ic1+0.01 elseif btn(1) then ic1=ic1-0.01 end
    --print(ic1)
    --ic1=tweak(iic1,iic1/2)
  elseif anim == 4 then
    ic1=1
    local tt= 100
    local dist = (pi/3+pi/6)/2
    local h = pi/3-dist
    ic2=(math.tanh((tt-100)/32))*h+dist
    branch(ix,iy,is,ia,id,ic1,ic2)
    branch(ix,0,is,3/2*pi,id,ic1,ic2,6)
  elseif anim ==5 then
    ic1=1
    local tt= 10000
    local dist = (pi/3+pi/6)/2
    local h = pi/3-dist
    ic2=(math.tanh((tt-100)/32))*h+dist
    --branch(ix,iy,is,ia,id,ic1,ic2)
    --branch(ix,0,is,3/2*pi,id,ic1,ic2,6)
    --hexagon(poss[2][1],poss[2][2],40,23,2,23)
    if t%100==1 then switchcol() end
    if t%200<100 then
      showhex(t,LENX//2+20,LENY//2+(true and 15 or 3),8) -- THE 3 IS THE VALUE THAT IS SET FOR THE GRID SHOW BY THE FRACTAL TREE, THE 15 IS A BETTER VALUE, THE GRID SHOULD LERP TOWARD THAT VALUE
    else
      showhex(t)
    end
    gridhex()
    gridhex(LENX//2-21,LENY//2+(true and 15 or 3),8)
    print(t%100)
    --t=300
    --t=80
  elseif anim == 6 then 
    local sp = 1/126*20*83
    local mx = sp*8
    local d
    local tim = t%mx//sp
    print(tim+1)
    if tim == 2 or tim == 6 then branch(0,LENY//2,siz,0,8,0.7,pi/6,12) branch(LENX,LENY//2,siz,pi,8,0.7,pi/6,12)--siz=2*24 
    else siz = 24 end
    if tim<5 then d = tim//2+1
    else 
      d = tim+1
    end
    -- too taa [speed*2] -> (too too taa too too) (big changes on taa)
    branch(LENX//2,LENY,siz,pi/2,d,0.7,pi/6)
  elseif anim == 7 then
    local num = 3
    local frac = pi/num
    local cycl = 2*pi/frac
    for i=0,num*cycl-1 do
      local v = i*frac
      branch(LENX//2,LENY//2,tweak(24),tweak(v),tweak(6),0.7,ic2) --pi/6
      ic2=tweak(pi/6,pi/6, 2)
    end
  elseif anim == 8 then
    local num = 3
    local frac = pi/num
    local cycl = 2*pi/frac
    for i=0,cycl*2 do
      local v = i*frac
      branch(LENX//2,LENY//2,tweak(24),tweak(v),tweak(8),0.7,ic2) --pi/6
      ic2=tweak(pi/6,pi/6, 2)
    end
  elseif anim == 9 then
    local num = 3
    local frac = pi/num
    local cycl = 2*pi/frac
    for i=0,cycl*2 do
      local v = i*frac
      local vv = ocsill(v-pi/3,v+pi/3,t/32)
      branch(LENX//2,LENY//2,tweak(24),vv,tweak(6),0.7,ic2)
      branch(LENX//2,LENY//2,tweak(10),v+t/32,tweak(5),0.7,ic2,4) --pi/6
      ic2=tweak(pi/6,pi/6, 2)
    end
  elseif anim == 10 then
    local num = 3
    local frac = pi/num
    local cycl = 2*pi/frac
    for i=0,cycl*2 do
      local v = i*frac
      local vv = ocsill(v-pi/3,v+pi/3,t/32)
      branch(LENX//2,LENY//2,tweak(24),v-t/32,tweak(6),0.7,ic2)
      branch(LENX//2,LENY//2,tweak(10),v+t/32,tweak(5),0.7,ic2,4) --pi/6
      ic2=tweak(pi/6,pi/6, 2)
    end
  elseif anim == 11 then
    for i=0,5 do
      local v = pi/3*i
      branch(LENX//2,LENY//2,tweak(10),v+t/32,tweak(5),0.7,pi/6,4)
    end
    title_txt="Gemstone"
  elseif anim == 12 then
    for h=-5,5 do
      for j = 1,4 do
        for i=0,5 do
          local v = pi/3*i
          branch(LENX//2+sin(t/32)*9*(j%2*2-1)+h*20+cos(t),-LENY//2 + cos(t/64)*h*math.random(10)  +(t+j*136*2/4)%(2*LENY),tweak(3,1),v+t/32,1,0.7,pi/6,4)
        end
      end
    end
    title_txt="Retarded fireflies"
  elseif anim == 13 then
    for h=-6,6 do
      for j = 1,4 do
        for i=0,5 do
          local v = pi/3*i
          local y = -LENY//2 + h%2*35 + (t+j*136*2/4)%(2*LENY)
          local x = LENX//2+sin(t/32)*9*(j%2*2-1)+h*20
          x = LENX//2+sin(x)*9*(j%2*2-1)+h*20
          branch(x,y,tweak(3,1),v+t/32,1,0.7,pi/6,4)
        end
      end
    end
  elseif anim == 14 then
    local nmb = 20
    local wrap = 8
      for h=-nmb,nmb do
        for j = 1,4 do
          for i=0,5 do
            local v = pi/3*i
            local y = -LENY//2 + h%2*35 + (t+j*136*2/4)%(2*LENY) + h%2*2 + h%3*2 + h%4*2 + h%5*2 + h%1.5*10 + h%-3.2*-6
            local x = LENX//2+sin(t/32)*9*(j%2*2-1)+h*20
            x = LENX//2+sin(y/200)*9*(j%2*2-1)+h*wrap
            branch(x,y,tweak(3,1),v+t/32,1,0.7,pi/6,4)
          end
        end
      end
  elseif anim == 15 then
    branch2(LENX//2,LENY,26,pi/2,tweak(6),0.7,pi/5,8)
  elseif anim == 16 then
    if t%9==1 then
      cls()
      branch3(LENX//2+40,LENY,26,pi/2,8,0.7,pi/5,8)
      branch3(LENX//2-100,LENY,40,pi/2,8,0.7,pi/5,8)
    end
    title_txt="Windy day"
  elseif anim == 17 then
    if t%50==1 then
      cls()
      for x=0,5 do
        br(60+x,120,24,pi/2,8)
        br(150+x,120,24,pi/2,8)
      end
    end
  elseif anim == 18 then
    cls()
    ic2 = iic2--tweak(pi/3)
    ic1 = iic1
    br3(LENX//2,LENY,45,pi/2,7,nil,nil,nil,15*sin(t/32))
  elseif anim == 19 then
    cls()
    ic2 = iic2--tweak(pi/3)
    ic1 = iic1
    pine(LENX//2,LENY,45,pi/2,7,nil,nil,nil,15*sin(t/32))
  elseif anim == 20 then
    cls()
    ic2 = iic2--tweak(pi/3)
    ic1 = iic1
    pine(LENX//2,LENY,20,pi/2,10,nil,pi/3,8,0)
  elseif anim == 21 then
    cls()
    ic2 = iic2--tweak(pi/3)
    ic1 = iic1
    pine(LENX//2,LENY,20,pi/2,10,0.4,pi/3,8,0)
    --pine(LENX//2-70,0,20,-pi/2,10,tweak(0.4),tweak(pi/3),8,0)
  elseif anim == 22 then
    cls()
    ic2 = iic2
    ic1 = iic1
    pine2(LENX//2,LENY,20,pi/2,10,0.4,pi/3,8,0)
  elseif anim == 23 then
    cls()
    ic2 = iic2
    ic1 = iic1
    pine3(LENX//2,LENY,20,pi/2,10,0.5,pi/3,8,0,-1)
    pine3(LENX//2+60,LENY,20,pi/2,10,0.5,pi/3,8,0,-1)
    pine3(LENX//2-90,LENY,20,pi/2,10,0.5,tweak(pi/3),8,0,-1)
  elseif anim == 24 then
    cls()
  end
  if t<100 and show_title and title_txt~="" then title(title_txt,t,100) end
  if btnp(0) then anim = (anim)%maxanim+1 clean_board() end
  if btnp(1) then anim = (anim-2)%maxanim+1 clean_board() end
  if keyp(14) then show_title=not show_title end
end
poss = {{LENX//2,LENY//2-20},{LENX//2+41,LENY//2-20}}

function pine3(x1,y1,s,a,d,c1,c2,col,hh,vv)
  local col = col or 8
  local c1=c1 or ic1
  local c2=c2 or ic2
  local vv = vv or 1
  --c2=tweak(c2)
  local x2,y2 = x1+cos(a)*s,y1-sin(a)*s
  line(x1,y1,x2,y2,d//1)
  y2=y2+3*sign(y2-y1)*vv
  x2=x2+3*sign(x2-x1)*vv
  --x2=x2+sin(t/32)*5
  if d>0 and hh<3 then
    pine3(x2,y2,s*c1,a+c2,d-1,c1,c2,col,hh+1,vv)
    pine3(x2,y2,s*0.9,a,d-1,c1,c2,col,hh,vv)
    pine3(x2,y2,s*c1,a-c2,d-1,c1,c2,col,hh+1,vv)
  end
end

function pine2(x1,y1,s,a,d,c1,c2,col,hh,vv)
  local col = col or 8
  local c1=c1 or ic1
  local c2=c2 or ic2
  local vv = vv or 1
  --c2=tweak(c2)
  local x2,y2 = x1+cos(a)*s,y1-sin(a)*s
  line(x1,y1,x2,y2,d//1)
  y2=y2+3*sign(y2-y1)*sin(t/32)
  x2=x2+3*sign(x2-x1)*sin(t/32)
  --x2=x2+sin(t/32)*5
  if d>0 and hh<3 then
    pine2(x2,y2,s*c1,a+c2,d-1,c1,c2,col,hh+1)
    pine2(x2,y2,s*0.9,a,d-1,c1,c2,col,hh)
    pine2(x2,y2,s*c1,a-c2,d-1,c1,c2,col,hh+1)
  end
end

function sign(x)
  if x <0 then return -1
  elseif x==0 then return 0
  else return 1 end
end

function pine(x1,y1,s,a,d,c1,c2,col,hh)
  local col = col or 8
  local c1=c1 or ic1
  local c2=c2 or ic2
  c2=c2
  local x2,y2 = x1+cos(a)*s,y1-sin(a)*s
  line(x1,y1,x2,y2,d//1)
  if d>0 and hh<3 then
    pine(x2,y2,s*c1,a+c2,d-1,c1,c2,col,hh+1)
    pine(x2,y2,s*0.9,a,d-1,c1,c2,col,hh)
    pine(x2,y2,s*c1,a-c2,d-1,c1,c2,col,hh+1)
  end
end

function br3(x1,y1,s,a,d,c1,c2,col,hh)
  local col = col or 8
  local c1=c1 or ic1
  local c2=c2 or ic2
  c2=c2+hh*pi/50
  local x2,y2 = x1+cos(a)*s,y1-sin(a)*s
  line(x1,y1,x2,y2,d//1)
  if d>0 then
    br3(x2,y2,s*c1,a+c2,d-1,c1,c2,col,hh)
    br3(x2,y2,s*c1,a+c2/2,d-1,c1,c2,col,hh)
    br3(x2,y2,s*c1,a-c2/2,d-1,c1,c2,col,hh)
    br3(x2,y2,s*c1,a-c2,d-1,c1,c2,col,hh)
  end
end

function clean_board()
  t=0
  title_txt=""
end

title_txt = ""
show_title = true
maxanim=23
anim=maxanim
--t=300
siz=24
swi = 0

function title(txt,t,tmx)
  local t = t or t
  local tmx = tmx or 100
  if t>tmx-20 then
    print(txt,0,LENY-9+t-tmx+20,15,false,1,true)
  else print(txt,0,LENY-9, 15,false,1,true) 
  end
end

function gridhex(x,y,col)
  local x,y,col = x or LENX//2,y or LENY//2,col or 6
  for j=-3,3 do
    local yy = y + j*35
    for i=-3,3 do
      local xx = x + i*41 + (j%2==1 and -20 or 0)
      line(xx,yy+3,xx,yy+29,col)
      line(xx,yy+4,xx+19+(j%2==0 and 1 or 0),yy-7,col)
      line(xx,yy+28,xx+19+(j%2==0 and 1 or 0),yy+39,col)
    end
  end
end

function switchcol(inx,r,g,b)
  if inx == nil then
    local r1,g1,b1,r2,g2,b2
    if swi==0 then
      r1,g1,b1,r2,g2,b2=210,20,20,60,100,210
      swi=1
    else
      r1,g1,b1,r2,g2,b2=100,30,30,10,100,250
      swi=0
    end
    pal(6,r1,g1,b1)
    pal(8,r2,g2,b2)
  end
end

function showhex(t,x,y,col)
  local x,y,col = x or LENX//2,y or LENY//2,col or 6
  local tm = 10
  local fr = 9
  for i=1,3 do
    hexagon(x+41*((t//tm+i*3)%fr-4)+1, y-20, nil, nil, col)
    hexagon(x+41*((t//tm+i*3-1)%fr-4)-40//2, y+16, nil, nil, col)
    hexagon(x+41*((t//tm+i*3)%fr-4)+1, y+16+36, nil, nil, col)
    hexagon(x+41*((t//tm+i*3-1)%fr-4)-20, y-20-36, nil, nil, col)
  end
end

function hexagon(x,y,lx,ly,col,triy)
  local lx,ly,col = lx or 40, ly or 24, col or 2
  local triy = triy or 23
  rect(x-lx//2,y-ly//2,lx,ly,col)
  tri(x-lx//2,y-ly//2,x+lx//2,y-ly//2,x,y-triy,col)
  tri(x-lx//2,y+ly//2,x+lx//2,y+ly//2,x,y+triy,col)
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
