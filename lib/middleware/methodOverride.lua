
-- provides faux http method support

function methodOverride ()
	return function (req, res, next)
		-- body
	end
end

return methodOverride
