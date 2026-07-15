local Point2D = Class:create()

Point2D.SCREEN_WIDTH = 1
Point2D.SCREEN_HEIGHT = 1
Point2D.ASPECT_RATIO = 1

function Point2D:new(x, y)
    self.x = x
    self.y = y

    self.s = 3

    x = x / self.ASPECT_RATIO --normaliza con el aspect ratio

    --pasa las coordenadas de un rango de -1 a 1 a un rango de 0 a width/height
    self.screen_x = (x + 1) / 2 * self.SCREEN_WIDTH
    self.screen_y = (1 - (y + 1) / 2 ) * self.SCREEN_HEIGHT --invierte el eje y
end

function Point2D:draw()
    love.graphics.circle(
        "fill",
        self.screen_x - self.s / 2,
        self.screen_y - self.s / 2,
        self.s
    )
end

function Point2D:getAspectRatio()
    Point2D.ASPECT_RATIO = Point2D.SCREEN_WIDTH / Point2D.SCREEN_HEIGHT
end

return Point2D