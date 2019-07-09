--Jonathan Harmon

local physics = require("physics");
local Object = {tag="object"};

function Object:new (obj)    --constructor
  obj = obj or {}; 
  setmetatable(obj, self);
  self.__index = self;
  return obj;
end

function Object:remove()  --deconstructor
    self = nil;
end

return Object