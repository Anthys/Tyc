LENX = 240
LENY = 136

game = {
 s=1
}

t=0
tt= 0

ST = {'intro'}

cos = math.cos
abs= math.abs
sin = math.sin
max = math.max
min = math.min
pi = math.pi

debug = false

-------------
-------------

Dragable = {}
Dragable.__index = Dragable

function Dragable:n(x,y)
    tmp = {}
    setmetatable(tmp, Dragable)
    tmp.x = x or 0 
    tmp.y = y or 0
    tmp.clamp = nil
    tmp.c = math.random(14)
    return tmp
end

function Dragable:set_clamp(x1,y1,x2,y2)
    self.clamp = {x1=x1,x2=x2,y1=y1,y2=y2}
end

function Dragable:update()
    local x,y,l,m,r = mouse()
    local has_obj = (hand.taken ~= nil)
    if l and (has_obj == false) then
        if self:is_mouse_on(x,y) then
            hand.taken = self
            hand.dr.x = x - self.x 
            hand.dr.y = y - self.y
        end
    end
end

Rectangle = Dragable:n()
Rectangle.__index = Rectangle

function Rectangle:n(x,y, dx, dy)
    tmp = Dragable:n(x,y)
    tmp.dx = dx or 5
    tmp.dy = dy or 5
    local behaviour = copy(Dragable)
    for i,v in pairs(Rectangle) do
        behaviour[i] = v
    end
    setmetatable(tmp, behaviour)
    return tmp
end

