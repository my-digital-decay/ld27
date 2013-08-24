--------------------------------------------------------------------------------
--- frontend/title.lua
--- author: keith w. thompson

function titleScreen ( layer )

  printf (" title screen\n")
  layer:setClearColor ( 0.5, 0.5, 0.0, 1.0 )

  local text = MOAITextBox.new ()
  text:setString ( "CONCORD" )
  text:setFont ( Main.font )
  text:setColor ( 0.9, 0.9, 0.9, 1.0 )
  text:setTextSize ( 128 )
  text:setRect ( -512, -256, 512, 0 )
  text:setAlignment ( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
  layer:insertProp ( text )

end

