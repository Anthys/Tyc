function TIC()
	--cls(0)
	--lorenz()
	cls(0)
	t=t+1
	if t==1 then
		initcol()
	end
	desmo()
end

cls(0)
LENX=240
LENY=136
pi=math.pi
mp = pi/4
szax= 50
orig = {LENX//2,LENY//2}
t=0






--YES 1

function initcol()
	trace(3)
	local l = {
		"#75245d",
		"#7f325a",
		"#884157",
		"#924f54",
		"#9c5d51",
		"#a66c4e",
		"#b07a4b",
		"#b98847",
		"#c39744",
		"#cda541",
		"#d7b33e",
		"#e0c23b"}
	for i=1,#l do
		r,g,b = hex2rgb(l[i])
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

function desmo()
	local a = (t/320)*14-7
	a = math.cos(t/320)*7
	--print(a)
	for theta=0,12*pi,pi/1000 do
		local r = theta + a*(theta%(a*pi/4))-a*math.floor(a*pi*(theta%(pi/2)))
		local x,y =math.cos(theta)*r, math.sin(theta)*r
		pix(x+LENX//2,y+LENY//2,theta//pi+1)
	end
end


--LORENZ ATTRACTOR

function axes()
	local ox,oy = orig[1],orig[2]
	line(ox,oy,ox+math.cos(mp)*szax,oy-math.sin(mp)*szax+1, 3)
	line(ox,oy,ox+szax,oy, 1)
	line(ox,oy,ox,oy-szax, 2)
end

function lorenz()
	axes()
	xx, yy, zz = rlorenz(x,y,z)
	x,y,z= x+xx*dt,y+yy*dt,z+zz*dt
	px,py,pz=x+LENX//2,y+LENY//2,z
	px,py = px + math.cos(mp)*pz,py+math.sin(mp)*pz
	print(px,0,0)
	print(py,0,10)
	--line(orig[1],orig[2],px,py,14)
	pix(px,py,15)
end

function rlorenz(x, y, z, s, r, b)
	local s=s or 10
	local r=r or 28
	local b=b or 2.667

	x_dot = s*(y-x)
	y_dot=r*x-y-x*z
	z_dot=x*y-b*z
	return x_dot,y_dot,z_dot
end

dt=0.01
stepCnt=10000
x,y,z = 0.,1.,1.05