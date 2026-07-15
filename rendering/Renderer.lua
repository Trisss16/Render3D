local r = {}

r.vertices = nil
r.faces = nil

--datos para las transformaciones y renderizado
r.showVertices = false
r.angle = 0
r.objDistance = 1

--asignar vertices y caras
function r:setObj(vertices, faces)
    self.vertices = vertices
    self.faces = faces

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

    self:getVelocities()
end

function r:getVelocities()
    if self.depth > self.width then
        self.wide = self.depth
    else
        self.wide = self.width
    end

    self.zoomVelocity = self.wide * 1.5
    self.objDistance = self.wide * 3

    self.spinVelocity = math.pi / 2
end



function r:update(dt)
    if self.vertices == nil or self.faces == nil then
        return
    end

    --[[CONTROLES PARA DEBUG]]

    if love.mouse.isDown(1) then
        self.angle = (self.angle - self.spinVelocity * dt) % (2 * math.pi)
    elseif love.mouse.isDown(2) then
        self.angle = (self.angle + self.spinVelocity * dt) % (2 * math.pi)
    end

    if love.keyboard.isDown("up") then
        self.objDistance = self.objDistance + self.zoomVelocity * dt
    elseif love.keyboard.isDown("down") then
        self.objDistance = self.objDistance - self.zoomVelocity * dt
    end
end

function r:draw()
    if self.vertices == nil or self.faces == nil then
        return
    end

    if self.showVertices then self:drawVertices() end
    self:drawFaces()
end

function r:drawVertices()
    for _, vertex in ipairs(self.vertices) do
        local transform = self:applyTransformations(vertex)

        local projected = t:project2D(transform)
        projected:draw()
    end
end

function r:drawFaces()
    for _, face in ipairs(self.faces) do

        local s = #face

        for i = 1, s do
            local v1 = self.vertices[ face[ i ] ]
            local v2 = self.vertices[ face[ i % s + 1] ]

            v1 = self:applyTransformations(v1)
            v2 = self:applyTransformations(v2)

            local p1 = t:project2D(v1)
            local p2 = t:project2D(v2)

            love.graphics.line(p1.screen_x, p1.screen_y, p2.screen_x, p2.screen_y)
        end

    end

end



--aplica todas las transformaciones a un vertice para poder visualizarlo correctamente
function r:applyTransformations(vertex)
    --rotación constante
    local transform = t:rotate_xz(vertex, self.angle)

    --alejar el objeto para que entre en el campo de visión
    transform = t:translate(transform, 0, 0, self.objDistance)

    return transform
end

return r