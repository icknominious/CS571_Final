--Jonathan Harmon

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn
local box
local circle
local triangle

local red = {1,0,0}
local blue = {0,0,1}
local green = {0,1,0}
local yellow = {1,1,0}


local function onPlayBtnRelease()
	
	local options =
	{
		effect = "fade",
		time = 500,
		params = {
				circleInBox = false,
				circleColor = circle.color,
				triangleInBox = false,
				triangleColor = triangle.color
			}
	}
	if(circle.x <= display.contentCenterX + 80
		and circle.x >= display.contentCenterX - 80
		and circle.y <= display.contentCenterY + 80
		and circle.y >= display.contentCenterY - 80	
	) then
		options.params.circleInBox = true
	else 
		options.params.circleInBox = false
	end

	if(triangle.x <= display.contentCenterX + 80
		and triangle.x >= display.contentCenterX - 80
		and triangle.y <= display.contentCenterY + 80
		and triangle.y >= display.contentCenterY - 80	
	) then
		options.params.triangleInBox = true
	else 
		options.params.triangleInBox = false
	end

	composer.gotoScene( "scene2", options)
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	playBtn = widget.newButton{
		width=120, height=40,
		shape = "roundedRect",
		fillColor = { default={1,1,1,1}, over={1,0.1,0.7,0.4} },
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX + 80
	playBtn.y = display.contentCenterY - 225

	box = display.newRect( display.contentCenterX, display.contentCenterY, 175, 175 )
	box.strokeWidth = 5
	box:setFillColor( 0,0,0,0 )
	box:setStrokeColor( 1, 1, 1 )

	circle =  display.newCircle(100, 115, 19);
	circle.fill = red
	circle.color = red

	triangle = display.newPolygon(220, 115, {20,20,-20,20,0,-13})
	triangle.fill  = red
	triangle.color = red

	local function shapeTap (event)
		if (event.target.color == red) then
			event.target.fill = blue
			event.target.color = blue
		elseif (event.target.color == blue) then 
			event.target.fill = green
			event.target.color = green
		elseif (event.target.color == green) then 
			event.target.fill = yellow
			event.target.color = yellow
		elseif (event.target.color == yellow) then 
			event.target.fill = red
			event.target.color = red
		end
	end

	local function shapeDrag (event)
		if event.phase == "began" then
			event.target.markX = event.target.x
			event.target.markY = event.target.y
		elseif event.phase == "moved" then
			local x = (event.x - event.xStart) + event.target.markX
			local y = (event.y - event.yStart) + event.target.markY
			event.target.x = x
			event.target.y = y
		end
	end

	circle:addEventListener("tap",shapeTap)
	circle:addEventListener("touch", shapeDrag)
	triangle:addEventListener("tap",shapeTap)
	triangle:addEventListener("touch", shapeDrag)
	
	-- all display objects must be inserted into group
	sceneGroup:insert( playBtn )
	sceneGroup:insert (circle)
	sceneGroup:insert (triangle)
	sceneGroup:insert (box)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
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