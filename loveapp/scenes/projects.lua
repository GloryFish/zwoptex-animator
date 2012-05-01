--
--  base.lua
--  rogue-descent
--
--  A base scene that can be used when creating new scenes.
--
--  Created by Jay Roberts on 2012-02-23.
--  Copyright 2012 Jay Roberts. All rights reserved.
--

require 'logger'
require 'vector'
require 'colors'
require 'rectangle'

local scene = Gamestate.new()

function scene:enter(pre)
  self.currentIndex = 1
end

function scene:keypressed(key, unicode)
  if key == 'escape' then
    self:quit()
  end
  
  if key == 'up' then
    self.currentIndex = self.currentIndex + 1
    if self.currentIndex > #projects then
      self.currentIndex = 1
    end
  end

  if key == 'down' then
    self.currentIndex = self.currentIndex - 1
    if self.currentIndex == 0 then
      self.currentIndex = #projects
    end
  end

  if key == 'return' then
    scenes.animations.projectDirectory = projects[self.currentIndex].folder
    Gamestate.switch(scenes.animations)
  end
  
  if key == 'escape' then
    love.event.push('quit')
  end
end

function scene:mousepressed(x, y, button)
end

function scene:mousereleased(x, y, button)
end

function scene:update(dt)
  if love.mouse.isDown('l') then
  end
end

function scene:draw()
  
  colors.black:set()

  love.graphics.print('Please select a project:', 20, 10)

  local y = 50
  local padding = 20
  
  for i = 1, #projects do
    love.graphics.print(projects[i].name, 30, y)
    if i == self.currentIndex then
      love.graphics.print('>', 20, y)
    end
    y = y + padding
  end
end

function scene:quit()
end

function scene:leave()
end

return scene