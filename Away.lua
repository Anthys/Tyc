--[[
	use color for collision instead of tiles
	make terrains more shapy
	different rockets
	specific refuel stations
]]

function TIC()
	_G[ST[g.s]]()
end
t=0
p={
	x=0,
	y=0,
	vx=0,
	vy=0,
	lx=5,ly=6,
	th=0,
	fuel=0,
	mxfuel=2000
}

LENX=240
LENY=136
g={
	s=1,
	lvl=1
}

cam={
	x=120,
	y=68
}

c=math.cos
s=math.sin

ST= {"spawn","fly"}

COORDLVL = {
	{8*10,8*108}
}

function spawn()
	p.x,p.y = COORDLVL[g.lvl][1], COORDLVL[g.lvl][2]
	cam.x,cam.y =p.x,p.y
	g.s=g.s+1
end

function fly()
	cls(0)
	t=t+1
	rend_map()
	take_input()
	physics_fly()
	add_fuel()
	show_fuel()
	progress()
end

function physics_fly()
	local x,y=p.x,p.y+LENY//2
	local xx=x+p.vx
	local yy=y+p.vy
	if can_go(xx,yy) then
		p.x=p.x+p.vx
		p.y=p.y+p.vy
		p.vy=min(3,p.vy+PHYS.g)
	else
		if can_go(xx,y) then p.x=p.x+p.vx else p.vx=p.vx/2 end
		if can_go(x,yy) then p.y=p.y+p.vy p.vy=min(3,p.vy+PHYS.g)
		else p.vy=p.vy/2 p.vx=p.vx/2 end
	end
end

function can_go(x,y)
	for i=0,3 do
		for j=0,(i//2==0 and p.lx or p.ly)-1 do
			local xx,yy=(x+(i//2==0 and j or (i==3 and p.lx-1 or 0)))//8,(y+(i//2==1 and j or (i==1 and p.ly-1 or 0)))//8
			local tl = mget(xx,yy)
			if (tl>0 and tl<10) or BLK[tl]~=nil then return false end
		end
	end
	return true
end

BLK = {[1]=true}

min=math.min
max=math.max
abs=math.abs
PHYS = {
	incx=0.1,
	incy=0.1,
	g=0.01,
	incdir=0.05,
	incv=0.1
}

function show_fuel()
	rect(100,10,20*p.fuel/p.mxfuel,8,2)
end

function progress()
	rect(200,10,10,40,4)
	local my=136*7
	local mx=240
	pix(200+10*p.x/mx,(p.y+LENY//2)/my*40+10,5)
end

function islanded()
	if abs(p.vy)>0.1 then return false end
	for i=0,p.lx do
		local tl=mget((p.x+i)/8,(p.y+p.ly+LENY//2)//8)
		if BLK[tl]~=nil then trace(t) return true end
	end
	return false
end

function take_input()

	if btn(0) and p.fuel>0 then p.vx=addspeed(p.vx,s(p.th)*PHYS.incv,3) p.vy=addspeed(p.vy,-c(p.th)*PHYS.incv,3) p.fuel=max(0,p.fuel-1) end
	if btn(3) then p.th=p.th+PHYS.incdir end
	if btn(2) then p.th=p.th-PHYS.incdir end

	if true then return  end

	local fx,fy=PHYS.incx,PHYS.incy
	if btn(0) then p.vy=max(p.vy-fy,-3) end
	if btn(1) then p.vy=min(p.vy+fy,3) end
	if btn(2) then p.vx=max(p.vx-fx,-3) end
	if btn(3) then p.vx=min(p.vx+fx,3) end
end

function addspeed(init,val,mx)
	if val<0 then return max(init+val,-mx)
	elseif val>=0 then return min(init+val,mx) end
end

function add_fuel()
	if islanded() then p.fuel=min(p.fuel+1,p.mxfuel) end
end

function draw_fly()
	local n1,n2,n3 = {x=2,y=0},{x=0,y=5},{x=4,y=5}
	for i,v in pairs({n1,n2,n3}) do
		--p.th=math.pi/2
		v.x=v.x-p.lx/2
		v.y=v.y-p.ly/2
		local nx=c(p.th)*v.x-s(p.th)*v.y
		local ny=s(p.th)*v.x+c(p.th)*v.y
		v.x,v.y =nx,ny
		v.x=v.x+p.lx/2 v.y=v.y+p.ly/2
		v.x=v.x+p.x v.y=v.y+p.y-cam.y+LENY//2
	end
	tri(n1.x,n1.y,n2.x,n2.y,n3.x,n3.y,15)
	pix(n1.x,n1.y,13)
end

function rend_map()
	--cam.x,cam.y =p.x,p.y
	cam.y = lerp(cam.y,p.y,0.05)
	cam.x=p.x
	map(0,0,240,136,-(cam.x//LENX*LENX),-cam.y)
	draw_fly()
	--rect(p.x,p.y-cam.y+LENY//2,p.lx,p.ly,5)
end

function lerp(a,b,t) return (1-t)*a + t*b end