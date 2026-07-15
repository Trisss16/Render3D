local r = {}

--canvas
r.canvas_w = 100
r.canvas_h = 100
r.canvas_x = 0
r.canvas_y = 0
r.canvas = love.graphics.newCanvas(r.canvas_w, r.canvas_h)

--objeto
r.vertices = nil
r.faces = nil
r.transformedVertices = nil

--datos para las transformaciones y renderizado
r.showVertices = false
r.XZAngle = 0
r.YZAngle = 0
r.objDistance = 1

--asignar vertices y caras
function r:setObj(vertices, faces)
    self.vertices = vertices
    self.faces = faces

    self:getRenderingData()
    self:resetInputs()
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



function r:update(dt)
    if self.vertices == nil or self.faces == nil then
        return
    end

    --evita que el modelo se acerque demasiado al plano de la camara
    if self.objDistance < self.wide then
        self.objDistance = self.wide
    end

    --matrices para las transformaciones
    self.transform = {}
    self.transform.rotationXZ = t:rotateXZ_matrix(self.XZAngle)
    self.transform.rotationYZ = t:rotateYZ_matrix(self.YZAngle)
    self.transform.translation = t:translate_matrix(0, 0, self.objDistance)

    --aplica las transformaciones y guarda los vertices dentro de una nueva lista
    self:applyTransformations()
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
    for _, face in ipairs(self.faces) do

        local s = #face

        for i = 1, s do
            local v1 = self.transformedVertices[ face[ i ] ]
            local v2 = self.transformedVertices[ face[ i % s + 1] ]

            local p1 = self:project2D(v1)
            local p2 = self:project2D(v2)

            love.graphics.line(p1.screen_x, p1.screen_y, p2.screen_x, p2.screen_y)
        end

    end

end



--aplica todas las transformaciones a un vertice para poder visualizarlo correctamente
function r:applyTransformations()
    self.transformedVertices = {}

    for _, v in ipairs(self.vertices) do
        local vector = self.transform.translation * self.transform.rotationYZ * self.transform.rotationXZ * v.vector
        table.insert(self.transformedVertices, Vertex(vector))
    end
end


function r:project2D(vertex)
    return Point2D(vertex.x / vertex.z, vertex.y / vertex.z)
end

function r:resetInputs()
    self.objDistance = self.wide * 3
    self.XZAngle = 0
    self.YZAngle = 0
end

return r