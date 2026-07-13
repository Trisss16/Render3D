local Container = Class:create()

--recibe el nodo que va a contener, un container puede almacenar un unico nodo
function Container:new(w, h, node)
    self.w = w
    self.h = h

    self.node = node
    self.node_x = 0
    self.node_y = 0

    self.margin = 0

    node:addContainer(self)

    --la posición del contenedor dentro del padre
    self.x = 0
    self.y = 0

    self.canvas = love.graphics.newCanvas(w, h)
    self.canvas:setFilter("nearest", "nearest")
end



function Container:getNodePos()
    self.node_x = self.w / 2 - self.node.w / 2
    self.node_y = self.h / 2 - self.node.h / 2

    self.node_x = math.floor(self.node_x)
    self.node_y = math.floor(self.node_y)
end



function Container:drawToCanvas()
    self:getNodePos()

    local current = love.graphics.getCanvas()

    love.graphics.setCanvas(self.canvas)
        love.graphics.clear(0, 0, 0, 0)

        --dibujar nodo
        self.node:drawToCanvas()
        love.graphics.draw(self.node.canvas, self.node_x, self.node_y)

        --dibuja los hijos recursivamente
        if self.node.manageChildren then
            self:drawChildren()
        end

        --dibuja los bordes del contenedor
        if self.node.ui.debug then
            self:drawDebug()
        end

    love.graphics.setCanvas(current)
end

function Container:drawChildren()
    for _, container in ipairs(self.node.children) do

        if container.node.ignoredByLayout == false and container.node.visible and container.node.managed then
            container:drawToCanvas()
            --love.graphics.draw(container.canvas, container.x, container.y)
            love.graphics.draw(container.canvas, container.x + container.margin, container.y + container.margin)
        end

    end
end

function Container:drawDebug()
    love.graphics.push("all")

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", 0, 0, self.w, self.h)

    love.graphics.pop()
end



function Container:setPos(x, y)
    self.x = x
    self.y = y
end

function Container:GetPos()
    return self.x, self.y
end

function Container:setDimensions(w, h)
    if w <= 0 then w = 1 end
    if h <= 0 then h = 1 end

    self.w = math.floor(w)
    self.h = math.floor(h)

    self.canvas = love.graphics.newCanvas(self.w, self.h)
    self.canvas:setFilter("nearest", "nearest")
end

function Container:getDimensions()
    return math.floor(self.w - self.margin * 2) ,
        math.floor(self.h - self.margin * 2)
end

return Container