local plugin = {
    ready = false,
    tick_callbacks = {},
    config = require('bolted.config'),
    time = require('bolted.time'),
    bolt = require('bolt')
}

plugin.bolt.onswapbuffers(function()
    if plugin.ready ~= true then
        return
    end

    for _, callback in pairs(plugin.tick_callbacks) do
        callback(plugin)
    end
end)

function plugin:start()
    self.ready = true
end

function plugin:load_config(deafult)
    self.config:add_data(deafult)
    self.config:load(self.bolt)
    self.time:fill(self.config.data.last_known_time.year,
                   self.config.data.last_known_time.month,
                   self.config.data.last_known_time.day,
                   self.config.data.last_known_time.weekday,
                   self.config.data.last_known_time.hour,
                   self.config.data.last_known_time.minute)
end

function plugin:save_config()
    local year, month, day, hour, minute = plugin.bolt.datetime()
    local weekday = plugin.bolt.weekday()
    self.config.data.last_known_time = {
        year = year,
        month = month,
        day = day,
        weekday = weekday,
        hour = hour,
        minute = minute
    }

    self.config:save(self.bolt)
end

local year, month, day, hour, minute = plugin.bolt.datetime()
local weekday = plugin.bolt.weekday()
plugin.config:add_data({
    last_known_time = {
        year = year,
        month = month,
        day = day,
        weekday = weekday,
        hour = hour,
        minute = minute
    }
})

table.insert(plugin.tick_callbacks, function(plugin)
    plugin.time:tick(plugin)
end)

return plugin
