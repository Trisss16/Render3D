local Node = require "ui.Node"
local Color= require "ui.Color"

local Label = Node:extend()

function Label:new(text, font, color)
    Node.new(self)

    self.ignoreRelativeWidth = true
    self.ignoreRelativeHeight = true

    self.focusable = false

    self:initFont(font)
    self:setText(text)
    self:setColor(color)

    self.text_x, self.text_y = 0, 0

    self.w, self.h = 0, 0
end



function Label:setColor(color)
    self.color = color or Color.DARK_GRAY
end

function Label:setText(text)
    self.text = text or ""
    self.textObj = love.graphics.newText(self.font, self.text)
    self.text_w, self.text_h = self.textObj:getDimensions()
end



function Label:updateNode(dt)
    Node.updateNode(self, dt)

    self:updateDimensions()

    self.text_x = self.w / 2 - self.text_w / 2
    self.text_y = self.h / 2 - self.text_h / 2
end

function Label:updateDimensions()
    self.w, self.h = self.container:getDimensions()

    self.w = math.floor(self.w)
    self.h = math.floor(self.h)
end



function Label:resize()
    self:updateDimensions()
    Node.resize(self)
end



function Label:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.textObj, self.text_x, self.text_y)
end



function Label:useRelativeDimensions(use)
    --no hace super para evitar que se usen dimensiones relativas
end



return Label