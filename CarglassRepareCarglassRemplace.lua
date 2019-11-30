t=0 LENX=240 LENY=136
inc=1

function TIC()
	if t==0 then initpal() end
	t=t+inc
	simul()
end

particls = {
	{x=30,y=30,q=1}
}
x=0
y=20

sx=20
sy=20

function cos(a,b,tmin,tmax,ta)
	local ttt = ta-tmin
	ttt = ttt/(tmax-tmin)
	return (a+b)/2 + -math.cos(ttt*math.pi)*(b-a)/2
end

function initpal()
	local a = {'#d61e1c', '#c72329', '#b92937', '#ab2f45', '#9d3553', '#8f3b61', '#81416f', '#74477d', '#654c8a', '#575297', '#4958a6', '#3b5eb4', '#2d64c2', '#1f6acf', '#1271de'}
	for i=1,15 do
		local r,g,b = hex2rgb(a[i])
		pal(i,r,g,b)
	end
end

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
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

function simul()
	cls()
	--for i,v in pairs(particls) do
	--	circ(v.x, v.y,3, 15)
	--end
	grid()
	local frac = 25
	local fcycl = frac*2
	local t1 = frac
	local t2 = frac*2
	local tt = t%(fcycl+1)
	if tt<=t1 then 
		--x=(tt/t1)*(sx)
		y=0
		x = cos(0,sx,0,t1,tt)
	--elseif tt==t1+20 then x=math.floor(x+1)
	elseif tt <= t2 then
		x=sx
		y=cos(0,sy,0,frac,tt-t1)
		--y=((tt-frac)/frac)*sy
	end
	mi = 13
	mj = 9
	for i=0,mi do
		for j=0,mj do
			local jj = 1+mj-j
			local col = i+jj-9
			--local super = t//25
			col = math.abs(-col+3)
			col = col%15
			--local super = t//25
			col = col+1--math.abs(8+super-col)+1
			show_point(x-sx + i*sx,y-sy+j*sy,col)
		end
	end
end

function grid()
	for i=0,LENX,20 do
		for j=0,LENY,20 do
			pix(i,j,15)
		end
	end
end

function show_point(x,y,col)
	circ(x,y,4,col)
	--pix(x,y,col)
end