pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
vector = {}

function vector:new(x, y)
 local prop = {x = x, y = y}
 local meta = {
 __index = vector,
 __add = function(v1, v2)
     return setmetatable(
     {x = v1.x + v2.x, 
      y = v1.y + v2.y}, 
      getmetatable(v1))
 end,
 __sub = function(v1, v2)
     return setmetatable(
     {x = v1.x - v2.x, 
      y = v1.y - v2.y}, 
      getmetatable(v1))
 end,
 __mul = function(s, v)
     return setmetatable(
     {x = s * v.x, 
      y = s * v.y},
      getmetatable(v))
 end,
 __div = function(v, s)
     return setmetatable(
     {x = v.x / s, 
      y = v.y / s}, 
      getmetatable(v))
 end,
 __unm = function(v)
     return setmetatable(
     {x = -v.x, 
      y = -v.y}, 
      getmetatable(v))
 end,
 __len = function(v)
     return sqrt(
     v.x^2 + v.y^2)
 end,
 __eq = function(v1, v2)
     return v1.x == v2.x 
        and v1.y == v2.y
 end,
 }
 return setmetatable(prop, meta)
end

function vector:tostring()
 return self.x..","..self.y
end

function vector:add(v)
 self.x = self.x + v.x
 self.y = self.y + v.y
end

function vector:normalize()
 local mag = #self
 self.x = self.x / mag
 self.y = self.y / mag
end

-->8
function _init()
 m={}
	 for i=1, 5 do
	 pos_x = flr(rnd(128))
	 pos_y = flr(rnd(128))
	 speed_x = flr(rnd(4)+1)
	 speed_y = flr(rnd(4)+1)
	 add(m,mover:new(
	  vector:new(pos_x,pos_y),
	  vector:new(speed_x,speed_y),
	  flr(rnd(3)+1)))
 end
 pause=true
end

function _update()
 if (btnp(4)) then
  pause=not pause
 end
 if not pause then
  for x in all(m) do x:update() end
 end
end

function _draw()
 cls(2)
 for x in all(m) do x:draw() end
end
-->8
mover={}

function mover:new(pos,speed,pic)
 local prop={pos=pos,speed=speed,pic=pic}
 local meta={__index=mover}
 return setmetatable(prop,meta) 
end

function mover:update()
 self.pos:add(self.speed)
 self:chk_collision()
end

function mover:draw()
 spr(self.pic,self.pos.x,self.pos.y)
end

function mover:chk_collision()
 if self.pos.x>127-8 or self.pos.x<0 then
  --self.speed.x+=rnd(1)*(flr(rnd(2))==0 and -1 or 1)
  self.speed.x=-self.speed.x
  if self.pos.x>127-8 then
   self.pos.x=127-8
  end
  if self.pos.x<0 then
   self.pos.x=0
  end
  sfx(self.pic-1)
 end
 if self.pos.y>127-8 or self.pos.y<0 then
  --self.speed.y+=rnd(1)*(flr(rnd(2))==0 and -1 or 1)
  self.speed.y=-self.speed.y
  if self.pos.y>127-8 then
   self.pos.y=127-8
  end
  if self.pos.y<0 then
   self.pos.y=0
  end
  sfx(self.pic-1)
 end
end
__gfx__
00000000666666668888888833333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000600000068000000830000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700600000068000000830000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000600000068000000830000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000600000068000000830000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700600000068000000830000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000600000068000000830000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666666668888888833333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000023320213201e320193001430010300103000f300103002270020700207001f7001e7001c7001b70012600101001870016700101001470009600127001170000000000000000000000000000000000000
000300001902019020190201902000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001661016610166100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
