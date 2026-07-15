local Node = require "ui.Node"

local Layout = Node:extend()

function Layout:new()
    --self.super.new(self)
    Node.new(self)

    --ignora las proporciones relativas. Un layout siempre tomará el tamaño completo de su contenedor
    self.ignoreRelative = true

    self.manageChildren = true

    self.focusable = false

    self.allowScroll = false
end

function Layout:setAllowScroll(allow)
    self.allowScroll = allow

    if self:has("container") then
        self.container.allowScroll = allow
        self.container:setSCrollbarPos()
    end
end



function Layout:updateNode(dt)
    Node.updateNode(self, dt)

    if self.allowScroll then
        self.container:updateScrollbar()
    end

    --mantiene el tamaño del layout para que cubra todo su contenedor
    if self.container ~= nil then
        self.w, self.h = self.container:getDimensions()
    end

    --calcula el tamaño total que los hijos del nodo abarcan
    self:calculateTotalDimensions()
end



function Layout:draw()
    Node.draw(self)
end



function Layout:resize()
    Node.resize(self)

    --actualiza sus propios hijos
    if self:has("container") then
        self:defineChildrenContainers()
        self.container:setSCrollbarPos()
        --self.canvas = love.graphics.newCanvas(self.container.total_w, self.container.total_h)
    end
end

function Layout:addContainer(container)
    self.w, self.h = container:getDimensions()

    container.allowScroll = self.allowScroll

    Node.addContainer(self, container)

    if self.allowScroll then
        container:setSCrollbarPos()
    end
end



function Layout:addChildren(...)
    Node.addChildren(self, ...)
    self:defineChildrenContainers()
end

--esta función define la posición y tamaño para cada hijo. Cada layout decide como implementarla
function Layout:defineChildrenContainers()
    local last

    --un layout simple muestra un único elemento a la vez
    for _, container in ipairs(self.children) do
        if container.node.managed then
            last = container
            container:setPos(0, 0)
            container:setDimensions(self.w, self.h)
            container.node.ignoredByLayout = true
        end
    end

    last.node.ignoredByLayout = false
end


--[[dimensiones totales del nodo. Si se quiere permitir el scroll en un layout se tiene que sobreescribir
este método, calculando las dimensiones totales que tomarán todos los hijos]]

function Node:calculateTotalDimensions()
    local total_w, total_h = self.container.getDimensions()
    Node:setContainerTotalDimensions(total_w, total_h)
end

function Node:setContainerTotalDimensions(total_w, total_h)
    self.container.total_w = total_w
    self.container.total_h = total_h
end

return Layout