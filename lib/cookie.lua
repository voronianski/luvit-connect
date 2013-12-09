-- Cookies module
-- TO DO: extract to separate luvit module

local os = require('os')
local qs = require('querystring')
local table = require('table')
local crypto = require('_crypto')
local json = require('json')
local Object = require('core').Object
local helpers = require('./helpers')

local Cookie = Object:extend()

function Cookie.meta.__tostring ()
	return '<Cookie>'
end

-- Serialize a "name-value" pair into a cookie string suitable for http headers.
-- An optional options table specifies cookie parameters.
-- @param {String} name
-- @param {String} value
-- @param {Table} options
-- @return {String}

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

-- Parse the given cookie header string into a table
-- @param {String} str
-- @return {Table}

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

-- Sign value with secret.
-- @param {String} value
-- @param {String} secret
-- @return {String}

function Cookie:sign (value, secret)
	if type(value) ~= 'string' then error('cookie required') end
	if type(secret) ~= 'string' then error('secret required') end

	local signed = value .. '.' .. crypto.hmac.new('sha256', secret):update(value):final():gsub('%=+$', '')

	return signed
end

-- Unsign and decode value with secret, returns 'false' if signature is invalid.
-- @param {String} value
-- @param {String} secret
-- @return {String}

function Cookie:unsign (value, secret)
	if type(value) ~= 'string' then error('cookie required') end
	if type(secret) ~= 'string' then error('secret required') end

	local str = value:sub(1, helpers.lastIndexOf(value, '%.') - 1)

	if self:sign(str, secret) == value then
		return str
	end

	return false
end

-- Parse JSON values in cookies
-- @param {Table} tbl
-- return {Table}

function Cookie:parseJSONCookies (tbl)
	table.foreach(tbl, function (index, str)
		if helpers.indexOf(str, 'j:') == 1 then
			local parseStatus, result = pcall(json.parse, str:sub(3, #str))

			if not parseStatus then return nil end

			tbl[index] = result
		end
	end)

	return tbl
end

-- @param {Table} tbl
-- return {Table}

function Cookie:parseSignedCookies (tbl)

end

return Cookie
