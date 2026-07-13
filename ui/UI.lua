local Container = require "ui.Container"
local Node = require "ui.Node"
local Layout = require "ui.layouts.Layout"
local LinearLayout = require "ui.layouts.LinearLayout"

local UI = Class:create()

function UI:new(node, w, h, x, y)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.focused = nil --al iniciar ningun nodo tiene el focus

    self.debug = false

    --nodo raíz
    self.root = node or LinearLayout(LinearLayout.VERTICAL)
    self.rootContainer = Container(w, h, self.root)
    self.root:setParent(nil, self.root, self) --se indica a si mismo como el nodo raiz
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
    if self:has("focused") then
        self.focused.isFocused = false
        self.focused:unfocus()
    end

    node.isFocused = true
    self.focused = node
end


function UI:getDimensions()
    return self.w, self.h
end

function UI:showBorders(show)
    self.debug = show
end

return UI