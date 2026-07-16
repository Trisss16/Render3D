local a = {}

function a:loadModel(path, renderer)
    if type(path) ~= "string" then
        print("Ruta invalida.")
        return
    end

    self.path = utf8.replace(path, {["\\"] = "/", ["\""] = ""}) --pasa el path al formato que lua usa

    self.renderer = renderer

    print(self.path)

    local foundFile = self:getContent()

    if not foundFile then
        return
    end

    local vertices = self:extractVertices()
    local faces = self:extractFaces()

    renderer:setObj(vertices, faces)
end

function a:getContent()
    local file = io.open(self.path, "r")

    if file == nil then
        print("No se encontro el archivo")
        return false
    end

    self.vStr = {}
    self.fStr = {}

    for line in file:lines() do
        --guarda los vertices
        if utf8.split(line, " ")[1] == "v" then
            table.insert(self.vStr, utf8.sub(line, 3))
        end

        --guarda las caras
        if utf8.split(line, " ")[1] == "f" then
            table.insert(self.fStr, utf8.sub(line, 3))
        end
    end

    file:close()

    return true
end

function a:extractVertices()
    local vertices = {}

    for _, str in ipairs(self.vStr) do
        local values = utf8.split(str, " ")

        --comprueba que todos los valores son números validos
        if tonumber(values[1]) and tonumber(values[2]) and tonumber(values[3]) then

            local vector = Matrix({
                {tonumber(values[1])},
                {tonumber(values[2])},
                {tonumber(values[3])},
                {1}
            })

            table.insert(vertices, Vertex(vector))

        end
    end

    return vertices
end

function a:extractFaces()
    local faces = {}

    for _, str in ipairs(self.fStr) do
        local values = utf8.split(str, " ")

        local face = {}

        for _, value in ipairs(values) do
            local vertexNum = utf8.split(value, "/")[1]

            if tonumber(vertexNum) then
                table.insert(face, tonumber(vertexNum))
            end
        end

        table.insert(faces, face)
    end

    return faces
end

function a:saveChanges()
    if not self.renderer then
        print("no se ha cargado un modelo.")
        return
    end

    local file = io.open(self.path, "r")
    if file == nil then
        print("No se encontro el archivo")
        return false
    end

    local content = {}

    for line in file:lines() do
        table.insert(content, line)
    end

    file:close()

    --escribir los nuevos vertices

    local transformed = self:getTransformedVertices()
    local ctr = 1

    for i, str in ipairs(content) do
        if utf8.split(str, " ")[1] == "v" then
            content[i] = transformed[ctr]
            ctr = ctr + 1
        end
    end

    --vuelve a abrir el archivo en modo escritura

    file = io.open(self.path, "w")
    if file == nil then
        print("No se encontro el archivo")
        return false
    end

    for _, str in ipairs(content) do
        file:write(str .. "\n")
    end

    file:close()

    self:loadModel(self.path, self.renderer)
end

--[[guarda los nuevos valores de cada vertice en strings. Al transformar un modelo solo
se afectan sus vertices, por lo que solo es necesario actualizar esa parte en el archivo]]
function a:getTransformedVertices()
    local transformed = {}

    for _, vertex in ipairs(self.renderer.vertices) do
        local str = string.format("v %f %f %f", vertex.x, vertex.y, vertex.z)
        table.insert(transformed, str)
    end

    return transformed
end

return a