local http = require('http')
local Emitter = require('core').Emitter
local res = http.Response
local req = http.Request
local flushHead = res.flushHead

if not res._hasConnectPatch then

	-- add events emitter to response
	res.events = Emitter:new()

	-- and events emitter to request
	req.events = Emitter:new()

	function res.flushHead (t, ...)
		if not res.headers_sent then res.events:emit('header', res) end
		flushHead(t, ...)
	end

	res._hasConnectPatch = true
end
