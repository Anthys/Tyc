
A={
  [1]={""},
  [2]={{{"Oh..."}, ["s"]= 15},["t"]={50}},
  [3]={{"Hi...", ["s"]= 15}, ["t"]={50}},
  [4]={"You're lucky, I almost missed your call...",["t"]={50}},
  [5]={"Who knows what would've happened if I had...",["t"]={50}},
  [6]={{"So.", ["s"]= 8}, ["t"]={50}},
  [7]={"Discreet", ["t"]={20}},
  [8]={"Let's see if I can help you with that.", ['t']={50}},
  [9]={"INITIALIZING INPUT"},
  [10]={"Here.", ["t"]={50}},
  [11]={{{"I think that's slighly better,","don't you agree?"}},{"Yes"}, {"No", 13}},
  [12]={"Cool.",["t"]={50, 14}},
  [13]={"Don't be fussy, I'm only doing that for you.", ["t"]={50}},
  [14]={"Right.",["t"]={50}},
  [15]={{"So, how do you feel right now?"}, {"Fine."}, {{"I'm not feeling"," anything."}, 17}},
  [16]={"Nice to hear that.", ["t"]={50, 18}},
  [17]={"Understandable.", ["t"]={50}},
  [18]={{{"I will have to ask you a few questions,", "if you don't mind."}}, ["t"]={50}},
  [19]={"That's just the protocol.", ["t"]={50}},
  [20]={"What is your name?", {{"I do not ","remember."}, 999}, {"Candace."}},
  --CandaceRoute
  [21]={"Oh, how funny, that's mine too!",["t"]={50}},
  [22]={"Nice to meet you, Candace.", ["t"]={50}},
  [23]={{{"So, do you have any memory"," about the incident?"}} ,{"Which incident?"}, {"I think I remember."}}
}
DEF_WAIT = 60
DEF_TXT_S = 3
ST={"intro"}
SRY={"X", "X", "X", "Wrong way.", "Sorry.", "Not at all.", "I don't think so.", "Please try again.", "Damn, no.", "There are at most four directions.", "This is beginning to be kind of weird.", "I'm sorry, I'm not interested.", "You don't seem to be the smarter, huh?"}

g={
  s=1,
  z=false --Allow use of z to hurt the IA implanted in your head
}
t, tt = 0, 0
t_compt_wrong=1
tcompt=0
wait_t=0
can_pass=true

q={
  --[[states: 
  0 is black screen between questions
  1 is question appearing
  2 is choices appearing
  3 is waiting for input
  4 is answer appearing
  5 is remain time
  ]]--
  state=0,
  t=0
}

zc=0
cur_i = 18
cur_q = A[cur_i]
cur_ans = nil

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

function lpx(txt)
  return print(txt, -100, -100)
end

