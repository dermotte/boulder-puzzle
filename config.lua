local ConfigScene = {}

function ConfigScene.load(ctx)
end

function ConfigScene.update(dt, ctx)
end

function ConfigScene.draw(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local gameFont = ctx.gameFont
    local smallGameFont = ctx.smallGameFont
    local myColors = ctx.myColors

    -- Draw Title
    love.graphics.setColor(myColors.text_1[1], myColors.text_1[2], myColors.text_1[3])
    love.graphics.setFont(gameFont)
    
    local text = "Settings"
    local width = gameFont:getWidth(text)
    local height = gameFont:getHeight()
    
    love.graphics.print(text, (screenW - width) / 2, (screenH - height) / 12)
    
    -- Draw instruction
    love.graphics.setColor(myColors.text_2[1], myColors.text_2[2], myColors.text_2[3])
    love.graphics.setFont(smallGameFont)
    local subText = "Game Sound"
    local subWidth = smallGameFont:getWidth(subText)
    local subHeight = smallGameFont:getHeight()
    love.graphics.print(subText, (screenW - subWidth) / 2, (screenH - height) / 12 + subHeight + 320)
end

function ConfigScene.mousepressed(x, y, mbtn, istouch, presses, ctx)
end

return ConfigScene
