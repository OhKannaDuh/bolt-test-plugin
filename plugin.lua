local plugin = {}

plugin.bolt = require('bolt')

--- @param browser Browser
--- @param message string
plugin.send_message_to_browser = function(browser, message)
    browser:sendmessage(message);
end

return plugin
