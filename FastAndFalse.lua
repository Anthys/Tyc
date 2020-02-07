LENX = 240
LENY = 136

game = {
 s=1,
 score=0,
 cur_place = -1,
 cur_name = "",
 set = {},
 cur_comb = {txt=nil, bool=nil, t =0, mx_t = 130},
 cur_chox = 0
}

t=0
tt=0

ST = {'intro', "in_game", "lost", "leadboard", "menu"}

dico = {["f"] = {"no","NO","NoO"}, ["y"]={"y", "YES","YEs"}}

special_sets = {choices = {"Plus", "Moins"}} --Doit dire si il y a plus d'objets que sur la diapo précédente ou non

set1 = {choies = {"Rouge", "Noir"}} -- Variations avec font blanc, écriture noire, etc..
set1 = {
  choices = {"YES", "NO"},
  elts = {
    {"y", "yes", "YES", "yee", "ys", "YEs"},
    {"No", "nonono", "NO", "no", "nn", "N", "NoO"}
  }
}
set2 = {
  choices = {"8", "12"},
  elts  = {
    {"8", "8", "4 + 4", "10 - 2", "6 + 2", "8 - 0"},
    {"12", "12", "10 + 2", "6 + 2 + 4", "6 + 6", "12 + 0"}
  }
} -- Résoudre opérations
set3 = {choices = {"Black", "Red"}} -- Doit dire si la carte généerée est noire ou rouge (2 of spades, queen of diamonds)
set4 = {choices = {}}
set3 = {
  choices = {"Animal", "Mobilier"},
  elts = {
    {"Vache", "Lapin", "Abeille", "Loup", "Araignee", "Chat", "Chien", "Cochon", "Serpent", "Tortue du Galapagos", "Cheval", "Chevre", "Mouette", "P O U L E"},
    {"Table basse", "Armoire", "Frigidaire", "Table de chevet", "Placard","Fauteuil", "Tabouret", {"CANAPE 3 PLACES SCANDINAVE","BLEU CANARD BEAUBOURG", "--------------------------------------","MILIBOO & STEPHANE PLAZA"}, "Chaise de bureau", "Etagere", "Lampe", {"Lit","Dans l'Antiquité","Lit en bois doré du XIVe siècle av. J.-C. de Toutânkhamon.","Lit et repose tête de la reine Hétep-Hérès Ire, la mère de Khéops.","Lectus triclinaris dans un Triclinium.","Les premiers lits (8000 av. J.-C.) n'étaient guère plus que des tas de paille","ou d'autre matière naturelle (par exemple, tas de feuilles de palmier, peaux parfois","emplies d'eau pour s'isoler de la terre froide) posés à même le sol. L'étymologie du mot","lit dérive d'ailleurs du verbe latin legere,","namasser, entasser1. ", "", "",""} }
  }
}
set4 = {
  choices = {"Compliment", "Insulte"},
  elts = {
    {"T'es grave bo", "t bo kom 1 camion", "Charmante", "T'es belle kom 1 irondele", "magnifik", "Superbe", "sublime", "intelligent", "seduisante", "grave bonne", "jtm", "<3"},
    {"Fdp de t morts", "astropute", "catapulte tes morts", "demeuré", "connard de con", "jte nik t morts",  "trouducu", "ntm", "tg putain", "TG", "va bien te faire encule gro", "salmerde", "lacalottedetesmorts"}
  }
}
set5 = {
  choices = {"Compliment", "Insulte"},
  elts = {
    {"nymphe", "amour", "resplendissante", "delicieuse", "merveilleuse", "sublime", "magnifique", "rayonnante", "superbe","somptueuse", "belle"},
    {"chenapan","malotru", "foutriquet", "gredin", "scélérat", "mauviette", "goujat", "vil faquin", "crétin des Alpes", "puterelle", "orchidoclaste", "faraud", "fripon", "godiche", "gougnafier", "houlier", "gourgandine", "malappris", "maraud", "olibrius", "pignouf", "sagouin"}
  }
}

all_sets = {set2, set1, set4, set3}

game.s = 1

intro_th = {fandf={}}

debug = false

function plx_bet(txt, s, f)
  return print(txt, -1000, -1000, 0, false, s, f)
end

focus = {menu = {chox = 0}}

BTN = {SPACE=48, ENTER=50, TAB=49}

