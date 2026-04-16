local Easing = require("easing")
local Button = require("button")

local MenuScene = {}

-- Animation state
local buttons = {}
local animationProgress = 0
local isExiting = false
local targetSceneName = nil
local ANIMATION_DURATION = 1.0 -- duration in seconds

function MenuScene.load(ctx)
    animationProgress = 0
    isExiting = false
    targetSceneName = nil
    buttons = {}

    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local smallGameFont = ctx.smallGameFont
    local myColors = ctx.myColors

    -- Draw Title height for positioning
    local titleText = "Boulder Puzzle"
    local titleHeight = ctx.gameFont:getHeight()
    local subHeight = smallGameFont:getHeight()
    local startY = (screenH - titleHeight) / 4 + subHeight

    -- Button 1: Click to Start
    table.insert(buttons, Button.newText("Start Bouldering", smallGameFont, (screenW - smallGameFont:getWidth("Start Bouldering")) / 2, startY, myColors.text_3, function()
        isExiting = true
        targetSceneName = "puzzle"
    end))

    -- Button 2: Settings
    table.insert(buttons, Button.newText("Settings", smallGameFont, (screenW - smallGameFont:getWidth("Settings")) / 2, startY + 240, myColors.text_2, function()
        isExiting = true
        targetSceneName = "config"
    end))
end

function MenuScene.update(dt, ctx)
    if not isExiting then
        animationProgress = math.min(1, animationProgress + dt / ANIMATION_DURATION)
    else
        animationProgress = math.max(0, animationProgress - dt / ANIMATION_DURATION)
        if animationProgress <= 0 then
            ctx.switchScene(targetSceneName)
        end
    end
end

local function getYOffset()
    if not isExiting then
        -- Fly in from above (-600) to current (0)
        return Easing.lerpEaseOut(-600, 0, animationProgress)
    else
        -- Fly out from current (0) to above (-600)
        -- As animationProgress goes 1 -> 0, t_exit goes 0 -> 1
        local t_exit = 1 - animationProgress
        return Easing.lerpEaseIn(0, -600, t_exit)
    end
end

function MenuScene.draw(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local gameFont = ctx.gameFont
    local myColors = ctx.myColors

    local yOffset = getYOffset()

    -- Draw Title
    love.graphics.setColor(myColors.text_1[1], myColors.text_1[2], myColors.text_1[3])
    love.graphics.setFont(gameFont)
    
    local text = "Boulder Puzzle"
    local width = gameFont:getWidth(text)
    local height = gameFont:getHeight()
    
    love.graphics.print(text, (screenW - width) / 2, (screenH - height) / 12 + yOffset)
    
    -- Draw Buttons
    for _, btn in ipairs(buttons) do
        Button.draw(btn, yOffset, 1)
    end
end

function MenuScene.mousepressed(x, y, mbtn, istouch, presses, ctx)
    if mbtn == 1 and not isExiting then
        local yOffset = getYOffset()
        for _, btn in ipairs(buttons) do
            if Button.isMouseOver(btn, x, y, yOffset, 1) then
                btn.onClick()
                break
            end
        end
    end
end

return MenuScene
