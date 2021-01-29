local event = {}
event.__index = event

function event.new()
    local new_event = setmetatable({}, event)
    new_event:init()
    return new_event
end

function event:init()
    self.events = {}
end

function event:add(name, id, func)
    if not self.events[name] then
        self.events[name] = {}
    end
    
    --if only two args passed, id is assumed to be the func.
    --id can also be a table containing a method with the same name as the "name" variable.
    self.events[name][id] = func or id 

    return id
end

function event:remove(name, id)
    if self.events[name] then
        self.events[name][id] = nil	
    end
end

function event:run(name, ...)
    if not self.events[name] then
        return
    end

    for id, func in pairs(self.events[name]) do
        if type(id) == "table" then
            local object = id

            if object[name] then
                object[name](object, ...)
            end
        else
            func(...)	
        end
    end
end

event:init()

return setmetatable(event, {
    __call = function()
        return event.new()
    end,

    new = event.new
})
