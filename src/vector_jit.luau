type vector = {
	x: number,
	y: number,
	z: number,
} & number

local g_require = require

local ffi = g_require("ffi")
local typeof = require("./typeof")

ffi.cdef([[
typedef struct {
	float x;
	float y;
	float z;
} vec3;
]])

local math = require("./math")
local abs = math.abs
local atan2 = math.atan2
local ceil = math.ceil
local clamp = math.clamp
local floor = math.floor
local sign = math.sign

local vector_create
vector_create = ffi.metatype("vec3", {
	__new = function(ct, x, y, z)
		local value = ffi.new(ct)
		value.x = x or 0
		value.y = y or 0
		value.z = z or 0
		return value
	end,
	__tostring = function(self)
		return `{self.x}, {self.y}, {self.z}`
	end,
	__unm = function(vec)
		return vector_create(-vec.x, -vec.y, -vec.z)
	end,
	__eq = function(a, b)
		return a.x == b.x and a.y == b.y and a.z == b.z
	end,
	__add = function(a, b)
		return vector_create(a.x + b.x, a.y + b.y, a.z + b.z)
	end,
	__sub = function(a, b)
		return vector_create(a.x - b.x, a.y - b.y, a.z - b.z)
	end,
	__mul = function(a, b)
		if typeof(a) == "number" then
			return vector_create(b.x * a, b.y * a, b.z * a)
		elseif typeof(b) == "number" then
			return vector_create(a.x * b, a.y * b, a.z * b)
		end
		return vector_create(a.x * b.x, a.y * b.y, a.z * b.z)
	end,
	__div = function(a, b)
		if typeof(a) == "number" then
			return vector_create(a / b.x, a / b.y, a / b.z)
		elseif typeof(b) == "number" then
			return vector_create(a.x / b, a.y / b, a.z / b)
		end
		return vector_create(a.x / b.x, a.y / b.y, a.z / b.z)
	end,
})

local function vector_magnitude(vec: vector)
	return (vec.x * vec.x + vec.y * vec.y + vec.z * vec.z) ^ 0.5
end

local function vector_normalize(vec: vector)
	local invSqrt = 1 / ((vec.x * vec.x + vec.y * vec.y + vec.z * vec.z) ^ 0.5)
	return vector_create(vec.x * invSqrt, vec.y * invSqrt, vec.z * invSqrt)
end

local function vector_cross(vec1: vector, vec2: vector)
	return vector_create(
		vec1.y * vec2.z - vec1.z * vec2.y,
		vec1.z * vec2.x - vec1.x * vec2.z,
		vec1.x * vec2.y - vec1.y * vec2.x
	)
end

local function vector_dot(vec1: vector, vec2: vector)
	return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
end

local function vector_angle(vec1: vector, vec2: vector, axis: vector?)
	local cross = {
		vec1.y * vec2.z - vec1.z * vec2.y,
		vec1.z * vec2.x - vec1.x * vec2.z,
		vec1.x * vec2.y - vec1.y * vec2.x,
	}

	local sin_vec1 = (cross[1] ^ 2 + cross[2] ^ 2 + cross[3] ^ 2) ^ 0.5
	local cos_vec1 = vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
	local angle = atan2(sin_vec1, cos_vec1)

	if axis then
		if (cross[1] * axis.x + cross[2] * axis.y + cross[3] * axis.z) < 0 then
			angle = -angle
		end
	end

	return angle
end

local function vector_floor(vec: vector)
	return vector_create(floor(vec.x), floor(vec.y), floor(vec.z))
end

local function vector_ceil(vec: vector)
	return vector_create(ceil(vec.x), ceil(vec.y), ceil(vec.z))
end

local function vector_abs(vec: vector)
	return vector_create(abs(vec.x), abs(vec.y), abs(vec.z))
end

local function vector_sign(vec: vector)
	return vector_create(sign(vec.x), sign(vec.y), sign(vec.z))
end

local function vector_clamp(vec: vector, min: vector, max: vector)
	if min.x > max.x then
		error("invalid argument #3 to 'clamp' (max.x must be greater than or equal to min.x)")
	end
	if min.y > max.y then
		error("invalid argument #3 to 'clamp' (max.y must be greater than or equal to min.y)")
	end
	if min.z > max.z then
		error("invalid argument #3 to 'clamp' (max.z must be greater than or equal to min.z)")
	end

	return vector_create(clamp(vec.x, min.x, max.x), clamp(vec.y, min.y, max.y), clamp(vec.z, min.z, max.z))
end

local function vector_min(vec: vector, ...: vector)
	local result = { vec.x, vec.y, vec.z }
	local args = { ... }

	for i = 1, #args do
		local v: vector = args[i]
		if v.x < result[1] then result[1] = v.x end
		if v.y < result[2] then result[2] = v.y end
		if v.z < result[3] then result[3] = v.z end
	end

	return vector_create(result[1], result[2], result[3])
end

local function vector_max(vec: vector, ...: vector)
	local result = { vec.x, vec.y, vec.z }
	local args = { ... }

	for i = 1, #args do
		local v: vector = args[i]
		if v.x > result[1] then result[1] = v.x end
		if v.y > result[2] then result[2] = v.y end
		if v.z > result[3] then result[3] = v.z end
	end

	return vector_create(result[1], result[2], result[3])
end

local vector_zero = vector_create(0, 0, 0)
local vector_one = vector_create(1, 1, 1)

return {
	abs = vector_abs,
	angle = vector_angle,
	ceil = vector_ceil,
	clamp = vector_clamp,
	create = vector_create,
	cross = vector_cross,
	dot = vector_dot,
	floor = vector_floor,
	magnitude = vector_magnitude,
	max = vector_max,
	min = vector_min,
	normalize = vector_normalize,
	sign = vector_sign,

	zero = vector_zero,
	one = vector_one,
}