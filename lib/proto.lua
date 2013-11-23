local http = require('http')

local app = {}

function app:use (route, fn)
	print('use')
end

function app:handle (req, res, out)
	-- body
	print('handle')
end

function app:listen ( ... )
	-- body
end

return app
