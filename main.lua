_G.love = require "love"
_G.Class = require "libs.Class"
_G.Point2D = require "rendering.Point2D"
_G.Vertex = require "rendering.Vertex"
_G.t = require "geometry.Transformations"
_G.Matrix = require "geometry.Matrix"
_G.utf8 = require "libs.utf8_simple"

--creación de UIs
_G.UI = require "ui.UI"
local LinearLayout = require "ui.layouts.LinearLayout"
local Node = require "ui.Node"
local Color = require "ui.Color"
local Button = require "ui.components.Button"
local TextField = require "ui.components.TextField"

local NodeDebug = Node:extend()
function NodeDebug:draw()
    Node.draw(self)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h, 20)
end

_G.SCREEN_WIDTH = nil
_G.SCREEN_HEIGHT = nil
_G.ASPECT_RATIO = nil

SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getMode()
ASPECT_RATIO = SCREEN_WIDTH / SCREEN_HEIGHT

local a = require "rendering.Adapter"
local r = require "rendering.Renderer"


local ui

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    createUI2()

    local vertices = {
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

    r:setObj(vertices, faces)

    --a:loadModel("C:\\Users\\trili\\OneDrive\\Documentos\\modelos 3D\\lowpolycat\\cat.obj", r)

    local translate = Matrix({
        {1, 0, 0, 2},
        {0, 1, 0, 2},
        {0, 0, 1, 2},
        {0, 0, 0, 1}
    })

    local vector = Matrix({
        {2},
        {4},
        {6},
        {1}
    })

    local translated = translate * vector

    translate:print()
    print()
    vector:print()
    print()
    translated:print()
end

function love.update(dt)
    ui:update(dt)
    r:update(dt)
end

function love.draw()
    r:draw()
    ui:draw()
end

function love.textinput(t)
    ui:textinput(t)
end

function love.keypressed(key)
    ui:keypressed(key)
end

function _G.createUI()
    local root = LinearLayout(LinearLayout.VERTICAL)

    ui = UI(root, 400, 700, 750, 50)
    ui:showBorders(true)
    ui:setBgColor(Color.PURPLE)

    local n1 = Node()
    n1:setDebugActive(true)
    n1:setRelativeDimensions(0.2, 0.2)

    local n2 = NodeDebug()
    --n2:setDebugActive(true)
    n2:setRelativeDimensions(0.2, 0.1)

    local n3 = LinearLayout(LinearLayout.HORIZONTAL)
    --n3:setDebugActive(true)
    n3:setRelativeDimensions(0.2, 0.1)

    root:addChildren(n1, n2, n3)

    local n4 = NodeDebug()
    --n4:setDebugActive(true)
    --n4:setRelativeDimensions(0.2, 0.2)
    n4:setRelativeDimensions(0.2)

    local n5 = NodeDebug()
    --n5:setDebugActive(true)
    n5:setRelativeDimensions(0.2, 0.2)

    local n6 = LinearLayout(LinearLayout.VERTICAL)
    n6:setDebugActive(true)

    n3:addChildren(n4, n5, n6)

    local n7 = Node()
    n7:setDebugActive(true)
    n7:setRelativeDimensions(0.1, 0.05)

    local n8 = Node()
    n8:setDebugActive(true)
    n8:setRelativeDimensions(0.1, 0.05)

    n6:addChildren(n7, n8)
end

function _G.createUI2()
    --local font = love.graphics.newFont("ui/fonts/Press_Start_2P/")
    --local font = love.graphics.newFont("ui/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 20)
    --local font = love.graphics.newFont("ui/fonts/Anton/Anton-Regular.ttf", 20)
    local font = love.graphics.newFont("ui/fonts/Lilita_One/LilitaOne-Regular.ttf", 20)

    local root = LinearLayout(LinearLayout.VERTICAL)
    --root:setConstraints({0.4, 0.2, 0.1, 0.3})

    ui = UI(root, 400, 700, 750, 50)
    ui:showBorders(true)
    --ui:setFocusedHints(false)
    ui:setBgColor(Color.GRAY)
    ui:setRounding(0.075)

    --local btn1 = Button(Color.PURPLE, "hola", font)
    local btn1 = Button(Color.PURPLE, "hola")
    btn1:setRelativeDimensions(0.3, 0.07)
    root:addChildren(btn1)

    btn1:addClickListeners(
        function ()
            --local btn = Button(Color.PURPLE, "", 10)
            --local btn = Button(Color.PURPLE, "")
            local btn = Button(Color.PURPLE)
            local random = 0.2 + math.random() * 0.3
            --print(random)
            --btn:setRelativeDimensions(random, 0.07)
            btn:setRelativeDimensions(random)
            root:addChildren(btn)
        end
    )

    local field = TextField()
    --local field = TextField(20)
    --local field = TextField(font)

    --field:setNumeric(true)

    field:setRelativeDimensions(0.7, 0.7)

    root:addChildren(field)
end