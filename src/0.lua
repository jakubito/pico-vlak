-- disable btnp repeat
poke(0x5f5c,255)

defspeed=10
hispeed=5
speed=defspeed
lvl=0
maxlvl=3
items=0
objects={}
state={}
train={}
inputs={}
player=nil
exit=nil
crashed=false

animations={
  {2,2},
  {3,4,fr=4,nxt=3},
  {4,4},
  {{5,8},{9,12}},
  {{16,21},{22,27},nxt=6},
  {28,31,fr=4},
  {32,35},
  {36,39},
  {40,43},
  {44,47},
  {{48,49},{50,51},fr=6},
  {{52,53},{54,55},fr=6},
  {{56,57},{58,59},fr=6},
  {{60,61},{62,63},fr=6},
}

entities={1,4,7,8,9,10,11,12,13,14}
cars_map={[3]=7,[4]=8,[5]=9,[6]=10}

function _init()
  show(title_screen)
end