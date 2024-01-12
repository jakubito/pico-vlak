-- loading screen

loading_screen={
  init=function()
    rows=0
    show_lvl=false
    show_thx=false
    finished=false
    loading:reset()
  end,
  update=function()
    if finished and anybtnp() then
      show(title_screen)
    else
      loading:resume()
      rsm_objects()
    end
  end,
  draw=function()
    cls()
    draw_map()
    draw_objects()
    draw_rows()
    if show_thx then
      print_thx()
    elseif show_lvl and rows>7 then
      print_lvl()
    end
  end,
}

loading=co(function()
  fill()
  if lvl+1>maxlvl then
    game_finished()
  else
    load_next()
  end
end)

function game_finished()
  show_thx=true
  wait(15)
  finished=true
end

function load_next()
  next_lvl()
  speed=defspeed
  show_lvl=true
  wait(30)
  unfill()
  show(game_screen)
end

function fill()
  for n=0,15 do
    rows=n
    wait(2)
  end
end

function unfill()
  for n=15,0,-1 do
    rows=n
    wait(2)
  end
end

function draw_rows()
  for y=0,rows do
    for x=0,15 do
      spr(1,x*8,y*8)
    end
  end
end

function print_thx()
  local x0,y0,x1,y1=48,56,78,64
  rectfill(x0+1,y0+1,x1+1,y1+1,2)
  rectfill(x0,y0,x1,y1,0)
  print("the end",x0+2,y0+2,7)
  x0,y0,x1,y1=23,68,104,76
  rectfill(x0+1,y0+1,x1+1,y1+1,2)
  rectfill(x0,y0,x1,y1,0)
  print("thanks for playing♥",x0+2,y0+2,14)
end

function print_lvl()
  local x0,y0,x1,y1=48,59,78,67
  if lvl>=10 then
    x0-=2
    x1+=2
  end
  rectfill(x0+1,y0+1,x1+1,y1+1,2)
  rectfill(x0,y0,x1,y1,0)
  print("level",x0+2,y0+2,7)
  print(lvl,x0+26,y0+2,14)
end