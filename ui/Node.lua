local Container = require "ui.Container"


local Node = Class:create()

function Node:new(w, h)
    --las dimensiones reales, en pixeles
    self.w = 1
    self.h = 1

    --dimensiones relativas, de 0 a 1, siendo 1 el tamaño de la ui.
    self.relative_w = 0.1
    self.relative_h = 0.05

    --el tamaño de la ui se asigna hasta que se agregue un nodo padre
    self.ui_w = 0
    self.ui_h = 0

    --mismo caso con el tamaño del contenedor
    self.container_w = 0
    self.container_h = 0

    self.isFocused = false
    self.cursor = love.mouse.getSystemCursor("hand")

    self.hovered = false
    self.pressed = false

    self.root = nil --primer nodo
    self.ui = nil
    self.container = nil --contenedor (se crea automaticamente al asignarle un padre)
    self.parent = nil --nodo padre

    self.debugActive = false

    self.children = {} --lista de los hijos de este nodo

    self.canvas = love.graphics.newCanvas(self.w, self.h)
end



function Node:setDebugActive(debugActive)
    if not type(debugActive) == "boolean" then
        debugActive = false
    end

    self.debugActive = debugActive
end



--[[updateNode actualiza datos importantes para el funcionamiento del nodo. Cada frame se llama a
este método para todos los nodos en la ui]]
function Node:updateNode(dt)
    --actualizar el tamaño del contenedor
    if self.container ~= nil then
        self.container_w = self.container.w
        self.container_h = self.container.h
    end

    --actualizar el tamaño de la ui
    if self.ui ~= nil then
        self.ui_w = self.ui.w
        self.ui_h = self.ui.h
    end

    if self.ui ~= nil and self.container ~= nil then
       self:checkHovered()
    end
end

--[[este update es para las funcionalidades especificas de un componente, se sobreescribe en las
subclases. Este método unicamente se llama cuando el nodo tiene el focus]]
function Node:update(dt)
end



function Node:drawToCanvas()
    local current = love.graphics.getCanvas()
    love.graphics.push("all")

    love.graphics.setCanvas(self.canvas)

        love.graphics.clear(0, 0, 0, 0)
        self:draw()

    love.graphics.pop() --regresa al estado gráfico guardado antes de dibujar en el nodo
    love.graphics.setCanvas(current)
end

function Node:draw()
    if self.debugActive then
        self:placeholder()
    end
end

function Node:placeholder()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
end



function Node:setParent(parent, root, ui)
    self.parent = parent
    self.root = root
    self.ui = ui

    self.ui_w = ui.w
    self.ui_h = ui.h
    self:resize()
end

function Node:addChild(child)
    --[[cuando se agrega un nodo al arbol de componentes siempre se va a guardar la referencia al
    nodo raiz. Si no la tiene el nodo aún no ha sido agregado, por lo que no permite agregarle hijos]]

    if self.root == nil then
        return
    end

    child:setParent(self, self.root)

    local childContainer = Container(1, 1, child)
    table.insert(self.children, childContainer)

    --[[todo nodo puede tener hijos, pero es responsabilidad de las subclases decidir si se renderizan y como se hace.
    Usando la clase Node se pueden crear layouts que hereden de esta e implementen una forma de mostrar todos los hijos,
    o se pueden crear componentes que unicamente se muestren a si mismos.]]
end



--[[las dimensiones funcionan en base al porcentaje del tamaño del nodo raiz, siendo 1 la dimensión del nodo raíz, tanto en x como en y.]]
function Node:setDimensions(relative_w, relative_h)
    self.relative_w = relative_w
    self.relative_h = relative_h
    self:resize()
end

function Node:resize()
    self.w = self.relative_w * self.ui_w
    self.h = self.relative_h * self.ui_h

    self.canvas = love.graphics.newCanvas(self.w, self.h)
end



--cada subclase decide que hacer en el momento en el que pierde el focus sobreescribiendo el método
function Node:unfocus()
end



function Node:checkHovered()
    local gx, gy, gw, gh = self:getGlobalPos()
    local mx, my = love.mouse.getPosition()

    self.hovered =
    mx >= gx and
    mx <= gx + gw and
    my >= gy and
    my <= gy + gh

    self.pressed = self.hovered and love.mouse.isDown(1)

    if self.hovered then
        love.mouse.setCursor(self.cursor)
    else
        love.mouse.setCursor()
    end
end

--posición global
function Node:getGlobalPos()
    local node = self

    local total_x = 0
    local total_y = 0

    local total_w = self.w
    local total_h = self.h

    while(node ~= nil) do
        local container = node.container

        container:getNodePos()
        local node_x = container.node_x
        local node_y = container.node_y

        --si el nodo se sale del limite de su contenedor se ajusta, para no considerar partes invisibles

        if node_x < 0 then
            node_x = 0
            total_w = container.w
        elseif node_x > container.w then
            node_x = container.w
            total_w = container.w
        end

        if node_y < 0 then
            node_y = 0
            total_h = container.h
        elseif node_y > container.h then
            node_y = container.h
            total_h = container.h
        end

        local container_x = container.x
        local container_y = container.y

        total_x = total_x + node_x + container_x
        total_y = total_y + node_y + container_y

        if node:has("parent") then
            node = node.parent
        else
            break
        end
    end

    total_x = total_x + self.ui.x
    total_y = total_y + self.ui.y

    return total_x, total_y,  total_w, total_h
end

return Node