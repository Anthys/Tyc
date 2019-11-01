ST= {"water"}
game={s=1}

function TIC()
  _G[ST[game.s]]()
  if keyp(14) then game.s = (game.s)%#ST + 1 end
end


p=pix m=math c=m.cos s=m.sin z=m.random t=0 b=15 cls(8)
curfunc = 1
function water()
  t=t+1
  for x=0,240 do
    l=yes(x)
    for a=0,10 do
      if z()>0.9 then p(x,l-5+a,8) end
    end
    for a=0,b do
      if z()>0.75 and p(x,l+5+a)==b then p(x,l+5+a,8) end
    end
    line(x,0,x,l,b)
    line(x,0,x,l-2,red)
    line(x,l+5+15,x,136,8)
    p(x,l-1,3)
  end
  draw_sky()
  michel(mich1)
  michel(mich2)
  michel(mich3)
  if btnp(6) then curfunc=(curfunc)%2+1 end
  --pix(20,c(20/32+t/32)*20 + 20, 0)
end

function yes(val)
  if curfunc == 1 then
    return c(s(val/32)+t/32)*16+68 +20
  elseif curfunc == 2 then
    return c(s((val+t*2)/32)+t/32)*16+68 +20
  end
end

mich1 = {
  x=120,y=0,vx=1,vy=0
}
mich2 = {
  x=120,y=0,vx=2,vy=0
}
mich3 = {
  x=120,y=0,vx=-1.75,vy=0
}

function michel(mich)
  local m = mich
  local l=yes(m.x)
  if m.y>l then --pix(m.x, m.y)==9 or 
    m.vy = m.vy-0.5>-4 and m.vy-0.5 or m.vy
  else m.vy = math.abs(m.vy+0.1)<6 and m.vy+0.1 or m.vy end
  --[[if btn(3) then 
    local v = m.vx + 0.1
    m.vx=math.abs(v)<2 and v or m.vx
  elseif btn(2) then
    local v = m.vx - 0.1
    m.vx=math.abs(v)<2 and v or m.vx
  end]]--
  m.x = m.x + m.vx
  m.y = m.y + m.vy

  local mx = 280
  local mxx = (mx-240)/2
  m.x = (m.x+mxx)%mx-mxx
  --spr(49, m.x, m.y, 0)
  --draw_mich(m.x, m.y)
  draw_fish(m.x,m.y,m.vx>=0)
end

bib = {{},{3,4,5},{3,4,5,6,7,8},{2,3,4,5,6,7,8},{1,2,5,6,7,8},{1,2,3,4,5,6,7,8},{2,3,4,5,6,7}}

bbib = {
  [0]={
    {5,6,7,8,9},
    {5,10,11},
    {3,4,12},
    {2,13},
    {1,13},
    {1,3,5},
    {1,3,5},
    {1},
    {2},
    {1,5,14,15},
    {2,3,6,16},
    {4,7,16},
    {3,4,7,16},
    {2,6,13,16},
    {3,4,5,11,12,14,15},
    {6,7,8,9,10}
  },
  [14]={
    {},
    {6,7,8,9},
    {10,11},
    {3,5,6,7},
    {2,3,4,5,6,7},
    {2,4,6,7,13,14,15},
    {2,4,6,7,12,13,14,15,16},
    {2,3,4,5,6,7,11,12,13,14,15,16},
    {3,5,6,11,12,13,14,15},
    {2,3,4},
    {4,5,15},
    {5,6,8,15},
    {5,6,8,9,10,14,15},
    {3,4,5,7,8,9,10,11,14,15},
    {6,7,8,9,10}
  },
  [6]={
    {},
    {},
    {5,6,7,8,9},
    {4,8,9,10,11,12},
    {8,9,10,11,12},
    {8,9,10,11,12},
    {8,9,10,11},
    {8,9,10},
    {4,7,8,9,10},
    {6,7,8,9,10,11,12,13},
    {7,8,9,10,11,12,13,14},
    {9,10,11,12,13,14},
    {11,12,13},
    {12}
  }
}

function draw_fish(x,y,inv)
  local l={}
  local maxx = 16
  local dir = inv and -1 or 1
  for a=1,16 do
    l[#l+1]=yes(x+a)
  end
  for col,n in pairs(bbib) do
    for j,v in pairs(n) do
      for i,c in pairs(v) do
        local c2 = (dir==1 and c or (maxx-c+1))
        local x2= x+c2
        local y2=y+j
        if y2<l[c2]-1 then pix(x2,y2,col) end
      end
    end
  end
end

function draw_mich(x, y)
  local l ={}
  for a=1,8 do
    l[#l+1]=yes(x+a)
  end
  for j,v in pairs(bib) do
    for i,c in pairs(v) do
      local x2=x+c
      local y2=y+j
      if y2<l[c]-1 then pix(x2,y2,4) end
    end
  end
end

function draw_sky()
  rect(0,0,240,50,11)
  spr(5,200,10+s(t/32)*5,0,1,0,0,3,3)
  if t%50<25 and t%2==0 then
    local r3,g3,b3=pal(12)
    pal(12,r3,g3-3,b3-3)
  elseif t%50>25 and t%2==0 then
    local r3,g3,b3=pal(12)
    pal(12,r3,g3+3,b3+3)
  end
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

ADDR = 0x3FC0
r1,g1,b1 = pal(11)
r4,g4,b4 = pal(8)
palette = 11
red= 11
maxline = 110

function changered()
  local r2,g2,b2 = pal(11)
  trace("r"..tostring(r2).."g"..tostring(g2).."b"..tostring(b2))
  pal(11,r2-1,g2+5,b2-1)
end
 
function SCN(scnline)
  if scnline < maxline and scnline%3==0 then
    changered()
  elseif scnline == maxline then
    pal(11,r1,g1,b1)
  end
  if scnline >60 and scnline<135 and scnline%1==0 then
    changeblue()
  end
  if scnline == 1 then
    pal(8,r4,g4,b4)
  end
end

function changeblue()
  local r2,g2,b2 = pal(8)
  pal(8,r2-1,g2-1,b2-1)
end