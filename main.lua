_G.love = require "love"
_G.Class = require "libs.Class"
_G.Point2D = require "rendering.Point2D"
_G.Vertex = require "rendering.Vertex"
_G.t = require "geometry.Transformations"
_G.Matrix = require "geometry.Matrix"
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

    --[[local vertices = {
        Vertex( -0.25,  0.25,  0.25 ), --1
        Vertex(  0.25,  0.25,  0.25 ), --2
        Vertex(  0.25, -0.25,  0.25 ), --3
        Vertex( -0.25, -0.25,  0.25 ), --4

        Vertex( -0.25,  0.25, -0.25 ), --5
        Vertex(  0.25,  0.25, -0.25 ), --6
        Vertex(  0.25, -0.25, -0.25 ), --7
        Vertex( -0.25, -0.25, -0.25 ), --8
    }

    local faces = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {1, 5},
        {2, 6},
        {3, 7},
        {4, 8},
    }

    renderer:setObj(vertices, faces)]]

    ui = buildUI:get()
end

function love.update(dt)
    ui:update(dt)
    renderInput:update(dt)
    renderer:update(dt)

    --[[print("altura del layout: " .. ui.root.h)
    print("altura del contenedor: " .. ui.rootContainer.h)
    print("\ncanvas del layout: " .. ui.root.canvas:getHeight())
    print("canvas del contenedor: " .. ui.rootContainer.canvas:getHeight())
    print("\ntotal_h: " .. ui.rootContainer.total_h)
    print("\n")]]
end

function love.draw()
    renderer:draw()
    ui:draw()
end

function love.textinput(t)
    ui:textinput(t)
end

function love.keypressed(key)
    ui:keypressed(key)
end