LENX = 240
LENY = 136

game = {
 s=1
}
debug = false

t=0

ST = {'intro'}

cos = math.cos
abs= math.abs
sin = math.sin
max = math.max
min = math.min


---------
---------

Panel = {}
Panel.__index = Panel

function Panel:n(x,y,sx,sy,c)
    local tmp = {}
    setmetatable(tmp, Panel)
    tmp.x = x or 0
    tmp.y = y or 0
    tmp.sx = sx or 0
    tmp.sy = sy or 0
    tmp.dx = 2
    tmp.dy = 2
    tmp.c = c or 2
    tmp.lines = 2
    tmp.msg = nil
    tmp.queue = {}
    tmp.t = 0
    tmp.tt = 0
    tmp.waiting = false
    tmp.continue_alone = true
    tmp.pause = 30
    return tmp
end

function Panel:update()
    self.t = self.t + 1
    self.tt = self.tt +1
end

function Panel:draw()
    rect(self.x, self.y, self.sx, self.sy, self.c)
    print(self.t, 40,40, 12)
    self:draw_text()
    self:update()
end

function Panel:draw_text()
    if self.msg then
        --trace(self.msg)
        local msg = self.msg
        local x,y = self.x+self.dx, self.y+self.dy
        local pause = self.pause
        local mxtime = msg.speed * 4* #msg.txt + pause
        local txt1 = string.sub(msg.txt, 1, (#msg.txt*( self.tt/(mxtime-pause) ))//1)
        txt1 = msg.char.name .. ": " .. txt1
        print(txt1, x, y, msg.char.col)
        if self.tt >= mxtime - pause then
            self.waiting = true
        end
        if self.tt > mxtime and #self.queue > 0 and self.continue_alone then 
            self:next_m()
        end
    elseif #self.queue > 0 then
        self:next_m()
    end
end


function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function seq_by_word(txt)
    return mysplit(txt, " ")
end

function Panel:cut_message(msg)
    local orig_txt = msg.txt
    local orig_text = seq_by_word(orig_txt)
    local max_lines = (self.sy - 2*self.dy)//7
    local max_px_per_line = self.sx -2* self.dx
    local cur_txt = ""
    local final_groups = {{}}
    for i=1,#orig_text do
        local cur_word = orig_text[i]
        if plx(cur_txt .. cur_word .. " ") < (#final_groups[#final_groups]>0 and max_px_per_line or max_px_per_line - plx(msg.char.name)) then
            cur_txt = cur_txt .. cur_word .. " "
        else
            table.insert(final_groups[#final_groups], cur_txt)
            cur_txt = cur_word .. " "
            if #final_groups[#final_groups] >= max_lines then 
                final_groups[#final_groups+1] = {}
            end
        end
        if i == #orig_text then
            if #final_groups[#final_groups] >= max_lines then 
                final_groups[#final_groups+1] = {cur_txt}
            else
                table.insert(final_groups[#final_groups], cur_txt)
            end
        end
    end
    local output = {}
    for i=1,#final_groups do
        if #final_groups[i] > 1 then
            local final_txt = ""
            for j=1,#final_groups[i] do
                final_txt = final_txt .. final_groups[i][j] .. "\n"
            end
            final_groups[i] = {final_txt}
        end
        local temp = Message:n(final_groups[i][1], msg.char, msg.speed)
        output[#output+1] = temp
    end
    return output
end

function Panel:add_messsage(msg)
    local msgs = self:cut_message(msg)
    for i = 1,#msgs do
        trace(msgs[i])
        self.queue[#self.queue+1] = msgs[i]
    end
end

function Panel:next_m()
    if #self.queue > 0 then
        self.tt = 0
        self.waiting = false
        self.msg = self.queue[1]
        table.remove(self.queue, 1)
    end
end

function Panel:process_skip()
    if self.waiting then 
        self:next_m()
    else
        local msg = self.msg
        self.tt = msg.speed * 4* #msg.txt
    end
end

----------


Message = {}
Message.__index = Message

function Message:n(txt, char, speed)
    local tmp = {}
    setmetatable(tmp, Message)
    tmp.txt = txt or ""
    tmp.char = char or 0
    tmp.speed = speed or 1
    return tmp
end

function Message:__tostring()
    return self.txt
end
----------

Character = {}
Character.__index = Character

function Character:n(name, col)
    local tmp = {}
    setmetatable(tmp, Character)
    tmp.name = name or "Michel"
    tmp.col = col or 2
    return tmp
end


----------
----------

function plx(txt)
    return print(txt, -1000,-1000)
end


----------
----------

bib = {
    "Super1",
    "Super2",
    "Super3"
}

function init()
    a = Panel:n(10,10,200,25)
    c = Character:n("Micheml", 3)
    e = Character:n("Christine", 6)
    b = Message:n("Bonjour, je me prenome gustave michael, j'adore les voitures et les six tonnes. Rhododindron a vous aussi.", c)
    d = Message:n("Je t'aime bb tes trop le plus bo je veux etre la cerise de ton cake frero je temenerai au neuviem ciel on va fer des trucs de fou", e)
    --a.msg = b
    a:add_messsage(b)
    a:add_messsage(d)
end

function intro()
    if t == 0 then init() end
    cls()
    print(1)
    a:draw()
    if keyp(48) then a:process_skip() end
    --print(a.msg, 20, 20)
end


function TIC()
 _G[ST[game.s]]()
 t=t+1
end