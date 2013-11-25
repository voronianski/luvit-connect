local os = require('os')
local helpers = require('../helpers')

-- available options:
-- `format` - format of a string (default, short, dev)
-- `stream` - output stream, defaults to stdout

function logger (options)
	options = options or {}

	local format, stream
	if type(options) == 'string' then
		format = options
		stream = process.stdout
	else
		format = options.format or 'default'
		stream = options.stream or process.stdout
	end

	return function (req, res, follow)
		local output
		local startTime = os.clock()
		local dateTime = os.date()
		local httpVersion = req.version_major .. '.' .. req.version_minor
		local function duration (seconds)
			return helpers.roundToDecimals(seconds * 1000, 2)
		end

		if format == 'dev' then
			output = req.method .. ' ' .. res.code .. ' ' .. req.url .. ' ' .. duration(os.clock() - startTime) .. 'ms'
		elseif format == 'short' then
			output = dateTime .. ' - ' .. req.method .. ' ' .. req.url .. ' HTTP/' .. httpVersion .. ' ' .. res.code .. ' ' .. duration(os.clock() - startTime) .. 'ms'
		else
			output = dateTime .. ' - ' .. req.method .. ' ' .. req.url .. ' HTTP/' .. httpVersion .. ' ' .. res.code .. ' ' .. duration(os.clock() - startTime) .. 'ms ' .. req.headers['user-agent']
		end

		stream:write(output .. '\n')
		follow()
	end
end

return logger
