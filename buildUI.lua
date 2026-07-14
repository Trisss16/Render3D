local buildUI = {}

local renderer = require "rendering.Renderer"
local adapter = require "rendering.Adapter"
local root

function buildUI:get()
    root = LinearLayout()
    --root:setConstraints({0.5})

    local ui = UI(root, 350, 600, 800, 80)
    self:searchBar()
    self:translateT()
    self:escaleT()
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

-- Tarnsformacion para trasladar 
function buildUI:translateT()
    local translateTrans = LinearLayout(LinearLayout.VERTICAL)
    root:addChildren(translateTrans)
    local titleT = Label("Traslación", 30)
    translateTrans:addChildren(titleT)

    local tx = LinearLayout(LinearLayout.VERTICAL)
    translateTrans:addChildren(tx)
    local txTitle = Label("Traslación en X:",20)
    local txField = TextField(20)
    txField:setRelativeDimensions(0.5,20)
    tx:addChildren(txTitle,txField)

    local ty = LinearLayout(LinearLayout.VERTICAL)
    translateTrans:addChildren(ty)
    local tyTitle = Label("Traslación en Y:",20)
    local tyField = TextField(20)
    tyField:setRelativeDimensions(0.5,20)
    ty:addChildren(tyTitle,tyField)

    local tz = LinearLayout(LinearLayout.VERTICAL)
    translateTrans:addChildren(tz)
    local tzTitle = Label("Traslación en Z:",20)
    local tzField = TextField(20)
    tzField:setRelativeDimensions(0.5,20)
    tz:addChildren(tzTitle,tzField)

    local TranslateButton = Button(Color.GREEN)
    translateTrans:addChildren(TranslateButton)

end

-- Transformacion para escalamiento
function buildUI:escaleT()
    local escaleTrans = LinearLayout(LinearLayout.VERTICAL)
    root:addChildren(escaleTrans)
    local titleE = Label("Escalamiento", 30)
    escaleTrans:addChildren(titleE)

    local sx = LinearLayout(LinearLayout.VERTICAL)
    escaleTrans:addChildren(sx)
    local sxTitle = Label("Escalamiento en X:")
    local sxField = TextField(20)
    sxField:setRelativeDimensions(0.5,20)
    sx:addChildren(sxTitle,sxField)

    local sy = LinearLayout(LinearLayout.VERTICAL)
    escaleTrans:addChildren(sy)
    local syTitle = Label("Escalamiento en Y:")
    local syField = TextField(20)
    syField:setRelativeDimensions(0.5,20)
    sy:addChildren(syTitle,syField)

    local sz = LinearLayout(LinearLayout.VERTICAL)
    escaleTrans:addChildren(sz)
    local szTitle = Label("Escalamiento en Z:")
    local szField = TextField(20)
    szField:setRelativeDimensions(0.5,20)
    sz:addChildren(szTitle,szField)

    local EscaleButton = Button(Color.GREEN)
    escaleTrans:addChildren(EscaleButton)
    
end

-- Transformación para rotar
function buildUI:rotateTrans()
    local rotate = LinearLayout(LinearLayout.HORIZONTAL)
    root:addChildren(rotate)

        -- Rotación en XY
        local rotateXY = LinearLayout(LinearLayout.VERTICAL)
        rotate:addChildren(rotateXY)
        local XYTitle = Label ("Rotate XY", 15)
        --[[Hacer numérico los Field, hacer que me regrese los valores en un matriz]]
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