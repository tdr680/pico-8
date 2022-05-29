pico-8 cartridge // http://www.pico-8.com
version 19
__lua__
-- 3d dot party
-- by zep

function _init()
	-- make some points
	pt={}
	for y=-1,1,1/3 do
		for x=-1,1,1/3 do
			for z=-1,1,1/3 do
				p={}
				p.x=x p.y=y p.z=z
				p.col=8 + (x*2+y*3)%8
				add(pt,p)
			end
		end
	end
	
end

-- rotate point x,y by a
-- (rotates around 0,0)
function rot(x,y,a)
	local x0=x
	x = cos(a)*x - sin(a)*y
	y = cos(a)*y + sin(a)*x0 -- *x is wrong but kinda nice too
	return x,y
end

function _draw()
	cls()
	
	for p in all(pt) do
		--transform:
		--world space -> camera space
		
		p.cx,p.cz=rot(p.x,p.z,t()/8)
		p.cy,p.cz=rot(p.y,p.cz,t()/7)
		
		p.cz += 2 + cos(t()/6)
	end
	
	-- sort furthest -> closest
	-- (so that things in distance
	-- aren't drawn over things
	-- in the foreground)
	
	for pass=1,4 do
	for i=1,#pt-1 do
		if pt[i].cz < pt[i+1].cz then
			--swap
			pt[i],pt[i+1]=pt[i+1],pt[i]
		end
	end
	for i=#pt-1,1,-1 do
		if pt[i].cz < pt[i+1].cz then
			--swap
			pt[i],pt[i+1]=pt[i+1],pt[i]
		end
	end
	end
	
	rad1 = 5+cos(t()/4)*4
	for p in all(pt) do
		--transform:
		--camera space -> screen space
		sx = 64 + p.cx*64/p.cz
		sy = 64 + p.cy*64/p.cz
		rad= rad1/p.cz
		-- draw
		
		if (p.cz > .1) then
			circfill(sx,sy,rad,p.col)
			circfill(sx+rad/3,sy-rad/3,rad/3,7)
		end
	end

--print(stat(1),2,2,7)
end

