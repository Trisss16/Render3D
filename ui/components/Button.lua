local Node = require "ui.Node"
local Color= require "ui.Color"

local Button = Node:extend()

Button.bodyOffsetFactor = 0.015

function Button:new(color, text, font)
    Node.new(self)

    self.color = color or Color.WHITE
    self.text = text or ""

    --inicializar fuente
    self:initFont(font)

    self.textObj = love.graphics.newText(self.font, self.text)

    self.bodyShadow = 0.6

    self.roundingFactor = 0.25
    self.topSizeFactor = 0.85

    self.clickListeners = {}

    self:getDrawingData()
    self:getTextData()
end

function Button:setColor(color)
    self.color = color
end

function Button:setButtonBodyHeight(relative_h)
    if self:has("ui") then
        self.bodyOffset = relative_h * self.ui.h
    else
        self.bodyOffset = 15
    end
end

function Button:getDrawingData()
    self.rounding = math.floor(self.h * self.roundingFactor)

    self.top_w = self.w
    --self.top_h = math.floor(self.h * self.topSizeFactor)
    --self.bodyOffset = self.h - self.top_h

    self:setButtonBodyHeight(self.bodyOffsetFactor)
    self.top_h = self.h - self.bodyOffset
end

function Button:getTextData()
    self.text_w, self.text_h = self.textObj:getDimensions()

    self.text_x = self.top_w / 2 - self.text_w / 2
    self.text_y = self.top_h / 2 - self.text_h / 2
end

function Button:resize()
    Node.resize(self)
    --self:getDrawingData()
end

function Button:updateNode(dt)
    Node.updateNode(self, dt)
    self:getDrawingData()
    self:getTextData()
end

function Button:update(dt)
    Node.update(self, dt)

    if self.clicked then
        self:triggerClickListeners()
    end
end



function Button:draw()
    Node.draw(self)

    --dibujar el cuerpo

    love.graphics.setColor(
        self.color[1] * self.bodyShadow,
        self.color[2] * self.bodyShadow,
        self.color[3] * self.bodyShadow
    )

    love.graphics.rectangle("fill", 0, self.bodyOffset, self.top_w, self.top_h, self.rounding)


    --dibujar top

    love.graphics.setColor(self.color)

    if not self.pressed then
        love.graphics.rectangle("fill", 0, 0, self.top_w, self.top_h, self.rounding)
    else
        love.graphics.rectangle("fill", 0, self.bodyOffset, self.top_w, self.top_h, self.rounding)
    end

    self:drawText()
end

function Button:drawText()
    love.graphics.setColor(
        self.color[1] * self.bodyShadow,
        self.color[2] * self.bodyShadow,
        self.color[3] * self.bodyShadow
    )

    love.graphics.setFont(self.font)

    if not self.pressed then
        love.graphics.draw(self.textObj, self.text_x, self.text_y)
    else
        love.graphics.draw(self.textObj, self.text_x, self.text_y + self.bodyOffset)

    end
end



function Button:addClickListeners(...)
    local args = {...}

    for i, arg in ipairs(args) do
        if type(arg) ~= "function" then
            error("El argumento " .. i .. " no es una función.", 1)
        end

        table.insert(self.clickListeners, arg)
    end
end

function Button:triggerClickListeners()
    for _, listener in ipairs(self.clickListeners) do
        listener()
    end
end

return Button