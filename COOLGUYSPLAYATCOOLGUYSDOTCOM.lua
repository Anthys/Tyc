function TIC()
  --put fonction here
end


-- Cool concepts
function bugged_text_but_lisible(arrayoftext)
  cls()
  local t_txt = arrayoftext[t//90 + 1]
  print(string.sub(t_txt, 1, math.min(t//5%20, string.len(t_txt))))
end


--Utilities
  -- quickpos
for i=0,4 do
  if btnp(i) then p.pos[(i//2+1)%2+1]=p.pos[(i//2+1)%2+1]+i%2*2-1 end
end

function lerp(a,b,t) return (1-t)*a + t*b end

function stxt(txt, xs)
  -- Fit txt in a box of length xs
  output={txt}
  done = false
  while not done do
    if spx(output[#output])<xs then
      trace('###')
      for i,v in pairs(output) do
        trace(i)
        trace(v)
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