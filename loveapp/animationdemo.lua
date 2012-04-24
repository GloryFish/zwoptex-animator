-- 
--  animationdemo.lua
--  zwoptex-animator
--  
--  Created by Jay Roberts on 2012-04-23.
--  Copyright 2012 GloryFish.org. All rights reserved.
-- 


require 'middleclass'
require 'vector'

AnimationDemo = class('AnimationDemo')

function AnimationDemo:initialize(name, animation, spritesheet)
  self.name = name
  self.frames = animation.frames
  self.position = vector(0, 0)
  self.offset = vector(0, 0)
  self.currentFrameIndex = 1
  self.spritesheet = spritesheet
  self.elapsed = 0
  
  self.valid = true
  
  for i, frame in pairs(self.frames) do
    if not self.spritesheet:hasSpriteNamed(frame.name) then
      print(frame.name..' is not a valid sprite')
      self.valid = false
    end
  end
  
end

function AnimationDemo:update(dt)
  self.elapsed = self.elapsed + dt
  
  -- Handle animation
  if #self.frames > 1 then -- More than one frame
    local duration = self.frames[self.currentFrameIndex].duration
    
    if self.elapsed > duration then -- Switch to next frame
      self.currentFrameIndex = self.currentFrameIndex + 1
      if self.currentFrameIndex > #self.frames then -- Aaaand back around
        self.currentFrameIndex = 1
      end
      self.elapsed = self.elapsed - duration
    end
  end
end

function AnimationDemo:draw()
  local currentFrame = self.frames[self.currentFrameIndex]
  self.spritesheet.batch:addq(self.spritesheet.quads[currentFrame.name], 
                         math.floor(self.position.x) + self.offset.x, 
                         math.floor(self.position.y) + self.offset.y,
                         0,
                         2,
                         2)
  colors.black:set()
  
  local width = fonts.default:getWidth(self.name)
  
  love.graphics.print(self.name, self.position.x - width / 4, self.position.y + 45, 0, 1, 1)
  love.graphics.print(currentFrame.name, self.position.x - width / 4, self.position.y + 65, 0, 1, 1)
end