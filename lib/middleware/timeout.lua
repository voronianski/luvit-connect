local timer = require('timer')
local helpers = require('../helpers')

function timeout (ms)
	ms = ms or 5000

	return function (req, res, follow)
		local tid = timer.setTimeout(ms, function ()
			req.events:emit('timeout')
		end)

		req.events:on('timeout', function ()
			if res.headers_sent then return end
			local err = helpers.throwError(503)
			err.timeout = ms

			follow(err)
		end)

		function req.clearTimeout ()
			timer.clearTimer(tid)
		end

		res.events:once('header', function ()
			timer.clearTimer(tid)
		end)

		follow()
	end
end

return timeout
