LENX = 240
LENY = 136

game = {
 s=1
}

t=0

ST = {'intro'}

cos = math.cos
abs= math.abs
sin = math.sin
max = math.max
min = math.min
pi = math.pi

debug = false


Vect = {}
Vect.__index = Vect

function Vect:n(x,y,z)
  local tmp = {}
  setmetatable(tmp,Vect)
  tmp.x=x or 0
  tmp.y=y or 0
  tmp.z=z or 0
  return tmp
end
  
function Vect:__eq(b)
  return self.x==b.x and self.y==b.y and self.z==b.z
end

function Vect:len()
  return self:__len()
end

function Vect:__len()
  return math.sqrt(self.x^2+self.y^2+self.z^2)
end

function Vect:__add(b)
  return Vect:n(self.x+b.x,self.y+b.y,self.z+b.z)
end

function Vect:__sub(b)
  return self+(-1)*b
end

function Vect:__mul(b)
  if type(b)=="number" then return Vect:n(self.x*b,self.y*b,self.z*b) end
  return self.x*b.x+self.y*b.y+self.z*b.z
end

function Vect:__tostring()
  return "("..self.x..", "..self.y..", "..self.z..")"
end

function Vect:cross(b)
  return Vect:n(self.y*b.z-self.z*b.y,self.z*b.x-self.x*b.z,self.x*b.y-self.y*b.x)
end

function Vect:dist(b)
  return #(b-self)
end

function Vect:depend(b)
  if self.x*b.y-self.y*b.x ~= 0 or self.y*b.z-self.z*b.y ~= 0 or self.z*b.x-self.x*b.z ~=0 then return false else return true end
end

function Vect:orth()
  return Vect:n(-self.y,self.x,0)
end

