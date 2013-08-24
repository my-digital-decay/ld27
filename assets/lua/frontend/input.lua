--------------------------------------------------------------------------------
--- frontend/input.lua
--- author: keith w. thompson

function Frontend.onKeyboardEvent ( key, down )

  local KEY_BACK = 257 --- [esc]
  local KEY_SELECT = 13 --- [return]
  local KEY_SPACE = 32 --- [space]

---[[
  if true == down then
    printf ( "[FE] key: %d [down]\n", key)
  else
    printf ( "[FE] key: %d [up]\n", key)
  end
--]]

  if true == down then
    if KEY_BACK == key then
      printf ( "Frontend.state = STATE_QUIT\n")
      Frontend.state_new = Frontend.STATE_QUIT
    end

    if KEY_SELECT == key or KEY_SPACE == key then
      printf ( "Frontend.state = STATE_LOAD_BACKEND\n")
      Frontend.state_new = Frontend.STATE_LOAD_BACKEND
    end
  end

end

if nil ~= MOAIInputMgr.device.keyboard then
  printf ("[FE] keyboard event handler registered\n")
  MOAIInputMgr.device.keyboard:setCallback ( Frontend.onKeyboardEvent )
end

