local Layout = require "ui.layouts.Layout"

local LinearLayout = Layout:extend()

LinearLayout.HORIZONTAL = 0
LinearLayout.VERTICAL = 1

function LinearLayout:new(mode)
    Layout.new(self)

    if mode ~= self.HORIZONTAL and mode ~= self.VERTICAL then
        mode = self.VERTICAL
    end

    self.mode = mode
end

function LinearLayout:defineChildrenContainers()
    local cw, ch = self.container:getDimensions()
    local w, h

    if self.mode == self.HORIZONTAL then
        w = cw / #self.children
        h = ch
    else
        w  = cw
        h = ch / #self.children
    end

    if w <= 0 then w = 1 end
    if h <= 0 then h = 1 end

    local acum = 0

    for _, container in ipairs(self.children) do
        container.node.ignoredByLayout = false

        if not self.managed then
            goto continue
        end

        container:setDimensions(w, h)

        if self.mode == self.HORIZONTAL then
            container:setPos(acum, 0)
            acum = acum + w
        else
            container:setPos(0, acum)
            acum = acum + h
        end

        ::continue::
    end
end

return LinearLayout