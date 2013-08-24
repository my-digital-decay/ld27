--------------------------------------------------------------------------------
--- main.lua
--- author: keith w. thompson

_CODE = "assets/lua"
_IMAGES = "assets/images"
_FONTS = "assets/fonts"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
--SCREEN_WIDTH = 1920
--SCREEN_HEIGHT = 1080

MOAISim.openWindow ( "ld27", SCREEN_WIDTH, SCREEN_HEIGHT )

viewport = MOAIViewport.new ()
viewport:setSize ( SCREEN_WIDTH, SCREEN_HEIGHT )
viewport:setScale ( SCREEN_WIDTH, -SCREEN_HEIGHT )

require ( _CODE .. "/utils" )
require ( _CODE .. "/splash" )
require ( _CODE .. "/transition" )
require ( _CODE .. "/frontend/title" )

printf ("=== ld27 ===\n")

Main = {}
Main.state = 0
Main.state_new = 0
Main.font = {}

GAME_STATE_QUIT = 1
GAME_STATE_FRONTEND = 2
GAME_STATE_BACKEND = 3

function Main.loop ()

  ---
  --- Font
  ---

  Main.font = MOAIFont.new ()
  Main.font:loadFromBMFont ( _FONTS .. '/PG_32.fnt' )

  ---
  --- Main loop
  ---

  Main.framebuffer = MOAIGfxDevice.getFrameBuffer ()

  do
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

    layers[LAYER_BG]:setClearColor ( 0.0, 0.0, 0.0, 1.0 )
    --layers[LAYER_BG]:setClearDepth ( true )

--[[
    splashScreen ( layers[LAYER_TOP] )
--]]
--[[
    layers[LAYER_BG]:setClearColor ( 0.2, 0.2, 0.2, 1.0 )
    titleScreen ( layers[LAYER_MAIN] )
    do
      local transition = makeTransition( TRANSITION_FADE_OUT )
      transition:setColor ( 0,0,0,1 )
      transition:start ( layers[LAYER_TOP], 0.8 )
    end
--]]
  end
--  layers[LAYER_MAIN]:clear ()

  Main.state = GAME_STATE_FRONTEND
  Main.state_new = Main.state
  dofile ( _CODE .. "/frontend/main.lua" )

  ---
  --- Game Loop
  ---
  local done = false
  while not done do
    coroutine.yield ()

--    printf ("mainThread:main - %d\n", Main.state)
    if Main.state_new ~= Main.state then
--      printf (" Main.state change %d --> %d\n", Main.state, Main.state_new)
      if GAME_STATE_FRONTEND == Main.state_new then
        dofile ( _CODE .. "/frontend/main.lua" )
      elseif GAME_STATE_BACKEND == Main.state_new then
        dofile ( _CODE .. "/backend/main.lua" )
      elseif GAME_STATE_QUIT == Main.state_new then
        done = true
      end
      Main.state = Main.state_new
    end
  end

--  MOAILogMgr.openFile "ld27.log"
--  MOAISim.reportLeaks ()
--  MOAILogMgr.closeFile ""

  printf ("=== bye ===\n")
  os.exit ()

end

printf ("  main thread\n")
Main.thread = MOAIThread.new ()
Main.thread:run ( Main.loop )

printf ("  *end main.lua\n")

