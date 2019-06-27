function TIC()
    t=t+0.01
    --cls()
    --intro()
    --secundo()
    --tertio()
    --quatro()
    --losange()
    render_cube()
end
cls()
t=0
color=1

cub={
    x=5,
    y=5
}

function lerp(a,b,t) return (1-t)*a + t*b end


function render_cube()
    --cls()

    mx, my, mc = mouse()

    if mc then
        cub.x = lerp(cub.x, mx, 0.05)
        cub.y = lerp(cub.y, my, 0.05)
    end
        
    rect(cub.x, cub.y, 2, 2, 15)
end

function intro()
    if t%90==0 then color=(color+1)%16 end
    local r, theta, x, y
    r=60
    theta=math.rad(t*4%360)
    x=r*math.cos(theta)
    y=r*math.sin(theta)
    rect(x+120, y+64, 2, 2, color)
end

function secundo()
    if t%100<50 then
        circ(120, 64, t%50, 15)
    else circb(120, 64, 50-t%50, 0) end
end

color3=15

function tertio()
    local r, theta, x, y
    if t%90==0 then
        color3=color3==15 and 0 or 15
    end
    r=50
    theta=math.rad(t*4%360)
    x=r*math.cos(theta)
    y=math.sin(theta)*x
    rect(y+30, x+64, 2, 2, color3)
    rect(y+210, -x+64, 2, 2, color3)
end

function quatro()
    local r, theta, x, y
    r=40
    theta=math.rad(t*4%360)
    theta0=math.rad((t-10)*4%360)
    x=r*math.cos(theta)
    x0=r*math.cos(theta0)
    --y=math.sin(theta)*x
    rect(30, x+64, 2, 2, 14)
    rect(30, x0+64, 2, 2, 0)
end

pi8=math.pi/8
pi2=math.pi*2

function losange()
 cls()
 lx=135
 ly=135

 --lines
 for i=t%8,lx,8 do
  line(i,0,0,ly-i,8)
  line(i,ly,lx,135-i,6)
  t=t+0.01
 end

 --prism
 for i=t/16%pi8,pi2,pi8 do
  x=lx//2+32*math.cos(i)
  y=ly//2+32*math.cos(i)
  line(lx,0,x,y,15)
  line(0,ly,x,y,15)
 end

 --Border
 line(0,0,lx,0,8)
 line(0,0,0,lx,8)
 line(lx,0,lx,ly,6)
 line(0,ly,lx,ly,6)

end