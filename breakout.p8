pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
 g=gm:new()
 w=wall:new()
end

function kick()
 p=paddle:new(
  box:new(53,120,22,3),  -- box
  0.5,1.8,9)         --ax,f,col
 b=ball:new(
  vector:new(0,0),       -- pos
  vector:new(
  rnd(2)-1,          -- speed x
  -2.0),             -- speed y
  2,6,true, -- size,color,stick
  p.box.x+p.box.w/2) -- stick_x
end

function _update60()
 for c in all(g.act) do
  if costatus(c) then
   coresume(c)
  else
   del(g.act, c)
  end
 end
 g.fun.update[g.state]()
end

function _draw()
 g.fun.draw[g.state]()
end

function update_game()
 cls(2)
 for v in all(w.br) do 
  b:chk_brick(v)
 end 
 p:update()
 b:chk_paddle()
 b:update()
 w:update()
end

function draw_game()
 cls(2)
 b:draw()
 p:draw() 
 w:draw()
 draw_bar()
end

function draw_bar()
 rectfill(0,0,127,5,0)
 print(g.lives,0,0,7)
 print(g.points,20,0,4)
end

function update_init()
 if btnp(5) then
  g.level=1
  g.points=0
  g.lives=3
  w.seqhit=0
  w:build()
  kick()
  g.state="game"
 end
end

function draw_init()
 cls()
 print("init",0,0,7)
 print("press ❎ to start",32,40,7)
end

function update_lup()
 if btnp(5) then
  w.seqhit=0
  g.level+=1
  if g.level>#g.plan then
   g.state="won"
  else
   g.state="game"
   w:build()
   kick()
  end
 end
end

function draw_lup()
 cls()
 print("level up",0,0,7)
 print("press ❎ to continue",32,40,7)
end

function update_won()
end

function draw_won()
 print("won")
end

function update_lost()
 if btnp(5) then
  g.level=1
  g.points=0
  g.lives=3
  w.seqhit=0
  w:build()
  g.state="game"
  kick()
 end
end

function draw_lost()
 draw_game()
 print("lost",57,40,7)
end

-->8
vector = {}

function vector:new(x,y)
 local prop={x=x,y=y}
 local meta={
 __index=vector
 }
 return setmetatable(prop,meta)
end

function vector:add(v)
 self.x+=v.x
 self.y+=v.y
end

function vector:mag()
 return sqrt(self.x^2+self.y^2)
end

function vector:setmag(len)
 self.normalize()
 self.mult(len)
end

function vector:normalize()
 local m=self:mag()
 self.x=self.x/m
 self.y=self.y/m
end

function vector:limit(l)
 if self:mag() > l then
  self:normalize()
  self:mult(l)
 end
end

function vector:mult(s)
 self.x=s*self.x
 self.y=s*self.y
end

function sign(n)
 if n>0 then return 1
 elseif n<0 then return -1
 else return 0 end
end
-->8
ball = {}

function ball:new(pos,speed,size,col,stick,stick_x)
 local prop={
  pos=pos,
  speed=speed,
  size=size,
  col=col,
  stick=stick,
  stick_x=stick_x,
  ang=1} -- 1:norm,2:raise,0:flatten
 local meta={
 __index=ball
 }
 return setmetatable(prop,meta)
end

