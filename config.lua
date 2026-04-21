local Button = require("button")
local ConfigScene = {}
local backButton = nil
local soundToggleButton = nil

function ConfigScene.load(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local microGameFont = ctx.microGameFont
    local myColors = ctx.myColors

    -- Sound Toggle Button
    local toggleText = "Sound"
    local textWidth = microGameFont:getWidth(toggleText)
    local height = microGameFont:getHeight()
    local circleRadius = height / 2
    local padding = 10
    local totalWidth = textWidth + padding + (circleRadius * 2)

    soundToggleButton = Button.newToggle(toggleText, microGameFont, (screenW - totalWidth) / 2, screenH * 0.65, myColors.text_3, ctx.soundOn, function()
        ctx.soundOn = not ctx.soundOn
        soundToggleButton.isOn = ctx.soundOn
    end)

    -- Back Button
    local text = "Back to Menu"
    local width = microGameFont:getWidth(text)
    local height = microGameFont:getHeight()
    
    backButton = Button.newText(text, microGameFont, (screenW - width) / 2, screenH * 0.8, myColors.text_2, function()
        ctx.switchScene("menu")
    end)
end

function ConfigScene.update(dt, ctx)
end

function ConfigScene.draw(ctx)
    -- Getting context for drawing
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local gameFont = ctx.gameFont
    local smallGameFont = ctx.smallGameFont
    local miniGameFont = ctx.miniGameFont
    local  microGameFont = ctx.microGameFont
    local myColors = ctx.myColors

    -- Draw Title
    love.graphics.setColor(myColors.text_1[1], myColors.text_1[2], myColors.text_1[3])
    love.graphics.setFont(smallGameFont)
    
    local text = "Settings"
    local width = smallGameFont:getWidth(text)
    local height = smallGameFont:getHeight()
    
    love.graphics.print(text, (screenW - width) / 2, (screenH - height) / 12)
    
    -- Draw button
    if soundToggleButton then
        Button.draw(soundToggleButton, 0, 1)
    end

    if backButton then
        Button.draw(backButton, 0, 1)
    end
end

function ConfigScene.mousepressed(x, y, mbtn, istouch, presses, ctx)
    if mbtn == 1 then
        if soundToggleButton and Button.isMouseOver(soundToggleButton, x, y, 0, 1) then
            soundToggleButton.onClick()
        elseif backButton and Button.isMouseOver(backButton, x, y, 0, 1) then
            backButton.onClick()
        end
    end
end

return ConfigScene
