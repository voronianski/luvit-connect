
-- static files middleware
-- root - directory path
-- options:
--  `maxAge` - browser cache maxAge in milliseconds, defaults to 0
--  `index` - default file name, defaults to 'index.html'
--  `autoIndex` - create autoindex page if no index, defaults to true

function static (root, options)
	if not root then error('root is required') end
	options = options or {}

	return function (req, res, follow)
		if req.method ~= 'GET' and req.method ~= 'HEAD' then return follow() end

		follow()
	end
end

return static