function ball:update()
 if self.stick then
  self.pos.x=self.stick_x
  self.pos.y=p.box.y-self.size-1
  self.speed.x+=p.dx/10
  self.speed.y=-2.0
  self.speed:limit(3)
  --self.speed.x=mid(
  if btnp(4) then
   self.stick=nil
  end
 else
	 self:chk_border()
	 self.pos:add(self.speed)
 end
end

function ball:draw()
 if self.stick then
  line(self.pos.x,self.pos.y,
       self.pos.x+5*self.speed.x,
       self.pos.y+5*self.speed.y)
 end
 circfill(self.pos.x,self.pos.y,
          self.size,self.col)
end

function ball:chk_border()
 if self.pos.x>127 or self.pos.x<0 then
  self.speed.x=-self.speed.x
 end
 if self.pos.y>127 or self.pos.y<5 then
  self.speed.y=-self.speed.y
 end
 self.pos.x=mid(0,self.pos.x,127)
 self.pos.y=mid(0,self.pos.y,127)
end

function ball:chk_paddle()
 if self:collide(p.box)
 then
  if g.pu==6 then --catch
   self.stick=true
  else
   self.speed.y=-self.speed.y
   self.pos.y=p.box.y-self.size
   if abs(p.dx)>2 then
    if sign(self.speed.x)==sign(p.dx) then
     -- flatten
     self:setang(self.ang-1)
    else
     -- raise
     self:setang(self.ang+1)
    end
   end
  end
  sfx(1)
  w.seqhit=0
 else
	 if self.pos.y>=127-p.box.h then
	  g:miss()
	 end 
 end
end

function ball:chk_brick(b)
 local h=false
 if b.a then
	 if self:collide(b.box) then
	  b.t.hit(b)
    if g.pu == 9 then -- and b is not indestructible
     -- megaball
    else
  	 if not h then
	    self.speed.y=-self.speed.y
	   end
    end
	  h=true
	 end
 end
end

function ball:collide(b)
 if self.pos.y-self.size>b.y+b.h then
  return false
 end
 if self.pos.y+self.size<b.y then
  return false
 end
 if self.pos.x-self.size>b.x+b.w then
  return false
 end
 if self.pos.x+self.size<b.x then
  return false
 end
 self.stick_x=self.pos.x
 return true
end

function ball:setang(a)
 self.ang=mid(0,a,2)
 if self.ang==2 then
  self.speed.x=0.50*sign(self.speed.x)
  self.speed.y=1.30*sign(self.speed.y)  
 elseif self.ang==0 then
  self.speed.x=1.30*sign(self.speed.x)
  self.speed.y=0.50*sign(self.speed.y) 
 end
 self.speed.x+=rnd(1)-0.5
 self.speed.y+=rnd(0.6)-0.5
 self.speed:limit(3)
end

-->8
paddle = {}

function paddle:new(box,ax,f,col)
 local prop={box=box,dx=0,ax=ax,f=f,col=col}
 local meta={
 __index=paddle
 }
 return setmetatable(prop,meta)
end

function paddle:update()
 self.box.w=22
 if g.pu==7 then --expand
  self.box.w=30
 end
 if g.pu==8 then --reduce
  self.box.w=15
 end
 local a=false
 if btn(0) then
  self.dx-=self.ax
  a=true
 end
 if btn(1) then
  self.dx+=self.ax
  a=true
 end
 if not a then
  self.dx/=self.f
 end
 self.box.x+=self.dx
 if b.stick then
  b.stick_x+=self.dx
 end
 self:chk_border()
end

function paddle:draw()
 self.box:draw(self.col)
end

function paddle:chk_border()
 if self.box.x>127-self.box.w then
  self.box.x=127-self.box.w
  self.dx=0
 end
 if self.box.x<0 then
  self.box.x=0
  self.dx=0
 end
end

-->8
gm = {}

function gm:new()
 local prop={
  state="init",
  level=1,
  lives=3,
  points=0,
  act={},
  pu=nil, -- powerup type
  fun={
   draw={
   init=function() draw_init() end,
   game=function() draw_game() end,
   lup =function() draw_lup()  end,
   won =function() draw_won()  end,
   lost=function() draw_lost() end
   },
   update={
   init=function() update_init() end,
   game=function() update_game() end,
   lup =function() update_lup()  end,
   won =function() update_won()  end,
   lost=function() update_lost() end
   }   
 }}
 local meta={
 __index=gm
 }
 return setmetatable(prop,meta)
end

function gm:set_powerup(p)
  printh("powerup: "..p)
  if p==4 then
    b.speed.x/=2
    b.speed.y/=2
   end
   if p==5 then
   self.lives+=1
  end
  self.pu=p
  add(self.act, cocreate(
  function()
   for i=1,pu_type[self.pu][t] do
    for j=1,60 do
     yield()
    end
   end
   printh("powerdown: "..p)
   if p==4 then
    b.speed.x*=2
    b.speed.y*=2
   end 
   self.pu=nil
  end
  ))
end

function gm:miss()
	sfx(0)
 self.lives-=1
 if self.lives<=0 then
  self.state="lost"
 else
  w.pi={}
  self.pu=nil
  kick()
 end
end

gm.plan={
-- 1
{
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,},
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,},
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,},
  { 5,5,5,5,5,5,5,5,5,5,5,5,5,},
