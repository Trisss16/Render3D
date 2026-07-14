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

    self.constraints = {}
    self.defaultConstraint = 0
end

function LinearLayout:setConstraints(constraints)
    local last

    for _, value in ipairs(constraints) do
        if type(value) ~= "number" then
            error("Constraints invalidas.", 1)
        end

        last = value
    end

    self.constraints = constraints
    self.defaultConstraint = last
    self:resize()
end

function LinearLayout:defineChildrenContainers()
    local cw, ch = self.container:getDimensions()
    local s = self:childrenSize()

    local w, h

    if self.mode == self.HORIZONTAL then
        --w = cw / #self.children
        w = cw / s
        h = ch
    else
        w  = cw
        --h = ch / #self.children
        h = ch / s
    end

    if w <= 0 then w = 1 end
    if h <= 0 then h = 1 end

    if #self.constraints == 0 then
        self:defineNoConstraints(w, h)
    else
        self:defineWithConstraints(cw, ch, w, h)
    end
end


function LinearLayout:defineNoConstraints(w, h)
    local acum = 0

    for _, container in ipairs(self.children) do
        container.node.ignoredByLayout = false

        if not container.node.managed then
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


function LinearLayout:defineWithConstraints(cw, ch, w, h)
    local last = self.constraints[#self.constraints - 1]

    local acum = 0

    for i, container in ipairs(self.children) do
        container.node.ignoredByLayout = false

        if not container.node.managed then
            goto continue
        end

        local constraint

        --si ya no hay mas constraints, el resto de elementos usarán la última del arreglo
        if self.constraints[i] then
            constraint = self.constraints[i]
        else
            constraint = self.defaultConstraint
        end

        if self.mode == self.HORIZONTAL then
            constraint = constraint * cw
            container:setDimensions(constraint, h)
            container:setPos(acum, 0)
            acum = acum + constraint
        else
            constraint = constraint * ch
            container:setDimensions(w, constraint)
            container:setPos(0, acum)
            acum = acum + constraint
        end

        ::continue::
    end
end

return LinearLayout