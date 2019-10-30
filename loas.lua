
t=0

ST={'intro', "generation", "inmap", "ending"}

curstate=0

g={
  s=1
}

lvl={
  st={},
  fin={}
}

p={
  pos={0,0}
}

function TIC()
  _G[ST[g.s]]()
  t=t+1
end

function intro()
  cls()
  draw_back()
  draw_focus()
  if curstate==0 then get_surfing_input()
  elseif curstate==1 then
    show_choices() 
    get_input_choice() end
  if curstate==2 then 
    show_choices()
    show_def() end
end

choxtitl={"Wing", "Breach code", "Gene group", "Success rate", ""}
chox = {
  {
    {"ANEM", "Creatures located here were too deeply contaminated by a PSION source. They are maintained under complexe cryostasis, as they could die in seconds if brought out."}, --player has a time limit before dying.
    {"ISL", "Here are kept creatures that were in direct or indirect contact with a [REDACTED] source. Must be contained at any cost."}, --can teleport at certain locations from certain locations
    {"FCL", 'Location of creatures which are in the middle of an experiment/operation. May be instable or weak.'}, --player power/vision/strength/speed may be instable
    {"OPSF", "This area was locked down due to incident 9-R3. There were still creatures in there at the time of lockdown. See addendum for compulsory preparations, in case of a need to go there."} --player keep gaining power. If it reaches a certain level, player explodes. Must use certain stations to unleash its power and decrease the level.
  },
  {
    {"PWS", "A power surge has occured. If the surge isn't controlled quickly, the laboratory integrity may suffer from it."}, --random explosions, electrical problems, machines not functioning
    {"AIS", "Artificial intelligence shutdown. Some vital processes may have been shut down. Mechanical assistants operating without guidance."}, -- Mechanical assistants may be controlled/hostile/friendly/passive. Some control panels are accessible.
    {"EVD", "Environmental destabilization. Some areas may have become inhospitable. Remaining greenhouse are locked and guarded."}, --Must breath in greenhouses, which are protected by the A.I.
    {"RQST", "High-personel request. Consequences unknown."} -- 
  },
  {
    {"A", "A-group creature have abilities to modify the shape of their body very easily. Some can cross thin gaps or compress air to increase their weight."}, 
    {"F", "F-group creatures posses fragments of ADN that appears to make them way more resistant against environmental fluctuations than usual organsisms. To a certain extent, they can bear fire, poison, vacuum, or even high sudden changes of velocity."},
    {"L", "L-group creatures appear to be able to discern and treat information very quickly. They seem to understand complex mechanisms and foreign languages in a fraction of time."}, 
    {"X", "X-group creatures seem to have the ability to share information between them by means that are still not really understood. It looks like some kind of contagious telepathy, as extended contact with X-group creatures as showed that the ADN of the subjects seem to mutate quickly, to share genes of the X-group."}, --maybe X-group is actually one an only creature, possessing multiples bodies.
    {"Z", "Z-group creatures seem to have the ability to restore their organic tissues at a very high speed, making them sort of invicible. However, when faced with ---(danger?), they seem to switch in a phase looking like hibernation, becoming completly inert and non-responsive."}, --"All Z-group creatures where found in [REDACTED]." found during certain events, they appear at certain times. Only creature than can't be built artificially or replicated. However, invicible. -- Experiment: Subject of Z-group locked in a perfectly locked container. A laser destroy each fragment of ADN of the body. At 50% destroyed, weird observations, the dead body seem to be vibrating. At 75%, the remaining cells of the body begin to dissociate from each other, and try to remain as espaced as they can. At 90%, inside pression increase. At 95%, container stability is breaking. At 98%, container explode, cells are dissemated. A body looking exactly like the first subject of the experiment is found 3 days later in a greenhouse room. Seems to have been synthetised with nearby materials. 
  },
  {
    {"12", "Very deffective creature. If no blatant results are observed in the next days, must be terminated if possible."}, 
    {"523"}, 
    {"712"}, 
    {"891+", "Extremely sucessful creature. Can be trusted (to a certain extent), and has wonderful capacities."}
  }
}
chosen = {"ANEM", "PWS", "A", "12"}
focus = 1
focus2= 1

function text_box()
  rectb(0, 68, 240, 68, focus=="text" and 4 or 1)
end

function inv()
  rectb(180, 0, 60, 66, focus=="inv" and 4 or 1)
end

function action_box()
  rectb(98, 0, 80, 66, focus=="action" and 4 or 1)
  for a,b in pairs(actions_list) do
    for i,v in pairs(b) do
      print(v, 100, i*6, 15, false, 1, true)
    end
  end