__gfx__
70000000777077707770077077707070070077700000777070707000777077707770000077707070777077707770777007000000077007707770077077707770
07000000777070007770700070707070700070700000707070707000707070707070000070707070007070707070707000700000700070000700707070707000
00700000707077007070700077707770700070700000707007007770707070707070000070700700777070707070707000700000700077700700707077007700
07000000707070007070700070000070700070700700707070707070707070707070070070707070700070707070707000700000700000700700707070707000
70000000707077707070077070007770070077707000777070707770777077707770700077707070777077707770777007000000077077000700770070707770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000eee00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000eee7e0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000eee777e000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000eeee7ee000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000eeefffe000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000efff7f000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000eee0000fff777f00000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000eee7e000ffff7ff00000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000eeeee000fffffff00000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000eeeee0000ff887000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000fff00000088777e0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ddd0000fff7f00008888788e000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000ddd7d00fff777f0008888888e000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000ddddd00ffff7ff0008888888f000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000ddddd00fffffffee0088999f7f00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ddd0000f888fee7e099999797f0000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000ccc000eee000088878eeee09999777ff0000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ccc7c0eee7e008887778eee999999799f0000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ccccc0eeeee0d8888788ee09999999997e000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ccccc0eeeeedd8888888ff09999999998e000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000ccc00dddc00fffe0ddd88888ff7f09999999778000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000ccc7cddd7d0fff7f0dddd999fffffe9999aaa788000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000cccccdddddfff777f0dd99979ffffe7eaaaaaaa8f00000000000000000000000000000000000000000000
000000000000000000000000000000000000000bbb0cccccdddddffff7ff0e9997779888eeeaaaaa7aff00000000000000000000000000000000000000000000
00000000000000000000000000000000000000bbbbbdddc00ddd0fffffffee99997998878eaaaaa777afe0000000000000000000000000000000000000000000
00000000000000000000000000000000000000bb7bdd7dd0eeec00fffff0ee999999987778aaaaaa7aa9e0000000000000000000000000000000000000000000
00000000000000000000000000000000000000bbbbdddddeee7ec0088800eee99999888788aaaaaaaaa790000000000000000000000000000000000000000000
0000000000000000000000000000000000bbb00bbbddddeee777e088878cceee9998888888faaaaaaa7990000000000000000000000000000000000000000000
000000000000000000000000000000000bbb7ccc000dddeeee7ee8887778cfffaaad88888ffaaaaaaa999f000000000000000000000000000000000000000000
000000000000000000000000000000000bbbccc7c00bbbeeeeeee8888788ffaaaaa7a8999ffeeaaa99998ff00000000000000000000000000000000000000000
000000000000000000000000000000000bbbccccceeebb7eeeee08888888ffaaaa77799979eee00099988ff00000000000000000000000000000000000000000
00000000000000000000000000000000bbbbcccceee7ebfffeedcc88888cfaaaaaa7aa977798ffebbbbbaff00000000000000000000000000000000000000000
0000000000000000000000000000000bbb7b0ccceeeeefff7fddcce8880ddaaaaaaaaa99799787bbbbbbbaa00000000000000000000000000000000000000000
0000000000000000000000000000000bbbbdddbbeeeefff777fdcee7eedd7aaaaaaaaa9999988bbbbb7bbbaf0000000000000000000000000000000000000000
0000000000000000000000000000000bbbddd7dbbeeeffff7ffb0e999edd88aaaaaaa9999988bbbbb777bbbaf000000000000000000000000000000000000000
00000000000000000000000000000000bbdddddfffccfffffffb099979d888aaaaaaae999888bbbbbb7bbbbaf000000000000000000000000000000000000000
000000000000000000000000000000ccc0ddddfff7fccfffffeb999777988887aaaffeeeed99bbbbbbbbbbbaf000000000000000000000000000000000000000
00000000000000000000000000000ccccc0ddfff777fccfffee099997998888888fffeaaa999bbbbbbbbbbbfff00000000000000000000000000000000000000
00000000000000000000000000000cc7cc000ffff7ff0beeeeec9999999e88888bbbcaaaa797bbbbbbbbbbb88ff0000000000000000000000000000000000000
00000000000000000000000000000cccceee0fffffff8887eeccf99999eee88bbbb7bbaa77797bbbbbbbbb9998f0000000000000000000000000000000000000
000000000000000000000000000000cceee7e0fffff888777cccff999eeeeedbbb777baaa7a999bbbbbbbaaa79f0000000000000000000000000000000000000
00000000000000000000000000000000eeeeeccfff8888878ccefffffdee99bbbbb7bbbaaaa9990bbbbbbbb777f0000000000000000000000000000000000000
000000000000000000000000000ddd00eeeee8880d8888888f0eefffddd999bbbbbbbbbaaa99999987bbbbbbba8f000000000000000000000000000000000000
00000000000000000000000000ddddd00eee8887808888888f0eaaae0d9999bbbbbbbbbaaffaaa9798bbbbb7ba88000000000000000000000000000000000000
00000000000000000000000000ddd7d00008887778e88888ffaaaaa7af99999bbbbbbb0fffaaa7a99bccccc77b98000000000000000000000000000000000000
00000000000000000000000000ddddd000088887887e888ffdaaaa777f99999bbbbbbb88faaa777a9cccc777bba9000000000000000000000000000000000000
000000000000000000000000000dddfff008888888eeccdddaaaaaa7aaf99999ebbb888bbbaaa7aacccc77777b7a800000000000000000000000000000000000
00000000000000000000000000000fff7fdd88888e999c0ddaaaaaaaaaff999ffe997bbbbb7baaaccccc77777c77a80000000000000000000000000000000000
0000000000000000000000000000fff777fd78889999999ecaaaaaaaaaeeeffff9977bbbb777aacccccc77777ccaa80000000000000000000000000000000000
0000000000000000000000000000ffff7ffddd0099999798ecaaaaaaa0beefff9999bbbbbb7bbaccccccc777cccbb90000000000000000000000000000000000
000000000000000000000000eee0fffffffddd09999977798caaaaaaaf88aaafcccccbbbbbbbbacccccccccccccbb90000000000000000000000000000000000
00000000000000000000000eee7e0fffff9990f9999997998c00aaaff88aaa7cccccccbbbbbbbaccccccccccccc7bb0000000000000000000000000000000000
00000000000000000000000eeeee00fff99979f99999999980eee00ff8aaa7cccccc7ccbbbbbbbcccccccccccccbbb9000000000000000000000000000000000
00000000000000000000000eeeee00009997779f999999980ee9990ff8aaacccccc777ccbbbbbb7cccccccccccccbb9900000000000000000000000000000000
000000000000000000000000eee000009999799f9999999d0ebbbbb0ffaaaccccccc7cccbbbbb777cccccccccccccb9900000000000000000000000000000000
0000000000000000000000000008870e9999999ffd999ff7dbbbbbbbee0aaccccccccccc99bbbb7bbcccccccccc7ccb900000000000000000000000000000000
0000000000000000000000000088777ee99999000009997fbbbbbbbbb88faccccccccccc90bbbbbbbacccccccc777ccb00000000000000000000000000000000
00000000000000000000fff008888788ee99900eee99979bbbbbbb7bbb88fcccccccccccf99bbbbbbbbaccccccc7cccb00000000000000000000000000000000
0000000000000000000fff7f08888888eee000ee7999777bbbbbb777bb9900cccccccccfccc9bbbbbb7bcccccccccccba0000000000000000000000000000000
000000000000000000fff777f88888880000888eaaa9979bbbbbbb7bbb97988cccccccccccc7c9bbb777ccccccccccc7ba000000000000000000000000000000
000000000000000000ffff7ff0888880000888aaaa7aa99bbbbbbbbbbb777988cccccacccc7779bbbb7bccccccccccc77b000000000000000000000000000000
000000000000000000fffffff0088800008887aaa777a99bbbbbbbbbbb97bbb800aaacccccc7ccbbbbbbbccccccccc7cbb000000000000000000000000000000
0000000000000000000fffff00000faaa0888aaaaa7aaaeebbbbbbbbb9bbbb7bb8888ccccccccc9bbbbbb7ccccccc777bb000000000000000000000000000000
00000000000000000000fff00000aaaaa7a88aaaaaaaaaee9bbbbbbb99bbb777b9780ccccccccccccbbbbbbccccccc7ccb000000000000000000000000000000
0000000000000000000000000000aaaa77788aaaaaaaaa8aaabbbbb99bbbbb7bbb8888cccccccccc7ccbbbbbccccccccc7b00000000000000000000000000000
000000000000000000000009990aaaaaa7aa88aaaaaaa88aaaaa7a999bbbbbbbbb8999ccccccccc777cbbbbbcccccccccbb00000000000000000000000000000
000000000000000000000099979aaaaaaaaaffaaaaaaa8aaaaa777a99bbbbbbbbbbbb790cccccccc7ccc0bbb7ccccccc7cbb0000000000000000000000000000
000000000000000088800999777aaaaaaaaaffffaaa788aaaaaa7aa999bbbbbbbbbbb799988ccccccccccbbbbccccccc77cb0000000000000000000000000000
0000000000000008887809999799aaaaaaa0fffaaa7777aaaaaaaaa99abbbbbbbbbb7779990ccccccccc7cbbbb7ccccc7ccb0000000000000000000000000000
0000000000000088877789999999aaaaaaa70faaaaa7affaaaaaaa87aaa7bbb9bbbbb7b9bbb9ccccccc777cbbbbbcccccccc0000000000000000000000000000
000000000000008888788099999880aaa97770aaaaaaaffaaaaaaa8aaa777a99bbbbbbbbbb7bcccccccc7cccbbbb0ccccc77c000000000000000000000000000
00000000000000888888800999887809999799aaaaaaaf0aaaaa088aaaa7aaaaabbbbbbbb777bbccccccccc7cbb000cccc7cc000000000000000000000000000
000000000000000888880000888777899999990aaaaa90aaaa7aaf8aaaaaaaaa77bbb7bbbb7bbb7baccccc777c0000cccccccc00000000000000000000000000
0000000000000000888000008888788999999909aaa779aaaaaaaffaaaaaaaaaa7a999bbbbbbb777b0ccccc7ccc0000ccccc77c0000000000000000000000000
0000000000000000000000008888888099999889999799aaaaaaafaaaaaaaaaaaaaaaa0bbbbbbb7bbb0ccccccc7c0000cccc7cc0000000000000000000000000
00000000000000000000000008888800099988899999990aaaaa0faaaaa0aaaaaaaaa7aabbbbbbbbb7b0ccccccccc000ccccccc0000000000000000000000000
000000000000000000000000008880000088888099999009aaa909aaaaaaaaaaaaaaaaaaaaabbbbbbbbbbccccccc7c000cccccc0000000000000000000000000
0000000000000000000000000000000000088800899980099999999aaa9aaaaaaaaaaaaaa7aabbbbbbb7bb00cccccc0000ccccc0000000000000000000000000
00000000000000000000000000000000000000008888808899909999999aaaaaaa7aaaaaaaaa7a0bbbbbbb000ccccc00000ccc00000000000000000000000000
000000000000000000000000000000000000000008880088888899999999aaaaaaaaa7aaaaaaaa000bbbbb0000ccc00000000000000000000000000000000000
0000000000000000000000000000000000000000000000888888899989999997aaaaaaaa0aaaaa0000bbb0000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000088808888888999999990aaaaa00aaa000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000008888888809999900aaa000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000888000999000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000008880000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000088878000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000088888000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000088888000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000008fff000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000fff7f00000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000fff777f0000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000ffff7ff0000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000009990000fffffff0000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000999790000fffff00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000009999900000eee008880000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000999990000eeee788878000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000009990000eeee7778888000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000008880000eeeee7e8888000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000088878000eeeeeee8880000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000aaa000888880000eeeee00fff000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000aaa7a008888800999eee00fff7f00000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000aaaaa0008880099979ddd0fffff88800000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000aaaaa000fff00999dddd7ddffff88880000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000aaa000fff7f0999ddd777dfff887880000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000aaa00999000fff777f09ddddd7dddeee88880000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000aaa7a9997900ffff7ff08dddddddddee7e8800000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000aaaaa9999900fffffff88ddddddddde777e000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000aaaaa9999900afffff0888dddddddeee7eeff0000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000aaa00999000aafff00888dddddddeeeeeef7f800000000000000000000000000000000000000000000
00000000000000000000000000000000000000000bbb09990000000000aaa00008880ddd99eeeeeffff780000000000000000000000000000000000000000000
0000000000000000000000000000000000000000bbb7999990888aaa00eee000000009ccc90eeefffff880000000000000000000000000000000000000000000
0000000000000000000000000000000000000000bbbb99979888787aaeee7e00aaffccccccc0000fff8880000000000000000000000000000000000000000000
0000000000000000000000000000000000000000bbbb9999988888aaeee777eaafffccccc7c9ddd7088800000000000000000000000000000000000000000000
0000000000000000000000000000000000000ccc0bbb0999088888aaeeee7eeaaffccccc777cdd777eefff880000000000000000000000000000000000000000
000000000000000000000000000000000000ccccaaa0000bbb888aaaeeeeeeeaaffcccccc7ccddd7de7ef7f88000000000000000000000000000000000000000
000000000000000000000000000000000000cc7aaa7a00bbbbb099900eeeee00aafcccccccccdddddeeefff88000000000000000000000000000000000000000
000000000000000000000000000000000000cccaaaaa888bbfff999900eee0009990cccccccddddddeeefff88000000000000000000000000000000000000000
0000000000000000000000000000000000000ccaaaa88878fff7f979008880099999cccccccdddddeeefff880000000000000000000000000000000000000000
00000000000000000000000000000000007bbb00aaa8888fff777f9908ddd80997eeeacccf88ddd9700000fff000000000000000000000000000000000000000
000000000000000000000000000000000cbbbbb00008888ffff7ff90ddddddd99eee7efff7f8878990dddeef7f00000000000000000000000000000000000000
0000000000000000000000000000000000bbb799900c888fffffff70dddd7dd0eee777effff888890ddd7d7eff80000000000000000000000000000000000000
0000000000000000000000000000000000bbb9997900c0aafffff8bdddd777ddeeee7eeffff888cccdd777deff00000000000000000000000000000000000000
0000000000000000000000000000000bbb0bb999990000aaafff878ddddd7dddeeeeeebbbbb00ccc7cdd7ddef000000000000000000000000000000000000000
000000000000000000000000000000bbb7b0099999fff00aaa88888ddddddddd8eeeebbbbbbbccc777cdddd00fff700000000000000000000000000000000000
000000000000000000000000000000bbbaaa00999fff7f00cc888880ddddddd888eebbbbbb7bbccc7ccddd00eee7f00000000000000000000000000000000000
000000000000000000000000000000bbaaaaa0000fffff990c088870ddddddd8888bbbbbb777bbcccccdd90eee7ef00000000000000000000000000000000000
0000000000000000000000000000000baaa7a0000fffff97ee70aaa0ffddd009888bbbbbbb7bbbcccc0097dddeeef00000000000000000000000000000000000
00000000000000000000000000000000aaaa888700fff99ee7770ac7fffff00790dbbbbbbbbbbbccc0087ddd7dee000000000000000000000000000000000000
00000000000000000000000000000aaa0aa88878b00099eeee7ee0c08fff80bbbddbbbbbbbbbbb0afff8cccdddeeee0000000000000000000000000000000000
0000000000000000000000000000aaa7a0088888aaa009eeeeeeef908888800bdddbbbbbbbbbbbafff7ccc7cddeeeee000000000000000000000000000000000
0000000000000000000000000000aaaaa0088888aa7ab0eeeeeeef990ccc000fddddbbbbbbbbbeeeffccc777c0eee7e000000000000000000000000000000000
0000000000000000000000000000aaa99900888aee7ab70eeeeeff9ccccccc8fdddddbbbbbbbeee7efcccc7cc0dddee000000000000000000000000000000000
00000000000000000000000000000a999790aaaee7778880eeeff99cccc7cc8ffdddddbbbbb7eeeebbbccccccddd7d0000000000000000000000000000000000
00000000000000000000000000000099999aaaeeee7ee878ab0099cccc777cc8ffdddb998dddeebbbbb7bccc0ddddde700000000000000000000000000000000
00000000000000000000000000999099999aaaeeeeeee8887a7000ccccc7ccc888a08fffddd7debbbb777cc00cccddee00000000000000000000000000000000
00000000000000000000000009999909990aaaeeeeeee888ab0000ccccccccc0caa8fffddd777bbbbbb7bb00ccc7cddd00000000000000000000000000000000
000000000000000000000000099979000fffaa9eeeee88ddd00888bccccccc000ca0fffdddd7dbbbbbbbbb0ccc777cd7d0000000000000000000000000000000
00000000000000000000000009999900fff7f099eeeaddddddde878ccccccc7feee0fffddddddbbbbbbbbbfcccc7ccddd0000000000000000000000000000000
00000000000000000000000000999000fffff099999adddd7dd7e8800ccc0bfeee7cccffdddddfbbbbbbbeecccccccdddd000000000000000000000000000000
00000000000000000000000000008880fffff909990dddd777dde880088800feeeccc7c0bbbbbdbbbbbbbe7bbbcccccdddd00000000000000000000000000000
000000000000000000000000000888780fff9900000ddddd7ddde800887880feeccc777bbbb777ddbbb0eebbb7bccc7cd7d00000000000000000000000000000
0000000000000000000000000008888809999ddd00fddddddddd0a00eee88bafecccc7bbbb77777ddd00ebbb777bccccddd00000000000000000000000000000
000000000000000000000000888888880099dddd70ffddddddd09a7eddde8a7a0ccccbbbbb77777bdf0ddbbbb7bbccccdd000000000000000000000000000000
00000000000000000000000887888880000dddd777ffdddddddff70ddd7d0b8700ccbbbbbb77777bbfdddbbbbbbbcccccc000000000000000000000000000000
00000000000000000000000888880000000ddddd7d9fffdddfff7fddd777d88eee7cbbbbbbb777bbb0ddddbbbbbbbbccc7c00000000000000000000000000000
0000000000000000000000088888000eee8ddddddd000009dddfffdbbbbbdaee7ee8bbbbbbbbbbbbbfdddddbbbbbb7bcccc00000000000000000000000000000
000000000000000000000000888000eee7e8ddddd000888ddd7dffbbbbbbbaeeddd7bbbbbbbbbbbbb0bbbbbd7bbb777bccccc000000000000000000000000000
00000000000000000000000000000eee777e0ddd000888ddd777dbbbbbbbbbeddd7dbbbbbbbbbbbbbbbbbbbbdbbbb7bbccc7cc00000000000000000000000000
00000000000000000000000000000eeee7ee0000888888dddd7dbbbbbbb7bbbdd777dbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccc00000000000000000000000000
0000000000000000000000000fff0eeeeeee00088eee88ddddddbbbbbb777bbddd7ddebbbbbbbbbbbbbbbb7bbbbbbbbbb7bccc00000000000000000000000000
000000000000000000000000fff7f0eeeee00008eee7e88dddddbbbbbbb7bbbddddddedbbbbbbbcbbbbbb777bbdbbbbbbbbcc000000000000000000000000000
00000000000000000000fff0fffff00eee0fff08eeeccc07ddd8bbbbbbbbbbbddddbbbddbbbbb0cbbbbbbb7bbbddd0bbbbbbb000000000000000000000000000
0000000000000000000fff7ffffff00000fffff0eccccc7c8eeebbbbbbbbbbbddbbbbbbbddee070bbbbbbbbbbbbbb00bbbbb7b00000000000000000000000000
0000000000000000000fffff0fff00fff0fff7f00cccc777eee7ebbbbbbbbbdddbbbbb7bdde0dddbbbbbbbbbbbbbbbb00bbbbb00000000000000000000000000
0000000000000000000fffff00000fffffcccff0cccccc7cceeee8bbbbbbb8ddbbbbb777b00dd7ddbbbbbbbbbbbb7bb00bbbbbb0000000000000000000000000
00000000000000000000fff000000fffccccc7cfccccccccceeee00bbbbb00ddbbbbbb7bb00ddddddbbbbbbbbbb777bb00bbbb7b000000000000000000000000
00000000000000000000000000000fffcccc777fccccccccceeef0cccc7e0eedbbbbbbbbbdddbbbdddbbbbbbbbbb7bbbbb0bbbbb000000000000000000000000
000000000000000000000000000dddfcccccc7cc7ccccccccfff7cccc777eee7ebbbbbbbdddbbb7bdddddd0bbbbbbbbbb7bbbbbb000000000000000000000000
00000000000000000000000000ddd7dcccccccccfccccccc7cfffccccc7ceeeecbbbbbbbddbbb777bdbbb7d0bbbbbbbb777bbbb0000000000000000000000000
000000000000000000000eee0ddd777cccccccccdd0cccc777cffccccccceeeccccbbbddddbbbb7bbbbb7bd0bbbbbbbbb7bbb000000000000000000000000000
00000000000000000000eee7edddd7ddcccccccdd7d0cccc7ccff0cccccf0ecccc777e0cccbbbbbbbbb777bbb0bbbbbbbbbb7b00000000000000000000000000
0000000000000000000eee777dddddddcccccccd777dcccccccff0ccccc0ffccccc7ceccc7cbbbbbbbbb7bbb7b0000bbbbb777b0000000000000000000000000
0000000000000000eeeeeee7eeddddd0eecccdddd7dd0cccccdf0ccc777c0fcccccccccc777cbbb0bbbbbbb777b0000bbbbb7bbb000000000000000000000000
000000000000000eee7eeeeeee0ddd0eee7e0ddddddd00cccd7d0cccc7ccffcccccc0cccc7cc0ccc0bbbbbbb7bbbb000bbbbbbb7bb0000000000000000000000
000000000000000eeeeeeeeee0eee7eeeeeeeeddddd7e00ddddd0ccccccc0fccccc0ccccccccccc7ccbbbbbbbbbb7bbb0bbbbbbbb7b000000000000000000000
000000000000000eeeee0eee00eeeeeeeeeeeeedddeeee0ddddd00ccccc00dccccccccccccccccccccc7cbbbbbbbbbbbb0bbbbbbbbb000000000000000000000
0000000000000000eee0000000eeeee0eeeeee7eeeeeeee0ddd7e0dcccd0dddcccdcccccccc7ccccccccccbbbbbbbbb7b0000bbbbbb000000000000000000000
000000000000000000000000000eee00000eeeee0eeee7e0eeeeeeddddd0dddddddcccccccccccccccccccccc0bbbbbbb000000bbb0000000000000000000000
000000000000000000000000000000000000eee000eeeee0eeeeeeedddeeddddddddcccdccccccccccccccccc0000bbb00000000000000000000000000000000
0000000000000000000000000000000000000000000eee000eeeeeeeeeeeeddd0ddddddddcccccccc0000ccc0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000eee00eee0eeeee00ddd0ddddd00ccc000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000eee00000000ddd000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

