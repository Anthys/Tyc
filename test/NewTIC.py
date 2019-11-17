import os

name = str(input("Name:"))
if not name + ".tic" in os.listdir():
  os.system("type nul > " + name +".tic")
  os.system("type nul > " + name + ".lua")
  ffile = open(name+".lua", "w+")
  txt = "LENX = 240\nLENY = 136\n\ngame = {\n s=1\n}\n\nt=0\n\nST = {'intro'}\n\ndebug = false\n\nfunction TIC()\n _G[ST[game.s]]()\n t=t+1\nend"
  ffile.write(txt)
  ffile.close()
else:
  print("ERROR")


