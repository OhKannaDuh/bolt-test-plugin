local json = require('bolted.json')

local config = {file = 'config.json', data = {}};

function config:merge(base, overrides)
    for k, v in pairs(overrides) do
        if type(v) == 'table' then
            if type(base[k] or false) == 'table' then
                self:merge(base[k] or {}, overrides[k] or {})
            else
                base[k] = v
            end
        else
            base[k] = v
        end
    end
end

function config:add_data(data)
    self:merge(self.data, data)
end

function config:load(bolt)
    local loaded_config = bolt.loadconfig(self.file)
    if loaded_config == nil then
        loaded_config = '{}'
    end

    self:add_data(json.decode(loaded_config))
end

function config:save(bolt)
    bolt.saveconfig(self.file, json.encode(self.data))
end

return config;
