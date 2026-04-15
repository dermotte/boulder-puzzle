--- Module for managing and caching loaded fonts.
local FontManager = {
    --- Cache of loaded font objects, keyed by "path_size".
    fonts = {}
}

--- Retrieves a font from the cache or loads it if not already present.
--- @param path string - The file path to the font asset.
--- @param size number - The font size to load.
--- @return love.Font - The requested font object.
function FontManager.get(path, size)
    local key = path .. "_" .. size
    
    -- Load and cache if not already present
    if not FontManager.fonts[key] then
        print("Loading new font size: " .. key)
        FontManager.fonts[key] = love.graphics.newFont(path, size)
    end
    
    return FontManager.fonts[key]
end

return FontManager
