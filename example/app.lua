local http = require('http')
local connect = require('../lib/connect')

local app = connect()

app:use(connect.favicon())

http.createServer(app):listen(8080)