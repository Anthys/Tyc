LENX = 240
LENY = 136

m=math
c=math.cos
s=math.sin
abs=math.abs

game = {
 s=1
}

p={
  x=5,
  y=100,
  amp=20,
  s=2, --side: 2 left 3 right 0 up 1 down
  l = 8,
  cx=0,
  cy=0,
  d=0,
  lp=0,
  hit=0,
  immun=0
}

t=0

ST = {'intro'}

debug = false

function TIC()
 _G[ST[game.s]]()
 t=t+1
end

function intro()
  cls(0)
  border()
  inp()
  check_edge()
  render_ents()
  render_player()
  show_tempo()
  p.d = lerp(p.d, 0, 0.05)
  if SLC.get_tempo==1 then get_tempo()end
  if keyp(49) then debug=not debug end
  if debug then show_debug() end
end

function lerp(a,b,t) return (1-t)*a + t*b end

function border()
  rectb(0,0,LENX,LENY,3)
end

function plx(txt)
  return print(txt, -100,-100)
end

function show_tempo()
  local txt = "TEMPO:"..tostring(tempo*60*60/m.pi)
  print(txt, LENX//2-plx(txt)//2,LENY//2)
  if btw((t*tempo)%(m.pi), m.pi/2-0.03,m.pi/2+0.15) then circ(50,50,5,6) end
end

function btw(v,lw,hg)
  return v>lw and v<hg
end

michel = true

function show_debug()
  print(p.cx)
  print(p.cy, 0,10)
  print(p.s, 0,20)
  print(p.hit,0,30)
  print(p.immun,0,40)
  print(tostring(time()//1000),0,50)
  if time()//1000==10. and michel then trace(t) michel=false end
end

function check_edge()
  local tempo = tempo
  local siz = p.l
  if p.s//2==1 then
    if p.y<=0 then p.s=0 p.y=1 p.x=p.cx p.d=newpd()
    elseif p.y>=LENY-siz then p.s=1 p.y=LENY-p.l-1 p.x=p.cx p.d=newpd() end
  else
    if p.x<=0 then p.s=2 p.x=1 p.y=p.cy p.d=newpd()
    elseif p.x>=LENX-siz then p.s=3 p.x=LENX-p.l-1 p.y=p.cy p.d=newpd() end
  end
end

function newpd()
  return (m.pi/2-t*tempo)%(m.pi)
end

-- 0.2 == 73
--tempo = 0.2/m.pi
tempo = 1/60*m.pi

incv = 1.5

function inp()
  local var = p.s//2==1 and "y" or "x"
  if btn(abs(p.s*2-3)==3 and 3 or 2) then p[var]=p[var]-incv
  elseif btn(abs(p.s*2-3)==3 and 2 or 3) then p[var]=p[var]+incv end
  if btn(0) then p.amp=p.amp+1
  elseif btn(1) then p.amp=p.amp-1 end
  if key(16) then tempo=tempo+0.001/m.pi elseif key(13) then tempo=tempo-0.001/m.pi end
  if key(12) then t=m.pi/(tempo*2) end
  if keyp(20) then SLC.get_tempo=1 end
end

function render_ents()
  for i,v in pairs(ents) do 
    v:move()
    v:draw()
  end
end

Ent = {}
Ent.__index = Ent

function Ent:new(x,y,typ,spr,l,o)
  local tmp = {}
  setmetatable(tmp,Ent)
  tmp.x=x or 0
  tmp.y=y or 0
  tmp.type=typ or 1
  tmp.spr = spr or 2
  tmp.l = l or 8
  tmp.o=o or {}
  return tmp
end

ents = {}

ents[#ents+1] = Ent:new()
ents[#ents+1] = Ent:new(0,0,2)
ents[#ents+1] = Ent:new(0,0,3)
ents[#ents+1] = Ent:new(0,0,4,2,8,{x1=20,x2=80,y1=20,y2=80})

function Ent:move()
  if self.type == 1 then
    self.x=c(t/32)*40+LENX//2
    self.y=100
  elseif self.type ==2 then 
    local x = t*tempo
    local thin = s(x)+s(3*x)/3
    self.x = 70+thin*50
    self.y= c(x)*40+50
  elseif self.type ==3 then 
    local x = t*tempo/2 + 0.8
    local thin = s(x)+s(3*x)/3
    self.x = 70+thin*50
    self.y= c(x)*40+50 
  elseif self.type ==4 then
    local tx,ty
    local tt = t*tempo%(2*m.pi)
    print(tt, 0,20)
    if btw(tt,0,0.5) then tx,ty=self.o.x1,self.o.y1
    elseif btw(tt,m.pi,m.pi+0.5) then tx,ty=self.o.x2,self.o.y2 
    elseif btw(tt,0.5,m.pi) then tx,ty=tt*(self.o.x2-self.o.x1)/(m.pi-0.5), tt*(self.o.y2-self.o.y1)/(m.pi-0.5) 
    else tx,ty=tt*(self.o.x1-self.o.x2)/(-m.pi-0.5),tt*(self.o.y1-self.o.y2)/(-m.pi-0.5) end
    self.x=tx
    self.y=ty
  end  
end

function Ent:draw()
  if self.type == 1 then
    spr(self.spr,self.x,self.y)
  elseif self.type == 2 then
    rect(self.x,self.y,5,5,6)
  elseif self.type == 3 then
    rect(self.x,self.y,5,5,6)
  elseif self.type == 4 then
    rect(self.x,self.y,5,5,8)
  end
end



SLC = {get_tempo=0,input_tempo=0}

c_rtempo = '60'
tempo_t = {ltempo = {}, l_tim=0, c_m_tempo=0}

function mean(l)
  local s = 0
  for i,v in pairs(l) do
    s=s+v
  end
  return s/#l
end

function get_tempo()
  rect(10,10,LENX-20,LENY-20,7)
  local s_ip = SLC.input_tempo==1
  local avtempo = "0"
  local txt = "Tap space to get tempo\nEnter to validate\nR to reset\nT to input tempo"
  if keyp(48) then 
    if tempo_t.l_tim ==0 then tempo_t.l_tim = time()
    else
      tempo_t.ltempo[#tempo_t.ltempo+1]= time()-tempo_t.l_tim tempo_t.l_tim=time() 
      tempo_t.c_m_tempo=60/(mean(tempo_t.ltempo)/1000)
    end
  end
  if keyp(51) then tempo_t.ltempo = {} tempo_t.l_tim=0 tempo_t.c_m_tempo=0 end
  print(txt, cnttxt(txt), 20)
  txt= "Average tempo: "..tostring(tempo_t.c_m_tempo)
  print(txt, cnttxt(txt),80)
  if keyp(09) and not s_ip then SLC.input_tempo=1 end
  if keyp(50) and not s_ip then SLC.get_tempo=0 change_tempo(tempo_t.c_m_tempo) tempo_t.ltempo = {} tempo_t.l_tim=0 tempo_t.c_m_tempo=0 end
  if s_ip then input_tempo() end
end

function cnttxt(txt)
  return LENX//2 - plx(txt)//2
end

function change_tempo(x)
  tempo = tonumber(x)*m.pi*1/60*1/60
end

function input_tempo()
  if keyp(50) then SLC.input_tempo=0 SLC.get_tempo=0 change_tempo(c_rtempo) end
  local txt = "Input tempo:"..c_rtempo
  print(txt, LENX//2-plx(txt)//2, 100)
  for i=27,36 do
    if keyp(i) then 
      local test = c_rtempo..tostring(i-27)
      if tonumber(test)<200 then c_rtempo=test end
    end
  end
  if keyp(51) and c_rtempo~="" then c_rtempo=string.sub(c_rtempo,0,#c_rtempo-1) end
end

function render_player()
  if p.immun>0 then p.immun=p.immun-1 end
  --rect(70+c(t/32)*50,40,5,5,6)
  local bp_st = p.s%2==1 and (p.s==3 and LENX-p.l or LENY-p.l) or 1 
  local mod = p.s%2==1 and -1 or 1
  local cx = (p.s//2==1) and bp_st+mod*abs(c(t*tempo+p.d))*p.amp or p.x
  local cy = (p.s//2==0) and bp_st+mod*abs(c(t*tempo+p.d))*p.amp or p.y
  p.cx=cx
  p.cy=cy
  ennemy_collision()
  spr(1,cx,cy)
end

function vect(x,y)
  return {x=x,y=y}
end

function ennemy_collision()
  if p.immun>0 then return end
  local x1,x2,y1,y2 = p.cx,p.cx+p.l,p.cy,p.cy+p.l
  for i,v in pairs(ents) do
    local e1,e2,e3,e4 = vect(v.x,v.y),vect(v.x+v.l,v.y),vect(v.x,v.y+v.l),vect(v.x+v.l,v.y+v.l)
    for k,l in pairs({e1,e2,e3,e4}) do
      if btw(l.x,x1,x2) and btw(l.y,y1,y2) and p.immun==0 then p.hit=p.hit+1 p.immun = 60 end
    end
  end
end