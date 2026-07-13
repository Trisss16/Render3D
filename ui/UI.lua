local Container = require "ui.Container"
local Node = require "ui.Node"
local Layout = require "ui.layouts.Layout"
local Color = require "ui.Color"

local UI = Class:create()

function UI:new(node, w, h, x, y)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.focused = nil --al iniciar ningun nodo tiene el focus
    self.showFocusedHint = true

    --para el manejo de texto
    self.textInput = ""
    self.backspaces = 0

    self.debug = false

    --fondo
    self.useBgColor = true
    self.bgColor = Color.GRAY
    self.bgRoundingFactor = 0
    self.bgRounding = self.w * self.bgRoundingFactor

    --nodo raíz
    self.root = node or Layout()
    self.rootContainer = Container(w, h, self.root)
    self.root:setParent(nil, self.root, self) --se indica a si mismo como el nodo raiz
end

function UI:update(dt)
    --deja el cursor original
    love.mouse.setCursor()

    --actualiza el nodo principal y todos sus hijos
    self.root:updateNode(dt)

    if love.keyboard.isDown then
        
    end

    if self:has("focused") then
        self.focused:update(dt)
    end
end

function UI:draw()
    --fondo
    if self.useBgColor then
        love.graphics.setColor(self.bgColor)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.bgRounding)
        love.graphics.setColor(1, 1, 1, 1)
    end

    --contenedor del nodo raíz
    self.rootContainer:drawToCanvas()
    love.graphics.draw(self.rootContainer.canvas, self.x, self.y)
end


function UI:setBgColor(color)
    self.bgColor = color
    self.useBgColor = true
end

function UI:setRounding(factor)
    self.bgRoundingFactor = factor
    self.bgRounding = self.w * factor
end



function UI:setTextInput(t)
    self.textInput = self.textInput .. t
end

function UI:setKeyPressed(key)
    if key == "backspace" then
        self.backspaces = self.backspaces - 1
    end
end



function UI:setFocusedHints(show)
    self.showFocusedHint = show
end

function UI:giveFocus(node)
    if self:has("focused") then
        self.focused.isFocused = false
        self.focused:unfocus()
    end

    node.isFocused = true
    self.focused = node

    --cada que se cambia el focus se reinicia el texto
    self.textInput = ""
    self.backspaces = 0
end


function UI:getDimensions()
    return self.w, self.h
end

function UI:setDimensions(w, h)
    self.w = w
    self.h = h
    self:setRounding(self.bgRoundingFactor)
end

function UI:showBorders(show)
    self.debug = show
end

return UI