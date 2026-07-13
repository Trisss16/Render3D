local Node = require "ui.Node"

local TextField = Node:extend()

function TextField:new(fontSize, fontPath)
    Node.new(self)
    --self.ignoreRelative = true

    self.previousText = ""
    self.text = ""

    self.bgColor = {0.8, 0.8, 0.8}

    self.fontSize = fontSize or 20

    if fontPath then
        self.font = love.graphics.newFont(fontPath, self.fontSize)
    else
        self.font = love.graphics.newFont(self.fontSize)
    end

    self.textObj = love.graphics.newText(self.font, self.text)

    self:getTextPosAndDimensions()
end

function TextField:getTextPosAndDimensions()
    self.h = self.font:getHeight() * 1.5

    self.text_w = self.textObj:getWidth()
    self.text_h = self.textObj:getHeight()

    self.text_y = self.h / 2 - self.text_h / 2
    self.text_x = self.text_y
end

function TextField:resize()
    self:getTextPosAndDimensions()
    Node.resize(self)
end




function TextField:updateNode(dt)
    Node.updateNode(self, dt)
    self:getTextPosAndDimensions()
end

function TextField:update(dt)
    Node.update(self, dt)
    self:updateText(dt)
end



function TextField:updateText(dt)
    self.text = self.ui.textInput

    self.finalText = self.previousText .. self.ui.textInput

    self.textObj = love.graphics.newText(self.font, self.finalText)
end

function TextField:unfocus()
    self.previousText = self.text
end



function TextField:draw()
    Node.draw(self)

    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.textObj, self.text_x, self.text_y)
end

return TextField