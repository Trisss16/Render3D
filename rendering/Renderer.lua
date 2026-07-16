local Point2D = require "rendering.Point2D"
local Vertex = require "rendering.Vertex"
local Polygon = require "rendering.Polygon"

local r = {}

--canvas
r.canvas_w = 100
r.canvas_h = 100
r.canvas_x = 0
r.canvas_y = 0
r.canvas = love.graphics.newCanvas(r.canvas_w, r.canvas_h)

r.camera = Matrix({
    {0},
    {0},
    {0},
    {1}
})

--objeto
r.vertices = nil
r.faces = nil
r.transformedVertices = nil

--datos para las transformaciones y renderizado
r.showVertices = false
r.XZAngle = 0
r.YZAngle = 0
r.objDistance = 1
r.near = 1

r.zoomVelocity = 0
r.spinVelocity = 0

--asignar vertices y caras
function r:setObj(vertices, faces)
    self.vertices = vertices
    self.faces = faces

    self:getRenderingData()
    self:resetInputs()

    --crea las tablas para los vertices transformados y los poligonos una sola vez
    self.transformedVertices = {}
    for i, _ in ipairs(self.vertices) do
        local v = Matrix({{0}, {0}, {0}, {0}})
        self.transformedVertices[i] = Vertex(v)
    end
end

function r:setPosAndDimensions(w, h, x, y)
    self.canvas_w = w
    self.canvas_h = h
    self.canvas_x = x
    self.canvas_y = y
    self.canvas = love.graphics.newCanvas(r.canvas_w, r.canvas_h)
    self.canvas:setFilter("nearest", "nearest")

    Point2D.SCREEN_WIDTH = w
    Point2D.SCREEN_HEIGHT = h
    Point2D:getAspectRatio()
end

function r:getRenderingData()
    local low_w, high_w = 0, 0
    local low_h, high_h = 0, 0
    local low_d, high_d = 0, 0

    for i, vertex in ipairs(self.vertices) do
        if vertex.x < low_w then
            low_w = vertex.x
        elseif vertex.x > high_w then
            high_w = vertex.x
        end

        if vertex.y < low_h then
            low_h = vertex.y
        elseif vertex.y > high_h then
            high_h = vertex.y
        end

        if vertex.z < low_d then
            low_d = vertex.z
        elseif vertex.z > high_d then
            high_d = vertex.z
        end

        print("vertice " .. i)
        print("x: " .. vertex.x .. "\ny: " .. vertex.y .. "\nz: " .. vertex.z .. "\n")
    end

    self.width = high_w - low_w
    self.height = high_h - low_h
    self.depth = high_d - low_d

    if self.depth > self.width then
        self.wide = self.depth
    else
        self.wide = self.width
    end

    self.zoomVelocity = self.wide * 1.5
    self.spinVelocity = math.pi / 2
end

function r:resetInputs()
    self.objDistance = self.wide * 2
    self.XZAngle = 0
    self.YZAngle = 0
end



function r:update(dt)
    if self.vertices == nil or self.faces == nil then
        return
    end

    --matrices para las transformaciones
    local rotationXZ = t:rotateXZ_matrix(self.XZAngle)
    local rotationYZ = t:rotateYZ_matrix(self.YZAngle)
    local translation = t:translate_matrix(0, 0, self.objDistance)
    self.transform = translation * rotationYZ * rotationXZ

    --aplica las transformaciones y guarda los vertices dentro de una nueva lista
    self:applyTransformations()

    --construye los polígonos en base a los vertices transformados
    self:getPolygons()

    --organiza los vertices, de más cercano a más lejano
    self:sortPolygons()

    --calcula el producto punto de la normal del polígonos con respecto a la dirección con la camara para decidir que caras se dibujan
    self:getPolygonsDotProduct()
end

function r:draw()
    if self.vertices == nil or self.faces == nil then
        return
    end

    love.graphics.push("all")
    love.graphics.setCanvas(self.canvas)

        love.graphics.clear()

        self:drawFaces()

    love.graphics.setCanvas()
    love.graphics.pop()

    love.graphics.draw(self.canvas, self.canvas_x, self.canvas_y)
end

function r:drawFaces()
    for _, polygon in ipairs(self.polygons) do
        if not polygon.behind and polygon.dp < 0 then
            love.graphics.setColor(-polygon.dp, -polygon.dp, -polygon.dp)
            love.graphics.polygon("fill", polygon.vertices2D)
        end
    end
end



--aplica todas las transformaciones a un vertice para poder visualizarlo correctamente
function r:applyTransformations()
    for i, v in ipairs(self.vertices) do
        local vector = self.transform * v.vector
        self.transformedVertices[i]:setVector(vector)
    end
end

function r:getPolygons()
    self.polygons = {}

    for i, face in ipairs(self.faces) do
        local vertices = {}

        for j, vertexIndex in ipairs(face) do
            vertices[j] = self.transformedVertices[vertexIndex]
        end

        self.polygons[i] = Polygon(vertices)
    end
end

function r:sortPolygons()
    table.sort(self.polygons, function (a, b)
        return b.centerZ < a.centerZ
    end)
end

function r:getPolygonsDotProduct()
    for _, polygon in ipairs(self.polygons) do

        if polygon.behind then
            goto continue
        end

        --[[al calcular el producto punto entre la normal de un polígono y el vector desde la camara hacia el vertice (toCamera), se puede saber 
        que tan grande es la apertura entre estos dos, lo que sirve para asignarle un sombreado, además de un decidir cual lado del polígono se
        dibuja, dependiendo de la posición de la camara.]]
        local normal = polygon.normal
        local toCamera = Vectors:unitVector(polygon.vertices[1].vector - self.camera)

        polygon.dp = Vectors:dotProduct(normal, toCamera)

        if polygon.dp > 0 then
            goto continue
        end

        --obtener la tabla de vertices en 2D para el dibujado en draw
        local s = #polygon.vertices
        polygon.vertices2D = {}

        for i = 1, s do
            --proyectar el vertice 3D a coordenadas en 2D
            local p1 = self:project2D(polygon.vertices[i])

            table.insert(polygon.vertices2D, p1.screen_x)
            table.insert(polygon.vertices2D, p1.screen_y)
        end

        ::continue::
    end
end

function r:project2D(vertex)
    return Point2D(vertex.x / vertex.z, vertex.y / vertex.z)
end

return r