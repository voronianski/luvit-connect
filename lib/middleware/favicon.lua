local fs = require('fs')

function favicon (path, options)
	local icon -- caching the icon

	if not options then options = {} end

	path = path or __dirname .. '/../public/favicon.ico'
	maxAge = options.maxAge or 86400000

	return function (req, res, follow)
		if ('/favicon.ico' == req.url) then
			if (icon) then
				print(req.url)
				res:writeHead(200, icon.headers)
				res:finish(icon.body)
			else
				fs.readFile(path, function (err, buf)
					if (err) then follow(err) end

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
			follow()
		end
	end
end

return favicon
