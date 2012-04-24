--
--  main.lua
--  xenofarm
--
--  Created by Jay Roberts on 2011-01-20.
--  Copyright 2011 GloryFish.org. All rights reserved.
--

require 'middleclass'
require 'middleclass-extras'

require 'gamestate'
require 'input'
require 'logger'
require 'utility'
require 'spritesheets'

scenes = {}
require 'scenes/animations'
require 'scenes/error'

app = {}
app.workspaceDirectory = '/Users/gloryfish/git/rogue-descent/loveapp/resources/sprites/'

function love.load()
  isDebug = true

  love.graphics.setCaption('Zwoptex Animator')
  love.filesystem.setIdentity('zwoptex-animator')

  love.graphics.setBackgroundColor(255, 255, 255)

  -- Seed random
  local seed = os.time()
  math.randomseed(seed);
  math.random(); math.random(); math.random()

  fonts = {
    default        = love.graphics.newFont('resources/fonts/silkscreen.ttf', 20),
    small          = love.graphics.newFont('resources/fonts/silkscreen.ttf', 20),
  }

  input = Input()

  soundOn = true
  love.audio.setVolume(1)

  Gamestate.registerEvents()

  if not file_exists(app.workspaceDirectory..'spritesheet.png') or 
     not file_exists(app.workspaceDirectory..'spritesheet.lua') then
    scenes.error.message = "Place files in the workspace folder."
    Gamestate.switch(scenes.error)
  else
    if not file_exists(app.workspaceDirectory..'animations.lua') then
      local templateData = love.filesystem.read('resources/templates/animations.lua')
      local templateFile = io.open(app.workspaceDirectory..'animations.lua', 'w')
      templateFile:write(templateData)
      templateFile:close()
    end
    
    Gamestate.switch(scenes.animations)
  end
  
  
end

function love.update(dt)
end

function love.quit()
end
