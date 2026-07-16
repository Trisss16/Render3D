_G.love = require "love"
_G.Class = require "libs.Class"
_G.t = require "geometry.Transformations"
_G.Matrix = require "geometry.Matrix"
_G.Vertex = require "rendering.Vertex"
_G.Vectors = require "geometry.Vectors"
_G.utf8 = require "libs.utf8_simple"


--creación de UIs
_G.UI = require "ui.UI"
_G.LinearLayout = require "ui.layouts.LinearLayout"
_G.Node = require "ui.Node"
_G.Color = require "ui.Color"
_G.Button = require "ui.components.Button"
_G.TextField = require "ui.components.TextField"
_G.Label = require "ui.components.Label"


local buildUI = require "buildUI"
local adapter = require "rendering.Adapter"
local renderer = require "rendering.Renderer"
local renderInput = require "rendering.RenderInput"


local ui

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    renderer:setPosAndDimensions(800, 800, 0, 0)

    ui = buildUI:get()
end

function love.update(dt)
    ui:update(dt)
    renderInput:update(dt)
    renderer:update(dt)
end

function love.draw()
    renderer:draw()
    ui:draw()

    local fps = love.timer.getFPS()
    love.graphics.print("FPS: " .. fps, 10, 10)
end

function love.textinput(t)
    ui:textinput(t)
end

function love.keypressed(key)
    ui:keypressed(key)
end