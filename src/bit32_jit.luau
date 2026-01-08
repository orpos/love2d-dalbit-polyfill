local g_require = require

local bit = g_require("bit") :: any

-- Converts it to a unsigned 32 number
local function u32(x)
	return bit.band(x, 0xFFFFFFFF)
end

local function logical_rshift(x, n)
	return bit.band(bit.rshift(x, n), 0x7FFFFFFF)
end

local bit32 = {}

bit32.band = function(a, b, ...)
	local result = bit.band(a, b)
	if ... then
		return bit32.band(result, ...)
	end
	return u32(result)
end

bit32.bor = function(a, b, ...)
	local result = bit.bor(a, b)
	if ... then
		return bit32.bor(result, ...)
	end
	return u32(result)
end

bit32.bxor = function(a, b, ...)
	local result = bit.bxor(a, b)
	if ... then
		return bit32.bxor(result, ...)
	end
	return u32(result)
end

bit32.bnot = function(x)
	return u32(bit.bnot(x))
end

bit32.lshift = function(x, disp)
	return u32(bit.lshift(x, disp))
end

bit32.rshift = function(x, disp)
	return logical_rshift(x, disp)
end

bit32.arshift = function(x, disp)
	return u32(bit.rshift(x, disp))
end

return bit32