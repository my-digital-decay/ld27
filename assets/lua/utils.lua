--------------------------------------------------------------------------------
--- utils.lua
--- author: keith w. thompson

function printf ( ... )
--  return io.stdout:write ( string.format (...) )
  return MOAILogMgr.log ( string.format (...) )
end

function lerp (a, b, t)
  return a + (b - a) * t
end
