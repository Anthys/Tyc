LENX = 240
LENY = 136

game = {
 s=1
}

t=0

ST = {'intro'}

debug = false

function TIC()
 _G[ST[game.s]]()
 t=t+1
end

function intro()
  cls(0)
  print("Yesa")
end