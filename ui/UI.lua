local Container = require "ui.Container"
local Node = require "ui.Node"
local Layout = require "ui.layouts.Layout"
local LinearLayout = require "ui.layouts.LinearLayout"

local UI = Class:create()

local NodeDebug = Node:extend()

function NodeDebug:draw()
    self.super.draw(self)

    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
end


function UI:new(w, h, x, y)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.focused = nil --al iniciar ningun nodo tiene el focus

    self.debug = true

    --crear nodo raíz
    --self.root = Layout()
    self.root = LinearLayout(LinearLayout.VERTICAL)
    self.root:setParent(nil, self.root, self) --se indica a si mismo como el nodo raiz
    --self.root:setDebugActive(true)
    self.rootContainer = Container(w, h, self.root)

    local n1 = Node()
    n1:setDebugActive(true)
    n1:setRelativeDimensions(0.2, 0.2)

    local n2 = NodeDebug()
    --n2:setDebugActive(true)
    n2:setRelativeDimensions(0.2, 0.1)

    local n3 = LinearLayout(LinearLayout.HORIZONTAL)
    --n3:setDebugActive(true)
    n3:setRelativeDimensions(0.2, 0.1)

    self.root:addChildren(n1, n2, n3)

    local n4 = NodeDebug()
    --n4:setDebugActive(true)
    n4:setRelativeDimensions(0.2, 0.2)

    local n5 = NodeDebug()
    --n5:setDebugActive(true)
    n5:setRelativeDimensions(0.2, 0.2)

    n3:addChildren(n4, n5)
end

function UI:update(dt)
    --deja el cursor original
    love.mouse.setCursor()

    --actualiza el nodo principal y todos sus hijos
    self.root:updateNode(dt)

    if self:has("focused") then
        self.focused:update(dt)
    end
end

function UI:draw()
    --fondo
    love.graphics.setColor(1, 0.5, 0.9)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)

    --contenedor del nodo raíz
    self.rootContainer:drawToCanvas()
    love.graphics.draw(self.rootContainer.canvas, self.x, self.y)
end



function UI:giveFocus(node)
    if self.focused then
        self.focused.isFocused = false
        self.focused:unfocus()
    end

    node.isFocused = true
    self.focused = node
end


function UI:getDimensions()
    return self.w, self.h
end

return UI