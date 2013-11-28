local helpers = require('../helpers')

-- provides faux http method support
-- pass optional key param to use when checking for a method override, defaults to '_method'

function methodOverride (key)
	key = key or '_method'

	req.originalMethod = req.originalMethod or req.method

	return function (req, res, next)
		local method

		if req.body and type(req.body) == 'table' and req.body[key] ~= nil then
		end

		if req.headers['x-http-method-override'] then
			method = req.headers['x-http-method-override']:lower()
		end

		if helpers.supports(method) then
			req.method = method:upper()
		end

		follow()
	end
end

return methodOverride