function menu()
  cls()
  local men = {"8 ou 12", "yes or no", "Compliment \nou Insulte", "Animal \nou \nMobilier"}
  local chox = focus.menu.chox
  for i=0,3 do
    local a = i%2
    local b = i//2
    rect(LENX/2-110+110*a+10*a, LENY/2-60+60*b+10*b, 100, 50, 1)
    rectb(LENX/2-110+110*a+10*a, LENY/2-60+60*b+10*b, 100, 50, 2)
    print(men[i+1],LENX/2-110+110*a+10*a +50-plx_bet(men[i+1], 2, true)/2,  LENY/2-60+60*b+10*b +25 -5 -(i==2 and 4 or 0) - (i==3 and 11 or 0), 15, false, 2, true)
  end
  
  local a = chox%2
  local b = chox//2
  rectb(LENX/2-110+110*a+10*a, LENY/2-60+60*b+10*b, 100, 50, 14)

  if btnp(0) then chox = chox-2 >= 0 and chox -2 or chox
  elseif btnp(1) then chox = chox+2 <= 3 and chox + 2 or chox
  elseif btnp(2) then chox = (chox-1)%2==0 and chox-1 or chox
  elseif btnp(3) then chox = (chox+1)%2==1 and chox+1 or chox end

  if keyp(BTN.ENTER) or keyp(BTN.SPACE) then
    init(chox)
    game.cur_chox = chox
    game.s = 2
  end
  
  focus.menu.chox = chox

  maybe_leaderboard()


  --show_text()

end

function intro()
  cls()

  fast_and_false_texts()

  local tem_t = 60
  local txt = "Start"
  circ(LENX/2, LENY/2, plx(txt), 0)
  circb(LENX/2, LENY/2, plx(txt), 1)
  if t%tem_t < tem_t/2 then print(txt, LENX/2-plx(txt)/2, LENY/2) end
  txt = "Tab for leaderboard"
  if t%tem_t < tem_t/2 and t<20 then print(txt, LENX/2-plx(txt)/2, LENY/2+50, 13) end
  --print(1)
  if anyput() or keyp(BTN.SPACE) then 
    game.s = 5
    --init()
  end
  maybe_leaderboard()  
end

