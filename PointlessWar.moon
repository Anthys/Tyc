-- script: moon
LENX = 240
LENY = 136



cls 1
game = {
 s:1
}

t=0




debug = false

all_units = {}

class Unit
  new:(col=1,val,x,y)->
    @col=col
    @val=val
    @x=x
    @y=y
    @spr = 1

render_units = ->
  for i,v in pairs all_units
    spr(v.spr,30+math.cos(t/64)*20, 40)
    print(v.col)

intro = -> 
  print 1
  render_units!

ST = {intro}

export TIC=-> 
  if t==0
    all_units[1]=Unit\new
  t+=1 
  cls 1 
  a = ST[game.s]
  ST[game.s]!

