---- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua
-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

t = 0
x = 96
y = 24


vp1 = {256, 260, 264, 268, 320}
vp1c = {1, 2, 8, 9, 15}
vp2c = {3, 4, 5, 6, 10, 11, 13}
vp2 = {384, 386, 388, 390}
vp3 = {416, 417, 418, 419}
PALETTE_MAP = 0x3FF0
white = 12
times = 0
timef = times + 3 * 60 * 1000
timec = 4
timecReset = 0

virus = {}

virusdraw = function(self, x, y)
  x = x or 0
  y = y or 0
  newcol = vp1c[self.vp1c]
  pal(12, newcol)
  --poke4(PALETTE_MAP * 2 + white, newcol) -- swap the colors
  spr(vp1[self.vp1], x, y, 15, 1, 0, 0, 4, 4)

  newcol = vp2c[self.vp2c]
  pal(12, newcol)
  --poke4(PALETTE_MAP * 2 + white, newcol) -- swap the colors
  spr(vp2[self.vp2], x + 8, y + 8, 0, 1, 0, 0, 2, 2)

  newcol = vp2c[self.vp3c]
  pal(12, newcol)
  --poke4(PALETTE_MAP * 2 + white, newcol) -- swap the colors
  spr(vp3[self.vp3], x + 12, y + 12, 0, 1, 0, 0, 1, 1)

  palt()
end

target = {}
target.vp1 = math.floor((1 + math.random() * 5))
target.vp1c = math.floor((1 + math.random() * 5))
target.vp2 = math.floor((1 + math.random() * 4))
target.vp2c = math.floor((1 + math.random() * 7))
target.vp3 = math.floor((1 + math.random() * 4))
target.vp3c = math.floor((1 + math.random() * 7))

virus[1] = {}
virus[1].vp1 = target.vp1
virus[1].vp1c = target.vp1c
virus[1].vp2 = target.vp2
virus[1].vp2c = target.vp2c
virus[1].vp3 = target.vp3
virus[1].vp3c = target.vp3c
virus[1].s = 1 - math.random() * 2
virus[1].c = 1 - math.random() * 2
virus[1].sp = 8 + math.random() * 4
virus[1].cp = 8 + math.random() * 4
virus[1].target = true

for i = 2, 18 do
  virus[i] = {}
  virus[i].vp1 = target.vp1
  virus[i].vp1c = target.vp1c
  virus[i].vp2 = target.vp2
  virus[i].vp2c = target.vp2c
  virus[i].vp3 = target.vp3
  virus[i].vp3c = target.vp3c
  virus[i].s = 1 - math.random() * 2
  virus[i].c = 1 - math.random() * 2
  virus[i].sp = 8 + math.random() * 4
  virus[i].cp = 8 + math.random() * 4
  virus[i].target = false
  repeat
    if math.random() < 0.15 then
      virus[i].vp1 = math.floor((1 + math.random() * 5))
    end
    if math.random() < 0.3 then
      virus[i].vp1c = math.floor((1 + math.random() * 5))
    end
    if math.random() < 0.15 then
      virus[i].vp2 = math.floor((1 + math.random() * 4))
    end
    if math.random() < 0.15 then
      virus[i].vp2c = math.floor((1 + math.random() * 7))
    end
    if math.random() < 0.15 then
      virus[i].vp3 = math.floor((1 + math.random() * 4))
    end
    if math.random() < 0.15 then
      virus[i].vp3c = math.floor((1 + math.random() * 7))
    end
  until(virus[i].vp1 ~= target.vp1 or
    virus[i].vp1c ~= target.vp1c or
    virus[i].vp2 ~= target.vp2 or
    virus[i].vp2c ~= target.vp2c or
    virus[i].vp3 ~= target.vp3 or
  virus[i].vp3c ~= target.vp3c)
end

strands = {}
strands[1] = {}
strands[1].s = math.random() * 10
strands[1].sp = 3 + math.random() * 2

function checkStrands(i)
  val = false
  for j = 1, 6 do
    if strands[1][j] ~= strands[i][j] then
      val = true
    end
  end
  return val
end

for j = 1, 6 do
  strands[1][j] = math.floor((1 + math.random() * 7))
end
for i = 2, 20 do
  strands[i] = {}
  strands[i].s = math.random() * 10
  strands[i].sp = 3 + math.random() * 2
  for j = 1, 6 do
    strands[i][j] = strands[1][j]
  end
  repeat
    for j = 1, 6 do
      if math.random() < 0.15 then
        strands[i][j] = math.floor((1 + math.random() * 7))
      end
    end
  until (checkStrands(i))
end

strandst = strands[1]


rot = 0
nrot = 0

rna = {}
rna[1] = {}
for j = 1, 6 do
  rna[1][j] = math.floor(math.random() * 2)
  if rna[1][j] == 0 then
    rna[1][j] = -1
  end
--  trace(rna[1][j] )
end

function checkRna(i)
  val = false
  for j = 1, 6 do
    if rna[1][j] ~= rna[i][j] then
      val = true
    end
  end
  return val
end

for i = 2, 6 do
  rna[i] = {}
  for j = 1, 6 do
    rna[i][j] = rna[1][j]
  end
  repeat
    for j = 1, 6 do
      if math.random() < 0.15 then
        rna[i][j] = math.floor(math.random() * 2)
        if rna[i][j] == 0 then
          rna[i][j] = -1
        end
      end
    end
  until (checkRna(i))
end

rnat = rna[1]
rnar = {}

for i = 1, 6 do
rnar[i] = 2
end

rnaCounter = 1

rotTimer = 0

txt = {}
txt.x = 1
txt.y = 1
txt.mouth = 0
txt.mouthSpr = 1
txt.add = function(t, amount)
  amount = amount or 1
  if txt.x < #t[txt.y] then
    txt.x = txt.x + amount
    txt.mouth = txt.mouth + 0.3 * amount
  elseif txt.y < #t then
    txt.x = 0
    txt.y = txt.y + 1

  end

