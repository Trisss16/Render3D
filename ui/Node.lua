local Container = require "ui.Container"


local Node = Class:create()

function Node:new()
    --las dimensiones reales, en pixeles
    self.w = 1
    self.h = 1

    --dimensiones relativas, de 0 a 1, siendo 1 el tamaño de la ui.
    self.relative_w = 0.1
    self.relative_h = 0.05
    self.ignoreRelative = false

    --el tamaño de la ui se asigna hasta que se agregue un nodo padre
    self.ui_w = 0
    self.ui_h = 0

    --mismo caso con el tamaño del contenedor
    self.container_w = 0
    self.container_h = 0

    self.isFocused = false
    self.focusable = true
    self.handCursor = love.mouse.getSystemCursor("hand")

    self.hovered = false --mouse sobre el nodo
    self.pressed = false --mouse sobre el nodo mientras se presiona el click
    self.clicked = false --mouse sigue en el nodo después de presionar y soltar

    self.managed = true
    self.visible = true

    self.root = nil --primer nodo
    self.ui = nil
    self.container = nil --contenedor (se crea automaticamente al asignarle un padre)
    self.parent = nil --nodo padre

    --falso por defecto. Cuando es true, se llama a los métodos para actualizar y dibujar a los hijos del nodo. Activar para crear layouts
    self.manageChildren = false

    --[[para las implementaciones de layouts, define si un layout ignora un nodo. tanto managed como visible son variables que unicamente el
    usuario puede modificar. En cambio, ignoredByLayout puede ser modificada por el propio layout según la implementación]]
    self.ignoredByLayout = false

    self.debugActive = false

    self.children = {} --lista de los hijos de este nodo

    self.canvas = love.graphics.newCanvas(self.w, self.h)
end



function Node:setDebugActive(debugActive)
    if not type(debugActive) == "boolean" then
        debugActive = false
        return
    end

    self.debugActive = debugActive
end



--[[updateNode actualiza datos importantes para el funcionamiento del nodo. Cada frame se llama a
este método para todos los nodos en la ui]]
function Node:updateNode(dt)
    --actualizar el tamaño del contenedor
    if self.container ~= nil then
        self.container_w, self.container_h = self.container:getDimensions()
    end

    --actualizar el tamaño de la ui
    if self.ui ~= nil then
        self.ui_w, self.ui_h = self.ui:getDimensions()
    end

    if self.ui ~= nil and self.container ~= nil then
       self:checkHovered()
    end

    if self.focusable then
        self:setCursor()
    end

    --actualiza los nodos hijos recursivamente
    if self.manageChildren then
        self:updateChildren(dt)
    end
end

function Node:updateChildren(dt)
    for _, container in ipairs(self.children) do
        if container.node.managed then
            container.node:updateNode(dt)
        end
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
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
end



function Node:setParent(parent, root, ui)
    self.parent = parent
    self.root = root
    self.ui = ui

    self.ui_w, self.ui_h = self.ui:getDimensions()
    self:resize()
end

function Node:addChildren(...)
    --[[cuando se agrega un nodo al arbol de componentes siempre se va a guardar la referencia al
    nodo raiz. Si no la tiene el nodo aún no ha sido agregado, por lo que no permite agregarle hijos]]
    if not self:has("root") then
        error("El nodo no tiene padre, no se pueden agregar hijos.", 1)
    end

    local args = {...}

    for _, child in ipairs(args) do
        child:setParent(self, self.root, self.ui)
        local childContainer = Container(1, 1, child)
        table.insert(self.children, childContainer)

        child:resize()
    end

    --[[todo nodo puede tener hijos, pero es responsabilidad de las subclases decidir si se renderizan y como se hace. Por
    defecto, un nodo no tiene la capacidad de renderizar sus propios hijos (manageChildren). Usando la clase Node se pueden
    crear layouts que hereden de esta e implementen una forma de mostrar todos los hijos, o se pueden crear componentes que
    unicamente se muestren a si mismos.]]
end



--[[las dimensiones funcionan en base al porcentaje del tamaño del nodo raiz, siendo 1 la dimensión del nodo raíz, tanto en x como en y.]]
function Node:setRelativeDimensions(relative_w, relative_h)
    self.relative_w = relative_w
    self.relative_h = relative_h
    self:resize()
end

function Node:setPixelDimensions(pixel_w, pixel_h)
    self.w = pixel_w
    self.h = pixel_h
    self:resize()
end

function Node:resize()
    if not self.ignoreRelative then
        self.w = self.relative_w * self.ui_w
        self.h = self.relative_h * self.ui_h
    end

    if self.w <= 0 then
        self.w = 1
    end
    if self.h <= 0 then
        self.h = 1
    end

    self.canvas = love.graphics.newCanvas(self.w, self.h)
end

function Node:addContainer(container)
    self.container = container
    self.container_w, self.container_h = container:getDimensions()
    self:resize()
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
end

function Node:setCursor()
    if self.hovered then
        love.mouse.setCursor(self.handCursor)
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