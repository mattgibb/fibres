-- Lua script.
p=tetview:new()
p:load_mesh("vesselwrapping_zeroalpha_001.1")
rnd=glvCreate(0, 0, 500, 500, "TetView")
p:plot(rnd)
glvWait()
