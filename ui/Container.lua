local Container = Class:create()

--recibe el nodo que va a contener, un container puede almacenar un unico nodo
function Container:new(w, h, node)
    self.w = w
    self.h = h

    --las dimensiones totales que los elementos dentro del contenedor ocupan, para realizar el calculo del scroll
    self.total_w = self.w
    self.total_h = self.h

    self.node = node
    self.node_x = 0
    self.node_y = 0

    self.margin = 0

    node:addContainer(self)

    --la posición del contenedor dentro del padre
    self.x = 0
    self.y = 0

    self.allowScroll = false
    self.scrollOffset = 0 --que tanto se recorre el contenido con la scroll bar

    self.scrollbar_w = 15 --tamaño fijo
    self.scrollbar_h = self.h
    self.scrollbar_x = 0
    self.scrollbar_y = 0

    self.thumb_h = self.scrollbar_h
    self.thumb_x = self.scrollbar_x
    self.thumb_y = self.scrollbar_y
    self.thumbHovered = false

    self.thumbOffset = 0
    self.draggingThumb = false

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

        if self.allowScroll then
            self:drawScrollbar()
        end

    love.graphics.setCanvas(current)
end

function Container:drawChildren()

    for _, container in ipairs(self.node.children) do

        if container.node.ignoredByLayout == false and container.node.visible and container.node.managed then
            container:drawToCanvas()

            love.graphics.draw(
                container.canvas,
                container.x + container.margin,
                --container.y + container.margin
                container.y + container.margin - self.scrollOffset
            )

            --[[genuinamente no entiendo por qué el scroll funciona solo restandole el offset al dibujar el canvas obtenido de los hijos,
            el canvas del layout no tiene un tamaño mayor al del contenedor, el contenido fuera del alto del layout se recorta y no se ve,
            por lo que al recorrer con scrollOffset todo lo que está fuera del layout simplemente deberia de no verse, PERO SI LO HACE]]
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

function Container:drawScrollbar()
    love.graphics.push("all")

    love.graphics.setColor(Color.DARK_GRAY)
    love.graphics.rectangle("fill",
        self.scrollbar_x, self.scrollbar_y,
        self.scrollbar_w, self.scrollbar_h
    )

    love.graphics.setColor(Color.WHITE)
    love.graphics.rectangle("fill",
        self.thumb_x, self.thumb_y,
        self.scrollbar_w, self.thumb_h,
        10
    )

    love.graphics.pop()
end



function Container:updateScrollbar()
    local f = self.h / self.total_h
    self.thumb_h = f * self.scrollbar_h

    if self.thumb_h > self.scrollbar_h then
        self.thumb_h = self.scrollbar_h
    end

    self.thumb_x = self.scrollbar_x
    --self.thumb_y = self.scrollbar_y

    self:checkScrollbarThumbHovered()

    if self.thumbHovered then
        love.mouse.setCursor(self.node.handCursor)
    end

    if love.mouse.isDown(1) then

        if self.thumbHovered and not self.draggingThumb then
            self.draggingThumb = true
            self.thumbOffset = love.mouse.getY() - self.thumb_y
        end

        if  self.draggingThumb then
            self.thumb_y = love.mouse.getY() - self.thumbOffset
        end

        if self.thumb_y < self.scrollbar_y then
            self.thumb_y = self.scrollbar_y
        elseif self.thumb_y + self.thumb_h > self.scrollbar_y + self.scrollbar_h then
            self.thumb_y = self.scrollbar_y + self.scrollbar_h - self.thumb_h
        end

    else
        self.draggingThumb = false
    end

    self:applyScroll()
end

function Container:checkScrollbarThumbHovered()
    local thumb_x, thumb_y = self.thumb_x, self.thumb_y

    local parent = self.node

    while parent ~= nil do
        local container = parent.container

        thumb_x = thumb_x + container.node_x + container.x
        thumb_y = thumb_y + container.node_y + container.y

        if parent:has("parent") then
            parent = parent.parent
        else
            break
        end
    end

    thumb_x = thumb_x + self.node.ui.x
    thumb_y = thumb_y + self.node.ui.y

    local mx, my = love.mouse.getPosition()

    self.thumbHovered =
        mx >= thumb_x and
        mx <= thumb_x + self.scrollbar_w and
        my >= thumb_y and
        my <= thumb_y + self.thumb_h

end

function Container:applyScroll()
    local offsetFactor = (self.thumb_y - self.scrollbar_y) / self.scrollbar_h

    self.scrollOffset = offsetFactor * self.total_h
end



function Container:setPos(x, y)
    self.x = x
    self.y = y

    self:setSCrollbarPos()
end

function Container:GetPos()
    return self.x, self.y
end

function Container:setDimensions(w, h)
    if w <= 0 then w = 1 end
    if h <= 0 then h = 1 end

    self.w = math.floor(w)
    self.h = math.floor(h)

    --self.total_w = self.w
    --self.total_h = self.h

    self:setSCrollbarPos()

    self.canvas = love.graphics.newCanvas(self.w, self.h)
    self.canvas:setFilter("nearest", "nearest")
end

function Container:getDimensions()
    return math.floor(self.w - self.margin * 2) ,
        math.floor(self.h - self.margin * 2)
end

--dimensiones reales sin considerar los margenes
function Container:getRealDimensions()
    return self.w, self.h
end


function Container:setSCrollbarPos()
    self:setSCrollbarDimensions()
    self.scrollbar_x = self.w - self.scrollbar_w
    self.scrollbar_y = self.h / 2 - self.scrollbar_h / 2

    self.thumb_x = self.scrollbar_x
    self.thumb_y = self.scrollbar_y
end

function Container:setSCrollbarDimensions()
    --el ancho es un tamaño fijo
    self.scrollbar_w = 15
    self.scrollbar_h = self.h * 0.95
end

return Container