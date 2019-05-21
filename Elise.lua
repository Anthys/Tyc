-- Elise.lua
function init()
  t=0
end

init()

st=1
ST={"menutic", "transitic", "yestic"}

function TIC()
  _G[ST[st]]()
  t=t+1
end

a=0
ti=0

shake=0
d=4
tt=0

if btnp()~=0 then shake=30 end
	if shake>0 then
		poke(0x3FF9+1,math.random(-d,d))
		shake=shake-1		
		if shake==0 then memset(0x3FF9,0,2) end
  end

if a==0 then rect(0,0,240,136,1) else
  if ti<137 then
  line(ti, 0, 0, ti, 2)
  elseif ti<241 then line(ti, 0, ti-136, 136, 2)
  elseif ti<241+136 then line(240, ti-240, ti-136, 136, 2)
  end ti=ti+1 end  
if btnp(0) then a=1 end


function menutic()
  cls(1)
  --print(text1, 22, 60)
  if btnp(0) then st=2 ti=0 end
end


function transitic()
  cls(1)
  ti=ti+1
  if ti//60>3 then 
    tt=tt+1
    print(string.sub(text1, 0, math.min(tt//5, string.len(text1))), 22, 60)
  end
end

function scanline(row)
	if shake>0 then
		poke(0x3FF9,math.random(-d,d))		
	end
end

text1="It all began when the angels decided \n\n   that we were no longer worth it."
text2="And then the night came."
function yestic()
end