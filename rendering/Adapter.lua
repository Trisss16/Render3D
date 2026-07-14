local a = {}

function a:loadModel(path, renderer)
    if type(path) ~= "string" then
        print("Ruta invalida.")
        return
    end

    self.path = utf8.replace(path, {["\\"] = "/"}) --pasa el path al formato que lua usa

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
end

function a:extractVertices()
    local vertices = {}

    for _, str in ipairs(self.vStr) do
        local values = utf8.split(str, " ")

        --comprueba que todos los valores son números validos
        if tonumber(values[1]) and tonumber(values[2]) and tonumber(values[3]) then
            local vertex = Vertex(tonumber(values[1]), tonumber(values[2]), tonumber(values[3]))
            table.insert(vertices, vertex)
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

return a