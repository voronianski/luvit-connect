
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
