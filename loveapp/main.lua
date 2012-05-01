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
require 'spritesheets'

scenes = require 'scenes'
projects = require 'projects'

app = {}
app.currentProject = nil

function love.load()
  isDebug = true

  love.graphics.setCaption('Zwoptex Animator')
  love.filesystem.setIdentity('zwoptex-animator')

  love.graphics.setBackgroundColor(255, 255, 255)

  fonts = {
    default        = love.graphics.newFont('resources/fonts/silkscreen.ttf', 20),
    small          = love.graphics.newFont('resources/fonts/silkscreen.ttf', 20),
  }

  input = Input()

  soundOn = true
  love.audio.setVolume(1)

  Gamestate.registerEvents()

  Gamestate.switch(scenes.projects)
end

function love.update(dt)
end

function love.quit()
end
