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
function lerp(a,b,t) return (1-t)*a + t*b end