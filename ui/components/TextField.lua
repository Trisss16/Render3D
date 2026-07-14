local Node = require "ui.Node"
local Color = require "ui.Color"

local TextField = Node:extend()

function TextField:new(font)
    Node.new(self)
    self.ignoreRelativeHeight = true

    self.text = ""

    self.numeric = false

    self.bgColor = Color.DARK_GRAY
    self.textColor = Color.WHITE
    self.caretColor = Color.WHITE

    --caret
    self.drawCaret = false
    self.caretTimer = 0
    self.caretBlinking = 0.5

    self:initFont(font)

    self.rounding = math.floor(self.font:getHeight() / 2)

    self.textObj = love.graphics.newText(self.font, self.text)

    self:getTextPosAndDimensions()
end

function TextField:setNumeric(numeric)
    self.numeric = numeric
end

function TextField:getTextPosAndDimensions()
    self.h = self.font:getHeight() * 1.75

    self.text_w = self.textObj:getWidth()
    self.text_h = self.font:getHeight()

    --self.text_y = self.h / 2 - self.text_h / 2
    --self.text_x = self.text_y

    self.text_y = self.h / 2 - self.text_h / 2

    if self.text_w <= self.w - self.text_y * 2 then
        self.text_x = self.text_y
    else
        local dif = self.text_w - self.w
        self.text_x = - dif - self.text_y * 2
    end

    self.text_x = math.floor(self.text_x)
    self.text_y = math.floor(self.text_y)
    self.text_w = math.floor(self.text_w)
    self.text_h = math.floor(self.text_h)

    self.caret_y = self.text_y
    self.caret_x = self.text_x + self.text_w
    --self.caret_w = self.font:getWidth("|") / 2
    self.caret_w = math.floor(self.font:getHeight() * 0.15)
end

function TextField:resize()
    self:getTextPosAndDimensions()
    Node.resize(self)
end

function TextField:useRelativeDimensions(use)
    Node.useRelativeDimensions(self, use)
    self.ignoreRelativeHeight = true
end



function TextField:updateNode(dt)
    Node.updateNode(self, dt)
    self:getTextPosAndDimensions()
end

function TextField:update(dt)
    Node.update(self, dt)
    self:updateText(dt)
    self:updateCaretTimer(dt)
end

function TextField:updateText(dt)
    local inputText = self.ui.inputText

    if self.numeric then
        if tonumber(self.text .. inputText) then
            self.text = self.text .. inputText
        end
    else
        self.text = self.text .. inputText
    end

    if self.ui.backspace then
        self.text = utf8.sub(self.text, 1, -2)
    end

    self.textObj = love.graphics.newText(self.font, self.text)
end

function TextField:updateCaretTimer(dt)
    self.caretTimer = self.caretTimer + dt

    if self.caretTimer >= self.caretBlinking then
        self.caretTimer = 0
        self.drawCaret = not self.drawCaret
    end
end



function TextField:getValue()
    if self.numeric then
        if tonumber(self.text) then
            return tonumber(self.text)
        end

        return 0
    end

    return self.text
end

function TextField:resetValue()
    self.text = ""
end



function TextField:unfocus()
    self.caretTimer = 0
    self.drawCaret = false
end

function TextField:getFocus()
    self.drawCaret = true
    self.caretTimer = 0
end



function TextField:draw()
    Node.draw(self)

    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h, self.rounding)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.textObj, self.text_x, self.text_y)

    --caret
    if self.drawCaret then
        love.graphics.setColor(self.caretColor)
        love.graphics.rectangle("fill", self.caret_x, self.caret_y, self.caret_w, self.text_h)
    end
end

return TextField