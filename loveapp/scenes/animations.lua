
require 'logger'
require 'vector'
require 'colors'
require 'rectangle'
require 'animationdemo'

scenes.animations = Gamestate.new()

local scene = scenes.animations

function scene:enter(pre)
  self.demos = {}
  self:reloadAnimations()
  self.paused = false
end

function scene:keypressed(key, unicode)
  if key == 'escape' then
    self:quit()
  end
  
  if key == 'r' then
    self:reloadAnimations()
  end
  
  if key == ' ' then
    self.paused = not self.paused
  end
end

function scene:copySpritesheetResources()
  local source = io.open(app.workspaceDirectory..'spritesheet.png', 'rb')
  local dest = io.open(love.filesystem.getWorkingDirectory()..'/loveapp/cache/spritesheet.png', 'wb')
  local data = source:read('*all')
  dest:write(data)
  dest:close()
  source:close()

  source = io.open(app.workspaceDirectory..'spritesheet.lua', 'r')
  dest = io.open(love.filesystem.getWorkingDirectory()..'/loveapp/cache/spritesheet.lua', 'w')
  data = source:read('*all')
  dest:write(data)
  dest:close()
  source:close()
end

function scene:reloadAnimations()
  print('Reloading...')
  
  -- Copy spritesheet.png and .lua to local space
  self:copySpritesheetResources()
  
  self.spritesheet = Spritesheet()
  self.spritesheet:load('cache/', 'spritesheet')
  
  local f, message = loadfile(app.workspaceDirectory..'animations.lua')

  if f ~= nil then
    self.animations = f()
  else
    print('Error:'..message)
  end
  
  local offset = vector(100, 100)
  local width = 4
  local padding = 200
  local index = 0

  for name, animation in pairs(self.animations) do
    local demo = AnimationDemo(name, animation, self.spritesheet)
    if demo.valid then
      demo.position = vector(offset.x + ((index % width) * padding), offset.y + (math.floor(index / width) * padding))

      table.insert(self.demos, demo)
      print('Added demo for: '..name)
      
      index = index + 1
      
    end
  end  
  
end

function scene:mousepressed(x, y, button)
end

function scene:mousereleased(x, y, button)
end

function scene:update(dt)
  if self.paused then
    dt = 0
  end
  
  if love.mouse.isDown('l') then
  end

  for i, demo in ipairs(self.demos) do
    demo:update(dt)
  end
end

function scene:draw()
  self.spritesheet.batch:clear()
  
  for i, demo in ipairs(self.demos) do
    demo:draw()
  end

  colors.white:set()
  love.graphics.draw(self.spritesheet.batch)
end

function scene:quit()
end

function scene:leave()
end