function Rectangle:draw()
    rect(self.x-self.dx//2, self.y-self.dy//2, self.dx, self.dy, self.c)
end

function Rectangle:is_mouse_on(x,y)
    return self.x+self.dx//2 > x and self.x-self.dx//2 <x and self.y + self.dy//2 > y and self.y - self.dy//2 < y
end

Losange = Dragable:n()
Losange.__index = Losange

function Losange:n(x,y, dx, dy)
    tmp = Dragable:n(x,y)
    tmp.dx = dx or 5
    tmp.dy = dy or 5
    local behaviour = copy(Dragable)
    for i,v in pairs(Losange) do
        behaviour[i] = v
    end
    setmetatable(tmp, behaviour)
    return tmp
end

function Losange:draw()
    local x,y,dx,dy = self.x,self.y, self.dx//2, self.dy//2
    local c = self.c
    tri(x, y, x+dx, y, x, y+dy,c)
    tri(x, y, x-dx, y, x, y+dy,c)
    tri(x, y, x+dx, y, x, y-dy,c)
    tri(x, y, x-dx, y, x, y-dy,c)
end

function Losange:is_mouse_on(x,y)
    local dist = {x= x-self.x,y= y-self.y}
    return abs(dist.x)/(self.dx//2) + abs(dist.y)/(self.dy//2) < 1
end

Oval = Dragable:n()
Oval.__index = Oval

function Oval:n(x,y, dx, dy)
    tmp = Dragable:n(x,y)
    tmp.dx = dx or 5
    tmp.dy = dy or 5
    local behaviour = copy(Dragable)
    for i,v in pairs(Oval) do
        behaviour[i] = v
    end
    setmetatable(tmp, behaviour)
    return tmp
end

function Oval:draw()
    local x,y,dx,dy = self.x,self.y, self.dx//2, self.dy//2
    local A,B,ang = dx,dy, 0
    local col = self.c
    local c1 = cos(ang)
    local s1 = sin(ang)
    local c2 = cos(ang)+pi/2
    local s2 = sin(ang) + pi/2
	local ux=A*c1
	local uy=A*s1
	local vx=B*c2
	local vy=B*s2
	local w=math.sqrt(ux*ux + vx*vx)
    local h=math.sqrt(uy*uy + vy*vy)
	for x0=-w,w do
		for y0=-h,h do
			x1=( c1*x0 + s1*y0)/A
			y1=(-s1*x0 + c1*y0)/B
            if x1*x1 + y1*y1 < 1 then pix(x+x0,y+y0,col) end
        end
    end
end

function Oval:is_mouse_on(x,y)
    local dist = {x= x-self.x,y= y-self.y}
    return math.pow(dist.x/(self.dx//2), 2) + math.pow(dist.y/(self.dy//2),2) < 1
end

-------------

Gui = {}
Gui.__index = Gui

function Gui:n(x,y)
    local tmp = {}
    tmp.x = x or 0
    tmp.y = y or 0
    tmp.c = math.random(12)
    tmp.children = {}
    setmetatable(tmp, Gui)
    return tmp
end
--math.randomseed()
function Gui:update()
    if self.children then 
        for i=1,#self.children do
            self.children[i]:update()
        end
    end
    local x,y,l,m,r = mouse()
    local has_obj = (hand.taken ~= nil)
    if r and (has_obj == false) then
        if self:is_mouse_on(x,y) then
            hand.taken = self 
            hand.dr.x = x - self.x 
            hand.dr.y = y - self.y
        end
    end
end

Switch = Gui:n()
Switch.__index = Switch

function Switch:n(x,y,dx,dy)
    local tmp = Gui:n(x,y)
    tmp.dx = dx or 5
    tmp.dy = dy or 5
    tmp.on = false
    tmp.state = {
        on = {
            col = math.random(14)
        },
        off = {
            col = math.random(14)
        }
    }
    local behaviour = copy(Gui)
    for i,v in pairs(Switch) do
        behaviour[i] = v
    end
    setmetatable(tmp, behaviour)
    return tmp
end

function Switch:switch()
    self.on = not self.on
end

function Switch:draw()
    local state = (self.on and self.state.on or self.state.off) 
    local col = state.col
    rect(self.x-self.dx//2, self.y-self.dy//2, self.dx, self.dy, col)
end

function Switch:update()
    local x,y,l,m,r = mouse()
    local has_obj = (hand.taken ~= nil)
    if l and (has_obj == false) then
        if self:is_mouse_on(x,y) then
            self:switch()
        end
    end
end

function Switch:is_mouse_on(x,y)
    dist = {x=abs(x-self.x), y=abs(y-self.y)}
    return dist.x<self.dx and dist.y<self.dy
end

Slider = Gui:n()
Slider.__index = Slider

function Slider:n(x,y,dx,dy)
    local tmp = Gui:n(x,y)
    tmp.dx = dx or 5
    tmp.dy = dy or 5
    local size_x = 5
    local temp = Rectangle:n(x+dx//2,y+dy//2,size_x,dy-2)
    temp:set_clamp(x+size_x//2+1,y+dy//2,x+dx-size_x//2-2,y+dy//2)
    tmp.label = "Val: 0"
    tmp.box = temp
    tmp.children[#tmp.children+1] = temp
    local behaviour = copy(Gui)
    for i,v in pairs(Slider) do
        behaviour[i] = v
    end
    setmetatable(tmp, behaviour)
    return tmp
end

function Slider:draw()
    --self.c = 3
    rect(self.x, self.y, self.dx, self.dy, self.c)
    local box = self.box
    box:draw()
    local maxx = 255
    self.label = "Val: " .. strn(tostring( ( (box.x-self.x)/(self.dx-4)*100//1/100 ) *maxx),3)
    print_ctr(self.label, self.x+self.dx//2, self.y-10, self.c)
end

function Slider:is_mouse_on(x,y)
    dist = {x=abs(x-self.x), y=abs(y-self.y)}
    return dist.x<self.dx and dist.y<self.dy
end


function update_and_mouse()
    local x,y,l,m,r = mouse()
    local has_obj = (hand.taken ~= nil)
    if (r == false) and (l == false) and (has_obj) then
        hand.taken = nil
    end
    if hand.taken ~= nil then 
        dx = x - hand.dr.x - hand.taken.x
        dy = y - hand.dr.y - hand.taken.y
        move_obj(hand.taken,dx,dy)
        if hand.taken.children then
            for child_i=1,#hand.taken.children do
                local child = hand.taken.children[child_i]
                if child.clamp then
                    local x,y,xx,yy =child.clamp.x1+dx,child.clamp.y1+dy,child.clamp.x2+dx,child.clamp.y2+dy
                    child.clamp = {x1=x,y1=y,x2=xx,y2=yy}
                end
                move_obj(child, dx, dy)
            end
        end
    end
    for i=1,#panier do
        panier[i]:update()
    end
end

function move_obj(obj, dx, dy)
    local objx,objy = obj.x + dx,obj.y+dy
    if obj.clamp then 
        local temp = obj.clamp
        obj.x = clamp(temp.x1,objx,temp.x2)
        obj.y = clamp(temp.y1,objy,temp.y2)
    else
        obj.x = objx
        obj.y = objy
    end
end
--------

function strn(txt,n)
    if #txt >= n then return string.sub(txt, 1,n)
    else
        final = txt
        for i=1,n-#txt do
            final = final .. "0"
        end
        return final
    end
end


function copy(obj)
    res = {}
    for i,v in pairs(obj) do
        res[i] = v
    end
    return res
end

function clamp(a,val,b)
    val = min(val,b)
    return max(val,a)
end

function plx(txt)
    return print(txt, -1000,-1000)
end

function print_ctr(txt,x,y,c)
    local s = plx(txt)
    print(txt, x-s//2, y,c)
end
-------------
-------------

panier = {}
hand = {
    taken = nil,
    dr = {x=0,y=0}
}
supr = {}

function init()
    panier[#panier+1] = Rectangle:n(50,50,20,30)
    panier[#panier+1] = Losange:n(90,50,20,50)
    panier[#panier+1] = Oval:n(20,70,30,20)
    panier[#panier+1] = Slider:n(20,90,100,10)
    panier[#panier+1] = Switch:n(90,90,10,10)
end

--init()

function intro()
    cls(0)
    if t == 0 then init() end
    for i=1,#panier do
        local drag = panier[i]
        drag:draw()
    end
    update_and_mouse()
end

function TIC()
 _G[ST[game.s]]()
 t=t+1
 tt=tt+1
end