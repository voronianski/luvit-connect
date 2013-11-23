local helpers = require('./helpers')
local proto = require('./proto')

function createServer (...)
	local app = {}

	app.route = '/'
	app.stack = {}
	helpers.merge(app, proto)

	--print(...)
	--for key, value in pairs(...) do
	--	app.use(select(key, ...))
	--end

	return function (req, res, next)
		app.handle(req, res, next)
	end
end

return createServer
