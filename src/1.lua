-- functions

function wait(n)
  for i=1,n do yield() end
end

function co(fn)
  return {
    fn=fn,
    co=cocreate(fn),
    resume=function(self)
      if (costatus(self.co)=="dead") return
      local act,ex=coresume(self.co)
      if ex then
        cls()
        color(7)
        stop(trace(self.co,ex))
      end
    end,
    reset=function(self)
      self.co=cocreate(self.fn)
    end,
  }
end

function show(screen)
  if (screen.init) screen.init()
  _update=screen.update
  _draw=screen.draw
end

function new_object(en,x,y)
  local ob={en=en,x=x,y=y,si=0}
  ob.an=entities[en]
  ob.co=co(animate(ob))
  return ob
end

function add_mapob(en,x,y)
  local ob=new_object(en,x,y)
  state[ob.y*16+ob.x]=ob
  add(objects,ob)
  if en==1 then
    exit=ob
  elseif en==2 then
    player=ob
    player.dir=1
    add(train,player)
  else
    items+=1
  end
end

function move_object(ob,x,y)
  if ob.x and ob.y then
    state[ob.y*16+ob.x]=nil
  end
  state[y*16+x]=ob
  ob.x=x
  ob.y=y
end

function del_object(ob)
  state[ob.y*16+ob.x]=nil
  del(objects,ob)
end

function animate(ob)
  return function()
    while true do
      local ran=animations[ob.an]
      local an=get_animation(ob)
      wait(ran.fr or 3)
      ob.si+=1
      if ob.si>an[2]-an[1] then
        ob.si=0
        if (ran.nxt) ob.an=ran.nxt
      end
    end
  end
end

function get_animation(ob)
  local	an=animations[ob.an]
  if (not ob.dir) return an
  if (type(an[1])=="number") return an
  if (ob.dir<2) return an[1]
  return an[2]
end

function reset_map()
  items=0
  objects={}
  state={}
  train={}
  inputs={}
  player=nil
  exit=nil
  crashed=false
end

function load_map()
  reset_map()
  local bx,by=lvcoord()
  for y=0,15 do
    for x=0,15 do
      local sp=mget(bx+x,by+y)
      local en=band(fget(sp),0x3f)
      if (en>0) add_mapob(en,x,y)
    end
  end
end

function draw_map()
  local x,y=lvcoord()
  map(x,y,0,0,16,16,0x80)
end

function rsm_objects()
  for ob in all(objects) do
    ob.co:resume()
  end
end

function draw_objects()
  for ob in all(objects) do
    draw_object(ob)
  end
  draw_object(player)
end

function draw_object(ob)
  local ran=animations[ob.an]
  local an=get_animation(ob)
  local sp=an[1]+ob.si
  local dir=ob.dir
  if (type(ran[1])=="number") dir=nil
  if dir==0 then
    spr(sp,ob.x*8-1,ob.y*8,1,1,true)
  elseif dir==2 then
    spr(sp,ob.x*8-1,ob.y*8-1,1,1,true,true)
 else
    spr(sp,ob.x*8,ob.y*8)
  end
end

function lvcoord()
  return lvl%8*16,lvl\8*16
end

function inrng(n,a,b)
  return n>=a and n<=b
end

function anybtnp()
  for i=0,5 do
    if (btnp(i)) return true
  end
  return false
end

function set_lvl(n)
  lvl=n
  load_map()
  game:reset()
end

function reload_lvl()
  set_lvl(lvl)
end

function next_lvl()
  set_lvl(lvl+1)
end

function reset_lvl()
  set_lvl(0)
end