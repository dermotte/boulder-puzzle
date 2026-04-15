local Easing = require("easing")

local MenuScene = {}

-- Animation state
local animationProgress = 0
local isExiting = false
local targetSceneName = nil
local ANIMATION_DURATION = 1.0 -- duration in seconds

function MenuScene.load(ctx)
    animationProgress = 0
    isExiting = false
    targetSceneName = nil
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

function MenuScene.draw(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local gameFont = ctx.gameFont
    local smallGameFont = ctx.smallGameFont
    local myColors = ctx.myColors

    -- Calculate Y offset for animation
    local yOffset = 0
    if not isExiting then
        -- Fly in from above (-200) to current (0)
        yOffset = Easing.lerpEaseOut(-600, 0, animationProgress)
    else
        -- Fly out from current (0) to above (-200)
        -- As animationProgress goes 1 -> 0, t_exit goes 0 -> 1
        local t_exit = 1 - animationProgress
        yOffset = Easing.lerpEaseIn(0, -600, t_exit)
    end

    -- Draw Title
    love.graphics.setColor(myColors.text_1[1], myColors.text_1[2], myColors.text_1[3])
    love.graphics.setFont(gameFont)
    
    local text = "Boulder Puzzle"
    local width = gameFont:getWidth(text)
    local height = gameFont:getHeight()
    
    love.graphics.print(text, (screenW - width) / 2, (screenH - height) / 4 + yOffset)
    
    -- Draw instruction
    love.graphics.setColor(myColors.text_2[1], myColors.text_2[2], myColors.text_2[3])
    love.graphics.setFont(smallGameFont)
    local subText = "Click to Start"
    local subWidth = smallGameFont:getWidth(subText)
    local subHeight = smallGameFont:getHeight()
    love.graphics.print(subText, (screenW - subWidth) / 2, (screenH - height) / 4 + subHeight + 120 - yOffset)
end

function MenuScene.mousepressed(x, y, mbtn, istouch, presses, ctx)
    if mbtn == 1 and not isExiting then
        isExiting = true
        targetSceneName = "puzzle"
    end
end

return MenuScene
