-- title screen

botcmd={
	10,⬆️,6,⬅️,13,⬇️,4,➡️,12,⬆️,
	3,⬅️,10,⬇️,1,➡️,9,⬇️,1,⬅️,
	12,⬇️,10,➡️,7,⬇️
}

title_screen={
	init=function()
		speed=defspeed
		reset_lvl()
		bot:reset()
		title:reset()
	end,
	update=function()
		if anybtnp() then
			next_lvl()
			show(game_screen)
		else
			bot:resume()
			title:resume()
		end
		rsm_objects()
	end,
	draw=function()
		cls()
		draw_map()
		draw_objects()
		print_title()
		print_controls()
	end,
}

title=co(function()
	wait(15)
	while true do
		local x,y=move()
		wait(speed)
		if isgate(x,y) then
			reset_lvl()
			bot:reset()
			title:reset()
			yield()
		end
	end
end)

bot=co(function()
	wait(14)
	for i=1,#botcmd,2 do
		wait(botcmd[i]*speed)
		add(inputs,botcmd[i+1])
	end
end)

function print_title()
	local x,y=46,64
	print("pico",x,y,14)
	x=66
	print("v",x,y,12)
	print("l",x+4,y,8)
	print("a",x+8,y,11)
	print("k",x+12,y,10)
	color(13)
	print("(𝘤) jakubito 2023",30,99)
	print("og vlak by m.nemecek 1993",14,106)
end

function print_controls()
	local x,y=20,78
	color(7)
	print("⬅️➡️⬆️⬇️ control train",x,y)
	print("❎ change speed",x+24,y+7)
end