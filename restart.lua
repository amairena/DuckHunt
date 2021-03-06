local composer = require( "composer" )
local scene = composer.newScene()



local w = display.contentWidth
local h = display.contentHeight

display.setDefault( "background", 255/255, 0/255, 0/255)


-- Add the NAMES of any additional objects you'll create here. Do not define the objects yet.

local text2
local menuaudio = audio.loadSound( "game_menu.mp3" )

-- Add any functions or handlers here, but not listeners.
local function nextScene (event)
  composer.gotoScene( "Game" )
end

function scene:create( event )

    local sceneGroup = self.view
    
    -- define any additional display objects here. Nothing should be declared as local; that was done above.
    -- be sure to add all objects to sceneGroup

        text2 = display.newImage("title.jpg")
          text2:translate( display.contentWidth/2, (display.contentHeight/2) )
          text2:scale( 3,3 )
          sceneGroup:insert( text2 )
        

    text2:addEventListener( "tap", nextScene )
        
    -- add any event listeners here
    
 
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "did" ) then
        
        audio.play(menuaudio)
        -- start any animation sequences (not required) or audio (not required) here
        -- start any timers here
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then      
        audio.pause(menuaudio)  
        -- cancel and remove any animation sequences, timers, or audio playback here
    end
end


function scene:destroy( event )

    local sceneGroup = self.view

  -- you do not need to add any clean up here
end





scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )





return scene