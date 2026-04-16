local Button = {}

--- Creates a new text-based button.
--- @param text string - The text to display on the button.
--- @param font table - The font object to use.
--- @param x number - The final x-coordinate.
--- @param y number - The final y-coordinate.
--- @param color table - The RGB color table {r, g, b}.
--- @param onClick function - Callback function when clicked.
--- @return table - A new button object.
function Button.newText(text, font, x, y, color, onClick)
    local width = font:getWidth(text)
    local height = font:getHeight()
    return {
        type = "text",
        text = text,
        font = font,
        x = x,
        y = y,
        w = width,
        h = height,
        color = color or {1, 1, 1},
        onClick = onClick
    }
end

--- Draws the given button object.
--- @param btn table - The button object to draw.
--- @param offsetY number - The animation offset to apply.
--- @param offsetMultiplier number - Multiplier for the offset (e.g., 1 or -1).
function Button.draw(btn, offsetY, offsetMultiplier)
    if btn.type == "text" then
        love.graphics.setColor(unpack(btn.color))
        love.graphics.setFont(btn.font)
        love.graphics.print(btn.text, btn.x, btn.y + (offsetY * offsetMultiplier))
    end
end

--- Checks if a point is within the button's bounding box.
--- @param btn table - The button object to check against.
--- @param mx number - The x-coordinate of the point.
--- @param my number - The y-coordinate of the point.
--- @param offsetY number - The animation offset to apply.
--- @param offsetMultiplier number - Multiplier for the offset.
--- @return boolean - True if the point is inside, false otherwise.
function Button.isMouseOver(btn, mx, my, offsetY, offsetMultiplier)
    if btn.type == "text" then
        local left = btn.x
        local right = btn.x + btn.w
        local top = btn.y + (offsetY * offsetMultiplier)
        local bottom = top + btn.h

        return mx >= left and mx <= right and my >= top and my <= bottom
    end
    return false
end

return Button
