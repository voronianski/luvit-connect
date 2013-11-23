local http = require('http')
local table = require('table')
local helpers = require('./helpers')

local app = {}
local stack = {}

function app:use (route, fn)
	if type(route) ~= 'string' then
		fn = route
		route = '/'
	end

	print('use')
	table.insert(stack, { route = route, handle = fn })

	return self
end

function app:handle (req, res, out)
	local index = 0

	print('handle')

	function fol (err)
		print('fol')
		index = index + 1
		local layer = stack[index]

		helpers.tprint(stack)
		--print(stack)

		-- all done
		if not layer then
			return
		end

		if err then
			fol(err)
		else
			print('stack')
			layer:handle(req, res, fol)
		end

	end
	fol()
end

function app:listen ( ... )
	-- body
end

return app
