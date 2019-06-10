function RectIsct(r1,r2)
  return
   r1.x+r1.w>r2.x and r2.x+r2.w>r1.x and
   r1.y+r1.h>r2.y and r2.y+r2.h>r1.y
end

function RectXLate(r,dx,dy)
return {x=r.x+dx,y=r.y+dy,w=r.w,h=r.h}
end

function CanMove(x, y)
    local dy=y-p.y
    local pcr=GetPlrCr()
    local r=CanMoveEx(x, y, pcr, dy)
    if not r then return false end
    return true
end

function CanMoveEx(x, y, cr, dy)
  local x1=x+cr.x
  local y1=y+cr.y
  local x2=x1+cr.w-1
  local y2=y1+cr.h-1

  local startC=x1//8
  local endC=x2//8
  local startR=y1//8
  local endR=y2//8

  for c=startC,endC do
  for r=startR,endR do
      local sol=GetTileSol(maprev(c,r))
      if sol==SOL.FULL then return false 
      elseif sol==SOL.HALF then
          if y+cr.h>r*8+4 then return false end
      end
  end
  end
  return true
end