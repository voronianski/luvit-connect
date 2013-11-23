local string = require('string')

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


-- merge table2 into table1
function merge (table1, table2)
	for key, value in pairs(table2) do
		table1[key] = value
	end

	return table1
end

return {
	merge = merge,
	tprint = tprint
}
