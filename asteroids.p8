pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include pq.lua
pq("----------------")
timer=0
function _update()
 ship:update()
 for a in all(asteroids) do
  a:update()
 end
 if (btn(❎)) then
  if #bullets<30 then
   add(bullets,_bullet:new(ship.pos[1],ship.pos[2], ship.ang))
  end
 end
 if (btnp(🅾️)) then
  ship:tele()
 end
 for b in all(bullets) do
  b:update()
 end
 timer+=1
 if timer>3*30 then
  for b in all(bullets) do
   if b.pos[1]>128 or b.pos[1]<0
    or b.pos[2]>128 or b.pos[2]<0
   then del(bullets,b)
   end
  end
  timer=0
 end
end

function _draw()
 cls()
 print(#bullets,0,120,9)
 ship:draw() 
 for b in all(bullets) do
  b:draw()
 end
 for a in all(asteroids) do
  a:draw()
 end
 sweeper:draw()
 ship:collide()
 for a in all(asteroids) do
  a:hit()
 end
end

-->8
_ship={}

function _ship:new()
 return setmetatable ({
  pos={64,64},
  ang=0.25,
  rot=0.02,
  v=0,
  maxv=3,
  len=7,
 },{
  __index=_ship
 })
end

function _ship:update()
 if (btn(⬅️)) self.ang+=self.rot
 if (btn(➡️)) self.ang-=self.rot
 if (btn(⬆️)) self.v+=0.1;sfx(0)
 if (btn(⬇️)) self.v-=0.1;sfx(1)
 if (self.v>self.maxv) self.v=self.maxv
 if (self.v<-self.maxv) self.v=-self.maxv

 self.pos[1]+=self.v*cos(self.ang)
 self.pos[2]+=self.v*sin(self.ang)

 if (self.pos[1]>128) self.pos[1]=0
 if (self.pos[2]>128) self.pos[2]=0
 if (self.pos[1]<0) self.pos[1]=128
 if (self.pos[2]<0) self.pos[2]=128
end

function _ship:draw()
 local x1=self.len*cos(self.ang)
 local y1=self.len*sin(self.ang)
 local x2=self.len*cos(self.ang+0.25)/3
 local y2=self.len*sin(self.ang+0.25)/3 
 line(self.pos[1]+x1,self.pos[2]+y1,
      self.pos[1]+x2,self.pos[2]+y2,6)
 line(self.pos[1]-x2,self.pos[2]-y2,6)
 line(self.pos[1]+x1,self.pos[2]+y1,6)
end

function _ship:collide()
 local x1=self.len*cos(self.ang)
 local y1=self.len*sin(self.ang)
 local c={self.pos[1]+x1/2,self.pos[2]+y1/2}
 local r=self.len/2
 for a in all(asteroids) do
  local l=sqrt((a.pos[1]-c[1])^2+(a.pos[2]-c[2])^2)
  if a:vis() and (r+a.r)>l then
   print("collision "..a.pos[1]..","..a.pos[2],0,0,8)
  else
   print("",0,0,0)
  end
 end
end

function _ship:tele()
 self.pos[1]=rnd(128)
 self.pos[2]=rnd(128)
 self.v=0
 self.ang=rnd(1)
end

ship=_ship:new()
-->8
_bullet={}

function _bullet:new(x,y,ang,v)
 sfx(2)
 return setmetatable ({
  pos={x,y},
  ang=ang,
  v=v or 4,
 },{
  __index=_bullet
 })
end

function _bullet:update()
 self.pos[1]+=self.v*cos(self.ang)
 self.pos[2]+=self.v*sin(self.ang)
end

function _bullet:draw()
  pset(self.pos[1],self.pos[2],9)
end

bullets={}
-->8
_asteroid={}

function _asteroid:new(x,y,r,s,ang,v)
 return setmetatable ({
  pos={x,y},
  ver={},
  s=max(3,flr(s-s/2+rnd(s/2))),
  r=r,
  v=v,
  ang=ang,
 },{
  __index=_asteroid
 })
end

function _asteroid:cver()
 for j=0,self.r do
  local ver={}
  for i=0,self.s-1 do
   local a=i/self.s
   local px=cos(a)*self.r
   local py=sin(a)*self.r
   add(ver,{px,py})
  end
  self.ver=ver
  --pq(self.s,self.r,j,costatus(a.cover))
  yield()
 end
end

function _asteroid:cre(x,y,r,s,ang,v)
 a=_asteroid:new(x,y,r,s,ang,v)
 a.cover=cocreate(function () a:cver() end)
 coresume(a.cover)
 return a
end

function _asteroid:update()
 if costatus(self.cover)!="dead" then
  coresume(self.cover)
 end
 self.pos[1]+=self.v*cos(self.ang)
 self.pos[2]+=self.v*sin(self.ang)
end

function _asteroid:draw()
 local n=#self.ver
 for i=1,n do
  local x1,y1=self.ver[i][1],self.ver[i][2]
  local x2,y2=self.ver[(i%n)+1][1],self.ver[(i%n)+1][2]
  line(self.pos[1]+x1,
       self.pos[2]+y1,
       self.pos[1]+x2,
       self.pos[2]+y2,8)
 end
end

function _asteroid:hit()
 for b in all(bullets) do
  c={min(max(b.pos[1],0),128),min(max(b.pos[2],0),128)}
  local l=sqrt((self.pos[1]-c[1])^2+(self.pos[2]-c[2])^2)
  if self:vis() and self.r>l then
   print("hit",0,8,9)
   del(bullets,b)
   del(asteroids,self)
  else
   print("",0,8,0)
  end
 end
end

function _asteroid:vis()
 if self.pos[1]-self.r>128 or
    self.pos[1]+self.r<0 or
    self.pos[2]-self.r>128 or
    self.pos[2]+self.r<0 then
  return false
 else
  return true
 end
end

asteroids={
 _asteroid:cre(40,40,12,8,-0.2,0.1),
 _asteroid:cre(60,10,14,8,-0.2,0.2),
 _asteroid:cre(100,90,10,8,0.2,0.3),
}
-->8
_sweeper={}

function _sweeper:new(x,y,v)
 return setmetatable ({
  pos={x,y},
  v=v,
 },{
  __index=_sweeper
 })
end

function _sweeper:update()

end

function _sweeper:draw()
 spr(2,10,10)
 spr(3,18,10)
end

sweeper=_sweeper:new()
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000110000000002222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700001111000002222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700001dddd102222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001d6776d12222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001d6776d10002222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011dd1100000002222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000c6100c6100b6100a6100a610096100861007610066100561005600046000360002600016000060000600066000660006600066000560005600056000460003600036000360002600016000060000600
0001000015610116100c6100861005610140001600026600226001f6001b600186001460010600096000260000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000017010140100f0100b0100a010000000020004200002000f20009200022000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
