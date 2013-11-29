local url = require('url')
local qs = require('querystring')

-- automatically parse the query-string when available to `req.query` table

function query ()
	return function (req, res, follow)
		if not req.query then
			if req.url:find('%?') then
				local urlParsed = req._parsedUrl

				if not urlParsed or urlParsed.href ~= req.url then
					urlParsed = url.parse(req.url)
				end

				req.query = qs.parse(urlParsed.query)
			end
		end

		follow()
	end
end

return query
