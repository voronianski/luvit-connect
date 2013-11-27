local http = require('http')
local path = require('path')
local connect = require('../lib/connect')

local app = connect.createServer()
local public = path.join(__dirname, 'public')

app:use(connect.favicon())
app:use(connect.logger('dev'))
app:use(connect.static(public))
app:use(connect.directory(public))
app:use(function (req, res, fol)
	res:finish('hello!')
end)

http.createServer(app.handler):listen(8080)
print('connect server started on localhost:8080')
