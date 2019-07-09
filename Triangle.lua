--Jonathan Harmon

local Parent = require("Parent")

local Triangle = Parent:new({tag="triangle"});

function Triangle:spawn (x,y,color,tag, group)

    self.coordinates = {20,20,-20,20,0,-13}
    self.shape = display.newPolygon(group, x, y, self.coordinates);
    self.shape.fill = color;
    self.shape.tag = tag;

    self:move()

    local function onTouch (event)
        if(event.phase == "began") then
            Runtime:dispatchEvent({name="pointRemovedEvent"})
        end
    end

    self.shape:addEventListener("touch", onTouch);
  
end

function Triangle:move()

    self.physParams = {density=1.0, friction=0.0, bounce=0.7, shape = self.coordinates}
    physics.addBody (self.shape, "kinematic", self.physParams);
    self.shape:setLinearVelocity(0,100)

end

function Triangle:remove()
    physics.removeBody(self.shape);
    self.shape:removeSelf();
    self = nil;
end

return Triangle