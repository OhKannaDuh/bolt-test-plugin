local plugin = require('bolted.browser_plugin')
plugin.bolt.checkversion(1, 0)

plugin:load_config({tasks = {daily = {}, weekly = {}, monthly = {}}})

plugin:create_browser('file://app/index.html')

plugin:onmessage('ready', function()
    plugin:message('config', plugin.config.data)
end)

plugin:onmessage('tasks', function(data)
    plugin.config.data.tasks = data

    plugin:save_config()
end)

plugin.time:add_on_minute_changed_callback(function(plugin)
    plugin:save_config()
end)

plugin.time:add_on_day_changed_callback(function(plugin)
    for key, value in pairs(plugin.config.data.tasks.daily) do
        plugin.config.data.tasks.daily[key].value = false;
    end

    plugin:save_config()

    plugin:message('tasks', plugin.config.data.tasks)
end)

plugin.time:add_on_weekly_reset_day_callback(function(plugin)
    for key, value in pairs(plugin.config.data.tasks.weekly) do
        plugin.config.data.tasks.weekly[key].value = false;
    end

    plugin:save_config()

    plugin:message('tasks', plugin.config.data.tasks)
end)

plugin.time:add_on_month_changed_callback(function(plugin)
    for key, value in pairs(plugin.config.data.tasks.monthly) do
        plugin.config.data.tasks.monthly[key].value = false;
    end

    plugin:save_config()

    plugin:message('tasks', plugin.config.data.tasks)
end)

plugin:start()
