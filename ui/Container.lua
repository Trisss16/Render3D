local Container = Class:create()

--recibe el nodo que va a contener, un container puede almacenar un unico nodo
function Container:new(w, h, node)
    self.w = w
    self.h = h
    self.node = node

    node.container_w = w
    node.container_h = h
    node.container = self

    --la posición del contenedor dentro del padre
    self.x = 0
    self.y = 0

    self.canvas = love.graphics.newCanvas(w, h)
end



function Container:getNodePos()
    self.node_x = self.w / 2 - self.node.w / 2
    self.node_y = self.h / 2 - self.node.h / 2
end



function Container:drawToCanvas()
    self:getNodePos()

    local current = love.graphics.getCanvas()

    love.graphics.setCanvas(self.canvas)
        love.graphics.clear(0, 0, 0, 0)

        --dibujar nodo
        self.node:drawToCanvas()
        love.graphics.draw(self.node.canvas, self.node_x, self.node_y)

        --dibuja los bordes del contenedor
        self:drawDebug()

    love.graphics.setCanvas(current)
end

function Container:drawDebug()
    love.graphics.push("all")

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(6)
    love.graphics.rectangle("line", 0, 0, self.w, self.h)

    love.graphics.pop()
end



function Container:setPos(x, y)
    self.x = x
    self.y = y
end

function Container:setDimensions(w, h)
    self.w = w
    self.h = h
    self.canvas = love.graphics.newCanvas(w, h)
end

return Container