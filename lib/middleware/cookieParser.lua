local helpers = require('../helpers')
local Cookie = require('../cookie')

local cookie = Cookie:new()

-- parse cookie header and populate 'req.cookies'

function cookieParser (secret, options)
	options = options or {}

	return function (req, res, follow)
		if req.cookies then return follow() end

		local cookies = req.headers.cookies

		req.secret = secret
		req.cookies = {}
		req.signedCookies = {}

		if cookies then
			local parseStatus, result = pcall(cookie.parse, cookies, options)

			if not parseStatus then
				local err = helpers.throwError(400, result)
				return follow(err)
			end

			if secret then
				-- TO DO: parse req.signedCookies
			end

			req.cookies = cookie:parseJSONCookies(result)
		end

		follow()
	end
end

return cookieParser
