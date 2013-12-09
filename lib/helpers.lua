local http = require('http')
local table = require('table')
local string = require('string')
local math = require('math')

-- pretty print of tables to console
function tprint (tbl, indent)
	indent = indent or 0

	for key, value in pairs(tbl) do
		formatting = string.rep('  ', indent) .. key .. ': '

		if type(value) == 'table' then
			print(formatting)
			tprint(value, indent + 1)
		else
			print(formatting .. tostring(value))
		end
	end
end

-- filter values from table
function filter (tbl, fn)
	local result = {}

	if not tbl or type(tbl) ~= 'table' then return result end

	for key, value in pairs(tbl) do
		if fn(value, key, tbl) then
			table.insert(result, value)
		end
	end

	return result
end

-- round number to decimals, defaults to 2 decimals
function roundToDecimals (num, decimals)
	decimals = decimals or 2
	local shift = 10 ^ decimals
	local result = math.floor(num * shift + 0.5) / shift
	return result
end

-- merge table2 into table1
function merge (table1, table2)
	for key, value in pairs(table2) do
		table1[key] = value
	end

	return table1
end

-- get index of field in table or character in string
function indexOf (target, field)
	if type(target) == 'string' then
		return target:find(field, 1, true)
	end

	for index, value in pairs(target) do
		if value == field then
			return index
		end
	end

	return nil
end

-- last index of an element in string
function lastIndexOf (str, elem)
	if type(str) ~= 'string' then error('string required') end
	if type(str) ~= 'string' then error('elem required') end

	local index = str:match('.*' .. elem .. '()')
	if not index then
		return nil
	else
		return index - 1
	end
end

-- split string
function split (str, sep)
	sep = sep or '%s+'

	local result = {}
	local i = 1

	for value in str:gmatch('([^' .. sep .. ']+)') do
		result[i] = value
		i = i + 1
	end

	return result
end

function mime (headers)
	local str = headers['content-type'] or ''
	return split(str, ';')[1]
end

-- create an error table to throw
function throwError (code, msg)
	return {
		status = code,
		msg = msg or http.STATUS_CODES[code]
	}
end

-- check if http method is supported by luvit
function supportMethod (method)
	local methods = {
		'get',
		'post',
		'put',
		'head',
		'delete',
		'options',
		'trace',
		'copy',
		'lock',
		'mkcol',
		'move',
		'propfind',
		'proppatch',
		'unlock',
		'report',
		'mkactivity',
		'checkout',
		'merge',
		'm-search',
		'notify',
		'subscribe',
		'unsubscribe',
		'patch'
	}

	return indexOf(methods, method) ~= nil
end

function hasBody (headers)
	return headers['transfer-encoding'] or headers['content-length'] and headers['content-length'] ~= 0
end

return {
	merge = merge,
	tprint = tprint,
	filter = filter,
	split = split,
	indexOf = indexOf,
	lastIndexOf = lastIndexOf,
	mime = mime,
	throwError = throwError,
	roundToDecimals = roundToDecimals,
	supportMethod = supportMethod,
	hasBody = hasBody
}
