require 'vector'
require 'colors'
require 'rectangle'

local scene = Gamestate.new()

function scene:enter(pre)
end

function scene:keypressed(key, unicode)
  if key == 'escape' then
    Gamestate.switch(scenes.projects)
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
  love.graphics.print('Error: '..self.message, 20, 40)
end

function scene:quit()
end

function scene:leave()
end

return scene