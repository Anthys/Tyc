t=0 LENX=240 LENY=136
inc=1

function TIC()
	t=t+inc
	simul()
end

particls = {
	{x=30,y=30,q=1}
}

function simul()
	cls(0)
	for i,v in pairs(particls) do
		circ(v.x, v.y,3, 15)
	end
	for i=0,LENX,5 do
		for j=0,LENY,5 do
			pix(i,j,15)
		end
	end
end