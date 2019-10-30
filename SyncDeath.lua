
LENX = 240
LENY = 136

game = {
  s=1
}

t=0
tt=0

circle = {
  ok = false
}

cols = {5, 6, 7}

spd = 7

ST = {"intro", "duo"}

function TIC()
  _G[ST[game.s]]()
  t=t+1
  tt=tt+1
  if btnp(3) then game.s = (game.s)%#ST + 1 end
end



function intro()
  cls(0)
  if true then 
  --circle_grow(60, 60, 30, true)
  circle_grow(160, 60, 30, false) end
  circle_cons(60, 60, 30, 4)
  --circle_cons(160, 60, 30, 2, true)
end

game.s =2

function rect_choices()
  rect(10,100,LENX-20,LENY-110, 8)
  rectb(10,100,LENX-20,LENY-110, 0)
end

function show_choices()
  rect_choices()

  local dic = {"alpha", "beta", "ceta"}
  for m= 1,#dic do 
    print(dic[m],10+10,100+m*6,0)
  end

end

function duo()
  cls(0)
  rect(0,0,LENX//3,LENY,cols[1])
  rect(LENX//3,0,LENX//3,LENY,cols[2])
  rect(2*(LENX//3),0,LENX//3,LENY,cols[3])
  rect(LENX//3-1,0,3,LENY,0)
  rect(2*(LENX//3)-1,0,3,LENY,0)
  print("a")
  show_choices()
end

function circle_cons(x, y, r, n, inv)
  local n = n or 2
  local inv = inv and -1 or 1
  pix(x, y, 1)
  local ecrt = 4
  if n == 4 then ecrt = r/3 end
  local theta = inv*((t/spd)%50/50)*2*math.pi
  print(math.cos(theta))
  circ(math.cos(theta)*r+x, math.sin(theta)*r+y, r-ecrt, 2)
  circ(math.cos(theta+math.pi)*r+x, math.sin(theta+math.pi)*r+y, r-ecrt, 2)
  if n==4 then circ(math.cos(theta+(math.pi/2))*r+x, math.sin(theta+(math.pi/2))*r+y, r-ecrt, 2) circ(math.cos(theta+(3*math.pi/2))*r+x, math.sin(theta+(3*math.pi/2))*r+y, r-ecrt, 2) end
end


function circle_grow(x, y, r, inv)
  local tim = (t//spd)%(r*2)
  local colors = {1, 2}
  if tim>r then colors = {2, 1} tim = tim-r end
  circ(x,y,r,colors[1])
  if inv then circ(x,y,tim,colors[2]) else circ(x,y,r-tim,colors[2]) end
end