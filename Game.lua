local composer = require( "composer" )

local scene = composer.newScene()
composer.removeScene("Menu")


local w = display.contentWidth
local h = display.contentHeight

display.setDefault( "background", 109/255, 143/255, 252/255)
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local tree
local grass
local ground

local startaudio = audio.loadSound( "start_game.mp3" )
local bark = audio.loadSound("bark.mp3")



                    -- dog starts here --
local dogTable , dogSheet


dogTable = { 
  width = 63,
  height = 63.5,
  numFrames = 12, 
  sheetContentWidth = 379,
  sheetContentHeight = 127 
  }

dogSheet = graphics.newImageSheet( "dog.png", dogTable )

local dogData = {
  {
    name = "walk",
    frames = { 1,2,3,4,5,6,7,8},
    time = 2500, -- in milliseconds
    loopDirection = "forward",
    loopCount = 1
   }
}

local dogSprite = display.newSprite  ( dogSheet, dogData)
               -- dog ends here --


                    -- bird starts here --
local birdTable , birdSheet


birdTable = { 
  width = 51,
  height = 39.4285,
  numFrames = 21, 
  sheetContentWidth = 153,
  sheetContentHeight = 276 
  }

birdSheet = graphics.newImageSheet( "duck_flight.png", birdTable )

local birdData = {
  {
    name = "fly",
    frames = { 1,2,3,4,5,6,7,8},
    time = 2500, -- in milliseconds
    loopDirection = "forward",
    loopCount = 1
   }
}

local birdSprite = display.newSprite  ( birdSheet, birdData)
               -- bird ends here --

local function level1(event)
    composer.gotoScene( "levelOne" )
end



-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    dogSprite = display.newSprite ( dogSheet, dogData)
        dogSprite:setSequence("walk")
        dogSprite.x = 220
        dogSprite.y = 1750
        dogSprite:scale( 4, 4 )
        transition.to(dogSprite, {x=750, time=2850})
        transition.to(dogSprite, {y=1650, time=1600, delay= 1600})
        transition.to(dogSprite, {alpha=0, delay=3500})
        sceneGroup:insert( dogSprite )

    tree = display.newImage("tree.png")
      sceneGroup:insert( tree)
      tree:translate( (display.contentWidth/2)*0.35, (display.contentHeight/2)*1.4 )
      tree:scale( 7.4, 4 )
    
    grass = display.newImage("grass.png")
      sceneGroup:insert( grass )
      grass:translate( (display.contentWidth/2), (display.contentHeight/2)*1.68 )
      grass:scale( 6, 4 )
      grass:toBack()
      
    ground = display.newImage("ground.png")
      sceneGroup:insert( ground )
      ground:translate( (display.contentWidth/2), (display.contentHeight/2)*1.90 )
      ground:scale( 6, 16 )
      ground:toBack()
    

      
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        
        dogSprite:play()
        
        audio.play( startaudio )
        
        
        timer.performWithDelay( 6000, audio.play( bark,{loops=3} ) )
        timer.performWithDelay( 6000, level1 )
       
        
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene