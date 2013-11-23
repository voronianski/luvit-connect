local http = require('http')
local table = require('table')

local app = {}
local stack = {}

function app:use (route, fn)
	if type(route) ~= 'string' then
		fn = route
		route = '/'
	end

	-- define next stack
	local go = {}
	go.route = route
	function go:handle () return fn end

	table.insert(stack, go)

	return self
end

function app:handle (req, res, out)
	local index = 0

	function follow (err)
		local layer

		index = index + 1
		layer = stack[index]

		-- all done
		if not layer then
			return
		end

		if err then
			follow(err)
		else
			layer:handle()(req, res, follow)
		end
	end

	follow()
end

return app
