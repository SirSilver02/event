local event_manager = function()
    local event_manager = {
        events = {}
    }

    function event_manager:add(name, id, func)
        if not self.events[name] then
            self.events[name] = {}
        end
        
        --if only two args passed, id is assumed to be the func.
        --id can also be a table containing a method with the same name as the "name" varaible.
        self.events[name][id] = func or id 

        return id
    end

    function event_manager:remove(name, id)
        if self.events[name] then
            self.events[name][id] = nil	
        end
    end

    function event_manager:run(name, ...)
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

    return event_manager
end

return setmetatable({new = event_manager}, {__call = event_manager})
