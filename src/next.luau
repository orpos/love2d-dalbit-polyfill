local dalbit_next: typeof(next)
if _G.DALBIT_emulate_next then
	-- it is pratically the same 
	-- when i tested on a table with 100000 elements it performed about the same
	-- the difference is that the luau next is about 100ms faster in some cases
	-- and that the luau next seems to be more focused 

	-- if _G.DALBIT_luau_hash_table then

	if jit ~= nil then
		dalbit_next = require("./luauNext")
	else
		dalbit_next = require("./djb2Next")
	end
else
	dalbit_next = next
end

return dalbit_next
