local Point2D = require "rendering.Point2D"

local Polygon = Class:create()

Polygon.near = 0.1 --donde se hace el corte

function Polygon:new(vertices, camera)
    self.vertices = vertices

    self.behind = true
    self.centerZ = 0

    for _, v in ipairs(self.vertices) do
        if v.z > 0 then
            self.centerZ = self.centerZ + v.z
            self.behind = false
        end
    end

    self.centerZ = self.centerZ / #self.vertices

    self:getNormal()
end

function Polygon:getNormal()
    --local a = self.vertices[2].vector - self.vertices[1].vector
    --local b = self.vertices[3].vector - self.vertices[1].vector

    local a = self.vertices[2].vector - self.vertices[1].vector
    local b = self.vertices[3].vector - self.vertices[1].vector

    self.normal = Vectors:crossProduct(a, b)
    self.normal = Vectors:unitVector(self.normal) --lo vuelve unitario
end


return Polygon