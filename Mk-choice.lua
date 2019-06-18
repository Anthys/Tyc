
A={
  [1]={""},
  [2]={"SRYMSG",["t"]={60, 1}},
  [3]={"Blue or red?", {"Blue", 4}, {"Red", 4}},
  [4]={"Dog or cat?", {"Dog", 5}, {'Cat', 5}},
  [5]={""}
}

ST={"intro"}
SRY={"X", "X", "X", "Wrong way.", "Sorry.", "Not at all.", "I don't think so.", "Please try again.", "Damn, no.", "There are at most four directions.", "This is beginning to be kind of weird.", "I'm sorry, I'm not interested.", "You don't seem to be the smarter, huh?"}

g={
  s=1,
  z=false --Allow use of z to hurt the IA implanted in your head
}
t, tt = 0, 0
tcompt=1

zc=0
cur_i = 1
cur_q = A[cur_i]

function TIC()
  _G[ST[g.s]]()
  t=t+1
  tt=tt+1
end

function dc(object)
  local lookup_table = {}
  local function _copy(object)
      if type(object) ~= "table" then
          return object
      elseif lookup_table[object] then
          return lookup_table[object]
      end
      local new_table = {}
      lookup_table[object] = new_table
      for index, value in pairs(object) do
          new_table[_copy(index)] = _copy(value)
      end
      return setmetatable(new_table, getmetatable(object))
  end
  return _copy(object)
end

function show_choices()
  for i,j in pairs(A[cur_i]) do
    if i~=1 then
      if i==2 then print(j[1], 0, 64)
      elseif i==3 then print(j[1], 240-print(j[1], -100, -100), 64)
      elseif i==4 then print(j[1], 120-(print(j[1], -100, -100)//2), 128) 
      elseif i==5 then print(j[1], 120-(print(j[1], -100, -100)//2), 2) end
    end
  end
  for i=2,3 do
    if btnp(i) and A[cur_i][i] and A[cur_i][i][2] then nexq(A[cur_i][i][2]) end
  end
  for i=0,1 do
    if btnp(i) and A[cur_i][5-i] and A[cur_i][5-i][2] then nexq(A[cur_i][5-i][2]) end
  end
end

function nexq(indx)
  tt = 0
  if A[indx] then 
    cur_i = indx
    cur_q = dc(A[cur_i])
    if cur_i==2 then cur_q[1]=SRY[tcompt] tcompt=tcompt+1 end
  end
end

function show_quest()
  txt = cur_q[1]
  if cur_i==1 then
    if btnp(1) and tt//60>2 then
      ccount=1
    elseif tt//60>1 then
      m_arrow()
    end
  end
  if cur_q["t"] then 
    if cur_q["t"][1]>0 then cur_q["t"][1]=cur_q["t"][1]-1 
    else nexq(cur_q["t"][2]) end
  end
  if type(txt) == "string" then
  print(txt, 120-print(txt, -100, -100)//2, 64)
  elseif type(txt) == "table" then
    return
  end
end

function check_input()
  if g.z and btnp(4) then return end--make_screen_white_and_then_fade_to_previous_color
end

function white_to_black(i, c)
  local r,g,b = peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
  if c<=30 then r,g,b=255,255,255 c=c+1
  elseif r<=0 then r,g,b=0,0,0 c=0
  else r,g,b=r-1,g-1,b-1 c=c+1
  end
  poke(0x3fc0+(i*3)+2,b)
	poke(0x3fc0+(i*3)+1,g)
  poke(0x3fc0+(i*3),r)
  return c
end

function m_arrow()
  if tt//5%20<10 then
    spr(1, 116, 110 + tt//5%10, 0, 1, 0, 0, 2, 2)
  else spr(1, 116, 110 + 10 - tt//5%10, 0, 1, 0, 0, 2, 2)
  end
end

ccount = 0

function intro()
  cls()
  show_quest()
  show_choices()
  if ccount~=0 then ccount=white_to_black(0,ccount) end
end