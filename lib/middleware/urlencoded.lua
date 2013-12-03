local table = require('table')
local qs = require('querystring')
local helpers = require('../helpers')

-- parse x-ww-form-urlencoded request bodies into req.body table
-- options:
--  `limit` - payload limit number, defaults to false

function urlencoded (options)
	options = options or {}

	return function (req, res, follow)
		if req._body then return follow() end
		req.body = req.body or {}

		if not helpers.hasBody(req.headers) then return follow() end

		-- check content-type
		local mime = helpers.mime(req.headers)
		if  mime ~= 'application/x-www-form-urlencoded'
			or mime ~= 'application/www-urlencoded'
		then
			return follow()
		end

		-- mark as parsed
		req._body = true

		local body = {}
		local received = 0

		req:on('data', function (chunk)
			received = received + #chunk
			table.insert(body, chunk)
		end)

		req:on('end', function ()
			if options.limit and type(options.limit) == 'number' and received > options.limit then
				return follow(helpers.throwError(413, 'request entity too large'))
			end

			local buf = table.concat(body)
			if #buf ~= 0 then
				req.body = qs.parse(buf)
			end

			follow()
		end)
	end
end

return urlencoded
