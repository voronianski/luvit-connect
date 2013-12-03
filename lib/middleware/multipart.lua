local table = require('table')
local qs = require('querystring')
local helpers = require('../helpers')

function multipart (options)
	return function (req, res, follow)
		if req._body then return follow() end

		req.body = req.body or {}
		req.files = req.files or {}

		if not helpers.hasBody(req.headers) then return follow() end

		-- check content-type
		if helpers.mime(req.headers) ~= 'multipart/form-data' then return follow() end

		-- mark as parsed
		req._body = true

		req:on('data', function (chunk)
			p(chunk)
		end)

		follow()
	end
end

return multipart
