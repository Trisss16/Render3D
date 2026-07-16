local v = {}

function v:magnitude(a)
    return math.sqrt( a:get(1, 1)^2 + a:get(2, 1)^2 + a:get(3, 1)^2 )
end

function v:unitVector(a)
    local magnitude = self:magnitude(a)

    return Matrix({
        { a:get(1, 1) / magnitude },
        { a:get(2, 1) / magnitude },
        { a:get(3, 1) / magnitude },
        {1}
    })
end

function v:dotProduct(a, b)
    return
        a:get(1, 1) * b:get(1, 1) +
        a:get(2, 1) * b:get(2, 1) +
        a:get(3, 1) * b:get(3, 1)
end

function v:crossProduct(a, b)
    local x = a:get(2, 1) * b:get(3, 1) - a:get(3, 1) * b:get(2, 1)
    local y = a:get(3, 1) * b:get(1, 1) - a:get(1, 1) * b:get(3, 1)
    local z = a:get(1, 1) * b:get(2, 1) - a:get(2, 1) * b:get(1, 1)

    return Matrix({
        {x},
        {y},
        {z},
        {1}
    })
end

return v