--{ 4,4,4,4,4,4,4,4,4,4,4,4,4,},
--{ 1,1,1,1,1,1,4,1,1,1,1,1,1,},
--{ 0,1,0,2,0,3,0,4,0,5,0,0,0,},
--{ 1,0,1,0,1,0,1,0,1,0,1,0,1,},
--{ 0,1,0,1,0,1,0,1,0,1,0,1,0,},
--{ 1,0,1,0,1,0,1,0,1,0,1,0,1,},
--{ 0,1,0,1,0,1,0,1,0,1,0,1,0,},
},
-- 2
{
{ 1,1,1,1,1,1,1,1,1,1,},
--{ 1,1,1,1,1,1,1,1,1,1,},
},
-- 3
{
{ 1,1,0,1,0,1,1,},
{ 1,1,1,1,1,1,1,1,1,1,},
{ 1,1,1,1,},
},
}

-->8
brick = {}

function brick:new(box,t,r,c)
 local prop={box=box,t=t,r=r,c=c,a=true}
 local meta={
 __index=brick
 }
 return setmetatable(prop,meta)
end

function brick:draw()
 if self.a then
  self.box:draw(self.t.col)
 end
end

function brick:proxi(b)
 if b.box.y+b.box.h>=self.box.y-2
 and b.box.y<=self.box.y+self.box.h+2
 and b.box.x+b.box.w>=self.box.x-2
 and b.box.x<=self.box.x+self.box.w+2
 then
  return true
 else
  return false
 end
end

pill={}
function pill:new(pos,speed,s)
 local prop={pos=pos,speed=speed,s=s,a=true}
 local meta={
 __index=pill
 }
 return setmetatable(prop,meta)
end

function pill:update()
 self.pos:add(self.speed)
 if self.pos.y>128 then
  --self.a=false
  del(w.pi,self)
 end
 self:chk_paddle()
end

function pill:draw()
 --if self.a then
  if self.s==8 then
   palt(0,false)
   palt(15,true)
  end
  spr(self.s,self.pos.x,self.pos.y)
  palt() 
 end
--end

function pill:chk_paddle()
 --if self.a then
  if box:new(self.pos.x,
             self.pos.y,
             8,6):collide(p.box) then
   --self.a=false
   sfx(10)
   g:set_powerup(self.s)
   del(w.pi,self)
   --[[
   4  slowdown
   5  life
   6  catch
   7  expand
   8  reduce
   9  megaball
   10 multiball
   ]]--
  end
 --end   
end

pu_type = {
	[4] ={[t]=10},
	[5] ={[t]=0},
	[6] ={[t]=10},
	[7] ={[t]=10},
	[8] ={[t]=10},
	[9] ={[t]=10},
 [10]={[t]=0},
}

wall = {}

function wall:new()
 local prop={
  br={},
  seqhit=0
 }
 local meta={
 __index=wall
 }
 return setmetatable(prop,meta)
end

