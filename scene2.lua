
--Jonathan Harmon

local composer = require( "composer" )
local scene = composer.newScene()
local physics = require "physics"
local widget = require "widget"

local Triangle = require ("Triangle")
local Circle  = require ("Circle")

--------------------------------------------

-- forward declarations and other locals
local screenWidth, screenHeight = display.actualContentWidth, display.actualContentHeight

local backBtn
local scoreText
local scoreNumber
local score = 0
local dangerText

local useCircle, useTriangle, circleColor, triangleColor

local function onBackBtnRelease()
	
	local options =
	{
		effect = "fade",
		time = 500
	}
	

	composer.gotoScene( "scene1", options)
	
	return true	-- indicates successful touch
end

local function spawnShape ()

	local sceneGroup = scene.view

		if (useCircle) then
			local circle = Circle:spawn(math.random(20,screenWidth-20),-50,circleColor,"circle", sceneGroup)
		end
		if (useTriangle) then
			local triangle = Triangle:spawn(math.random(20,screenWidth-20),-50,triangleColor,"triangle", sceneGroup)
		end
end

local shapeSpawnTimer = timer.performWithDelay( 100, spawnShape, 0 )
timer.pause(shapeSpawnTimer)


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	useCircle = event.params.circleInBox
	useTriangle = event.params.triangleInBox
	circleColor = event.params.circleColor
	triangleColor = event.params.triangleColor

	local pointAwarded = function (event)
		score = score + 1
		scoreNumber.text = score
		if (score < 0 ) then
			dangerText.alpha = 1.0
		else
			dangerText.alpha = 0.0
		end
	end

	local pointRemoved = function (event)
		score = score - 1
		scoreNumber.text = score
		if (score < 0 ) then
			dangerText.alpha = 1.0
		else
			dangerText.alpha = 0.0
		end
	end

	Runtime:addEventListener("pointAwardedEvent",pointAwarded)
	Runtime:addEventListener("pointRemovedEvent",pointRemoved)


	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	
	physics.start()
	physics.pause()
	

	backBtn = widget.newButton{
		width=120, height=40,
		shape = "roundedRect",
		fillColor = { default={1,1,1,1}, over={1,0.1,0.7,0.4} },
		onRelease = onBackBtnRelease	-- event listener function
	}
	backBtn.x = display.contentCenterX - 80
	backBtn.y = display.contentCenterY - 225

	scoreText = display.newText( "Score:  ", display.contentCenterX + 100 , display.contentCenterY - 225, native.systemFont, 20)
	scoreNumber = display.newText( score, scoreText.x + 32 , display.contentCenterY - 225, native.systemFont, 20)
	dangerText = display.newText( "Danger!", display.contentCenterX + 100 , scoreText.y+25, native.systemFont, 20)
	dangerText.alpha = 0.0

	sceneGroup:insert(scoreText)
	sceneGroup:insert(scoreNumber)
	sceneGroup:insert(dangerText)
	sceneGroup:insert(backBtn)

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		useCircle = event.params.circleInBox
		useTriangle = event.params.triangleInBox
		circleColor = event.params.circleColor
		triangleColor = event.params.triangleColor

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		timer.resume(shapeSpawnTimer)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)

		physics.pause()
		timer.pause(shapeSpawnTimer)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil

	if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene