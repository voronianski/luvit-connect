local helpers = require('../helpers')
local Cookie = require('../cookie')

local cookie = Cookie:new()

p(cookie:parse('foo="bar";ddd;age=%D0%BF%D1%80%D0%B8%D0%B2%D0%B5%D1%82'))

-- parse cookie header and populate 'req.cookies'

function cookieParser (secret, options)
	return function (req, res, follow)
		if req.cookies then return follow() end

		local cookies = req.headers.cookies

		req.secret = secret
		req.cookies = {}
		req.signedCookie = {}

		if cookies then
			local parseStatus, result = pcall(cookie.parse, cookies)

			if signedCookie then end
		end

		follow()
	end
end

return cookieParser
