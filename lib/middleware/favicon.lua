local fs = require('fs')
local tp = require('../helpers').tprint

function favicon (path, options)
	local icon -- caching the icon

	if not options then options = {} end

	path = path or __dirname .. '/../public/favicon.ico'
	maxAge = options.maxAge or 86400000

	return function (s, req, res, fol)
		if ('/favicon.ico' == req.url) then
			if (icon) then
				print(req.url)
				res:writeHead(200, icon.headers)
				res:finish(icon.body)
			else
				fs.readFile(path, function (err, buf)
					if (err) then fol(err) end

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
			--print('gogo')
			--tp(fol)
			fol()
		end
	end
end

return favicon
