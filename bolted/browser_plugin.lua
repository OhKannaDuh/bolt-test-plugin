local browser_plugin = require('bolted.plugin');
local json = require('bolted.json')

-- Default plugin
browser_plugin.config:add_data{
    window = {x = 0, y = 0, width = 400, height = 250, showdevtools = false}
}

browser_plugin.message_callbacks = {}
browser_plugin.browser = nil;

function browser_plugin:create_browser(path, js)
    self.browser = self.bolt.createembeddedbrowser(self.config.data.window.x,
                                                   self.config.data.window.y,
                                                   self.config.data.window.width,
                                                   self.config.data.window
                                                       .height, path, js)

    if self.config.data.window.showdevtools then
        self:showdevtools()
    end

    self.browser:oncloserequest(function()
        self:close()
    end)

    self.browser:onmessage(function(message)
        message = json.decode(message)
        if self.message_callbacks[message.type] == nil then
            return
        end

        for _, callback in pairs(self.message_callbacks[message.type]) do
            callback(message.data)
        end
    end)

    self:onmessage('close', function()
        self:close()
    end)
end

function browser_plugin:showdevtools()
    self.browser:showdevtools()
end

function browser_plugin:onmessage(type, callback)
    if self.message_callbacks[type] == nil then
        self.message_callbacks[type] = {}
    end

    table.insert(self.message_callbacks[type], callback)
end

function browser_plugin:close()
    self.browser:close()
    self.bolt.close()
end

function browser_plugin:message(type, message)
    self.browser:sendmessage(json.encode({type = type, data = message}))
end

return browser_plugin;
