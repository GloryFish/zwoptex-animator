require 'logger'
require 'vector'
require 'colors'
require 'rectangle'

scenes.error = Gamestate.new()

local scene = scenes.error

function scene:enter(pre)
  self.logger = Logger();
  if self.message == nil then
    self.message = 'No message'
  end
end

function scene:keypressed(key, unicode)
  if key == 'escape' then
    self:quit()
  end
end

function scene:mousepressed(x, y, button)
end

function scene:mousereleased(x, y, button)
end

function scene:update(dt)
  if love.mouse.isDown('l') then
  end
  
  self.logger:update(dt)
  self.logger:addLine(self.message)
end

function scene:draw()
  self.logger:draw()
end

function scene:quit()
end

function scene:leave()
end
