local fs = require('fs')

function favicon (path, options)
	local icon -- caching the icon

	path = path or __dirname .. '/../public/favicon.ico'
	maxAge = options.maxAge or 86400000

	return function (req, res, next)
		if ('/favicon.ico' == req.url) then
			if (icon) then
				res:writeHead(200, icon.headers)
				res:finish(icon.body)
			else
				fs.readFile(path, function (err, buf)
					if (err) then next(err) end

					icon = {
						body = buf,
						headers = {
							['Content-Type'] = 'image/x-icon',
							['Content-Length'] = #buf,
							['Cache-Control'] = 'public, max-age=' .. (maxAge / 1000)
						}
					}

					res:writeHead(200, icon.headers)
					res:finish(icon.body)
				end)
			end
		else
			next()
		end
	end
end

return favicon
