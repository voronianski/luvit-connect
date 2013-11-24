local http = require('http')
local table = require('table')
local helpers = require('./helpers')

local app = {}
local stack = {}
local env = process.env.LUVIT_ENV or 'development'

function app:use (route, fn)
	if type(route) ~= 'string' then
		fn = route
		route = '/'
	end

	-- define next stack
	local go = { route = route }
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
			-- delegate to parent
			if out then return out(err) end

			-- unhandled error
			if err then
				local msg

				-- default to 500
				if res.code < 400 then res.code = 500 end

				-- respect err.status
				if type(err) == 'table' and err.status then
					res.code = err.status
				end

				-- basic error message for production
				if env == 'production' then
					msg = http.STATUS_CODES[res.code]
				else
					msg = tostring(err) or 'Unknown server error'
				end

				res:setHeader('Content-Type', 'text/html')
				res:setHeader('Content-Length', #msg)
				res:finish(msg)
			else
				res.code = 404
				res:setHeader('Content-Type', 'text/html')
				if 'HEAD' == req.method then return res:finish() end
				res:finish('Cannot ' .. req.method .. ' ' .. req.url)
			end

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
