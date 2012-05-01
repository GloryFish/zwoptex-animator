
require 'logger'
require 'vector'
require 'colors'
require 'rectangle'
require 'animationdemo'
require 'utility'

local scene = Gamestate.new()

function scene:enter(pre)
  assert(self.projectDirectory ~= nil, 'projectDirectory must be set before switching to animations scene')

  self.demos = {}
  self:reloadAnimations()
  self.paused = false
end

-- Attempt to move files form the project folder to a local workspace folder so 
-- they can be used by LÖVE
function scene:copyProjectFiles()
  print(love.filesystem.getWorkingDirectory()..'/loveapp/cache/spritesheet.png')
  
  self:copyFile('spritesheet.png', 'binary')
  self:copyFile('spritesheet.lua', 'text')
end

-- Copy a single file from the projectDirectory to the working directory
function scene:copyFile(filename, mode)
  local readmode = 'r'
  local writemode = 'w'
  if mode == 'binary' then
    readmode = 'rb'
    writemode = 'wb'
  end
  
  assert(filename ~= nil, 'filename must not be nil')
  local source = io.open(self.projectDirectory..filename, readmode)
  
  if source == nil then
    scenes.error.message = 'Couldn\'t load source: '..self.projectDirectory..filename
    Gamestate.switch(scenes.error)
    return
  end
  
  local dest = io.open(love.filesystem.getWorkingDirectory()..'/loveapp/cache/'..filename, writemode)

  if dest == nil then
    scenes.error.message = 'Couldn\'t open dest for writing: '..love.filesystem.getWorkingDirectory()..'/loveapp/cache/'..filename
    Gamestate.switch(scenes.error)
    return
  end
  
  local data = source:read('*all')
  dest:write(data)
  dest:close()
  source:close()
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

  if key == 'left' then
    for i, demo in ipairs(self.demos) do
      demo:back()
    end
    
  end

  if key == 'right' then
    for i, demo in ipairs(self.demos) do
      demo:forward()
    end
  end

end

function scene:reloadAnimations()
  print('Reloading...')
  
  self:copyProjectFiles()
  
  self.spritesheet = Spritesheet()
  self.spritesheet:load('cache/', 'spritesheet')
  
  if not file_exists(self.projectDirectory..'animations.lua') then
    local templateData = love.filesystem.read('resources/templates/animations.lua')
    local templateFile = io.open(self.projectDirectory..'animations.lua', 'w')
    
    if templateFile == nil then
      scenes.error.message = 'Couldn\'t create animation template: '..self.projectDirectory..'animations.lua'
      Gamestate.switch(scenes.error)
      return
    end
    
    templateFile:write(templateData)
    templateFile:close()
  end
  
  local file, message = loadfile(self.projectDirectory..'animations.lua')

  if file ~= nil then
    self.animations = file()
    self.demos = {}
  else
    scenes.error.message = message
    Gamestate.switch(scenes.error)
    return
  end
  
  local offset = vector(100, 140)
  local width = 5 -- Number of demos per row
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
  colors.black:set()

  love.graphics.print(self.projectDirectory..'spritesheet.lua', 20, 10)
  love.graphics.print(self.projectDirectory..'spritesheet.png', 20, 25)
  love.graphics.print(self.projectDirectory..'animations.lua', 20, 40)

  local play = 'play'
  if self.paused then
    play = 'paused'
  end
  love.graphics.print(play, 20, 60)

  colors.black:set()
  love.graphics.line(40, 100, love.graphics.getWidth() - 40, 100)
  
  self.spritesheet.batch:clear()
  
  for i, demo in ipairs(self.demos) do
    demo:draw()
  end

  colors.white:set()
  love.graphics.draw(self.spritesheet.batch)
end

function scene:quit()
  Gamestate.switch(scenes.projects)
end

function scene:leave()
end

return scene
