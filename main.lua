_G.love = require "love"
_G.Class = require "libs.Class"
_G.Point2D = require "rendering.Point2D"
_G.Vertex = require "rendering.Vertex"
_G.t = require "geometry.Transformations"
_G.utf8 = require "libs.utf8_simple"

_G.SCREEN_WIDTH = nil
_G.SCREEN_HEIGHT = nil
_G.ASPECT_RATIO = nil

SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getMode()
ASPECT_RATIO = SCREEN_WIDTH / SCREEN_HEIGHT

local a = require "rendering.Adapter"
local r = require "rendering.Renderer"

function love.load()
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

    r:setObj(vertices, faces)]]

    a:loadModel("C:\\Users\\trili\\OneDrive\\Documentos\\modelos 3D\\lowpolycat\\cat.obj", r)
end

function love.update(dt)
    r:update(dt)
end

function love.draw()
    r:draw()
end