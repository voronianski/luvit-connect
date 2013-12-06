-- Cookie module
-- TO DO: extract to separate luvit module

local os = require('os')
local qs = require('querystring')
local table = require('table')
local Object = require('core').Object
local helpers = require('./helpers')

local Cookie = Object:extend()

function Cookie.meta.__tostring ()
	return '<Cookie>'
end

function Cookie:serialize (name, value, options)
	options = options or {}
	options.encode = options.encode or qs.urlencode

	local cookiePairs = { name .. '=' .. options.encode(value) }

	if options.maxAge then table.insert(cookiePairs, 'Max-Age=' .. options.maxAge) end
	if options.domain then table.insert(cookiePairs, 'Domain=' .. options.domain) end
	if options.path then table.insert(cookiePairs, 'Path=' .. options.path) end
	if options.expires then table.insert(cookiePairs, 'Expires=' .. os.date('!%a, %d %b %Y %H:%M:%S GMT', options.expires)) end
	if options.httpOnly then table.insert(cookiePairs, 'HttpOnly') end
	if options.secure then table.insert(cookiePairs, 'Secure') end

	return table.concat(cookiePairs, '; ')
end

function Cookie:parse (str, options)
	options = options or {}
	options.decode = options.decode or qs.urldecode

	local tbl = {}
	local cookiePairs = helpers.split(str, '%;%,')

	table.foreach(cookiePairs, function (index, pair)
		local eqIndex = helpers.indexOf(pair, '=')

		if not eqIndex then return end

		local key = pair:sub(1, eqIndex-1)
		local val = pair:sub(eqIndex+1, #pair)

		-- quoted values
		if val:find('%"', 1) == 1 then
			val = val:sub(2, #val-1)
		end

		if not tbl[key] then
			tbl[key] = options.decode(val)
		end
	end)

	return tbl
end

return Cookie
