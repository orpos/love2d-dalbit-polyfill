print(bit32.band(4,2))

-- TODO: detect when using this syntax:
-- ("test|1234"):split("|")

print(string.split("test|1234", "|"))
local d = "test|1234"

function love.load()
    -- This will run once when the game loads
end

function love.update(dt)
    -- This will run every frame
end

function love.draw()
    -- This will run every time a new frame will be drawn
end