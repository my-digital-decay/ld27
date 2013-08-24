--------------------------------------------------------------------------------
--- backend/input.lua
--- author: keith w. thompson

function Backend.onKeyboardEvent ( key, down )

  local KEY_BACK = 257 --- [esc]
  local KEY_SELECT = 13 --- [return]
  local KEY_SPACE = 32 --- [space]

---[[
  if true == down then
    printf ( "[BE] key: %d [down]\n", key)
  else
    printf ( "[BE] key: %d [up]\n", key)
  end
--]]

  if true == down then
    if KEY_BACK == key then
      Backend.state_new = Backend.STATE_LOAD_FRONTEND
    end
  end

end

if nil ~= MOAIInputMgr.device.keyboard then
  printf ("[BE] keyboard event handler registered\n")
  MOAIInputMgr.device.keyboard:setCallback ( Backend.onKeyboardEvent )
end