end

function condition()
  local condi = {}
  condi.check = function check()
    
    end
  return condi
end

focus_dyc={"map", "action", "inv", "text"}
indx_focus={["map"]=1, ["action"]=2, ["inv"]=3, ["text"]=4}

-- #y*x+y

--typical room {
-- [1]= {{First message encountered when arrive in room (string or table)},{list of available actions}},
-- [2]= Message encountered if goes back in room,
-- [3]= Optionnal, message shown if quit room,
-- [4]={{"name of action", "result of action"}, {...}},
-- [5]={"tb":NumbOfTimesWherePlayerEnteredThisRoom, ""}
-- }
--rooms = {4*5+2={[1]=}}

function init_matrix(x, y)
  local matrix = {}
  for i=1,x do
    matrix[i]={}
    for j=1,y do
      matrix[i][j]=0
    end
  end
  return matrix
end

testmatrix=init_matrix(10, 15)
testmatrix[5][9]=1
testmatrix[5][10]=1
testmatrix[5][8]=1

testrooms={
  [5*15+9]={
    {"This is a room."},
    {"You already entered the room."}, 
    [4]={"Examine room","Examine lamp","Examine red button"},
    [5]={["tb"]=0}
  }
}

--[[

action={
  "action name",
  [1]={ --ResultWithBestImportance,WillBeChosenIfConditionsFulfill
    [1]={"msg"},
    [2]={
      --optional, conditions. If no conditions given then will be chosen everytime and next results won't ever be chosen
      {--condition 1 "variable 1", "operator", "variable 2"}, {condition 2}, {condition 3}
    },
    [3]={
      --Consequences
      {--cons 1 "variable 1", "variable that will be assigned to variable 1"}
    }
  }
}



]]--

actions_list = {["every"]={}, ["room"]={}}

function quit_room()
  local room = testrooms[p.pos[2]*15+p.pos[1]]
  state_room=0
  actions_list["room"]={}
end

function rml(lst, tormv)
  for i,v in ipairs(lst) do
    if v==tormv then lst[i]=nil end
  end
end

state_room=0
focus_act=0

function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end

