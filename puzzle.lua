local Sprite = require("sprite")
local Easing = require("easing")

local PuzzleScene = {}

-- State local to this scene
local button
local handText
local handIndex
local holdText
local holdIndex
local buttonAnimation = false
local buttonAnimationState = 0
local buttonScale = 0.75
local textAnimation = false
local textAnimationState = 1
local handTextPosition
local holdTextPosition

-- Options
local handOptions = {"Left Hand", "Right Hand", "Both Hands", "Left Foot", "Right Foot"}
local holdOptions = {"Green", "Blue", "Yellow", "Red", "Orange", "Black", "White", "Purple"}

--- Selects a random item from a list and returns both its value and its index.
local function getRandomFromList(list, lastIndex)
    if #list == 0 then return nil, nil end
    local index = math.random(1, #list)
    if index == lastIndex then 
        index = math.random(1, #list)
    end
    local value = list[index]
    return value, index
end

--- Converts an angle from degrees to radians.
local function degToRad(degrees)
    return degrees * (math.pi / 180)
end

--- Draws text at a specified position and angle.
local function drawRotatedText(text, x, y, angle, font)
    love.graphics.setFont(font)
    
    local width = font:getWidth(text)
    local height = font:getHeight()

    love.graphics.push()          -- Save current state
        love.graphics.translate(x, y) -- Move "the world" to the target X, Y
        love.graphics.rotate(angle)   -- Rotate "the world"
        
        -- Draw text offset by half its size to center it at (x, y)
        love.graphics.print(text, -width/2, -height/2)
    love.graphics.pop()           -- Restore everything else to normal
end

function PuzzleScene.load(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH

    -- Initialize button sprite
    button = Sprite.new("assets/button_round_depth_flat.png", screenW/2, screenH/2)
    button.scale = buttonScale

    -- Position the button relative to virtual screen dimensions
    button.x = screenW - (button.w*button.scale)/2 - screenW/8
    button.y = screenH - (button.h*button.scale) - screenH/8

    -- Set text layout positions
    handTextPosition = {
        x = 3.5 * (screenW / 8),
        y =  2 * (screenH / 5),
    }
    holdTextPosition = {
        x = 4.5 * (screenW / 8), 
        y = 3 * (screenH / 5),
    }

    -- Define button click behavior
    button.onClick = function()
        handText, handIndex = getRandomFromList(handOptions, handIndex)
        holdText, holdIndex = getRandomFromList(holdOptions, holdIndex)

        -- Trigger animations
        buttonAnimation = true
        textAnimation = true
        textAnimationState = 0
    end

    -- Initialize game state and random seed
    math.randomseed(os.time())
    handText, handIndex = getRandomFromList(handOptions, handIndex)
    holdText, holdIndex = getRandomFromList(holdOptions, holdIndex)
end

function PuzzleScene.update(dt, ctx)
    -- Handle button scale animation
    if buttonAnimation then
        button.scale = Easing.lerpEaseInOutBack(0.7, 0.75, buttonAnimationState)
        buttonAnimationState = buttonAnimationState + dt * 3

        -- Update position after scaling
        button.x = ctx.screenW - (button.w*button.scale)/2 - ctx.screenW/8
        button.y = ctx.screenH - (button.h*button.scale) - ctx.screenH/8
    end

    if buttonAnimationState > 1 then
        buttonAnimation = false
        buttonAnimationState = 0
    end

    -- Handle text entry animation
    if textAnimation then
        textAnimationState = textAnimationState + dt*3
    end

    if textAnimationState > 1 then
        textAnimation = false
        textAnimationState = 1
    end
end

function PuzzleScene.draw(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local gameFont = ctx.gameFont
    local myColors = ctx.myColors
    local holdColors = ctx.holdColors

    -- Draw hand text
    love.graphics.setColor(myColors.text_2[1], myColors.text_2[2], myColors.text_2[3])
    drawRotatedText(handText, handTextPosition.x, Easing.lerpEaseOut(-screenH/4, handTextPosition.y, textAnimationState), degToRad(-15), gameFont)

    -- Draw hold text
    love.graphics.setColor(holdColors[holdIndex][1], holdColors[holdIndex][2], holdColors[holdIndex][3])
    drawRotatedText("on " .. holdText, Easing.lerpEaseInOutBack(-screenW/4, holdTextPosition.x, textAnimationState), holdTextPosition.y, degToRad(-15), gameFont)

    -- Reset color
    love.graphics.setColor(myColors.white)

    Sprite.draw(button)
end

function PuzzleScene.mousepressed(x, y, mbtn, istouch, presses, ctx)
    if mbtn == 1 then
        if Sprite.isMouseOver(button, x, y) then
            if button.onClick ~= nil then
                button.onClick()
            end
        end
    end
end

return PuzzleScene
