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
    return tmp
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
    rect(self.x-self.dx//2, self.y-self.dy//2, self.dx, self.dy, 10)
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
    local x,y,dx,dy = self.x,self.y, self.dx, self.dy
    local c = 3
    tri(x, y, x+dx, y, x, y+dy,c)
    tri(x, y, x-dx, y, x, y+dy,c)
    tri(x, y, x+dx, y, x, y-dy,c)
    tri(x, y, x-dx, y, x, y-dy,c)
end

function Losange:is_mouse_on(x,y)
    local dist = {x= x-self.x,y= y-self.y}
    print(dist.x,30, 30)
    print(dist.y, 40, 10)
    print(abs(dist.x) < self.dx//2 and abs(dist.y)<self.dy//2, 50,50)
    if abs(dist.x) < self.dx//2 and abs(dist.y)<self.dy//2 then return true else return false end
end

--------

function copy(obj)
    res = {}
    for i,v in pairs(obj) do
        res[i] = v
    end
    return res
end

-------------
-------------

panier = {}
hand = {
    taken = nil,
    dr = {x=0,y=0}
}

function process_click()
    local x,y,l,m,r = mouse()
    local has_obj = (hand.taken ~= nil)
    if l and (has_obj == false) then
        for v=1,#panier do
            local temp_drag = panier[v]
            if temp_drag:is_mouse_on(x,y) then hand.taken = temp_drag hand.dr.x = x - temp_drag.x hand.dr.y = y - temp_drag.y break end
        end
    end
    if (l == false) and (has_obj) then
        hand.taken = nil
    end
    if hand.taken ~= nil then 
        hand.taken.x = x - hand.dr.x
        hand.taken.y = y - hand.dr.y
    end
end

function init()
    panier[#panier+1] = Rectangle:n(50,50,20,30)
    panier[#panier+1] = Losange:n(90,50,20,30)
end

--init()

function intro()
    cls(0)
    if t == 0 then init() end
    for i=1,#panier do
        local drag = panier[i]
        drag:draw()
    end
    process_click()
end

function TIC()
 _G[ST[game.s]]()
 t=t+1
 tt=tt+1
end