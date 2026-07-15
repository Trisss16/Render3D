local buildUI = {}

local renderer = require "rendering.Renderer"
local adapter = require "rendering.Adapter"
local t = require "geometry.Transformations"
local root

function buildUI:get()
    root = LinearLayout()
    root:setConstraints({0.2, 0.4})

    local ui = UI(root, 350, 600, 800, 80)
    ui:showBorders(true)

    self:searchBar()
    self:translateT()
    self:escaleT()
    self:rotateTrans()
    self:shearTrans()

    return ui
end

-- Barra de busqueda
function buildUI:searchBar()
    local container = LinearLayout(LinearLayout.VERTICAL)
    root:addChildren(container)
    container:setConstraints({0.4, 0.6})

    local title = Label("Cargar modelo", 30)
    container:addChildren(title)

    local bar = LinearLayout(LinearLayout.HORIZONTAL)
    bar:setConstraints({0.7, 0.3})
    container:addChildren(bar)

    local field = TextField(20, "ruta del archivo")
    field:setRelativeDimensions(0.6)
    local btn = Button(Color.GREEN, "buscar")
    btn:setRelativeDimensions(0.2)

    bar:addChildren(field, btn)

    --evento para cargar el archivo
    btn:addClickListeners(function ()
        local path = field:getValue()
        field:resetValue()
        adapter:loadModel(path, renderer)
    end)

end


-- Tarnsformacion para trasladar 
function buildUI:translateT()
    local translateTrans = LinearLayout(LinearLayout.VERTICAL)
    root:addChildren(translateTrans)
    local titleT = Label("Traslación", 30)
    translateTrans:addChildren(titleT)

    local constraints = {0.7, 0.3}

    local tx = LinearLayout(LinearLayout.HORIZONTAL)
    tx:setConstraints(constraints)
    translateTrans:addChildren(tx)
    local txTitle = Label("Traslación en X:",20)
    local txField = TextField(20, "tx")
    txField:setNumeric(true)
    txField:setRelativeDimensions(0.15)
    tx:addChildren(txTitle,txField)

    local ty = LinearLayout(LinearLayout.HORIZONTAL)
    ty:setConstraints(constraints)
    translateTrans:addChildren(ty)
    local tyTitle = Label("Traslación en Y:",20)
    local tyField = TextField(20, "ty")
    tyField:setNumeric(true)
    tyField:setRelativeDimensions(0.15)
    ty:addChildren(tyTitle,tyField)

    local tz = LinearLayout(LinearLayout.HORIZONTAL)
    tz:setConstraints(constraints)
    translateTrans:addChildren(tz)
    local tzTitle = Label("Traslación en Z:",20)
    local tzField = TextField(20, "tz")
    tzField:setNumeric(true)
    tzField:setRelativeDimensions(0.15)
    tz:addChildren(tzTitle,tzField)

    local TranslateButton = Button(Color.GREEN, "aplicar")
    TranslateButton:setRelativeDimensions(0.2)
    translateTrans:addChildren(TranslateButton)

    TranslateButton:addClickListeners(function ()
        local valX = txField:getValue()
        local valY = tyField:getValue()
        local valZ = tzField:getValue()

        local matrixTranslate = t:translate_matrix(valX, valY, valZ)

        txField:resetValue()
        tyField:resetValue()
        tzField:resetValue()

        self:transformObject(matrixTranslate)

    end)

end

