local bolt = require('bolt')
bolt.checkversion(1, 0)

local browser = bolt.createembeddedbrowser(0, 0, 200, 200,
                                           'file://app/index.html')

browser:oncloserequest(function()
    browser:close()
    bolt.close()
end)
