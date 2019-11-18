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
  d=0
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
  render_player()
  show_tempo()
  p.d = lerp(p.d, 0, 0.05)
  if SLC.get_tempo==1 then get_tempo()end
end

function lerp(a,b,t) return (1-t)*a + t*b end

function border()
  rectb(0,0,LENX,LENY,3)
end

function plx(txt)
  return print(txt, -100,-100)
end

function show_tempo()
  local txt = "TEMPO:"..tostring(tempo*m.pi*73/0.2)
  print(txt, LENX//2-plx(txt)//2,LENY//2)
  if btw((t*tempo)%(m.pi), m.pi/2-0.03,m.pi/2+0.15) then circ(50,50,5,6) end
end

function btw(v,lw,hg)
  return v>lw and v<hg
end

function check_edge()
  local tempo = tempo
  print(p.cx)
  print(p.cy, 0,10)
  print(p.s, 0,20)
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
  return (m.pi/2-t*tempo)%(2*m.pi)
end

-- 0.2 == 73
tempo = 0.2/m.pi

function inp()
  local var = p.s//2==1 and "y" or "x"
  if btn(abs(p.s*2-3)==3 and 3 or 2) then p[var]=p[var]-1 
  elseif btn(abs(p.s*2-3)==3 and 2 or 3) then p[var]=p[var]+1 end
  if btn(0) then p.amp=p.amp+1
  elseif btn(1) then p.amp=p.amp-1 end
  if key(16) then tempo=tempo+0.001/m.pi elseif key(13) then tempo=tempo-0.001/m.pi end
  if key(12) then t=m.pi/(tempo*2) end
  if keyp(20) then SLC.get_tempo=1 end
end

SLC = {get_tempo=0,input_tempo=0}

c_rtempo = '73'

function get_tempo()
  rect(10,10,LENX-20,LENY-20,7)
  local s_ip = SLC.input_tempo==1
  local avtempo = "0"
  local txt = "Tap space to get tempo\nEnter to validate\nR to reset\nT to input tempo"
  print(txt, cnttxt(txt), 20)
  txt= "Average tempo: "..tostring(avtempo)
  print(txt, cnttxt(txt),80)
  if s_ip then input_tempo() end
  if keyp(09) and not s_ip then SLC.input_tempo=1 end
  if keyp(50) then SLC.get_tempo=0 change_tempo(c_rtempo) end
end

function cnttxt(txt)
  return LENX//2 - plx(txt)//2
end

function change_tempo(x)
  tempo = tonumber(x)*0.2/(73*m.pi)
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
  --rect(70+c(t/32)*50,40,5,5,6)
  local x = t*tempo
  local thin = s(x)+s(3*x)/3 --+s(5*x)/5 + s(7*x)/7 + s(9*x)/9
  rect(70+thin*50,c(x)*40+50,5,5,6)
  local bp_st = p.s%2==1 and (p.s==3 and LENX-p.l or LENY-p.l) or 1 
  local mod = p.s%2==1 and -1 or 1
  local cx = (p.s//2==1) and bp_st+mod*abs(c(t*tempo+p.d))*p.amp or p.x
  local cy = (p.s//2==0) and bp_st+mod*abs(c(t*tempo+p.d))*p.amp or p.y
  p.cx=cx
  p.cy=cy
  spr(1,cx,cy)
end