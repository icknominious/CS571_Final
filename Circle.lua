--Jonathan Harmon

local Parent = require("Parent")

local Circle = Parent:new({tag="circle"});

function Circle:spawn (x,y,color,tag, group)

    self.shape = display.newCircle(group, x, y, 19);
    self.shape.fill = color;
    self.shape.tag = tag;

    self:move()

    local function onTouch (event)
        if(event.phase == "began") then
            Runtime:dispatchEvent({name="pointAwardedEvent"})
        end
    end

    self.shape:addEventListener("touch", onTouch);
  
end

function Circle:move()

    self.physParams = {density=1.0, friction=0.0, bounce=0.7, radius=19}
    physics.addBody (self.shape, "kinematic", self.physParams);
    self.shape:setLinearVelocity(0,200)

end


function Circle:remove()
    physics.removeBody(self.shape);
    self.shape:removeSelf();
    self = nil;
end

return Circle