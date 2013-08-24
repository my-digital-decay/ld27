--------------------------------------------------------------------------------
--- backend/input.lua
--- author: keith w. thompson

--------------------------------------------------------------------------------
---
--- Keyboard
---

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
---
--- Mouse
---

--------------------------------------------------------------------------------
function Backend.onPointerEvent ( x, y )

---[[
  printf ( "[BE] pointer: %d, %d\n", x, y )
--]]

  local oldX = Backend.pointerX
  local oldY = Backend.pointerY

  local wx, wy = Backend.pickLayer:wndToWorld ( x, y )
  printf ( "[BE] pointer (world): %0.2f, %0.2f\n", wx, wy )

  Backend.pointerX = wx
  Backend.pointerY = wy

  if Backend.pick then
    Backend.pick:addLoc ( wx - oldX, wy - oldY )
  end

end

if nil ~= MOAIInputMgr.device.pointer then
  printf ("[BE] pointer event handler registered\n")
  MOAIInputMgr.device.pointer:setCallback ( Backend.onPointerEvent )
end

--------------------------------------------------------------------------------
function Backend.onMouseLeftEvent ( down )

---[[
  if true == down then
    printf ( "[BE] mouse left: [down]\n" )
  else
    printf ( "[BE] mouse left: [up]\n" )
  end
--]]

  if true == down then
    partition = Backend.pickLayer:getPartition ()
    if nil ~= partition then
      Backend.pick = partition:propForPoint ( Backend.pointerX, Backend.pointerY )

      if Backend.pick then
        print ( Backend.pick.name )
      end
    end
  else
    if Backend.pick then
      Backend.pick = nil
    end
  end

end

if nil ~= MOAIInputMgr.device.mouseLeft then
  printf ("[BE] mouse left event handler registered\n")
  MOAIInputMgr.device.mouseLeft:setCallback ( Backend.onMouseLeftEvent )
end

--------------------------------------------------------------------------------
function Backend.onMouseRightEvent ( down )

---[[
  if true == down then
    printf ( "[BE] mouse right: [down]\n" )
  else
    printf ( "[BE] mouse right: [up]\n" )
  end
--]]

end

if nil ~= MOAIInputMgr.device.mouseRight then
  printf ("[BE] mouse right event handler registered\n")
  MOAIInputMgr.device.mouseRight:setCallback ( Backend.onMouseRightEvent )
end

