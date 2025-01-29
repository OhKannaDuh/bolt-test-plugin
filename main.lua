local plugin = require('plugin')
plugin.bolt.checkversion(1, 0)

local json = require('json')
local config = require('config')

config:load(plugin)

local browser = plugin.bolt.createembeddedbrowser(config.data.window.x,
                                                  config.data.window.y,
                                                  config.data.window.width,
                                                  config.data.window.height,
                                                  'file://app/index.html')

browser:showdevtools()

browser:oncloserequest(function()
    browser:close()
    plugin.bolt.close()
end) -- Close browser and end plugin

browser:onmessage(function(message)
    message = json.decode(message);

    if message.type == 'tasks' then
        -- plugin.bolt.saveconfig('tasks.json', json.encode(message.data));
    end

    if message.type == 'ready' then
        plugin.send_message_to_browser(browser, json.encode(config.data.tasks));
    end

    if message.type == 'close' then
        browser:close()
        plugin.bolt.close()
    end
end)
