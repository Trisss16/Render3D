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

-- Con matrices

    -- Matriz de traslacion 
function t:translate_matrix(tx, ty, tz)
    return Matrix({
        {1, 0, 0, tx},
        {0, 1, 0, ty},
        {0, 0, 1, tz},
        {0, 0, 0, 1}
    })
end

    -- Matriz de escalamiento
function t:escale_matrix(sx, sy, sz)
    return Matrix({
        {sx, 0, 0, 0},
        {0, sy, 0, 0},
        {0, 0, sz, 0},
        {0, 0, 0, 1}
    })
end

    -- Matriz de rotacion
function t:rotateXY_matrix(angle)
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    return Matrix({
        {cos, -sin, 0, 0},
        {sin, cos, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    })
end

function t:rotateXZ_matrix(angle)
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    return Matrix({
        {cos, 0, sin, 0},
        {0, 1, 0, 0},
        {-sin, 0, cos, 0},
        {0, 0, 0, 1}
    })
end

function t:rotateYZ_matrix(angle)
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    return Matrix({
        {1, 0, 0, 0},
        {0, cos, -sin, 0},
        {0, sin, cos, 0},
        {0, 0, 0, 1}
    })
end

    -- Matriz de sesgado
function t:ShearXY_matrix(shxz, shyz)
    return Matrix ({
        {1, 0, shxz, 0},
        {0, 1, shyz, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    })
end

function t:ShearXZ_matrix(shxy, shzy)
    return Matrix ({
        {1, shxy, 0, 0},
        {0, 1, 0, 0},
        {0, shzy, 1, 0},
        {0, 0, 0, 1}
    })
end

function t:ShearYZ_matrix(shyx, shzx)
    return Matrix ({
        {1, 0, 0, 0},
        {shyx, 1, 0, 0},
        {shzx, 0, 1, 0},
        {0, 0, 0, 1}
    })
    
end

return t
