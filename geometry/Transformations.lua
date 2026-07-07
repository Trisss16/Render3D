local t = {}

function t:rotate_xy(vertex, angle)
    local x = vertex.x
    local y = vertex.y
    local z = vertex.z

    local sin = math.sin(angle)
    local cos = math.cos(angle)

    local rotated_x = x * cos - y * sin
    local rotated_y = x * sin + y * cos

    return Vertex(rotated_x, rotated_y, z)
end

function t:rotate_xz(vertex, angle)
    local x = vertex.x
    local y = vertex.y
    local z = vertex.z

    local sin = math.sin(angle)
    local cos = math.cos(angle)

    local rotated_x = x * cos - z * sin
    local rotated_z = x * sin + z * cos

    return Vertex(rotated_x, y, rotated_z)
end

function t:translate(vertex, tx, ty, tz)
    return Vertex(vertex.x + tx, vertex.y + ty, vertex.z + tz)
end

function t:project2D(vertex)
    return Point2D(vertex.x / vertex.z, vertex.y / vertex.z)
end

return t