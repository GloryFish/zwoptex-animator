--
--  scenes.lua
--  zwoptex-animator
--
--  Created by Jay Roberts on 2012-05-01.
--  Copyright 2012 GloryFish.org. All rights reserved.
--

local scenes = {}

local scenelist = love.filesystem.enumerate('scenes')

for i, filename in ipairs(scenelist) do
  local name = filename:sub(1, -5)
  print(name)
  if name ~= 'base' then
    scenes[name] = require('scenes/'..name)
  end
end

return scenes