function make_answer(txt)
  if type(txt)=="table" then for i,v in pairs(yes) do
    print(v, 120-lpx(txt)//2, 120-#txt*9+i*9-9) end
  else print(txt, 120-lpx(txt)//2, 120) end
end

function show_choices()
  for i,j in pairs(A[cur_i]) do
    if i~=1 then
      if i==2 then 
        if type(j[1])=="table" then for k,l in pairs(j[1]) do
          print(l, 0, 120-#j*9+k*9-9) end
        else print(j[1], 0, 120) end --line(20, 50, 20, 80, 15)
      elseif i==3 then
        if type(j[1])=="table" then for k,l in pairs(j[1]) do
          print(l, 240-print(l, -100, -100), 120-#j*9+k*9-9) end
        else print(j[1], 240-print(j[1], -100, -100), 120) end -- line(225, 50, 225, 80, 15)
      elseif i==4 then print(j[1], 120-(print(j[1], -100, -100)//2), 128) 
      elseif i==5 then print(j[1], 120-(print(j[1], -100, -100)//2), 2) end
    end
  end
  for i=2,3 do
    if btnp(i) then
      if A[cur_i][i] and A[cur_i][i][2] then movnext(A[cur_i][i][2])
      elseif A[cur_i][i] then movnext(cur_i+1) end
    end
  end
  for i=0,1 do
    if btnp(i) and A[cur_i][5-i] and A[cur_i][5-i][2] then movnext(A[cur_i][5-i][2]) end
  end
end

function movnext(indx, ans)
  ans = ans or ""
  if ans=="" then nexq(indx)
  else return 3 end
end


function nexq(indx)
  tt = 0
  wait_t=0
  can_pass=false
  cur_ans = nil
  if A[indx] then
    cur_i = indx
    cur_q = dc(A[cur_i])
    if cur_i==-1 then cur_q[1]=SRY[t_compt_wrong] t_compt_wrong=t_compt_wrong+1 end
  end
end

function show_quest()
  txt = cur_q[1]
  if cur_i==1 then
    if btnp(1) and tt//60>2 then
      ccount=1
      tt = 0
      tcompt=tcompt+1
      if tcompt>2 then nexq(2) end
    elseif tt//60>1 then
      m_arrow()
    end
    return
  elseif cur_i==7 then
    local txt="I see that you're quite... discrete."
    print(string.sub(txt,0,math.min(tt//DEF_TXT_S, string.len(txt)-10)), 120-print(txt, -100, -100)//2, 64)
    if tt//DEF_TXT_S>string.len(txt)-10+30 then
      print(string.sub(txt,0,math.min(tt//2-string.len(txt)+10-30, string.len(txt))), 120-print(txt, -100, -100)//2, 64)
    end
    if tt//DEF_TXT_S>string.len(txt)-10+30+30 then nexq(8) end
    return
  elseif cur_i==9 then
    if tt//20<20 and tt//20%6>1 then
      spr(1, math.min(3, -30+tt/8), 64, 0, 1, 0, 1, 2, 2)
      spr(1, math.max(219, 254-tt/8), 57, 0, 1, 0, 3, 2, 2) 
    elseif tt//20>20 then
      nexq(10)
    end
  end
  if cur_q["t"] and can_pass then 
    if cur_q["t"][1]+DEF_REMAIN>0 then cur_q["t"][1]=cur_q["t"][1]-1 
    else 
      if #cur_q["t"]>1 then nexq(cur_q["t"][2]) else nexq(cur_i + 1) end
    end
  end
  printtxt(txt)
end

txt_t=0

function printtxt(txt)
  if type(txt)=="string" then
    if false then 
      print(txt, 120-lpx(txt)//2, 64)
    else 
      can_pass = math.min(tt//DEF_TXT_S, string.len(txt))==string.len(txt)
      print(string.sub(txt,0,math.min(tt//DEF_TXT_S, string.len(txt))), 120-lpx(txt)//2, 64)
    end
  elseif type(txt)=="table" then
    local a = txt["s"] or DEF_TXT_S
    local txt = txt[1]
    if type(txt)=="table" then
      local waiter = 0
      for i,j in ipairs(txt) do
        print(can_pass)
        --print(print(txt[2], -100, -100), 0, 30)
        --print(tt//a-waiter, 0, i*10)
        if (tt//a-waiter)>=0 then
          print(string.sub(j,0,math.min(tt//a-waiter, string.len(j))), 120-lpx(txt)//2, 64-#txt*9+i*9)
        end
        waiter=waiter+string.len(j)
      end
      can_pass = tt//a-waiter>=0
    else
      local j = txt
      print(string.sub(txt,0,math.min(tt//a, string.len(j))), 120-lpx(txt)//2, 64)
      can_pass=tt//a-string.len(j)>=0
    end
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
DEF_REMAIN = 60
backcol=0

function intro()
  cls(backcol)
  if wait_t<DEF_WAIT and wait_t>-1 then wait_t=wait_t+1 return elseif wait_t>-1 then tt=0 wait_t=-1 end
  show_choices()
  show_quest()
  if ccount~=0 then ccount=white_to_black(0,ccount) end
end

function state_q()
  q.t=q.t+1
  if q.state==0 then
    cls(backcol)
    if q.t>DEF_WAIT then q.state=1 q.t=0 end
  elseif q.state==1 then
    cls(backcol)
    if render_quest(q.t) then q.state=2 q.t=0 end
  elseif q.state==2 then
    cls(backcol)
    render_quest(0, true)
    local temp = show_choices()
    if q.t>0 then q.state=3 q.t=0 end --0 is default waiting for input
  elseif q.state==3 then
    cls(backcol)
    render_quest(0, true)
    local temp = show_choices()
    if temp then thechosen=temp q.state=3 q.t=0 end
  elseif q.state==4 then
    if not cur_q[thechosen[2]]["r"] then q.state=5 q.t=0 return
    else 
      if show_ans(cur_q[thechosen[2]]["r"], q.t) then nexq(thechosen[1]) q.state=0 q.t=0 end --maybe add remain time in nexq
    end
  end
end

function show_ans(msg, time)
  if type(msg)=="string" then
    ended = math.min(time//DEF_TXT_S, string.len(txt))==string.len(txt)
    print(string.sub(txt,0,math.min(time//DEF_TXT_S, string.len(txt))), 120-lpx(txt)//2, 130)
  elseif type(msg)=="table" then
    local waiter=0
    for i,v in msg do
      if (time//a-waiter)>=0 then
        print(string.sub(j,0,math.min(time//a-waiter, string.len(j))), 120-lpx(txt)//2, 64-#txt*9+i*9)
      end
      waiter=waiter+string.len(j)
    end
  ended = time//a-waiter>=0
  end
  return ended
end

thechosen = nil

function movnext2(n_and_i)
  if cur_q[n_and_i[2]]["r"] then thechosen=cur_q[n_and_i[2]]["r"] 
  else thechosen=nil end
end


function nexq2(indx)
  tt = 0
  wait_t=0
  can_pass=false
  cur_ans = nil
  if A[indx] then
    cur_i = indx
    cur_q = dc(A[cur_i])
    if cur_i==-1 then cur_q[1]=SRY[t_compt_wrong] t_compt_wrong=t_compt_wrong+1 end
  end
end

function show_choices2()
  for i,j in pairs(A[cur_i]) do
    if i~=1 then
      if i==2 then 
        if type(j[1])=="table" then for k,l in pairs(j[1]) do
          print(l, 0, 120-#j*9+k*9-9) end
        else print(j[1], 0, 120) end --line(20, 50, 20, 80, 15)
      elseif i==3 then
        if type(j[1])=="table" then for k,l in pairs(j[1]) do
          print(l, 240-print(l, -100, -100), 120-#j*9+k*9-9) end
        else print(j[1], 240-print(j[1], -100, -100), 120) end -- line(225, 50, 225, 80, 15)
      elseif i==4 then print(j[1], 120-(print(j[1], -100, -100)//2), 128) 
      elseif i==5 then print(j[1], 120-(print(j[1], -100, -100)//2), 2) end
    end
  end
  for i=2,3 do
    if btnp(i) then
      if A[cur_i][i] and A[cur_i][i][2] then return {A[cur_i][i][2], i}
      elseif A[cur_i][i] then return {cur_i+1, i} end
    end
  end
  for i=0,1 do
    if btnp(i) and A[cur_i][5-i] and A[cur_i][5-i][2] then return {A[cur_i][5-i][2], 5-i} end
  end
end


function render_quest(time, showfull)
  if showfull==true then time=9999999 end
  txt = cur_q[1]
  if cur_i==1 then
    if btnp(1) and tt//60>2 then
      ccount=1
      tt = 0
      tcompt=tcompt+1
      if tcompt>2 then nexq(2) end
    elseif tt//60>1 then
      m_arrow()
    end
    return
  elseif cur_i==7 then
    local txt="I see that you're quite... discrete."
    print(string.sub(txt,0,math.min(tt//DEF_TXT_S, string.len(txt)-10)), 120-print(txt, -100, -100)//2, 64)
    if tt//DEF_TXT_S>string.len(txt)-10+30 then
      print(string.sub(txt,0,math.min(tt//2-string.len(txt)+10-30, string.len(txt))), 120-print(txt, -100, -100)//2, 64)
    end
    if tt//DEF_TXT_S>string.len(txt)-10+30+30 then nexq(8) end
    return
  elseif cur_i==9 then
    if tt//20<20 and tt//20%6>1 then
      spr(1, math.min(3, -30+tt/8), 64, 0, 1, 0, 1, 2, 2)
      spr(1, math.max(219, 254-tt/8), 57, 0, 1, 0, 3, 2, 2) 
    elseif tt//20>20 then
      nexq(10)
    end
  end
  return printtxt2(txt, time)
end

function printtxt2(txt, time)
  local ended = true
  if type(txt)=="string" then
    if false then 
      print(txt, 120-lpx(txt)//2, 64)
    else 
      ended = math.min(time//DEF_TXT_S, string.len(txt))==string.len(txt)
      print(string.sub(txt,0,math.min(time//DEF_TXT_S, string.len(txt))), 120-lpx(txt)//2, 64)
    end
  elseif type(txt)=="table" then
    local a = txt["s"] or DEF_TXT_S
    local txt = txt[1]
    if type(txt)=="table" then
      local waiter = 0
      for i,j in ipairs(txt) do
        --print(can_pass)
        --print(print(txt[2], -100, -100), 0, 30)
        --print(tt//a-waiter, 0, i*10)
        if (time//a-waiter)>=0 then
          print(string.sub(j,0,math.min(time//a-waiter, string.len(j))), 120-lpx(txt)//2, 64-#txt*9+i*9)
        end
        waiter=waiter+string.len(j)
      end
    ended = time//a-waiter>=0
    else
      local j = txt
      print(string.sub(txt,0,math.min(time//a, string.len(j))), 120-lpx(txt)//2, 64)
      ended=time//a-string.len(j)>=0
    end
  end
  return ended
end 

for i,j in ipairs({[1]=1, [2]=2, [4]=4}) do trace(i) trace(j) end trace("--")