local Button = require("button")
local ConfigScene = {}
local backButton = nil

function ConfigScene.load(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local miniGameFont = ctx.miniGameFont
    local myColors = ctx.myColors

    local text = "Back to Menu"
    local width = miniGameFont:getWidth(text)
    local height = miniGameFont:getHeight()
    
    backButton = Button.newText(text, miniGameFont, (screenW - width) / 2, screenH * 0.8, myColors.text_2, function()
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
    if backButton then
        Button.draw(backButton, 0, 1)
    end
end

function ConfigScene.mousepressed(x, y, mbtn, istouch, presses, ctx)
    if mbtn == 1 and backButton then
        if Button.isMouseOver(backButton, x, y, 0, 1) then
            backButton.onClick()
        end
    end
end

return ConfigScene
