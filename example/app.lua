local http = require('http')
local connect = require('../lib/connect')

local app = connect.createServer()

app:use(connect.favicon())
app:use(connect.logger())
app:use(function (req, res, fol)
	res:finish('hello!')
end)

http.createServer(app.handler):listen(8080)
print('connect server started on localhost:8080')