function fast_and_false_texts()
  --print(#intro_th.fandf)
  for i,v in pairs(intro_th.fandf) do
    if v.x > LENX then table.remove(intro_th.fandf, i) end
    v.x = v.x + v.dx
    print(v.mes, v.x, v.y,v.c, false,v.s, v.f)
  end

  if #intro_th.fandf < 13 then
    if #intro_th.fandf < 6 or math.random(1,20) == 1 then 
      trace(8)
      local temp = {}
      temp.x = math.random(-250, -200)
      temp.y = math.random(20,LENY-20)
      temp.c = math.random(15)
      temp.dx = math.random()*4 + 1
      temp.f = math.random(1,2) == 1 and true or false
      local bib = {"Fast", "FAST", "and", "FALSE", "false", "False", "fast", "AND", "fast and false"}
      temp.s = math.random(4)
      temp.mes = bib[math.random(#bib)]
      if temp.mes == "fast and false" then temp.x = -400 end
      intro_th.fandf[#intro_th.fandf+1] = temp
    end
  end
end

function actu_lead(mx_save,chx)
  local chx = chx or game.cur_chox
  if game.score ~= 0 then
    local place = -1
    for i=1,mx_save do
      if game.score > pmem(i+2*chx*mx_save) then place = i+2*chx*mx_save break end
    end
    if place ~= -1 then
      local rel_p = place - 2*chx*mx_save
      for i=mx_save, rel_p+1, -1 do
        pmem(i+2*chx*mx_save, pmem(i-1+2*chx*mx_save))
        pmem(i+(2*chx+1)*mx_save, pmem(i-1+(2*chx+1)*mx_save))
      end
      pmem(place, game.score)
      trace(place)
      return place
    end
  end
end

function get_letter()
  for i=1,26 do
    if keyp(i) then 
      return string.char(64+i)
    end
  end
end

function leadboard()
  cls()
  local bib = {"8/12", "Y/N", "An/Mob", "Com/Ins"}
  if false then 
  for i=0,100 do
    pmem(i, i)
  end
  end
  --trace(game.score)
  for h=0,3 do
    print(bib[h+1], LENX//2 + (h+0.5-2)*60-(plx(bib[h+1])//2), 10)--+(plx(bib[h+1])//2), 10)
    --rect(LENX//2 + (h+0.5-2)*50, 10, 2, 100, 5)
    for i=1,mx_save do
      local a = pmem(i+2*h*mx_save)
      if a ~= 0 then
        print(a, LENX//2 + (h+0.5-2)*60-15, i*10+20)
      else 
        print("---",  LENX//2 + (h+0.5-2)*60-15, i*10+20, 1)
      end
    end
    for i=mx_save+1, mx_save*2 do
      local j = i-mx_save
      local a = byte2txt(pmem(i+2*h*mx_save))
      if a ~= "None" then
        print(a, LENX//2 + (h+0.5-2)*60+5, j*10+20)
      else
        print("---", LENX//2 + (h+0.5-2)*60+5, j*10+20)
      end
    end
  end
  if anyput() then game.s = 1 end
  if keyp(48) then game.s = 2 end
  if keyp(BTN.TAB) then game.s = 5 end
end


function init(chx)
  local chx = chx or game.cur_chox
  game.set = all_sets[chx+1]
  game.cur_comb = {txt=nil, bool=nil, t =0, mx_t = 130}
  lose = false
  game.score = 0
  game.cur_place = -1
  game.cur_name = ""
end

--choices = {"y", "f"}

function show_text(txt)
  if type(txt) == "table" then
    for i,j in pairs(txt) do
      print(j, LENX/2-plx(j)//2, LENY/2 +((i-#txt/2)*8) -5)
    end
  else
    print(txt, LENX/2 -plx(txt)/2, LENY/2)
  end
end

function chose_text()
  local set = game.set
  local a = math.random(#set.elts)
  local b
  b = set.elts[a][math.random(#set.elts[a])]
  return a,b
end

function maybe_leaderboard()
  if keyp(49) then game.s = 4 end
end

function anyput()
  for i=0,3 do
    if btnp(i) then 
      return true
    end
  end
  --if keyp(48) then return true end
end

mx_save = 10

function lost()
  cls()
  print("Game over",LENX/2-plx("Game over")/2, LENY/2)
  local txt = "Final score: " .. tostring(game.txt_score)
  print(txt, LENX//2-plx(txt)/2, LENY//2 + 40)
  if game.score ~= 0 then 
    game.cur_place = actu_lead(mx_save) 
    game.score = 0 
  end
  if game.cur_place ~= nil and game.cur_place ~= -1 then 
    local txt = "Score is in top 10!"
    print(txt,  LENX//2 -plx(txt)/2, 20)
    local txt = "Type your name and press enter"
    print(txt,  LENX//2 -plx(txt)/2, 30)
    txt = 'Current: '..game.cur_name
    print(txt, LENX//2-plx(txt)/2, 40)
    if #game.cur_name <= 4 then 
      if keyp(50) then
        --trace(game.cur_place+mx_save+1)
        --trace(game.cur_name)
        --trace(txt2byte(game.cur_name))
        pmem(game.cur_place+mx_save, txt2byte(game.cur_name))
        --trace(pmem(6))
        --trace(byte2txt(pmem(6)))
        game.cur_place = -1
      end
    end
    if #game.cur_name < 4 then
      local a = get_letter()
      if a then game.cur_name = game.cur_name..a end
    end
    if game.cur_name ~= "" and keyp(51) then 
      game.cur_name = string.sub(game.cur_name, 1, #game.cur_name-1)
    end
  end
  if anyput() or keyp(48) then
    game.s = 2
    init()
  end
  maybe_leaderboard()
end

function in_game()
  local cur_comb = game.cur_comb
  cls()
  if lose == true then 
    game.s = 3 
    game.txt_score = game.score
    return
  end
  if cur_comb.txt == nil then
    local a,b = chose_text()
    --if a == 1 then a = "L" elseif a == 2 then a = "R" end
    cur_comb.txt, cur_comb.bool = b,a
  end

  show_indics(game.set.choices)
  show_score()
  cur_comb.t = show_timer(cur_comb.t, cur_comb.mx_t)
  check_timer(cur_comb.t, cur_comb.mx_t)

  show_text(cur_comb.txt)


  ans = get_input()

  if ans ~= nil then 
    cur_comb = check_true(ans, cur_comb)
  end

  game.cur_comb = cur_comb

end

function plx(txt)
  return print(txt, -100, -100)
end

function show_timer(at,mx)
  local b = at/mx *220
  rect(10,LENY-5,b,5,1)
  return at +1
end

function check_timer(t,mx)
  if t >= mx then
    lose = true
  end
end

function check_true(ans, cur_comb)
  if ans == cur_comb.bool then 
    game.score= game.score+1
  else
    lose = true
  end
  cur_comb.txt=nil
  cur_comb.bool=nil
  cur_comb.t = 0
  cur_comb.mx_t = cur_comb.mx_t*0.95
  return cur_comb
end

function get_input()
  if btnp(2) then return 1
  elseif btnp(3) then return 2 end
end

function show_score()
  print("Score: "..tostring(game.score), 0,0)
end

function show_indics(chox)
  print(chox[1], 0, 100)
  print(chox[2], 240-plx(chox[2]),100)
end

function TIC()
  if t == 0 then init() end
 _G[ST[game.s]]()
 t=t+1
 tt=tt+1
end

function txt2byte(txt)
  local out = ""
  for i=1,#txt do
    out = out .. tostring(string.byte(txt,i)-30) -- to remain under 100
  end
  return tonumber(out)
end


function byte2txt(byte)
  if byte == 0 then return "None" end
  local out = ""
  byte = tostring(byte)
  for i=1,#byte/2 do
    out = out .. string.char(tonumber(string.sub(byte,i*2-1,i*2))+30)
  end
  return out
end