local Vertex = Class:create()

function Vertex:new(vector)
    self:setVector(vector)
end

function Vertex:setVector(vector)
    if vector.rows ~= 4 or vector.columns ~= 1 then
        error("Vector invalido.")
    end

    self.vector = vector

    self.x = vector:get(1, 1)
    self.y = vector:get(2, 1)
    self.z = vector:get(3, 1)
end

return Vertex