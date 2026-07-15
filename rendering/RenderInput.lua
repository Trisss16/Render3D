local renderer = require "rendering.Renderer"

local i = {}

i.pi2 = 2 * math.pi

function i:update(dt)
    renderer.XZAngle = renderer.XZAngle + self:rotationXZ(dt)
    renderer.YZAngle = renderer.YZAngle + self:rotationYZ(dt)

    renderer.XZAngle = renderer.XZAngle % self.pi2
    renderer.YZAngle = renderer.YZAngle % self.pi2

    renderer.objDistance = renderer.objDistance + self:zoom(dt)
end

function i:rotationXZ(dt)
    if love.keyboard.isDown("left") then
        return -renderer.spinVelocity * dt
    elseif love.keyboard.isDown("right") then
        return renderer.spinVelocity * dt
    else
        return 0
    end
end

function i:rotationYZ(dt)
    if love.keyboard.isDown("up") then
        return -renderer.spinVelocity * dt
    elseif love.keyboard.isDown("down") then
        return renderer.spinVelocity * dt
    else
        return 0
    end
end

function i:zoom(dt)
    if love.mouse.isDown(1) and self:hovering() then
        return -renderer.zoomVelocity * dt
    elseif love.mouse.isDown(2) and self:hovering() then
        return renderer.zoomVelocity * dt
    else
        return 0
    end
end

function i:hovering()
    local mx, my = love.mouse.getPosition()
    return
        mx >= renderer.canvas_x and
        mx <= renderer.canvas_x + renderer.canvas_w and
        my >= renderer.canvas_y and
        my <= renderer.canvas_y + renderer.canvas_h
end

return i