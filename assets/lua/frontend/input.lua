--------------------------------------------------------------------------------
--- frontend/input.lua
--- author: keith w. thompson

--------------------------------------------------------------------------------
---
--- Keyboard
---

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
---
--- Mouse
---

--------------------------------------------------------------------------------
function Frontend.onPointerEvent ( x, y )

---[[
  printf ( "[FE] pointer: %d, %d\n", x, y )
--]]

  local oldX = Frontend.pointerX
  local oldY = Frontend.pointerY

  local wx, wy = Frontend.pickLayer:wndToWorld ( x, y )
  printf ( "[FE] pointer (world): %0.2f, %0.2f\n", wx, wy )

  Frontend.pointerX = wx
  Frontend.pointerY = wy

  if Frontend.pick then
    Frontend.pick:addLoc ( wx - oldX, wy - oldY )
  end

end

if nil ~= MOAIInputMgr.device.pointer then
  printf ("[FE] pointer event handler registered\n")
  MOAIInputMgr.device.pointer:setCallback ( Frontend.onPointerEvent )
end

--------------------------------------------------------------------------------
function Frontend.onMouseLeftEvent ( down )

---[[
  if true == down then
    printf ( "[FE] mouse left: [down]\n" )
  else
    printf ( "[FE] mouse left: [up]\n" )
  end
--]]

  if true == down then
    printf ( "Frontend.state = STATE_LOAD_BACKEND\n")
    Frontend.state_new = Frontend.STATE_LOAD_BACKEND
  end

end

if nil ~= MOAIInputMgr.device.mouseLeft then
  printf ("[FE] mouse left event handler registered\n")
  MOAIInputMgr.device.mouseLeft:setCallback ( Frontend.onMouseLeftEvent )
end

--------------------------------------------------------------------------------
function Frontend.onMouseRightEvent ( down )

---[[
  if true == down then
    printf ( "[FE] mouse right: [down]\n" )
  else
    printf ( "[FE] mouse right: [up]\n" )
  end
--]]

  if true == down then
    partition = Frontend.pickLayer:getPartition ()
    if nil ~= partition then
      Frontend.pick = partition:propForPoint ( Frontend.pointerX, Frontend.pointerY )

      if Frontend.pick then
        print ( Frontend.pick.name )
      end
    end
  else
    if Frontend.pick then
      Frontend.pick = nil
    end
  end

end

if nil ~= MOAIInputMgr.device.mouseRight then
  printf ("[FE] mouse right event handler registered\n")
  MOAIInputMgr.device.mouseRight:setCallback ( Frontend.onMouseRightEvent )
end

