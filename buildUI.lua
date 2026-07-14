local buildUI = {}

local renderer = require "rendering.Renderer"
local adapter = require "rendering.Adapter"
local root

function buildUI:get()
    root = LinearLayout()
    --root:setConstraints({0.5})

    local ui = UI(root, 350, 600, 800, 80)
    self:searchBar()
    self:rotateTrans()
    self:shearTrans()

    return ui
end

-- Barra de busqueda
function buildUI:searchBar()
    local bar = LinearLayout(LinearLayout.HORIZONTAL)
    bar:setConstraints({0.7, 0.3})
    root:addChildren(bar)

    local field = TextField(20)
    field:setRelativeDimensions(0.6)
    local btn = Button(Color.GREEN, "buscar")
    btn:setRelativeDimensions(0.2)

    bar:addChildren(field, btn)

    --evento para cargar el archivo
    btn:addClickListeners(function ()
        local path = field:getValue()
        adapter:loadModel(path, renderer)
    end)

end


-- Transformación para rotar
function buildUI:rotateTrans()
    local rotate = LinearLayout(LinearLayout.HORIZONTAL)
    root:addChildren(rotate)

        -- Rotación en XY
        local rotateXY = LinearLayout(LinearLayout.VERTICAL)
        rotate:addChildren(rotateXY)
        local XYTitle = Label ("Rotate XY", 15)
        local XYField = TextField(20)
        local XYButton = Button(Color.GRAY, "send")
        XYButton:setRelativeDimensions(0.15)
        rotateXY:addChildren(XYTitle, XYField, XYButton)


        -- Rotación en XZ
        local rotateXZ = LinearLayout(LinearLayout.VERTICAL)
        rotate:addChildren(rotateXZ)
        local XZTitle = Label ("Rotate XZ", 15)
        local XZField = TextField(20)
        local XZButton = Button(Color.GRAY, "send")
        XZButton:setRelativeDimensions(0.15)
        rotateXZ:addChildren(XZTitle, XZField, XZButton)

        -- Rotación en YZ
        local rotateYZ = LinearLayout(LinearLayout.VERTICAL)
        rotate:addChildren(rotateYZ)
        local YZTitle = Label ("Rotate YZ", 15)
        local YZField = TextField(20)
        local YZButton = Button(Color.GRAY, "send")
        YZButton:setRelativeDimensions(0.15)
        rotateYZ:addChildren(YZTitle, YZField, YZButton)
end

-- Transformación para sesgar
function buildUI:shearTrans()
    local shear = LinearLayout(LinearLayout.HORIZONTAL)
    root:addChildren(shear)

        -- Sesgado XY
        local shearXY = LinearLayout(LinearLayout.VERTICAL)
        shear:addChildren(shearXY)
        local XYTitle = Label ("Shear XY", 15)
        local shxz = TextField(20)
        local shyz = TextField(20)
        local XYButton = Button(Color.GRAY, "send")
        XYButton:setRelativeDimensions(0.15)
        shearXY:addChildren(XYTitle, shxz, shyz, XYButton)

        -- Sesgado XZ
        local shearXZ = LinearLayout(LinearLayout.VERTICAL)
        shear:addChildren(shearXZ)
        local XZTitle = Label ("Shear XZ", 15)
        local shxy = TextField(20)
        local shzy = TextField(20)
        local XZButton = Button(Color.GRAY, "send")
        XZButton:setRelativeDimensions(0.15)
        shearXZ:addChildren(XZTitle, shxy, shzy, XZButton)

        -- Sesgado YZ
        local shearYZ = LinearLayout(LinearLayout.VERTICAL)
        shear:addChildren(shearYZ)
        local YZTitle = Label ("Shear YZ", 15)
        local shyx = TextField(20)
        local shzx = TextField(20)
        local YZButton = Button(Color.GRAY, "send")
        YZButton:setRelativeDimensions(0.15)
        shearYZ:addChildren(YZTitle, shyx, shzx, YZButton)
end

function buildUI:transformObject(matrix)
    local vertices = renderer.vertices
    
end
return buildUI