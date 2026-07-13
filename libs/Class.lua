local Object = {}
Object.__index = Object
setmetatable(Object, Object) --le asigna una metatabla a la clase objeto, para que la clase pueda comportarse como una función e instanciarse


--constructor, si no se sobreescribe en las clases hijas, estás serán clases abstractas
function Object:new(...)
    error("This is an abstract class and can not be instantiated.")
end


--crea una clase sin padre (más que la clase objeto)
function Object:create()
    return Object:extend()
end


function Object:extend()
    local child = {}
    child.__index = child
    setmetatable(child, self) --[[establece como metatabla a la clase padre, para que la clase hija tenga acceso a todos los metodos de esta]]

    child.super = self --guarda una referencia de la clase padre
    child["__call"] = self.__call --pasa el meta metodo call para poder instanciar todas las clases hijas

    return child
end


--crea una instancia del objeto al llamar a la tabla Obj como una función
function Object:__call(...)
    local instance = setmetatable({}, self) --[[agrega como metatabla a la clase, esto permite que la instancia tenga acceso a todos los metodos
    establecidos de la clase]]

    instance:new(...) --llama al constructor
    return instance
end


function Object:instanceOf(class)
    local parent = getmetatable(self)

    while parent do
        if parent == class then
            return true
        end

        if parent == Object then
            return false
        end

        parent = getmetatable(parent)
    end

    return false
end


--returns true if a field exists in the instance, false if the field is nil.
function Object:has(field)
    return rawget(self, field) ~= nil
end


--returns a reference of the class of the instance from where the function was called
function Object:getClass()
    return getmetatable(self)
end


return Object