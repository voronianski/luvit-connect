local fs = require('fs')
local path = require('path')
local proto = require('./proto')
local helpers = require('./helpers')

local connect = {}

function connect:createServer (...)
	local app = {}

	app.route = '/'
	app.stack = {}
	helpers.merge(app, proto)

	--print(...)
	--for key, value in pairs(...) do
	--	app.use(select(key, ...))
	--end

	app.handler = function (req, res, follow)
		return app:handle(req, res, follow)
	end

	return app
end

-- load all bundled middlewares
local filesCache = fs.readdirSync(__dirname .. '/middleware')
for key, file in pairs(filesCache) do
	local name = path.basename(file, '.lua')
	connect[name] = require('./middleware/' .. name)
end

return connect
