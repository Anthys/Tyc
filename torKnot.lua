LENX = 240
LENY = 136

game = {
 s=1
}

t=0

ST = {'intro'}

cos = math.cos
abs= math.abs
sin = math.sin
max = math.max
min = math.min

flr = math.floor

debug = false

function intro()
    c=circ
    d=cos
    s=t/64
    for i=1,99 do
        if(i<6) then 
            --pal(i,-({16,14,11,3,10})[i],1)
            c(64,64,(6-i+s%2)^3,i%2)
        end
            m=i/198*d(i/2)
            q=64/(4+d(m))
            j=2+i/19
            --fillp(({1034,1394,22447})[flr(j*4%4)])
            c(64+2*q*sin(m),64+q*d(s/2+m),q-9*d(m*3-s)*d(s/9),j+flr(j+.7)*16)
        
    end

end

function TIC()
 _G[ST[game.s]]()
 t=t+1
end