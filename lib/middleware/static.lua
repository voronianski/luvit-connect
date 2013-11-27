local path = require('path')
local fs = require('fs')
local mime = require('mime')
local os = require('os')
local debug = require('debug')

-- static files middleware
-- root - directory path required
-- options:
--  `maxAge` - browser cache maxAge in milliseconds, defaults to 0
--  `index` - default file name, defaults to 'index.html'
--  `hidden` - allow transfer of hidden files, defaults to false

function static (root, options)
	if not root then error('root is required') end

	root = path.normalize(root)

	options = options or {}
	options.index = options.index or 'index.html'
	options.maxAge = options.maxAge or 0

	return function (req, res, follow)
		if req.method ~= 'GET' and req.method ~= 'HEAD' then return follow() end

		local function serveFiles (route)
			fs.open(route, 'r', function (err, fd)
				if err then return follow() end

				fs.fstat(fd, function (err, stat)
					if err then
						fs.close(fd)
						res:writeHead(500, {})
						return res:finish(tostring(err) .. '\n' .. debug.traceback() .. '\n')
					end

					local headers
					local code = 200
					local etag = stat.size .. '-' .. stat.mtime

					if etag == req.headers['if-none-match'] then code = 304 end

					headers = {
						['Content-Type'] = mime.getType(route),
						['Content-Length'] = stat.size,
						['Last-Modified'] = os.date("!%a, %d %b %Y %H:%M:%S GMT", stat.mtime),
						['Etag'] = etag,
						['Cache-Control'] = 'public, max-age=' .. (options.maxAge / 1000)
					}

					-- skip directories and hidden files if no option specified
					if stat.is_directory or not options.hidden and '.' == path.basename(route):sub(1, 1) then
						fs.close(fd)
						return follow()
					end

					res:writeHead(code, headers)

					if req.method == "HEAD" or code == 304 then
						fs.close(fd)
						req.setCode = code
						return res:finish()
					end

					fs.createReadStream(route, { fd = fd }):pipe(res)
				end)
			end)
		end

		local urlPath = path.join(root, req.url)

		if options.index and urlPath:sub(#urlPath) == '/' then
			serveFiles(path.join(urlPath, options.index))
		else
			serveFiles(urlPath)
		end
	end
end

return static