function Vect:norm()
  return self*(1/#self)
end

function Vect:draw(decalx,decaly)
  pix(self.x+decalx, self.y+decaly, 15)
end

function mt_x_vect_3(mat, vect)
  local temp = Vect:n()
  temp.x = vect.x*mat[1][1]+vect.y*mat[1][2]+vect.z*mat[1][3]
  temp.y = vect.x*mat[2][1]+vect.y*mat[2][2]+vect.z*mat[2][3]
  temp.z = vect.x*mat[3][1]+vect.y*mat[3][2]+vect.z*mat[3][3]
  return temp
end

function TIC()
 _G[ST[game.s]]()
 t=t+1
end

intro_vect = {}

function init()
  intro_vect[#intro_vect+1] = Vect:n(10,10,10)
  intro_vect[#intro_vect+1] = Vect:n(-10,10,10)
  intro_vect[#intro_vect+1] = Vect:n(-10,-10,10)
  intro_vect[#intro_vect+1] = Vect:n(10,-10,10)
  intro_vect[#intro_vect+1] = Vect:n(10,10,-10)
  intro_vect[#intro_vect+1] = Vect:n(-10,10,-10)
  intro_vect[#intro_vect+1] = Vect:n(-10,-10,-10)
  intro_vect[#intro_vect+1] = Vect:n(10,-10,-10)
end

function line_them(x1,y1,x2,y2,c,decalx,decaly)
  line(x1+decalx, y1+decaly, x2+decalx, y2+decaly, c)
end

Mat = {}
Mat.__index = Mat

function Mat:n(a,b,c)
  local b = b or a
  local c = c or 0
  local tmp = {}
  if type(a) == 'table' then tmp = a
  elseif type(a) == 'number' then
    assert(type(c) == 'number')
    for i=1,a do
      tmp[#tmp+1]={}
      for j=1,b do
        tmp[i][#tmp[i]+1]=c
      end
    end
  end
  setmetatable(tmp,Mat)
  return tmp
end

function Mat:__eq(b)
  local a,c = self:lengths()
  if not self:eqsize(b) then return false end
  for i=1,a do 
    for j=1,c do
      if self[i][j] ~= b[i][j] then return false end
    end
  end
  return true
end

function Mat:eqsize(b)
  return #a[1]==#b[1] and #a==#b
end

function Mat:lengths()
  return #self,#self[1]
end

function Mat:__tostring()
  local x = ""
  for _,v in pairs(self) do
    for _,l in pairs(v) do
      x=x..l..", "
    end
    x=x.."\n"
  end
  return x
end

function Mat:__add(b)
  assert(self:eqsize(b))
  local a,c = self:lengths()
  local tmp = Mat:n()
  for i=1,a do
    tmp[#tmp+1]={} 
    for j=1,c do
      tmp[i][#tmp[i]+1]=self[i][j]+b[i][j]
    end
  end
  return tmp
end

function Mat:__sub(b)
  return self + (-1)*b
end

function Mat:rot_3D(ax, theta)
  local cot = cos(theta)
  local sit = sin(theta)
  if ax == "x" then
    return Mat:n({{1,0,0},{0,cot, -sit},{0,sit,cot}})
  elseif ax == "y" then
    return Mat:n({{cot, 0, sit}, {0,1,0}, {-sit, 0, cot}})
  elseif ax == "z" then 
    return Mat:n({{cot, -sit, 0}, {sit, cot, 0}, {0,0,1}})
  end
end


Mat.__mul = function (e,b)
  if type(e)=='number' then
    b,e = e,b
  end
  assert(type(e)~='number')
  local a,c = e:lengths()
  local tmp = Mat:n()
  if type(b)=="number" then
    for i=1,a do
      tmp[#tmp+1]={}
      for j=1,c do
        tmp[i][#tmp[i]+1]=e[i][j]*b
      end
    end
  elseif type(b)=='table' then
    local a,c,d = #e,#b[1],#b
    assert(#e[1]==#b)
    for i=1,a do
      tmp[#tmp+1]={}
      for j=1,c do
        local sum = 0
        for l=1,d do
          sum=sum+e[i][l]*b[l][j]
        end
        tmp[i][#tmp[i]+1]=sum
      end
    end
  end
  return tmp
end

function Mat:id(size)
  local temp = Mat:n(0)
  for i=1,size do
    local temp2 = {}
    for j=1,size do
      temp2[#temp2+1] = (j==i and 1 or 0)
    end
    temp[#temp+1] = temp2
  end
  return temp
end

a = Mat:n({{1,2,3},{4,5,6},{7,8,9}})
b = Mat:id(3)
--trace(a)
c = b*2
d = Vect:n(1,1,1)
--trace(b)
--trace(c)

--trace(a*c)

Polygone = {}
Polygone.__index = Polygone

function Polygone:n(vert, edges,x,y,z,c)
  local vert, edges = vert or {}, edges or {}
  local tmp = {}
  tmp.c = c or 15
  local tmp_v = {}
  for i,v in pairs(vert) do
    tmp_v[#tmp_v+1] = v
  end
  local tmp_e = {}
  for i,v in pairs(edges) do
    tmp_e[#tmp_e+1] = v
  end
  tmp.vert = tmp_v
  tmp.edges = tmp_e
  tmp.x=x
  tmp.y=y
  tmp.z=z
  setmetatable(tmp, Polygone)
  return tmp
end

function Polygone:apply_rot(mat)
  for i,v in pairs(self.vert) do
    self.vert[i] = mt_x_vect_3(mat, v)
  end
end

Sphere = Polygone:n()
Sphere.__index = Sphere

function Sphere:n(lx,ly,lz, x, y, z, res_long, res_lat)
  local bx, bz, by = lx/2, ly/2, lz/2
  local r = lx
  local res_long, res_lat = res_long or 4, res_lat or 4
  local tmp = {}
  local v = {}
  for long_i =0,res_long do
    local phi=2*pi/res_long*long_i
    for lat_i=0,res_lat do
      local theta = pi/res_lat*lat_i
      local x = r*sin(theta)*cos(phi)
      local z = r*sin(theta)*sin(phi)
      local y = r*cos(theta)
      v[#v+1] = Vect:n(x,y,z)
    end
  end
  tmp = Polygone:n(v, {}, x, y, z)
  local behaviour = copy(Polygone)
  for i,v in pairs(Sphere) do
    behaviour[i] = v
  end
  setmetatable(tmp, behaviour)
  return tmp
end

function Sphere:draw()
  for i,v in pairs(self.vert) do
    pix(v.x+self.x, v.y+self.y, 15)
  end
end

Pyramid = Polygone:n()
Pyramid.__index = Pyramid

function Pyramid:n(lx,ly,lz,x, y, z)
  local bx,by,bz = lx/2,ly/2,lz/2
  local tmp = {}
  local v = {
    {0,by,0},
    {-bx,-by,-bz},
    {bx,-by,-bz},
    {-bx,-by,bz},
    {bx,-by,bz}
  }
  local tmp_e = {
    {1,2},
    {1,3},
    {1,4},
    {1,5},
    {2,3},
    {3,5},
    {4,5},
    {4,2}
  }
  local tmp_v = {}
  for i,v in pairs(v) do
    tmp_v[i] = Vect:n(v[1],v[2],v[3])
  end
  tmp = Polygone:n(tmp_v, tmp_e, x, y, z)
  
  
  --trace("CLONE")
  local behaviour = copy(Polygone)
  setmetatable(tmp, behaviour)
  --tmp:apply_rot("y")
  --trace_meta(behaviour)
  --trace("yyyyyy")
  --trace_meta(behaviour)
  for i,v in pairs(Pyramid) do
    --trace(i)
    behaviour[i] = v
  end
  --trace_meta(behaviour)
  setmetatable(tmp, behaviour)
  --tmp:apply_rot("y")
  return tmp
end

function copy(obj)
  res = {}
  for i,v in pairs(obj) do
    res[i] = v
  end
  return res
end

function Polygone:draw_lines()
  local edges = self.edges
  local vert = self.vert
  for i,v in pairs(edges) do
    local a,b = vert[v[1]], vert[v[2]]
    a,b = a+Vect:n(self.x, self.y, self.z), b+Vect:n(self.x, self.y, self.z)
    line(a.x, a.y, b.x, b.y,self.c)
  end
end

function Pyramid:michel()
  trace(1)
end

function trace_meta(tablem)
  trace("----" .. tostring(tablem))
  for i,v in pairs(tablem) do
    trace(i)
    trace(v)
  end
end

a = Pyramid:n(10,10,10,30,30,30)
b = getmetatable(a)
--trace_meta(b)

Cube = {}
Cube.__index = Cube

function Cube:n(lx, ly, lz, x, y, z, c)
  local lx,ly,lz,x,y,z,c = lx or 10, ly or 10, lz or 10, x or 0, y or 0, z or 0, c or 15
  local tmp = {}
  local tmp_v = {}
  local bx,by,bz = lx/2, ly/2,lz/2
  local poss = {
    {lx/2, ly/2, lz/2},
    {-lx/2, ly/2, lz/2},
    {-lx/2, -ly/2, lz/2},
    {lx/2, -ly/2, lz/2},
    {lx/2, ly/2, -lz/2},
    {-lx/2, ly/2, -lz/2},
    {-lx/2, -ly/2, -lz/2},
    {lx/2, -ly/2, -lz/2},
  }
  for i,v in pairs(poss) do
    tmp_v[i] = Vect:n(v[1],v[2],v[3])
  end
  tmp.vert = tmp_v
  tmp.x, tmp.y, tmp.z, tmp.lx,tmp.ly,tmp.lz,tmp.c= x,y,z,lx,ly,lz,c
  setmetatable(tmp,Cube)
  return tmp
end

function Cube:draw_lines()
  local edges = {
    {1,2},
    {2,3},
    {3,4},
    {4,1},
    {5,6},
    {6,7},
    {7,8},
    {8,5},
    {1,5},
    {2,6},
    {3,7},
    {4,8}
  }
  local vert = self.vert
  for i,v in pairs(edges) do
    local a,b = vert[v[1]], vert[v[2]]
    a,b = a+Vect:n(self.x, self.y, self.z), b+Vect:n(self.x, self.y, self.z)
    line(a.x, a.y, b.x, b.y,self.c)
  end
end

function Cube:apply_rot(mat)
  for i,v in pairs(self.vert) do
    self.vert[i] = mt_x_vect_3(mat, v)
  end
end

function init()
  intro_vect[#intro_vect+1] = Vect:n(10,10,10)
  intro_vect[#intro_vect+1] = Vect:n(-10,10,10)
  intro_vect[#intro_vect+1] = Vect:n(-10,-10,10)
  intro_vect[#intro_vect+1] = Vect:n(10,-10,10)
  intro_vect[#intro_vect+1] = Vect:n(10,10,-10)
  intro_vect[#intro_vect+1] = Vect:n(-10,10,-10)
  intro_vect[#intro_vect+1] = Vect:n(-10,-10,-10)
  intro_vect[#intro_vect+1] = Vect:n(10,-10,-10)
  michel_lintro[#michel_lintro+1] = Cube:n(20,20,20,80,50,0)
  michel_lintro[#michel_lintro+1] = Pyramid:n(20,20,20,40,100,0)
  michel_lintro[#michel_lintro+1] = Sphere:n(20,20,20,100,100,0, 10,8)
end

michel_lintro = {}

function intro()
  cls()
  if t == 0 then
    init()
    michel_lintro[2]:apply_rot(Mat:rot_3D("x", pi))
  end
  local mx = Mat:rot_3D("x", pi/64)
  local mz = Mat:rot_3D("z", pi/64)
  local my = Mat:rot_3D("y", pi/64)
  for i,v in pairs(intro_vect) do
    intro_vect[i] = mt_x_vect_3(mz, mt_x_vect_3(mx, v))
    --intro_vect[i] = mt_x_vect_3(mat_rot_z(pi/64), mt_x_vect_3(mat_rot_x(pi/64), v)) --+ Vect:n(20,20,0)
    if i>1 then
      line_them(v.x,v.y, intro_vect[i-1].x, intro_vect[i-1].y, 15, 50,50)
    end
    v:draw(50,50)
    --print(v)
  end
  for i,v in pairs(michel_lintro) do
    --trace_meta(getmetatable(v))
    if i == 2 then
      v:apply_rot(mx)
      v:apply_rot(mz)
      v:draw_lines()
    elseif i == 3 then 
      v:apply_rot(my)
      v:apply_rot(mz)
      v:draw()
    else
    v:apply_rot(mx)
    v:apply_rot(my)
    v:apply_rot(mz)
    v:draw_lines()
    end
  end
  if t == 1 and false then
    o = michel_lintro[1]
    o = getmetatable(o)
    o = Cube
    for i,v in pairs(o) do
      --trace(i)
      --trace(v)
    end
  end
end