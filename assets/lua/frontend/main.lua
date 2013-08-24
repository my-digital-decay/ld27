--------------------------------------------------------------------------------
--- frontend/main.lua
--- author: keith w. thompson

require ( _CODE .. "/utils" )
require ( _CODE .. "/transition" )
require ( _CODE .. "/frontend/title" )

Frontend = {}
Frontend.state = 0

function Frontend.main ()

  dofile ( _CODE .. "/frontend/input.lua" )

  ---
  --- States
  ---
  Frontend.STATE_QUIT = 1
  Frontend.STATE_TITLE = 2
  Frontend.STATE_LOAD_BACKEND = 3

  ---
  --- Layers
  ---
  local LAYER_BG = 1
  local LAYER_MAIN = 2
  local LAYER_TOP = 3

  local layers = {}
  for i = 1, LAYER_TOP do
    local lr = MOAILayer2D.new ()
    lr:setViewport ( viewport )
    layers[i] = lr
  end
  Main.framebuffer:setRenderTable ( layers )

  layers[LAYER_BG]:setClearColor ( 0.2, 0.2, 0.2, 1.0 )
  titleScreen ( layers[LAYER_MAIN] )

  Frontend.state = Frontend.STATE_TITLE
  Frontend.state_new = Frontend.state

  ---
  --- Game Loop
  ---
  local done = false
  while not done do
    coroutine.yield ()

--    printf ("Frontend.thread:main - %d\n", Frontend.state)
    if Frontend.state_new ~= Frontend.state then
--      printf ("state change %d --> %d\n", game_state, game_state_new)
      if Frontend.STATE_LOAD_BACKEND == Frontend.state_new then
        Main.state_new = GAME_STATE_BACKEND
        done = true
      elseif Frontend.STATE_QUIT == Frontend.state_new then
        Main.state_new = GAME_STATE_QUIT
        done = true
      end
      Frontend.state = Frontend.state_new
    end
  end

  layers[LAYER_MAIN]:clear ()
  Main.framebuffer:setRenderTable ( nil )

  MOAISim.forceGarbageCollection ()

  printf ("  exit Frontend.thread\n")
end

printf ("  frontend thread\n")
Frontend.thread = MOAIThread.new ()
Frontend.thread:run ( Frontend.main )

printf ("  *end Frontend.main.lua\n")

