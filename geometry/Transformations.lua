local t = {}

    -- Matriz de traslacion 
function t:translate_matrix(tx, ty, tz)
    return Matrix({
        {1, 0, 0, tx},
        {0, 1, 0, ty},
        {0, 0, 1, tz},
        {0, 0, 0,  1}
    })
end

    -- Matriz de escalamiento
function t:escale_matrix(sx, sy, sz)
    return Matrix({
        {sx,  0,  0, 0},
        { 0, sy,  0, 0},
        { 0,  0, sz, 0},
        { 0,  0,  0, 1}
    })
end

    -- Matriz de rotacion
function t:rotateXY_matrix(angle)
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    return Matrix({
        {cos, -sin, 0, 0},
        {sin,  cos, 0, 0},
        {  0,    0, 1, 0},
        {  0,    0, 0, 1}
    })
end

function t:rotateXZ_matrix(angle)
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    return Matrix({
        { cos, 0, sin, 0},
        {   0, 1,   0, 0},
        {-sin, 0, cos, 0},
        {   0, 0,   0, 1}
    })
end

function t:rotateYZ_matrix(angle)
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    return Matrix({
        {1,   0,    0, 0},
        {0, cos, -sin, 0},
        {0, sin,  cos, 0},
        {0,   0,    0, 1}
    })
end

--sesgado en el eje x
function t:ShearX_matrix(shy, shz)
    return Matrix ({
        {  1, 0, 0, 0},
        {shy, 1, 0, 0},
        {shz, 0, 1, 0},
        {  0, 0, 0, 1}
    })
end

--sesgado en el eje y
function t:ShearY_matrix(shx, shz)
    return Matrix ({
        {1, shx, 0, 0},
        {0,   1, 0, 0},
        {0, shz, 1, 0},
        {0,   0, 0, 1}
    })
end

--sesgado en el eje z
function t:ShearZ_matrix(shx, shy)
    return Matrix ({
        {1, 0, shx, 0},
        {0, 1, shy, 0},
        {0, 0,    1, 0},
        {0, 0,    0, 1}
    })
end

return t
