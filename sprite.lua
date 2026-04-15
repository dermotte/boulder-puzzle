-- sprite.lua
--- Module for managing sprite objects and collision detection.
local Sprite = {}

--- Creates a new sprite object.
--- @param imagePath string - The file path to the image asset.
--- @param x number - The initial x-coordinate.
--- @param y number - The initial y-coordinate.
--- @return table - A new sprite object.
function Sprite.new(imagePath, x, y)
    local img = love.graphics.newImage(imagePath)
    
    local newSprite = {
        img = img,
        w = img:getWidth(),   -- Width for collision detection
        h = img:getHeight(),  -- Height for collision detection
        x = x or 0,
        y = y or 0,
        scale = 1,
        rotation = 0,
        onClick = nil         -- Callback function for click events
    }
    return newSprite
end

--- Draws the given sprite object.
--- @param obj table - The sprite object to draw.
function Sprite.draw(obj)
    love.graphics.draw(obj.img, obj.x, obj.y, obj.rotation, obj.scale, obj.scale)
end

--- Checks if a point is within the sprite's bounding box using AABB collision.
--- @param obj table - The sprite object to check against.
--- @param mx number - The x-coordinate of the point.
--- @param my number - The y-coordinate of the point.
--- @return boolean - True if the point is inside, false otherwise.
function Sprite.isMouseOver(obj, mx, my)
    -- Calculate bounding box boundaries
    local left = obj.x
    local right = obj.x + (obj.w * obj.scale)
    local top = obj.y
    local bottom = obj.y + (obj.h * obj.scale)

    return mx >= left and mx <= right and my >= top and my <= bottom
end

return Sprite
