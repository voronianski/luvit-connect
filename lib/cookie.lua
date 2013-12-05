-- Cookie module
-- TO DO: extract to separate module luvit module

local qs = require('querystring')
local Object = require('core').Object
local helpers = require('./helpers')

local Cookie = Object:extend()

function Cookie:initialize ( ... )
	self.w = 12
	self.h = 10
end

function Cookie.meta.__tostring ()
	return '<Cookie>'
end

function Cookie:serialize (name, value, options)
	options = options or {}

end

function Cookie:parse (str, options)
	options = options or {}
	options.decode = options.decode or helpers.decodeURI

	local tbl = {}
	local cookiePairs = helpers.split(str, '%;%,')

	for index, pair in pairs(cookiePairs) do
		local eqIndex = helpers.indexOf(pair, '=')

		if eqIndex then
			local key = pair:sub(1, eqIndex-1)
			local val = pair:sub(eqIndex+1, #pair)

			-- quoted values
			if val:find('%"', 1) == 1 then
				val = val:sub(2, #val-1)
			end

			if not tbl[key] then
				tbl[key] = options.decode(val)
			end
		end
	end

	return tbl
end

return Cookie
