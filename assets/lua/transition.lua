--------------------------------------------------------------------------------
--- transition.lua
--- author: keith w. thompson

TRANSITION_FADE_IN = 0
TRANSITION_FADE_OUT = 1

function makeTransition ( kind, prop )

  local transition = {}

  if nil == prop then
    transition.deck = MOAIGfxQuad2D.new ()
    transition.deck:setTexture ( _IMAGES .. "/white.png" )
    transition.deck:setRect ( -SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH/2, -SCREEN_HEIGHT/2 )

    transition.prop = MOAIProp2D.new ()
    transition.prop:setDeck ( transition.deck )
    transition.prop:setLoc ( 0, 0 )
  else
    transition.prop = prop
  end

  transition.kind = kind

  function transition:setColor ( r, g, b, a )
    self.prop:setColor ( r, g, b, a )
  end

  function transition:start ( layer, length )
    local curve = MOAIAnimCurve.new ()
    curve:reserveKeys ( 2 )

    if TRANSITION_FADE_IN == transition.kind then
      curve:setKey ( 1, 0.0, 0.0 , MOAIEaseType.EASE_OUT )
      curve:setKey ( 2, length, 1.0, MOAIEaseType.LINEAR )
    else
      curve:setKey ( 1, 0.0, 1.0 , MOAIEaseType.EASE_OUT )
      curve:setKey ( 2, length, 0.0, MOAIEaseType.LINEAR )
    end

    local timer = MOAITimer.new ()
    timer:setSpan ( length )
    timer:setMode ( MOAITimer.NORMAL )
--    timer:setCurve ( curve )

--    self.prop:setAttrLink ( MOAIColor.ATTR_R_COL, curve, MOAIAnimCurve.ATTR_VALUE )
--    self.prop:setAttrLink ( MOAIColor.ATTR_G_COL, curve, MOAIAnimCurve.ATTR_VALUE )
--    self.prop:setAttrLink ( MOAIColor.ATTR_B_COL, curve, MOAIAnimCurve.ATTR_VALUE )
    self.prop:setAttrLink ( MOAIColor.ATTR_A_COL, curve, MOAIAnimCurve.ATTR_VALUE )
    curve:setAttrLink ( MOAIAnimCurve.ATTR_TIME, timer, MOAITimer.ATTR_TIME )

    layer:insertProp ( self.prop )
    timer:start ()
    MOAIThread.blockOnAction ( timer )
    timer:stop ()
    layer:removeProp ( self.prop )
  end

  return transition

end

