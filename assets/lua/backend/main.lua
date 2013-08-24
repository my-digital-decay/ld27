--------------------------------------------------------------------------------
--- backend/main.lua
--- author: keith w. thompson

require ( _CODE .. "/utils" )

Backend = {}
Backend.state = 0

--
function Backend.main ()

  dofile ( _CODE .. "/backend/input.lua" )

  ---
  --- States
  ---
  Backend.STATE_PAUSE = 1
  Backend.STATE_LEVEL_START = 2
  Backend.STATE_LEVEL_ACTIVE = 3
  Backend.STATE_LEVEL_END = 4
  Backend.STATE_LOAD_FRONTEND = 5

--  Backend.level_index = 1
--  Backend.load_level ( Backend.level_files[Backend.level_index] )
--  Backend.level:start ()

  Backend.state = Backend.STATE_LEVEL_ACTIVE
  Backend.state_new = Backend.state

  ---
  --- Game Loop
  ---
  local done = false
  while not done do
    coroutine.yield ()

--    printf ("Backend.thread:main - %d\n", Backend.state)
    if Backend.state_new ~= Backend.state then
--      printf ("state change %d --> %d\n", game_state, game_state_new)
      if Backend.STATE_LOAD_FRONTEND == Backend.state_new then
        Main.state_new = GAME_STATE_FRONTEND
        done = true
      elseif Backend.STATE_LEVEL_START == Backend.state_new then
--        Backend.load_level ( Backend.level_files[Backend.level_index] )
--        Backend.level:start ()
      elseif Backend.STATE_LEVEL_END == Backend.state_new then
--        Backend.level:stop ()
--        Backend.level = {}

--        Backend.level_index = Backend.level_index + 1 -- next level
--        if ( nil == Backend.level_files[Backend.level_index] ) then
--          Backend.level_index = 1
--        end
      end

      Backend.state = Backend.state_new

      if Backend.STATE_LEVEL_START == Backend.state then
        Backend.state_new = Backend.STATE_LEVEL_ACTIVE
      elseif Backend.STATE_LEVEL_END == Backend.state then
        Backend.state_new = Backend.STATE_LEVEL_START
      end
    end
  end

  Main.framebuffer:setRenderTable ( nil )

  MOAISim.forceGarbageCollection ()

  printf ("  exit Backend.thread\n")

end

printf ("  backend thread\n")
Backend.thread = MOAIThread.new ()
Backend.thread:run ( Backend.main )

printf ("  *end Backend.main.lua\n")

