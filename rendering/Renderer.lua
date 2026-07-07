local r = {}

r.vertices = nil
r.faces = nil

--datos para las transformaciones y renderizado
r.showVertices = false
r.angle = 0
r.objDistance = 600

--asignar vertices y caras
function r:setObj(vertices, faces)
    self.vertices = vertices
    self.faces = faces

    for i, vertex in ipairs(self.vertices) do
        print("vertice " .. i)
        print("x: " .. vertex.x .. "\ny: " .. vertex.y .. "\nz: " .. vertex.z .. "\n")
    end
end



function r:update(dt)
    if self.vertices == nil or self.faces == nil then
        return
    end

    --[[CONTROLES PARA DEBUG]]

    local spinVelocity = math.pi / 2
    local translateVelocity = 100

    if love.mouse.isDown(1) then
        self.angle = (self.angle + spinVelocity * dt) % (2 * math.pi)
    elseif love.mouse.isDown(2) then
        self.angle = (self.angle - spinVelocity * dt) % (2 * math.pi)
    end

    if love.keyboard.isDown("up") then
        self.objDistance = self.objDistance + translateVelocity * dt
    elseif love.keyboard.isDown("down") then
        self.objDistance = self.objDistance - translateVelocity * dt
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