end
txt.draw = function(t)
  for z = 1, txt.y - 1 do
    print(t[z], 45, 91 + 8 * z, 0)
    print(t[z], 44, 90 + 8 * z, 12)
  end
  print(string.sub(t[txt.y], 1, math.floor(txt.x)), 45, 91 + 8 * txt.y, 0)
  print(string.sub(t[txt.y], 1, math.floor(txt.x)), 44, 90 + 8 * txt.y, 12)

end

txt.res = function()

  txt.x = 1
  txt.y = 1
  txt.mouth = 0
  txt.mouthSpr = 1

end

micBlink = false
screen = 0 --0=Logo, 1=Initial lab, 2=Virus selection, 3=Lab for strands, 4=Strands selection, 5=Lab for RNA, 6=RNA selection, 7=Win, 8=Lose
p = false
lastp = p

function drawLab()
  --Initial game screen
  cls(0)
  --PC Sprite:
  spr(0, 41, 19, 0, 1, 0, 0, 8, 8)
  --Microscope Sprite:
  if micBlink then
    spr(8 + t%80 // 40 * 96, 102, 35, 0, 1, 0, 0, 6, 6)
  else
    spr(8, 102, 35, 0, 1, 0, 0, 6, 6)
  end
  --
  --Vials Sprite:
  spr(128, 156, 60, 0, 1, 0, 0, 4, 3)
  rect(16, 80, 32, 4, 15) --color 15
  rect(48, 80, 171, 4, 13) --color 13
  --Leg 1
  rect(40, 84, 12, 3, 15) --color 15
  rect(40, 87, 4, 7, 15) --color 15
  rect(44, 87, 8, 7, 13) --color 13
  --Leg 2
  rect(186, 84, 12, 3, 15) --color 15
  rect(186, 87, 4, 7, 15) --color 15
  rect(190, 87, 8, 7, 13) --color 13
  --Textbox
  rectb(2, 94, 236, 40, 13)
  rectb(3, 95, 234, 38, 14)
  rect(4, 96, 232, 36, 15)
  line(40, 96, 40, 131, 14)
  --Scientist
  spr(192, 6, 100, 0, 1, 0, 0, 4, 4)
  --mouth
  if txt.mouth >= 1 then
    txt.mouth = 0
    txt.mouthSpr = math.floor((0 + math.random() * 4))
  end
  spr(244 + txt.mouthSpr, 18, 124, 0, 1, 0, 0, 1, 1)

end

function drawBack(val)
  --Back button for levels
  rectb(0, 0, 41, 12, 13)
  rectb(1, 1, 39, 10, 14)
  rect(2, 2, 37, 8, 15)
  print("Back", 4, 4, 4)
  spr(496, 30, 2, 0)
  if x <= 41 and y <= 12 then
    poke(0x03FFB, 129)
    if p and p ~= lastp then
      screen = val
    end
  end
end

function TIC()
  lastp = p
  x, y, p = mouse()
  
  if screen == 0 then
  	cls(0)
   title = "Find the cure!"
   subtitle = "Click to start"
   titleW = print(title, 0, 100, 0, false, 2)
   subtitleW = print(subtitle,0,100,0)
   for i = -1, 1 do
   	for j=-1 ,1 do
   		print(title,(240-titleW)//2+2*i,(136-6)//2+2*j, 12, false, 2)
   	end
   end
			print(title,(240-titleW)//2,(136-6)//2, 0, false, 2)
   for i = -1, 1 do
   	for j=-1 ,1 do
   		print(subtitle,(240-subtitleW)//2+1*i,(136-6)//2+1*j + 18, 12)
   	end
   end  
  	print(subtitle,(240-subtitleW)//2,(136-6)//2 + 18, 0)
   	poke(0x03FFB, 129)
    
    if p and p ~= lastp then
    	screen = 1
    end
  elseif screen == 1 then
    drawLab()
    text = {}
    text[1] = "Please help us with the virus!"
    text[2] = "but hurry, we only have 3 minutes!"
    text[3] = "I'm sending you a photo of it..."
    text[4] = "Try to find it on the microscope."

    --print(text[1],45,101,0)
    --print(string.sub(text[txt.y],1,txt.x),44,100,12)
    txt.draw(text)
    if btn(2) then txt.add(text) end--txt.x = txt.x + 1 end
    txt.add(text, 1 / 4)
    virusdraw(target, 63, 24)
    if txt.y == 4 then
      blockH = 32 - (txt.x / #text[4]) * 32
      rect(63, 24 + (32 - blockH), 32, blockH, 7)
      if txt.x < #text[4] then
        line(62, 24 + (32 - blockH), 62 + 33, 24 + (32 - blockH), 6)
      end
      if txt.x >= #text[4] then
        micBlink = true
      end
    else
      rect(63, 24, 32, 32, 7)
    end


    if micBlink == true then
      if x >= 112 and x <= 146 and y >= 36 and y <= 79 and pix(x, y) ~= 0 then
        poke(0x03FFB, 129)
        if p and p ~= lastp then
          screen = 2
          --p= false
        end
      end
    end
    --end
    --[[
  if btn(0) then y = y - 1 end
  if btn(1) then y = y + 1 end
  if btn(2) then x = x - 1 end
  if btn(3) then x = x + 1 end

  if t >= 59 then
    virus = shuffle(virus)
    t = 0
  end
  ]]
  elseif screen == 2 then
    cls(14)
    --spr(1+t%60//30*2,x,y,14,3,0,0,2,2)
    --spr(256+t%75//15*4,32,32,15,1,0,0,4,4)
    vrs = 1
    for i = 0, 5 do
      for j = 0, 2 do
        posx = 4 + 40 * i + math.sin(virus[vrs].s + t / virus[vrs].sp) * 1
        posy = 12 + j * 38 + math.cos(virus[vrs].c + t / virus[vrs].cp) * 1
        virusdraw(virus[vrs], posx, posy)
        if (posx + 16 - x) * (posx + 16 - x) + (posy + 16 - y) * (posy + 16 - y) < 18 * 18 and pix(x, y) ~= 14 then
          poke(0x03FFB, 129)
          if p and p ~= lastp then
            if virus[vrs].target == true then
              screen = 3
              sfx(1,"C-4")
              txt.x = 1
              txt.y = 1
            else
              timef = timef - 10000
              sfx(0,"C-4")
              timec = 2
              timecReset = 0
            end
            --p= false
          end
        end
        vrs = vrs + 1
      end

      drawBack(1)

    end
    --poke4(PALETTE_MAP * 2 + white, blue) -- swap them back
    --print("HELLO WORLD!",84,84)
  elseif screen == 4 then

    cls(14)

    for i = 1, 20 do
      posx = 8 + 56 * ((i - 1)%4)
      posy = 30 + 20 * ((i - 1) // 4)
      for j = 1, 6 do
        pal(12, strands[i][j])
        spr(432, 56 * ((i - 1)%4) + 8 * j, 30 + 20 * ((i - 1) // 4) + math.sin(strands[i].s + t / strands[i].sp + j / 2) * 2, 14, 1, 0, 0, 1, 2)
        palt()
      end
      if x > posx and x < posx + 40 and y > posy - 4 and y < posy + 8 then
        poke(0x03FFB, 129)
        if p and p ~= lastp then
          if strands[i] == strandst then
            screen = 5
            sfx(1,"C-4")
            txt.x = 1
            txt.y = 1
          else
            timef = timef - 10000
            sfx(0,"C-4")
            timec = 2
            timecReset = 0
          end
        end
      end
    end

    drawBack(3)

  elseif screen == 3 then
    drawLab()
    text = {}
    text[1] = "Great!"
    text[2] = "Now find the correct RNA strand."
    text[3] = "It will have these colors in order."
    text[4] = "Find it on the microscope."

    --print(text[1],45,101,0)
    --print(string.sub(text[txt.y],1,txt.x),44,100,12)
    txt.draw(text)
    if btn(2) then txt.add(text) end--txt.x = txt.x + 1 end
    txt.add(text, 1 / 4)
    rectb(63,39,32,7,0)
    for i=1, 6 do
      rect(59+5*i,40,5,5,strandst[i])
      --rectb(58+5*i,40,5,5,0)
    end
    --strandst[j]
  --  virusdraw(target, 63, 24)
    if txt.y == 4 then
      blockH = 32 - (txt.x / #text[4]) * 32
      rect(63, 24 + (32 - blockH), 32, blockH, 7)
      if txt.x < #text[4] then
        line(62, 24 + (32 - blockH), 62 + 33, 24 + (32 - blockH), 6)
      end
      if txt.x >= #text[4] then
        micBlink = true
      end
    else
      rect(63, 24, 32, 32, 7)
    end


    if micBlink == true then
      if x >= 112 and x <= 146 and y >= 36 and y <= 79 and pix(x, y) ~= 0 then
        poke(0x03FFB, 129)
        if p and p ~= lastp then
          screen = 4
          --p= false
        end
      end
    end
  elseif screen == 5 then
    drawLab()
    text = {}
    text[1] = "Awesome!!!"
    text[2] = "Lastly, you need to select the RNA."
    text[3] = "It will rotate like this."
    text[4] = "Again, find it on the microscope."

    --print(text[1],45,101,0)
    --print(string.sub(text[txt.y],1,txt.x),44,100,12)
    txt.draw(text)
    if btn(2) then txt.add(text) end--txt.x = txt.x + 1 end
    txt.add(text, 1 / 4)
    for i=1, 6 do
      local flip = 0
      --trace(rnat[i])
      if rnat[i] == -1 then
        flip = 1
      end
      spr(496,63+12*((i-1) % 3),30 + 12*((i-1) // 3),0,1,flip)
      --rect(59+5*i,40,5,5,rnat[i])
      --rectb(58+5*i,40,5,5,0)
    end
    --strandst[j]
  --  virusdraw(target, 63, 24)
    if txt.y == 4 then
      blockH = 32 - (txt.x / #text[4]) * 32
      rect(63, 24 + (32 - blockH), 32, blockH, 7)
      if txt.x < #text[4] then
        line(62, 24 + (32 - blockH), 62 + 33, 24 + (32 - blockH), 6)
      end
      if txt.x >= #text[4] then
        micBlink = true
      end
    else
      rect(63, 24, 32, 32, 7)
    end


    if micBlink == true then

      if x >= 112 and x <= 146 and y >= 36 and y <= 79 and pix(x, y) ~= 0 then
        poke(0x03FFB, 129)
        if p and p ~= lastp then
          screen = 6
          --p= false
        end
      end
    end
  elseif screen == 6 then

    cls(14)
    rotTimer = rotTimer + 1
    for i=1, 6 do
      posx = 60 + 60 * ((i - 1)%3)
      posy = 40 + 40 * ((i - 1) // 3)

      s = 464
      if rotTimer >= 60 and rotTimer <= 65 then
        if rna[i][rnaCounter] == 1 then
          s = 466
        else
          s = 468
        end

      end
      rot = rnar[i]
      spr(s, posx, posy, 13, 1, 0, rot, 2, 2)

      if x > posx and x < posx + 16 and y > posy and y < posy + 16 then
        poke(0x03FFB, 129)
        if p and p ~= lastp then
          if rna[i] == rnat then
            screen = 7
            sfx(1,"C-4")
            txt.x = 1
            txt.y = 1
          else
            timef = timef - 10000
            sfx(0,"C-4")
            timec = 2
            timecReset = 0
          end
        end
      end

    end
    if rotTimer == 60 then
      for i=1, 6 do
        rnar[i] = rnar[i] - rna[i][rnaCounter]
        if rnar[i] < 0 then
          rnar[i] = 3
        elseif rnar[i] > 3 then
          rnar[i] = 0
        end
      end
     end
     if rnaCounter == 6 and rotTimer >120 then
      rotTimer = 0
      --trace(rnaCounter)
      rnaCounter = rnaCounter + 1
      if rnaCounter > 6 then
        rnaCounter = 1
      end
      elseif rnaCounter ~= 6 and rotTimer > 65 then
    			rotTimer = 0
       --trace(rnaCounter)
      rnaCounter = rnaCounter + 1
      if rnaCounter > 6 then
        rnaCounter = 1
      end
    end
    drawBack(5)
    
    elseif screen == 7 then --win condition
    drawLab()
--    local tt = 3*60*1000 - timel
    text = {}
    text[1] = "Great, you have done it!!!"
    text[2] = "We now have the cure."
    text[3] = "You still had " .. math.floor(timel/1000) .." seconds!."
    text[4] = "Contratulations."

    --print(text[1],45,101,0)
    --print(string.sub(text[txt.y],1,txt.x),44,100,12)
    txt.draw(text)
    if btn(2) then txt.add(text) end--txt.x = txt.x + 1 end
    txt.add(text, 1 / 4)
    
    
    elseif screen == 8 then --lose condition
    drawLab()
    text = {}
    text[1] = "Sorry, we are out of time!!!"
    text[2] = "The cure was not found..."
    text[3] = "You'll have to try again..."
    text[4] = "Press ctrl+R to reload..."

    --print(text[1],45,101,0)
    --print(string.sub(text[txt.y],1,txt.x),44,100,12)
    txt.draw(text)
    if btn(2) then txt.add(text) end--txt.x = txt.x + 1 end
    txt.add(text, 1 / 4)
    
  end
		
	 
		
  t = t + 1

		

  --Timer draw and functions
  if screen > 0 then
  if timecReset < 30 then
    timecReset = timecReset + 1
  else
    timec = 4
  end
  if screen < 7  then
  timel = timef - time()
  end
  if timel <= 0  then
			screen = 8		
		end
  seconds = math.floor((timel / 1000)%60)
  minutes = math.floor((timel / (1000 * 60))%60)
  rectb(108, 0, 34, 12, 13)
  rectb(109, 1, 32, 10, 14)
  rect(110, 2, 30, 8, 15)
  --print("0"..minutes .. ":" .. seconds,120-8,4,4)
  print(string.format("%02d:%02d", minutes, seconds), 120 - 8, 4, timec)
	end
end

function wrap(x_max, x_min, x)
  return (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min;
end

function shuffle(t)
  local tbl = {}
  for i = 1, #t do
    tbl[i] = t[i]
  end
  for i = #tbl, 2, - 1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

virus = shuffle(virus)
strands = shuffle(strands)
rna = shuffle(rna)


function pal(c0, c1) -- remap c0 color with c1
  poke4(0x3FF0 * 2 + c0, c1)
end

function palt() -- reset color mapping
  for z = 0, 15 do
    poke4(0x3FF0 * 2 + z, z)
  end
end

FADETABLE = {
  {0, 0, 0, 0, 0, 0, 0},
  {1, 1, 1, 15, 0, 0, 0},
  {2, 2, 1, 1, 1, 1, 0},
  {3, 2, 2, 2, 1, 1, 0},
  {4, 3, 3, 2, 1, 1, 15},
  {5, 5, 6, 14, 15, 15, 0},
  {6, 6, 7, 15, 15, 15, 0},
  {7, 7, 15, 15, 15, 0, 0},
  {8, 8, 15, 15, 0, 0, 0},
  {9, 9, 8, 8, 8, 15, 0},
  {10, 9, 9, 7, 8, 15, 15},
  {11, 13, 14, 14, 14, 15, 15},
  {12, 13, 13, 14, 14, 15, 15},
  {13, 14, 14, 14, 15, 15, 15},
  {14, 14, 15, 15, 15, 15, 0},
  {15, 15, 15, 0, 0, 0, 0}
}

function getFadeColor(I, col)
  col = col or 0
  newcol = FADETABLE[col + 1][math.floor(I + 1)]
  return newcol
end

function fade(I)--, col)
  --col = col or 0
  --newcol = 0
  for C = 0, 15 do
    if math.floor(I + 1) >= 8 then
      pal(C, 0)
    else
      pal(C, FADETABLE[C + 1][math.floor(I + 1)])
      --if C == col then
      --newcol = FADETABLE[C + 1][math.floor(I + 1)]
      --end
    end
  end
  --return newcol
end

-- <TILES>
-- 000:000000ff00000fff00000fff00000fff00000fff00000fff00000fff000fffff
-- 001:fffffffeffffffedffffffedffffffedffffffedffffffedffffffedffffffed
-- 002:dddddddddddddddddddddeeedddde888dddd8877dddd8777dddd8777dddd8777
-- 003:ddddddddddddddddeeeeeeee8888888877777777777777777777777777777777
-- 004:ddddddddddddddddeeeeeeee8888888877777777777777777777777777777777
-- 005:ddddddddddddddddeeeeeeee8888888877777777777777777777777777777777
-- 006:ddddddddddddddddeeeeeeed8888888e77777788777777787777777877777778
-- 007:ddddd000dddddd00dddddd00dddddd00eddddd00eddddd00eddddd00eddddd00
-- 010:000000000000000000000000000000000000000e0000000e0000000e0000000e
-- 011:0000000000ffffed0ffffeeeeffffeeeeffffeeeeffffeeeeffffeeeeffffeee
-- 012:00000000de000000dde00000edde0000eddee000eddee000eddee000eddee000
-- 016:00ffffff00ffffff0fffffffffffffffffffffffffffffffffffffffffffffff
-- 017:ffffffedffffffedffffffedffffffedffffffedffffffedffffffedffffffed
-- 018:dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777
-- 019:7777777777777777777777777777777777777777777777777777777777777777
-- 020:7777777777777777777777777777777777777777777777777777777777777777
-- 021:7777777777777777777777777777777777777777777777777777777777777777
-- 022:7777777877777778777777787777777877777778777777787777777877777778
-- 023:eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00
-- 026:0000000e0000000e0000000e0000000e0000000e0000000f0000000f00fffffe
-- 027:effffeeeeffffeeeeffffeeeeffffeeeeffffeeeffffffffffffffffeffffeee
-- 028:eddee000eddee000eddee000eddee000eddee000fffff000fffff000eddee000
-- 032:fffffffffffffffff00000fff00000fff00000fffffffffffffffffff00000ff
-- 033:ffffffedffffffedffffffedffffffedffffffedffffffedffffffedffffffed
-- 034:dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777
-- 035:7777777777777777777777777777777777777777777777777777777777777777
-- 036:7777777777777777777777777777777777777777777777777777777777777777
-- 037:7777777777777777777777777777777777777777777777777777777777777777
-- 038:7777777877777778777777787777777877777778777777787777777877777778
-- 039:eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00
-- 041:000000000000000f000000ff00000fff0000fff0000fff0000fff0000fff0000
-- 042:0ffffffefff0000eff00000e0000000e00077788007678880766788876667788
-- 043:effffeeeeffffeeeeffffeeeeffffeee88877777887777778877777788877777
-- 044:eddee000eddee000eddee000eddee00076667700766667707666677076667700
-- 048:f00000fff00000fffffffffffffffffff00000fff00000fff00000ffffffffff
-- 049:ffffffedffffffedffffffedffffffedffffffedffffffedffffffedffffffed
-- 050:dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777dddd8777
-- 051:7777777777777777777777777777777777777777777777777777777777777777
-- 052:7777777777777777777777777777777777777777777777777777777777777777
-- 053:7777777777777777777777777777777777777777777777777777777777777777
-- 054:7777777877777778777777787777777877777778777777787777777877777778
-- 055:eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00
-- 056:000000000000000000000000000000000000000f0000000f0000000f0000000f
-- 057:0ff00007ff000076ff000766ff007666f0076667f0076670f0766700f0766700
-- 058:6667000e6670000e6700000e7000000e0000000e0000000e0000000e00000000
-- 059:effffeeeeffffeeeeffffeeeeffffeeeeffffeeeeffffeeeeffffeee0fffffff
-- 060:eddee000eddee000eddee000eddee000eddee000eddee000eddee000fff00000
-- 064:fffffffff00000fff00000fff00000ffffffffffffffffff0fffffff00ffffff
-- 065:ffffffedffffffedffffffedffffffedffffffedffffffedffffffedffffffed
-- 066:dddd8777dddd8777dddd8777dddd8777dddd8777dddd8877dddde888dddddddd
-- 067:77777777777777777777777777777777777777777777777788888888dddddddd
-- 068:77777777777777777777777777777777777777777777777788888888dddddddd
-- 069:77777777777777777777777777777777777777777777777788888888dddddddd
-- 070:7777777877777778777777787777777877777778777777888888888edddddddd
-- 071:eddddd00eddddd00eddddd00eddddd00eddddd00eddddd00dddddd00dddddd00
-- 072:000000ff000000ff000000ff00000ff000000ff000000ff000000ff000000ff0
-- 073:0076770000767000007670000076700000767000007677000076670000076670
-- 074:000000000000000000000000000eeeef000eeeef000008880000088800007777
-- 075:00ffffff0000000000000000fffeeeeefffeeeee888888888888888877777777
-- 076:ff0000000000000000000000eeeeedddeeeeeddd888888888888888877777777
-- 077:000000000000000000000000dddee000dddee000888000008880000070000000
-- 080:000fffff0000ffff0000000f00000fff00000fffffffffffffffffffffff00ff
-- 081:ffffffedfffffffeffffffffffffffffffffffffffffedddffffeddd00ffedee
-- 082:ddddddddddddddddfffffffffeeeeeeefeeeeeeeddddddddddddddddddeeddee
-- 083:ddddddddddddddddffffffffeeeeeeeeeeeeeeeeddddddddddddddddddeeddee
-- 084:ddddddddddddddddffffffffeeeeeeeeeeeeeeeedddddddddddddddddddddddd
-- 085:ddddddddddddddddffffffffeeeeeeeeeeeeeeeedddddddddddddddddeeeeeee
-- 086:ddddddddddddddddfffffff0eeeeeeeeeeeeeeeeddddddddddddddddeeeeeeee
-- 087:dddddd00ddddd00000000000e0000000e0000000ddddddddddddddddeeeeeddd
-- 088:00000ff00000fff0000fff00000ff00000000000000000000000000000000000
-- 089:000076670000076600000077000eeeee000eeeee000000000000000000000000
-- 090:777766666666666677777777fffffeeefffffeee000000000000000000000000
-- 091:666666666666666677777777eeeeeeeeeeeeeeee000000000000000000000000
-- 092:666667706667700077700000eeedddddeeeddddd000000000000000000000000
-- 093:000000000000000000000000ddeee000ddeee000000000000000000000000000
-- 096:ffff00ffffff00ffff00ff00ff00ff00ff00ff00ffff00ffffff00ffffff00ff
-- 097:00ffedee00ffedffffffedffffffedffffffedff00ffedff00ffedff00ffedff
-- 098:ddeeddeeddffddffddffddffddffddffddffddffddffddffddffddffddffddff
-- 099:ddeeddeeddffddffddffddffddffddffddffddffddffddffddffddffddffddff
-- 100:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 101:deffffffdeffffffdeffffffdeeeeeeedddddddddeeeeeeedeeeeeeedeffffff
-- 102:ffffffffffffffffffffffffeeeeeeeeddddddddeeeeeeeeffffffeeffffffff
-- 103:ffffedddffffedddffffedddeeeeedddddddddddeeeeedddeeeeedddffffeddd
-- 106:0000000000000000000000000000000c000000ce000000ce000000ce000000ce
-- 107:00cccccc0cffffedcffffeeeeffffeeeeffffeeeeffffeeeeffffeeeeffffeee
-- 108:cc000000dec00000ddec0000eddec000eddeec00eddeec00eddeec00eddeec00
-- 112:ff00ff00ff00ff00ff00ff00ffffffffffffffff000000000000000000000000
-- 113:ffffedddffffedddffffedddffffedddffffeddd000000000000000000000000
-- 114:dddddddddddddddddddddddddddddddddddddddd000000000000000000000000
-- 115:dddddddddddddddddddddddddddddddddddddddd000000000000000000000000
-- 116:dddddddddddddddddddddddddddddddddddddddd000000000000000000000000
-- 117:deffffffdeeeeeeedeeeeeeedddddddddddddddd000000000000000000000000
-- 118:ffffffffffffffeeeeeeeeeedddddddddddddddd000000000000000000000000
-- 119:ffffedddeeeeedddeeeeeddddddddddddddddddd000000000000000000000000
-- 122:000000ce000000ce000000ce000000ce000000ce000000cf000000cf00ffffce
-- 123:effffeeeeffffeeeeffffeeeeffffeeeeffffeeeffffffffffffffffeffffeee
-- 124:eddeec00eddeec00eddeec00eddeec00eddeec00fffffc00fffffc00eddeec00
-- 128:0000fe000000fe000000fe000000feff0000feff0000fe000000fe000000fe00
-- 129:ddddcd000ddcd0000ddcd000eeeeeeeeeeeeeeee0ddcd0000ddcd0000ddcd000
-- 130:ddddcd000ddcd0000ddcd000eeeeeeeeeeeeeeee0ddcd0000ddcd0000ddcd000
-- 131:ddddcd000ddcd0000ddcd000eeeeee00eeeeee000ddcd0000ddcd0000eede000
-- 137:000000000000000f000000ff00000fff0000fff0000fff0000fff0000fff000c
-- 138:0fffffcefff000ceff0000ce000cccce00c777880c767888c766788876667788
-- 139:effffeeeeffffeeeeffffeeeeffffeee88877777887777778877777788877777
-- 140:eddeec00eddeec00eddeec00eddeec00766677c07666677c7666677c766677c0
-- 144:0000fe000000fe000000fe000000fe000000fe000000fe000000fe000000fe00
-- 145:0ddcd0000ddcd0000ddcd0000223200002232000022320000223200000220000
-- 146:099a9000099a9000099a9000099a9000099a9000099a9000099a9000099a9000
-- 147:0eede0000eede0000eede0000eede0000eede0000eede00000ee000000000000
-- 152:000000000000000000000000000000000000000f0000000f0000000f0000000f
-- 153:0ff000c7ff000c76ff00c766ff0c7666f0c76667f0c7667cfc7667c0fc7667c0
-- 154:6667ccce667c00ce67c000ce7c0000cec00000ce000000ce000000ce000000cc
-- 155:effffeeeeffffeeeeffffeeeeffffeeeeffffeeeeffffeeeeffffeeecfffffff
-- 156:eddeec00eddeec00eddeec00eddeec00eddeec00eddeec00eddeec00fffccc00
-- 160:0000fe000000fe00fffeeeeefffeeeee00000000000000000000000000000000
-- 161:0000000000000000eeeeeeeeeeeeeeee00000000000000000000000000000000
-- 162:0099000000000000eeeeeeeeeeeeeeee00000000000000000000000000000000
-- 163:0000000000000000eeeeee00eeeeee0000000000000000000000000000000000
-- 168:000000ff000000ff000000ff00000ff000000ff000000ff000000ff000000ff0
-- 169:0c7677c00c767c000c767c000c767c000c767c000c7677c00c7667c000c7667c
-- 170:000000000000000000cccccc00ceeeef00ceeeef00ccc8880000c888cccc7777
-- 171:0cffffff00ccccccccccccccfffeeeeefffeeeee888888888888888877777777
-- 172:ffc00000cc000000cccccccceeeeedddeeeeeddd888888888888888877777777
-- 173:0000000000000000cccccc00dddeec00dddeec00888ccc00888c00007cc00000
-- 184:00000ff00000fff0000fff00000ff00000000000000000000000000000000000
-- 185:000c76670000c76600cccc7700ceeeee00ceeeee000000000000000000000000
-- 186:777766666666666677777777fffffeeefffffeee000000000000000000000000
-- 187:666666666666666677777777eeeeeeeeeeeeeeee000000000000000000000000
-- 188:6666677c66677cc0777ccccceeedddddeeeddddd000000000000000000000000
-- 189:c000000000000000cccccc00ddeeec00ddeeec00000000000000000000000000
-- 192:0000000000000033000003330000333300033333000333330003333300033333
-- 193:3333000033333300333333303333333333333333333333333333333333333333
-- 194:0000000000000000000000000000000030000000300333003333333333333333
-- 208:0003333300033333000333330033333300333333003333330033333300333333
-- 209:3333333333333333333333333333333333333334333334443444444443333444
-- 210:3333333333333333333333333333333343333333443333334444443344333343
-- 211:3000000033300000333300003333300033333000333330003333330033333300
-- 224:0033333400333331000333310004331300043314004433140044333100043331
-- 225:411133441334114434ccc1344ccccc144ccecc114ccccc1444ccc14414441144
-- 226:433111344114331131ccc4311ccccc431ccecc441ccccc4441ccc44141144411
-- 227:3333300033333000333330001334000013344000133440003334400033340000
-- 240:0000333400000334000000000000000000000000000000000000000000000000
-- 241:4111443444444444444444444444444404444444000444440000244400002222
-- 242:3441114444444444444444404444444044444400444440004422000022220000
-- 243:3330000003300000000000000000000000000000000000000000000000000000
-- 244:0000000000000000000000000111110000122000000000000000000000000000
-- 245:0000000000000000000000000011100000000000000000000000000000000000
-- 246:0000000000000000000000000011000000120000000000000000000000000000
-- 247:0000000000000000000000000001000000000000000000000000000000000000
-- </TILES>

-- <SPRITES>
-- 000:fffffffffffffffffffffffffffffffffffffffffffffffffffffff0ffffff0c
-- 001:ffffffffffffffffffffffffffff0000f000cccc0ccccccccccccccccccccccc
-- 002:ffffffffffffffffffffffff0000ffffcccc000fccccccc0cccccccccccccccc
-- 003:ffffffffffffffffffffffffffffffffffffffffffffffff0fffffffc0ffffff
-- 004:fffffffffffffffffffffffffffffffffffffffffffffffffffffff0ffffff0c
-- 005:ffffffffffffffffffffffffffff00ffff00cc00f0cccccc0ccccccccccccccc
-- 006:ffffffffffffffffffffffffff00ffff00cc00ffcccccc0fccccccc0cccccccc
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffff0fffffffc0ffffff
-- 008:fffffffffffffffffffffffffffff00fffff0cc0fff0ccccff0cccccff0ccccc
-- 009:ffffff00fffff0ccfffff0ccffff00ccf000cccc0ccccccccccccccccccccccc
-- 010:00ffffffcc0fffffcc0fffffcc00ffffcccc000fccccccc0cccccccccccccccc
-- 011:fffffffffffffffffffffffff00fffff0cc0ffffcccc0fffccccc0ffccccc0ff
-- 012:ffffffffffffffffffffffffffffffffffff0000ffff0cccffff0cccffff0ccc
-- 013:fffffff0ffffff0cfffff0ccfff00ccc000ccccccccccccccccccccccccccccc
-- 014:0fffffffc0ffffffcc0fffffccc00fffccccc000cccccccccccccccccccccccc
-- 015:ffffffffffffffffffffffffffffffff0000ffffccc0ffffccc0ffffccc0ffff
-- 016:fffff0ccffff0cccffff0cccfff0ccccfff0ccccfff0ccccfff0ccccfff0cccc
-- 017:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 018:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 019:cc0fffffccc0ffffccc0ffffcccc0fffcccc0fffcccc0fffcccc0fffcccc0fff
-- 020:ffffff0cfffff0ccfffff0ccffff0cccffff0cccfff0ccccff0cccccff0ccccc
-- 021:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 022:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 023:c0ffffffcc0fffffcc0fffffccc0ffffccc0ffffcccc0fffccccc0ffccccc0ff
-- 024:fff0ccccffff0cccffff0cccfff0ccccfff0ccccf00ccccc0ccccccc0ccccccc
-- 025:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 026:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 027:cccc0fffccc0ffffccc0ffffcccc0fffcccc0fffccccc00fccccccc0ccccccc0
-- 028:ffff0cccffff0cccffff0cccfff0ccccfff0ccccff0cccccf0cccccc0ccccccc
-- 029:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 030:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 031:ccc0ffffccc0ffffccc0ffffcccc0fffcccc0fffccccc0ffcccccc0fccccccc0
-- 032:fff0ccccfff0ccccfff0ccccfff0ccccfff0ccccffff0cccffff0cccfffff0cc
-- 033:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 034:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 035:cccc0fffcccc0fffcccc0fffcccc0fffcccc0fffccc0ffffccc0ffffcc0fffff
-- 036:ff0cccccff0cccccfff0ccccffff0cccffff0cccfffff0ccfffff0ccffffff0c
-- 037:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 038:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 039:ccccc0ffccccc0ffcccc0fffccc0ffffccc0ffffcc0fffffcc0fffffc0ffffff
-- 040:0ccccccc0cccccccf00cccccfff0ccccfff0ccccffff0cccffff0cccfff0cccc
-- 041:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 042:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 043:ccccccc0ccccccc0ccccc00fcccc0fffcccc0fffccc0ffffccc0ffffcccc0fff
-- 044:0cccccccf0ccccccff0cccccfff0ccccfff0ccccffff0cccffff0cccffff0ccc
-- 045:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 046:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 047:ccccccc0cccccc0fccccc0ffcccc0fffcccc0fffccc0ffffccc0ffffccc0ffff
-- 048:ffffff0cfffffff0ffffffffffffffffffffffffffffffffffffffffffffffff
-- 049:cccccccccccccccc0cccccccf000ccccffff0000ffffffffffffffffffffffff
-- 050:ccccccccccccccccccccccc0cccc000f0000ffffffffffffffffffffffffffff
-- 051:c0ffffff0fffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 052:ffffff0cfffffff0ffffffffffffffffffffffffffffffffffffffffffffffff
-- 053:cccccccc0cccccccf0ccccccff00cc00ffff00ffffffffffffffffffffffffff
-- 054:ccccccccccccccc0cccccc0f00cc00ffff00ffffffffffffffffffffffffffff
-- 055:c0ffffff0fffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 056:ff0cccccff0cccccfff0ccccffff0cc0fffff00fffffffffffffffffffffffff
-- 057:cccccccccccccccc0cccccccf000ccccffff00ccfffff0ccfffff0ccffffff00
-- 058:ccccccccccccccccccccccc0cccc000fcc00ffffcc0fffffcc0fffff00ffffff
-- 059:ccccc0ffccccc0ffcccc0fff0cc0fffff00fffffffffffffffffffffffffffff
-- 060:ffff0cccffff0cccffff0cccffff0000ffffffffffffffffffffffffffffffff
-- 061:cccccccccccccccccccccccc000cccccfff00cccfffff0ccffffff0cfffffff0
-- 062:ccccccccccccccccccccccccccccc000ccc00fffcc0fffffc0ffffff0fffffff
-- 063:ccc0ffffccc0ffffccc0ffff0000ffffffffffffffffffffffffffffffffffff
-- 064:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 065:ffffffffffffffffffffffffffff0000fff0ccccff0cccccf0ccccccf0cccccc
-- 066:ffffffffffffffffffffffff0000ffffcccc0fffccccc0ffcccccc0fcccccc0f
-- 067:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 068:001122330011223344556677445566778899aabb8899aabbccddeeffccddeeff
-- 080:ffffffffffffff00fffff0ccffff0cccfff0ccccfff0ccccfff0ccccfff0cccc
-- 081:0ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 082:ccccccc0cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 083:ffffffff00ffffffcc0fffffccc0ffffcccc0fffcccc0fffcccc0fffcccc0fff
-- 096:fff0ccccfff0ccccfff0ccccfff0ccccffff0cccfffff0ccffffff00ffffffff
-- 097:cccccccccccccccccccccccccccccccccccccccccccccccccccccccc0ccccccc
-- 098:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0
-- 099:cccc0fffcccc0fffcccc0fffcccc0fffccc0ffffcc0fffff00ffffffffffffff
-- 112:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 113:f0ccccccf0ccccccff0cccccfff0ccccffff0000ffffffffffffffffffffffff
-- 114:cccccc0fcccccc0fccccc0ffcccc0fff0000ffffffffffffffffffffffffffff
-- 115:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 128:00000ccc000ccccc00cccc000ccc0000ccc00000cc000000cc000000cc000000
-- 129:ccc00000ccccc00000cccc000000ccc000000ccc000000cc000000cc000000cc
-- 130:00000000000cc00000ccc0000ccc0000ccc00000cc0000000000000000000000
-- 131:00000000000cc000000ccc000000ccc000000ccc000000cc0000000000000000
-- 132:0000000c0000000c00cc000000cc0000000000000000000000000000cc000000
-- 133:c0000000c00000000000cc000000cc00000000000000000000000000000000cc
-- 134:00000ccc0000cccc00000000000000000c000000cc000000cc000000cc000000
-- 135:ccc00000cccc00000000000000000000000000c0000000cc000000cc000000cc
-- 144:cc000000cc000000cc000000ccc000000ccc000000cccc00000ccccc00000ccc
-- 145:000000cc000000cc000000cc00000ccc0000ccc000cccc00ccccc000ccc00000
-- 146:0000000000000000cc000000ccc000000ccc000000ccc000000cc00000000000
-- 147:0000000000000000000000cc00000ccc0000ccc0000ccc00000cc00000000000
-- 148:cc00000000000000000000000000000000cc000000cc00000000000c0000000c
-- 149:000000cc0000000000000000000000000000cc000000cc00c0000000c0000000
-- 150:cc000000cc000000cc0000000c00000000000000000000000000cccc00000ccc
-- 151:000000cc000000cc000000cc000000c00000000000000000cccc0000ccc00000
-- 160:000000000000000000cccc0000cccc0000cccc0000cccc000000000000000000
-- 161:000000000000000000c00c00000cc000000cc00000c00c000000000000000000
-- 162:0000000000000000000cc00000cccc0000cccc00000cc0000000000000000000
-- 163:0000000000000000000cc00000cccc0000cccc000cccccc00000000000000000
-- 164:00000000000000000cccccc000cccc0000cccc00000cc0000000000000000000
-- 176:ee0000eee0cccc0ee0cccc0e00cccc00e0cccc0eee0000eeeee00eeeeee00eee
-- 192:eee00eeeeee00eeeeee00eeeeee00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 208:eeeeeeeeeeeeeeeeeeeeeeeeeeee0000eee0cccceee0cccceee0cccceee0cccc
-- 209:eeeeeeeeeeeeeeeeeeeeeeee0000eeeecccc0eeecccc0eeecccc0eeecccc0eee
-- 210:eeeeeeeeeeeeeeeeeeeeeeeeeeee0000eee0cccceee0cccceee0cccceee0cccc
-- 211:eeeeeeeeeeeeeeeeeeeeeeee0000eeeecccc0eeecccc0eeecccc0eeecccc0eee
-- 212:eeeeeeeeeeeeeeeeeeeeeeeeeeee0000eee0cccceee0cccceee0cccceee0cccc
-- 213:eeeeeeeeeeeeeeeeeeeeeeee0000eeeecccc0eeecccc0eeecccc0eeecccc0eee
-- 224:eee0cccceee0cccceee0cccceee0cccceeee0000eeeeeee0eeeeeee0eeeeeee0
-- 225:cccc0eeecccc0eeecccc0eeecccc0eee0000eeee0eeeeeee0eeeeeee0eeeeeee
-- 226:eee0cccceee0cccc0ee0cccc00e0cccc0000000000000000e0000000ee000000
-- 227:cccc0eeecccc0eeecccc0eeecccc0eee0000eeee0eeeeeee0eeeeeee0eeeeeee
-- 228:eee0cccceee0cccceee0cccceee0cccceeee0000eeeeeee0eeeeeee0eeeeeee0
-- 229:cccc0eeecccc0eeecccc0ee0cccc0e0000000000000000000000000e000000ee
-- 240:0040000004400000444440004444440004404440004004400000044000000400
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:0070107010602060205030404030403050206010701080109010a010b010d000d000e000f000f000f000f000f000f000f000f000f000f000f000f000300000000000
-- 001:a020a020a030905080708080703060505070408020a010b0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000300000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

