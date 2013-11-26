local path = require('path')
local fs = require('fs')
local utils = require('utils')
local url = require('url')
local mime = require('mime')
local os = require('os')
local string = require('string')

-- static files middleware
-- root - directory path
-- options:
--  `maxAge` - browser cache maxAge in milliseconds, defaults to 0
--  `index` - default file name, defaults to 'index.html'
--  `autoIndex` - create autoindex page if no index, defaults to true
--  `redirectFolders` - redirect on folders, defaults to true
--  `dot` - allow dot-files to be fetched normally, defaults to false

function static (root, options)
	if not root then error('root is required') end

	root = path.normalize(root)

	options = options or {}
	options.index = options.index or 'index.html'
	options.maxAge = options.maxAge or 0

	return function (req, res, follow)
		if req.method ~= 'GET' and req.method ~= 'HEAD' then return follow() end

		-- check freshness of `req` and `res` headers
		-- returns boolean, false indicate that the cache is now stale
		local function isFresh ()
			-- defaults
			local etagMatches = true
			local notModified = true

			local modifiedSince = req['if-modified-since']
			local noneMatch = req['if-none-match']
			local lastModified = res['last-modified']
			local etag = res['etag']
			local cc = req['cache-control']

			-- unconditional request
			if not modifiedSince and not noneMatch then return false end

			-- check for no-cache
			if cc and string.find(cc, 'no%-cache') then return false end

			if modifiedSince then
				modifiedSince = os.date(modifiedSince)
				lastModified = os.date(lastModified)
				notModified = lastModified <= modifiedSince
			end

			return etagMatches and notModified
		end


		local function serveFiles (route, fallback)
			fs.open(route, 'r', function (err, fd)
				if err then end

				fs.fstat(fd, function (err, stat)
					if err then end

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

					-- TO DO: support caching

					if route:sub(#path) == '/' then
					else
						if stat.is_directory then
							-- redirection is turned off
							if not options.redirectFolders then return follow() end

							fs.close(fd)
							res:writeHead(302, { ['Location'] = req.url .. '/' })
							return res:finish()
						end


						res:writeHead(code, headers)

						if req.method == "HEAD" then return follow() end

						fs.createReadStream(route, { fd = fd }):pipe(res)
					end
				end)
			end)
		end

		local urlPath = path.join(root, req.url)

		if options.index and urlPath:sub(#urlPath) == '/' then
			serveFiles(path.join(urlPath, options.index), urlPath)
		else
			serveFiles(urlPath)
		end
	end
end

return static
