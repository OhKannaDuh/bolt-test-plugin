local json = require('json')

local config = {
    data = {
        window = {x = 0, y = 0, width = 400, height = 250},
        last_update = 0,
        tasks = {
            daily = {{text = "Some text...", value = false}},
            weekly = {},
            monthly = {}
        }
    }
};

function config:load(plugin)
    local loaded_config = plugin.bolt.loadconfig('config.json')
    if loaded_config == nil then loaded_config = '{}' end
    loaded_config = json.decode(loaded_config)
    for key, value in pairs(loaded_config) do self.data[key] = value end
end

return config;
