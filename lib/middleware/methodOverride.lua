local helpers = require('../helpers')

-- provides faux http method support
-- pass optional key param to use when checking for a method override, defaults to '_method'

function methodOverride (key)
	key = key or '_method'

	return function (req, res, follow)
		req.originalMethod = req.originalMethod or req.method

		local method

		if req.body and type(req.body) == 'table' and req.body[key] ~= nil then
			method = req.body[key]:lower()
			req.body[key] = nil
		end

		if req.headers['x-http-method-override'] then
			method = req.headers['x-http-method-override']:lower()
		end

		if helpers.supportMethod(method) then
			req.method = method:upper()
		end

		follow()
	end
end

return methodOverride