function wall:build()
 local add_row={
 r4 =function(n,r) self:ar(n,r,3,29) end,
 r7 =function(n,r) self:ar(n,r,2,16) end,
 r10=function(n,r) self:ar(n,r,5,10) end,
 r13=function(n,r) self:ar(n,r,0, 8) end,
 }
 self.br={}
 for i=1,#g.plan[g.level] do
  local r=g.plan[g.level][i]
  add_row["r"..#r](i,r)
 end
 self.pi={}
end

function wall:update()
 for p in all(self.pi) do
  p:update()
 end
end

function wall:draw()
 for p in all(self.pi) do
  p:draw()
 end
 for b in all(self.br) do
  b:draw()
 end
end

function wall:ar(n,r,b,w)
 local x,y
 for c=1,#r do
  if r[c]>0 then
   x=b+(w+2)*(c-1)
   y=6+6*(n-1)
   add(self.br,brick:new(
    box:new(x,y,w,4),
    brick_types[r[c]],
    n,c)) -- row,column
  end
 end
end

function wall:empty()
 for b in all(self.br) do
  if b.a and b.t.n!="i" then
   return false
  end
 end
 return true
end

function wall:proxi(b)
 pr={}
 for p in all(self.br) do
  if p!=b and p.a and b:proxi(p) then
   add(pr,p)
  end
 end
 return pr
end

box = {}

function box:new(x,y,w,h)
 local prop={x=x,y=y,w=w,h=h}
 local meta={
 __index=box
 }
 return setmetatable(prop,meta)
end

function box:draw(col)
 rectfill(self.x,self.y,
  self.x+self.w,self.y+self.h,col)
end

function box:collide(b)
 if self.y>b.y+b.h    then return false end
 if self.y+self.h<b.y then return false end
 if self.x>b.x+b.w    then return false end
 if self.x+self.w<b.x then return false end
 return true
end

function sqr(x) return x*x end

function dist(x1,y1,x2,y2)
 return sqrt(sqr(x1-x2)+sqr(y1-y2))
end

brick_type = {}

function brick_type:new(n,col,point,hit)
 local prop={n=n,col=col,point=point,hit=hit}
 local meta={
 __index=brick_type
 }
 return setmetatable(prop,meta)
end

function hit(b)
 b.a=false
 if w:empty() and g.state=="game" then
  g.state="lup" -- level up
 end
end

function hit_n(b)
 hit(b)
 local pt=b.t.point
 if g.pu==8 then --reduce
  pt*=2
 end
 g.points+=pt+w.seqhit
 w.seqhit+=1
 sfx(mid(2,w.seqhit,8))
end

function hit_i(b)
	sfx(9)
end

function hit_h(b)
 sfx(9)
 b.t=brick_types[1]
end

function hit_e(b)
 hit(b)
 sfx(2)
 add(g.act, cocreate(
  function()
   for p in all(w:proxi(b)) do
    p.t.hit(p)
    for j=1,10 do
     yield()
    end
   end
  end
 )) 
end

function hit_p(b)
	hit_n(b)
	sfx(2)
 -- trigger powerup
 add(w.pi,pill:new(
  vector:new(b.box.x,b.box.y),
  vector:new(0,0.4),
  --flr(rnd(7))+4)) -- 4..10
  9))
end

brick_types={
-- normal
brick_type:new("n",14,1,hit_n),
-- indestructible
brick_type:new("i",6,1,hit_i),
-- hardened
brick_type:new("h",15,1,hit_h),
-- exploding
brick_type:new("e",9,1,hit_e),
-- powerup
brick_type:new("p",12,1,hit_p),
}

function dump(o)
 if type(o) == 'table' then
  local s = '{ '
  for k,v in pairs(o) do
   if type(k) ~= 'number' then k = '"'..k..'"' end
   s = s .. '['..k..'] = ' .. dump(v) .. ','
  end
  return s .. '} '
 else
  return tostring(o)
 end
end
__gfx__
0000000000000000000000000000000006777760067777600677776006777760f677776f06777760067777600000000000000000000000000000000000000000
00000000000000000000000000000000559949555582885555b33b5555c11c555508805555e222e5556566650000000000000000000000000000000000000000
00700700000000000000000000000000559499555582885555b3bb5555c11c555508805555e222e5556566650000000000000000000000000000000000000000
00077000cdcdcdcdaaaaaaaa99999999559949555582885555b3bb5555c1cc555508805555e2e2e5556556650000000000000000000000000000000000000000
00077000dcdcdcdcaaaaaaaa99999999559499555582285555b33b5555c11c555508805555e2e2e5556556650000000000000000000000000000000000000000
00700700000000000000000000000000059999500588885005bbbb5005cccc50f500005f05eeee50056666500000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000
__sfx__
00030000380102b0101e010150100e000080000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300001452014520145200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300001952019520195200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300001e5201e5201e5200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002452024520245200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002a5202a5202a5200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002f5202f5202f5200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300003652036520365200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600001d4101d410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001b0101e010220102501019000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01424344

