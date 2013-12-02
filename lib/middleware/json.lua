local table = require('table')
local json = require('json')
local helpers = require('../helpers')

-- parse JSON request bodies into req.body table
-- options:
--  `strict` - when false anything JSON.parse() accepts will be parsed, defaults to true
--  `limit` - payload limit number, defaults to false

function parseJson (options)
	options = options or {}
	options.strict = options.strict or true

	return function (req, res, follow)
		if not helpers.hasBody(req.headers) then return follow() end

		-- mark as parsed
		req._body = true

		local body = {}
		local received = 0

		req:on('data', function (chunk, len)
			received = received + #chunk
			table.insert(body, chunk)
		end)

		req:on('end', function ()
			if options.limit and type(options.limit) == 'number' and received > options.limit then
				return follow(helpers.throwError(413, 'request entity too large'))
			end

			local buf = table.concat(body)
			local firstChar = buf:sub(1, 1)

			if strict and firstChar ~= '[' or firstChar ~= '{' then
				return follow(helpers.throwError(400, 'invalid json'))
			end

			if #buf == 0 then
				return follow(helpers.throwError(400, 'invalid json, empty body'))
			end

			local parseStatus, result = pcall(json.parse, buf)
			if not parseStatus then
				local err = helpers.throwError(400, result)
				return follow(err)
			end

			req.body = result

			follow()
		end)
	end
end

return parseJson
