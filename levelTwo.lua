local composer = require( "composer" )

local scene = composer.newScene()

local w = display.contentWidth
local h = display.contentHeight

composer.removeScene("levelOne")


display.setDefault( "background", 109/255, 143/255, 252/255)
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------


-- local forward references should go here
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local tree
local grass
local ground
local duckSound = audio.loadSound("duck.mp3")
local blast = audio.loadSound("blast.mp3")
local falling = audio.loadSound("falling.mp3")
local looserSensor
local winnerSensor
local laugh = audio.loadSound("laugh.mp3")
local win = audio.loadSound("captured.mp3")
local winImage
local looserImage

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
    loopCount = 3
   },
   {
    name = "flyAway",
    frames = { 13,14,15},
    time = 1500, -- in milliseconds
    loopDirection = "forward",
    loopCount = 3
   }
   
}

local birdSprite = display.newSprite  ( birdSheet, birdData)
               -- bird ends here --


local deathTable, deathSheet

deathTable = { 
  width = 39.25,
  height = 40,
  numFrames = 8, 
  sheetContentWidth = 157,
  sheetContentHeight = 80 
  }

deathSheet = graphics.newImageSheet( "duck_death.png", deathTable )

local deathData = {
  {
    name = "death",
    frames = { 1,5,6,7,8},
    time = 2500, -- in milliseconds
    loopDirection = "forward",
    loopCount = 1
   }
}

local deathSprite = display.newSprite  ( deathSheet, deathData)



local function flightPath(event)
  birdSprite:setSequence("flyAway")
  birdSprite:play()
end



local function birdDeath(event)
   transition.cancel()
   audio.pause(duckSound)
   birdSprite:pause()
   audio.play(blast) 
   audio.play(falling) 
   
          transition.to(birdSprite, {alpha=0})
          deathSprite = display.newSprite ( deathSheet, deathData)
          deathSprite:setSequence("death")
          deathSprite.x = event.x
          deathSprite.y = event.y
          deathSprite:scale( 4, 4 )
          deathSprite:play()
          transition.to(deathSprite,{ y=(display.contentHeight/2)*1.68, time = 2000, delay = 1000, alpha = 0.01})
          physics.addBody( deathSprite, "dynamic")  
          
    return true
end

local function nextScene (event)
  composer.gotoScene( "Menu" )
end

local function looser(event)   
       audio.play(laugh) 
       audio.pause(duckSound)
      looserImage=display.newImage( "laugh.png" )
      looserImage:translate( (display.contentWidth/2), (display.contentHeight/2)*1.68 )
      looserImage:scale(4,4)
      transition.to(looserImage,{ delay = 1000, alpha = 0})
      timer.performWithDelay( 3000, nextScene )
end

local function winner(event)
      audio.play(win)
      audio.pause(duckSound)
      winImage=display.newImage( "kill.png" )
      winImage:translate( (display.contentWidth/2), (display.contentHeight/2)*1.68 )
      winImage:scale(4,4)
      transition.to(winImage,{ delay = 1000, alpha = 0})
      timer.performWithDelay( 3000, nextScene )
end


-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    looserSensor = display.newRect(display.contentWidth/2, -30, display.contentWidth,50)
        sceneGroup:insert( looserSensor )
        physics.addBody( looserSensor, "static" )
        looserSensor.isSensor = true
        looserSensor.collision = looser
        looserSensor:addEventListener( "collision", looserSensor)
    
        
    winnerSensor = display.newRect(display.contentWidth/2, (display.contentHeight/2)*1.68, display.contentWidth,50)
        winnerSensor.alpha = 0.01
        sceneGroup:insert( winnerSensor )
        physics.addBody( winnerSensor, "static" )
        winnerSensor.isSensor = true
        winnerSensor.collision = winner
        winnerSensor:addEventListener( "collision", winnerSensor)    
        
        
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
      
     birdSprite = display.newSprite ( birdSheet, birdData)
        birdSprite:setSequence("fly")
        birdSprite.x = 620
        birdSprite.y = 750
        birdSprite:scale( 4, 4 )
        transition.to(birdSprite, {x=1450, y=1450, time=1700})
        transition.to(birdSprite, {y=1150, x= 200, xScale=-4, delay= 1700, time=1900})
        transition.to(birdSprite, {y=950, x= 1400, xScale=4, delay= 3400, time=1900})
        transition.to(birdSprite, {y=-30, delay=5500, time = 2500})
        sceneGroup:insert( birdSprite )   
        timer.performWithDelay( 5500, flightPath )
        physics.addBody( birdSprite, "dynamic")  
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        
        
        birdSprite:play()
        audio.play(duckSound,{loops=23})
        
        birdSprite:addEventListener( "tap", birdDeath )
 

  
        
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
            audio.pause(duckSound)
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






