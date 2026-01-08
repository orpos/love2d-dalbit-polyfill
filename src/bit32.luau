if jit ~= nil then
    return require("./bit32_jit") :: any
end
return require("./bit32_pure")