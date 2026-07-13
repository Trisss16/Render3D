local Matrix = Class:create()

function Matrix:new(matrix)
    self.matrix = matrix
    self:validateMatrix()
end

function Matrix:validateMatrix()
    self.rows = #self.matrix

    if self.rows <= 0 then
        error("Matriz invalida", 1)
    end

    self.columns = #self.matrix[1]

    for i, row in ipairs(self.matrix) do
        if type(row) ~= "table" then
            error(("Matriz invalida, la fila %d no es una tabla."):format(i), 1)
        end

        if #row ~= self.columns then
            error(("Matriz invalida, la fila %d tiene un tamaño diferente."):format(i), 1)
        end
    end
end

function Matrix:get(row, column)
    return self.matrix[row][column]
end

function Matrix:getDimensions()
    return self.rows, self.columns
end

function Matrix:print()
    for i = 1, self.rows do

        local str = ""

        for j = 1, self.columns do
            str = str .. string.format("%.1f\t", self.matrix[i][j])
        end

        print(str)
    end
end


--[[METAMETODOS ARITMETICOS]]

function Matrix.__add(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        error("Suma de matrices invalida.", 1)
    end

    if a.rows ~= b.rows or a.columns ~= b.columns then
        error("Suma de matrices invalida, las matrices no pueden tener diferentes dimensiones.", 1)
    end

    local new = {}

    for i = 1, a.rows do
        new[i] = {}
        for j = 1, a.columns do
            new[i][j] = a:get(i,j) + b:get(i,j)
        end
    end

    return Matrix(new)
end

function Matrix.__mul(a, b)

    if type(a) == "number" then
        return Matrix.scalar(a, b)
    elseif type(b) == "number" then
        return Matrix.scalar(b, a)
    end

    if a.columns ~= b.rows then
        error("Multiplicación de matrices invalida.", 1)
    end

    return Matrix.mult(a, b)
end

function Matrix.scalar(scalar, matrix)
    local new = {}

    local r, c = matrix:getDimensions()

    for i = 1, r do
        new[i] = {}

        for j = 1, c do
            new[i][j] = matrix:get(i, j) * scalar
        end
    end

    return Matrix(new)
end

function Matrix.mult(a, b)
    local new = {}

    for i = 1, a.rows do
        new[i] = {}

        for j = 1, b.columns do
            local sum = 0

            for k = 1, a.columns do
                sum = sum + a:get(i, k) * b:get(k, j)
            end

            new[i][j] = sum
        end
    end

    return Matrix(new)
end

return Matrix