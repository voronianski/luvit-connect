local http = require('http')
local connect = require('../lib/connect')
local h = require('../lib/helpers')

local app = connect.createServer()

app:use(connect.favicon())
app:use(function (s, req, res)
	h.tprint(res)
	res:finish('hello!')
end)

http.createServer(app.handler):listen(8080)
print('connect server started on localhost:8080')
