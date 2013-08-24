--------------------------------------------------------------------------------
--- splash.lua
--- author: keith w. thompson

function splashScreen ( layer )

  printf (" splash screen\n")
  local splashDeck = MOAIGfxQuad2D.new ()
  splashDeck:setTexture ( _IMAGES .. "/moai_splash.png" )
  splashDeck:setRect ( -SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH/2, -SCREEN_HEIGHT/2 )

  local splash = MOAIProp2D.new ()
  splash:setDeck ( splashDeck )
  splash:setLoc ( 0, 0 )
  layer:insertProp ( splash )

  local splashTimer = MOAITimer.new ()
  local fade_in = 0.75
  local fade_out = 0.75
  local hold = 1.33
  local length = fade_in + fade_out + hold
  splashTimer:setSpan ( length )
  splashTimer:setMode ( MOAITimer.NORMAL )

  local curve = MOAIAnimCurve.new ()
  curve:reserveKeys ( 4 )
  curve:setKey ( 1, 0.0, 0.0 , MOAIEaseType.EASE_OUT )
  curve:setKey ( 2, fade_in, 1.0, MOAIEaseType.EASE_IN )
  curve:setKey ( 3, fade_in + hold, 1.0, MOAIEaseType.EASE_OUT )
  curve:setKey ( 4, length, 0.0, MOAIEaseType.EASE_IN )
  splashTimer:setCurve (curve)

  splash:setAttrLink ( MOAIColor.ATTR_R_COL, curve, MOAIAnimCurve.ATTR_VALUE )
  splash:setAttrLink ( MOAIColor.ATTR_G_COL, curve, MOAIAnimCurve.ATTR_VALUE )
  splash:setAttrLink ( MOAIColor.ATTR_B_COL, curve, MOAIAnimCurve.ATTR_VALUE )
--  splash:setAttrLink ( MOAIColor.ATTR_A_COL, curve, MOAIAnimCurve.ATTR_VALUE )
  curve:setAttrLink ( MOAIAnimCurve.ATTR_TIME, splashTimer, MOAITimer.ATTR_TIME )

  splashTimer:start ()
  MOAIThread.blockOnAction ( splashTimer )
  splashTimer:stop ()

  layer:removeProp ( splash )

end

