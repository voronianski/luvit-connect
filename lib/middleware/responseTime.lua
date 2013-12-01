local os = require('os')
local helpers = require('../helpers')

function responseTime ()
	return function (req, res, follow)
		if res._responseTime then return follow() end

		local startTime = os.clock()

		res._responseTime = true

		res.events:once('header', function ()
			local duration = helpers.roundToDecimals((os.clock() - startTime) * 1000)
			res:setHeader('X-Response-Time', duration .. 'ms')
		end)

		follow()
	end
end

return responseTime
