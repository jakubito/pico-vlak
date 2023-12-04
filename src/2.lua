-- game screen

game_screen={
	update=function()
		if not crashed then
			set_speed()
			poll_input()
			game:resume()
		elseif anybtnp() then
			reload_lvl()
		end
		rsm_objects()
	end,
	draw=function()
		cls()
		draw_map()
		draw_objects()
	end,
}

game=co(function()
	wait(30)
	while true do
		local x,y=move()
		if (isgate(x,y)) lvcomplete()
		wait(speed)
	end
end)

function set_speed()
	if btnp(5) then
		if speed==hispeed then
			speed=defspeed
		else
			speed=hispeed
		end
	end
end

function poll_input()
	for i=0,3 do
		if btnp(i) then
			add(inputs,i)
			break
		end
	end
end

function move()
	local dir=next_dir()
	local x,y=next_pos(dir)
	if iscol(x,y) then
		crash()
	else
		if (isitem(x,y)) collect(x,y)
		move_train(x,y,dir)
	end
	return x,y
end

function next_dir()
	while #inputs>0 do
		local i=deli(inputs,1)
		if (player.dir!=i) return i
	end
	return player.dir
end

function next_pos(dir)
	local x,y=player.x,player.y
	if dir==0 then
		x-=1
	elseif dir==1 then
		x+=1
	elseif dir==2 then
		y-=1
	elseif dir==3 then
		y+=1
	end
	return x,y
end

function collect(x,y)
	local item=state[y*16+x]
	local en=cars_map[item.en]
	local car=new_object(en)
	del_object(item)
	add(objects,car)
	add(train,car)
	items-=1
	if (items==0) exit.an=2
end

function move_train(x,y,dir)
	local nxt={x=x,y=y,dir=dir}
	local prev
	for ob in all(train) do
		prev={x=ob.x,y=ob.y,dir=ob.dir}
		if (#train==2) prev.dir=nxt.dir
		move_object(ob,nxt.x,nxt.y)
		ob.dir=nxt.dir
		nxt=prev
	end
end

function crash()
	player.an=5
	player.si=0
	wait(30)
	crashed=true
end

function lvcomplete()
	wait(2)
	show(loading_screen)	
end

function iscol(x,y)
	return iscar(x,y)
		or isclosed(x,y)
		or iswall(x,y)
end

function isitem(x,y)
	local ob=state[y*16+x]
	return ob and inrng(ob.en,3,6)
end

function iscar(x,y)
	local ob=state[y*16+x]
	return ob and inrng(ob.en,7,10)
end

function isflag(x,y,f)
	local bx,by=lvcoord()
	return fget(mget(bx+x,by+y),f)
end

function iswall(x,y)
	return isflag(x,y,7)
end

function isgate(x,y)
	return isflag(x,y,6)
end

function isclosed(x,y)
	return isgate(x,y) and items>0
end