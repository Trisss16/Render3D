local Container = require "ui.Container"
local Node = require "ui.Node"

local UI = Class:create()

function UI:new(w, h, x, y)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.focused = nil --al iniciar ningun nodo tiene el focus

    self.root = Node()
    self.root:setParent(nil, self.root, self) --se indica a si mismo como el nodo raiz

    self.root:setDebugActive(true)
    self.root:setDimensions(1.2, 0.2)

    self.rootContainer = Container(w, h, self.root)
end

function UI:update(dt)
    self.root:updateNode(dt)
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

return UI