function live_room()
  local room = testrooms[p.pos[2]*15+p.pos[1]]
  if room~=nil then
    if state_room==0 then
      if room~=nil then
        room[5]["tb"]=room[5]["tb"]+1
      end
      if room[4]~=nil then for i,v in ipairs(room[4]) do
        actions_list["room"][#actions_list["room"]+1]=v
        trace(v)
      end end
      state_room=1
    elseif state_room==1 then
      if room[5]["tb"]==1 then printtxt(room[1][1]) 
      else printtxt(room[2][1]) end
    end
  end
end

function printtxt(txt)
  txt = stxt(txt, 236)
  print(txt, 2, 70, 15)
end

function inmap()
  cls()
  show_populated_map(matrix)
  rectb(p.pos[1]*SZ_MAP_SQR-1, p.pos[2]*SZ_MAP_SQR-1, SZ_MAP_PLY, SZ_MAP_PLY, 14)
  text_box()
  inv()
  action_box()
  if btnp(6) then 
    focus=focus_dyc[indx_focus[focus]%#focus_dyc+1] 
  end
  if btn(7) then show_legend() end
  if focus=="map" then
    if btnp(0) and trymove(0, -1) then quit_room() p.pos[2]=p.pos[2]-1
    elseif btnp(1) and trymove(0, 1) then quit_room() p.pos[2]=p.pos[2]+1
    elseif btnp(2) and trymove(-1, 0) then quit_room() p.pos[1]=p.pos[1]-1
    elseif  btnp(3) and trymove(1, 0) then quit_room() p.pos[1]=p.pos[1]+1
    end
  end
  live_room()
  --[[
  for i=0,3 do
    if btnp(i) and trymove(p.pos[1]+(i//2), p.pos[2]+(i//2+1)%2) then p.pos[(i//2+1)%2+1]=p.pos[(i//2+1)%2+1]+i%2*2-1 end
  end
  ]]--
end

debug = true

SZ_MAP_SQR=6
SZ_MAP_TILE=4
SZ_MAP_PLY=6
SZ_MAP_MOD=2

function trymove(x, y)
  --rectb((p.pos[1]+x)*SZ_MAP_SQR-1, (p.pos[2]+y)*SZ_MAP_SQR-1, SZ_MAP_PLY, SZ_MAP_PLY, 15)
  local x, y = p.pos[1]+x, p.pos[2]+y
  trace("##")
  trace(x)
  trace(y)
  trace(matrix[y][x])
  trace_matrix(matrix)
  if matrix[y][x]~=0 then return true end
end

function init_player()
  if debug then matrix=testmatrix end
  p.pos={lvl.st[2], lvl.st[1]}
  if debug then p.pos={9, 5} end
  focus="map"
end

function draw_back()
  for i,v in pairs(choxtitl) do
    if i == #choxtitl then print("  DONE  ", 0, i*8)
    else print(v..": "..chosen[i], 0, i*8) end
  end
end

function draw_focus()
  if focus==#choxtitl then rectb(0, focus*8-1, spx("  DONE  ")-1, 8, 1)
  else rectb(spx(choxtitl[focus]..": ")-3, focus*8-1, spx(chosen[focus])+5, 8, 1) end
end

function get_surfing_input()
  if btnp(0) then focus=(focus-2)%#choxtitl+1
  elseif btnp(1) then focus=(focus)%#choxtitl+1 end
  if btnp(4) then 
    if focus==#choxtitl then g.s=2 curstate=0 else curstate=1 focus2=1 end end
end

function show_choices()
  rect(120, 0, 120, 136, 1)
  for i,v in pairs(chox[focus]) do
    print(v[1], 123, i*8)
  end
  rectb(121, focus2*8-1, spx(chox[focus][focus2][1])+3, 8, 2)
end

function show_def()
  rect(120, 68, 120, 68, 2)
  print(stxt(chox[focus][focus2][2], 120), 120, 68)
  if btnp(0) or btnp(1) or btnp(4) or btnp(5) then curstate=1 end
end

function get_input_choice()
  if btnp(0) then focus2=(focus2-2)%#chox[focus]+1
  elseif btnp(1) then focus2=(focus2)%#chox[focus]+1 end
  if btnp(4) then curstate=0 chosen[focus]=chox[focus][focus2][1] end
  if btnp(5) then curstate=0 end
  if btnp(3) then curstate=2 end
end

function spx(txt)
  return print(txt, -100, -100)
end

matrix={}

function generation()
  cls()
  if curstate==0 then
    matrix=init_matrix(10, 15)
    trace_matrix(matrix)
    matrix=gener_map(matrix)
    curstate=1
  elseif curstate==1 then
    trace_matrix(matrix)
    show_map(matrix)
    if btnp(0) then curstate=0 end
    if btnp(1) then matrix=populate(matrix) curstate=2 end
  elseif curstate==2 then
    --trace_matrix(matrix)
    show_populated_map(matrix)
    show_legend()
    if btnp(0) then curstate=1 end
    if btnp(1) then curstate=0 g.s=3 init_player() end
  end
end



--up down left right udlr
g.s=2

function trace_matrix(mtrx)
  trace("###")
  for i=1,#mtrx do
    local temp = ""
    for j=1,#mtrx[1] do
      temp=temp..mtrx[i][j]
    end
    trace(temp)
  end
end 

function show_map(mtrx)
  rectb(0,0,#mtrx[1]*SZ_MAP_SQR+5, #mtrx*SZ_MAP_SQR+5, 4)
  for j=1,#mtrx[1] do
    for i=1,#mtrx do
      if mtrx[i][j]~=0 then rect(j*SZ_MAP_SQR,i*SZ_MAP_SQR,SZ_MAP_TILE,SZ_MAP_TILE,3) end
    end
  end
end

function show_populated_map(mtrx)
  rectb(0,0,(#mtrx[1]+1)*SZ_MAP_SQR, (#mtrx+1)*SZ_MAP_SQR, focus=="map" and 4 or 1)
  local dyc = {[1]=5, ["s"]=6, ["gh"]=7, ["pg"]=8, ['c']=9, ["ob"]=10, ["fin"]=11}
  for i=1,#mtrx[1] do
    for j=1,#mtrx do
      if mtrx[j][i]~=0 then rect(i*SZ_MAP_SQR,j*SZ_MAP_SQR,SZ_MAP_TILE,SZ_MAP_TILE,3) rect(i*SZ_MAP_SQR+1,j*SZ_MAP_SQR+1,SZ_MAP_MOD,SZ_MAP_MOD,dyc[mtrx[j][i]]) end
    end
  end
end

function show_legend()
  local dyc= {["Corridor"]=5, ["Start"]=6, ["Greenhouse"]=7, ["Power generator"]=8, ['Cell']=9, ["Observation room"]=10, ["End"]=11}
  local count=0
  rect(115, 0, 120, 60, 0)
  for i,v in pairs(dyc) do
    count=count+1
    rect(120, count*6+1, 4, 4, v)
    print(i, 120+6, count*6)
  end
end

function populate(mtrx)
  local dyc={s=0,gh=0,pg=0,c=0,ob=0,fin=0} --start greenhouse power-generator cell observation-room
  for i=1,#mtrx do
    for j=1,#mtrx[1]do
      if mtrx[i][j]~=0 then
        mtrx[i][j]=1
        local c = math.random(1,300)
        if c<40 and dyc.gh<4 then mtrx[i][j]="gh" dyc.gh=dyc.gh+1
        elseif c<70 and dyc.pg<3 then mtrx[i][j]="pg" dyc.pg=dyc.pg+1
        elseif c<85 and dyc.c<5 then mtrx[i][j]="c" dyc.c=dyc.c+1
        elseif c<100 and dyc.ob<2 then mtrx[i][j]="ob" dyc.ob=dyc.ob+1
        else mtrx[i][j]=1 end
      end
    end
  end
  while dyc.s~=1 do
    local a,b = math.random(1,#mtrx), math.random(1,#mtrx[1])
    if mtrx[a][b]==1 then dyc.s=1 mtrx[a][b]="s" lvl.st={a,b} end
  end
  while dyc.fin~=1 do
    local a,b = math.random(1,#mtrx), math.random(1,#mtrx[1])
    if mtrx[a][b]==1 then dyc.fin=1 mtrx[a][b]="fin" lvl.fin={a,b} end
  end
  return mtrx
end

function gener_map(mtrx)
  mtrx[#mtrx//2][#mtrx[1]//2]=1
  local roomnumb=1
  local done = false
  local count=0
  while not (count>3) do
    local toprocess={}
    for i=1,#mtrx do
      for j=1,#mtrx[1]do
        if mtrx[i][j]==1 then toprocess[#toprocess+1]={i,j} end
      end
    end
    for i,v in pairs(toprocess) do
      extend_rooms(mtrx, v[1], v[2])
    end
    count=count+1
  end
  return mtrx
end


function extend_rooms(mtrx, x, y)
  trace_matrix(mtrx)
  local dyc = {{x,y-1},{x,y+1},{x+1,y},{x-1,y}}
  mtrx[x][y]=2
  for i,v in pairs(dyc) do
    if 0<v[1] and v[1]<=#mtrx and 0<v[2] and v[2]<=#mtrx[1] and mtrx[v[1]][v[2]]==0 then
      if math.random(1,5)>2 then mtrx[v[1]][v[2]]=1 end
    end
  end
  return mtrx
end

function make_rooms(mtrx, x, y)
  local c = mtrx[x][y]
  local opr = {}
  if string.find(c, "u") then opr[#opr+1]={x, y-1} end
  if string.find(c, "d") then opr[#opr+1]={x, y+1} end
  if string.find(c, "l") then opr[#opr+1]={x-1, y} end
  if string.find(c, "r") then opr[#opr+1]={x+1, y} end
  for i,v in pairs(opr) do
    if 0<v[1]<#mtrx and 0<v[2]<#mtrx[1] and mtrx[v[1]][v[2]]==0 then mtrx = make_cell(mtrx, v[1], v[2]) end
  end
end

function make_cell(mtrx, x, y)
  local d1={"u","d","l","r"}

  local c = math.random(1,100)
  if c<10 then 
    local cc = math.random(1,4)
  end
end

function ending()
  cls()
  print("YES")
  print(string.sub("YES",2,2), 10, 10)
  rectb(20, 20, 50, 100, 2)
  print(stxt("aaa aaaa aaaaaa aa", 50), 20, 20)
end

function stxt(txt, xs)
  output={txt}
  done = false
  while not done do
    if spx(output[#output])<xs then
      --trace('###')
      for i,v in pairs(output) do
        --trace(i)
        --trace(v)
      end 
      final = output[1]
      if #output>1 then
        for i=2,#output do
          final = final.."\n"..output[i]
        end
      end
      return final
    else
      trace("#|#")
      c=output[#output]
      trace(c)
      for i=math.min(xs//3,string.len(c)),1,-1 do 
        if string.sub(c,i,i)==" " and spx(string.sub(c, 1, i-1))<xs then output[#output+1]=string.sub(c, i+1, string.len(c)) output[#output-1]=string.sub(c, 1, i) break end
        if i==2 then trace("oops")
          for i=1,math.min(xs//3,string.len(c)) do 
            if string.sub(c, i, i)==" " or i==math.min(xs//3,string.len(c)) then output[#output+1]=string.sub(c, i+1, string.len(c)) output[#output-1]=string.sub(c, 1, i) break end
          end
        end
      end
    end
  end
end
