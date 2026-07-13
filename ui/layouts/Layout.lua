local Node = require "ui.Node"

local Layout = Node:extend()

function Layout:new()
    --self.super.new(self)
    Node.new(self)

    --ignora las proporciones relativas. Un layout siempre tomará el tamaño completo de su contenedor
    self.ignoreRelative = true

    self.manageChildren = true

    self.focusable = false
end



function Layout:updateNode(dt)
    Node.updateNode(self, dt)

    --mantiene el tamaño del layout para que cubra todo su contenedor
    if self.container ~= nil then
        self.w, self.h = self.container:getDimensions()
    end
end



function Layout:draw()
    Node.draw(self)
end



function Layout:resize()
    Node.resize(self)

    --actualiza sus propios hijos
    if self:has("container") then
        self:defineChildrenContainers()
    end
end

function Layout:addContainer(container)
    self.w, self.h = container:getDimensions()
    Node.addContainer(self, container)
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

return Layout