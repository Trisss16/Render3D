local buildUI = {}

function buildUI:get()
    local root = LinearLayout()
    root:setConstraints({0.5})

    local ui = UI(root, 100, 100, 100, 100)

    return ui
end

return buildUI