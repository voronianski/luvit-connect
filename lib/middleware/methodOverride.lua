
-- provides faux http method support

function methodOverride (key)
	key = key or '_method'

	req.originalMethod = req.originalMethod or req.method

	return function (req, res, next)
		-- body
	end
end

return methodOverride