-- Transformacion para escalamiento
function buildUI:escaleT()
    local escaleTrans = LinearLayout(LinearLayout.VERTICAL)
    root:addChildren(escaleTrans)
    local titleE = Label("Escalamiento", 30)
    escaleTrans:addChildren(titleE)

    local constraints = {0.7, 0.3}

    local sx = LinearLayout(LinearLayout.HORIZONTAL)
    sx:setConstraints(constraints)
    escaleTrans:addChildren(sx)
    local sxTitle = Label("Escalamiento en X:")
    local sxField = TextField(20, "sx")
    sxField:setNumeric(true)
    sxField:setRelativeDimensions(0.15)
    sx:addChildren(sxTitle,sxField)

    local sy = LinearLayout(LinearLayout.HORIZONTAL)
    sy:setConstraints(constraints)
    escaleTrans:addChildren(sy)
    local syTitle = Label("Escalamiento en Y:")
    local syField = TextField(20, "sy")
    syField:setNumeric(true)
    syField:setRelativeDimensions(0.15)
    sy:addChildren(syTitle,syField)

    local sz = LinearLayout(LinearLayout.HORIZONTAL)
    sz:setConstraints(constraints)
    escaleTrans:addChildren(sz)
    local szTitle = Label("Escalamiento en Z:")
    local szField = TextField(20, "sz")
    szField:setNumeric(true)
    szField:setRelativeDimensions(0.15)
    sz:addChildren(szTitle,szField)

    local EscaleButton = Button(Color.GREEN, "aplicar")
    EscaleButton:setRelativeDimensions(0.2)
    escaleTrans:addChildren(EscaleButton)

    EscaleButton:addClickListeners(function ()
        local valX = sxField:getValue()
        local valY = syField:getValue()
        local valZ = szField:getValue()

        local matrixEscale = t:escale_matrix(valX, valY, valZ)

        sxField:resetValue()
        syField:resetValue()
        szField:resetValue()

        self:transformObject(matrixEscale)

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
        local XYField = TextField(20, "angle")
        XYField:setNumeric(true)
        XYField:setRelativeDimensions(0.18)
        local XYButton = Button(Color.GREEN, "aplicar")
        XYButton:setRelativeDimensions(0.2)
        rotateXY:addChildren(XYTitle, XYField, XYButton)

        XYButton:addClickListeners(function()
            local rad = math.rad(XYField:getValue())
            local matrixRotateXY = t:rotateXY_matrix(rad)

            XYField:resetValue()
            self:transformObject(matrixRotateXY)
        end)


        -- Rotación en XZ
        local rotateXZ = LinearLayout(LinearLayout.VERTICAL)
        rotate:addChildren(rotateXZ)
        local XZTitle = Label ("Rotate XZ", 15)
        local XZField = TextField(20, "angle")
        XZField:setNumeric(true)
        XZField:setRelativeDimensions(0.18)
        local XZButton = Button(Color.GREEN, "aplicar")
        XZButton:setRelativeDimensions(0.2)
        rotateXZ:addChildren(XZTitle, XZField, XZButton)

        XZButton:addClickListeners(function()
            local rad = math.rad(XZField:getValue())
            local matrixRotateXZ = t:rotateXZ_matrix(rad)

                XZField:resetValue()
            self:transformObject(matrixRotateXZ)
        end)

        -- Rotación en YZ
        local rotateYZ = LinearLayout(LinearLayout.VERTICAL)
        rotate:addChildren(rotateYZ)
        local YZTitle = Label ("Rotate YZ", 15)
        local YZField = TextField(20, "angle")
        YZField:setNumeric(true)
        YZField:setRelativeDimensions(0.18)
        local YZButton = Button(Color.GREEN, "aplicar")
        YZButton:setRelativeDimensions(0.2)
        rotateYZ:addChildren(YZTitle, YZField, YZButton)

        YZButton:addClickListeners(function()
            local rad = math.rad(YZField:getValue())
            local matrixRotateYZ = t:rotateYZ_matrix(rad)

                YZField:resetValue()
            self:transformObject(matrixRotateYZ)
        end)
end

-- Transformación para sesgar
function buildUI:shearTrans()
    local shear = LinearLayout(LinearLayout.HORIZONTAL)
    root:addChildren(shear)

        -- Sesgado en el eje X
        local shearX = LinearLayout(LinearLayout.VERTICAL)
        shear:addChildren(shearX)
        local XTitle = Label ("Sesgado en X", 15)
        local shyx = TextField(20, "Shy")
        shyx:setNumeric(true)
        shyx:setRelativeDimensions(0.15)
        local shzx = TextField(20, "Shz")
        shzx:setNumeric(true)
        shzx:setRelativeDimensions(0.15)
        local XButton = Button(Color.GREEN, "aplicar")
        XButton:setRelativeDimensions(0.2)
        shearX:addChildren(XTitle, shyx, shzx, XButton)

        XButton:addClickListeners(function()
            local matrixShearX = t:ShearX_matrix(shyx:getValue(), shzx:getValue())
            shyx:resetValue()
            shzx:resetValue()

            self:transformObject(matrixShearX)
        end)


        -- Sesgado en eje Y
        local shearY = LinearLayout(LinearLayout.VERTICAL)
        shear:addChildren(shearY)
        local YTitle = Label ("Sesgado en Y", 15)
        local shxy = TextField(20, "Shx")
        shxy:setNumeric(true)
        shxy:setRelativeDimensions(0.15)
        local shzy = TextField(20, "Shz")
        shzy:setNumeric(true)
        shzy:setRelativeDimensions(0.15)
        local YButton = Button(Color.GREEN, "aplicar")
        YButton:setRelativeDimensions(0.2)
        shearY:addChildren(YTitle, shxy, shzy, YButton)

        YButton:addClickListeners(function()
            local matrixShearY = t:ShearY_matrix(shxy:getValue(), shzy:getValue())
            shxy:resetValue()
            shzy:resetValue()

            self:transformObject(matrixShearY)
        end)


        -- Sesgado en eje Z             
        local shearZ = LinearLayout(LinearLayout.VERTICAL)
        shear:addChildren(shearZ)
        local ZTitle = Label ("Sesgado en Z", 15)
        local shxz = TextField(20, "Shx")
        shxz:setNumeric(true)
        shxz:setRelativeDimensions(0.15)
        local shyz = TextField(20, "Shy")
        shyz:setNumeric(true)
        shyz:setRelativeDimensions(0.15)
        local ZButton = Button(Color.GREEN, "aplicar")
        ZButton:setRelativeDimensions(0.2)
        shearZ:addChildren(ZTitle, shxz, shyz, ZButton)

        ZButton:addClickListeners(function()
            local matrixShearZ = t:ShearZ_matrix(shxz:getValue(), shyz:getValue())
            shxz:resetValue()
            shyz:resetValue()

            self:transformObject(matrixShearZ)
        end)
end

function buildUI:transformObject(matrix)
    local vertices = renderer.vertices
    print("Transformando objeto con la matriz: ")
    matrix:print()
    print()
end
return buildUI