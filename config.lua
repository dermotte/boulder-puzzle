local ConfigScene = {}

function ConfigScene.load(ctx)
end

function ConfigScene.update(dt, ctx)
end

function ConfigScene.draw(ctx)
    local screenW = ctx.screenW
    local screenH = ctx.screenH
    local gameFont = ctx.gameFont
    local myColors = ctx.myColors

    -- Draw Title
    love.graphics.setColor(myColors.text_1[1], myColors.text_1[2], myColors.text_1[3])
    love.graphics.setFont(gameFont)
    
    local text = "Configuration"
    local width = gameFont:getWidth(text)
    local height = gameFont:getHeight()
    
    love.graphics.print(text, (screenW - width) / 2, (screenH - height) / 2)
    
    -- Draw instruction
    love.graphics.setColor(myColors.text_2[1], myColors.text_2[2], myColors.text_2[3])
    local subText = "Coming Soon"
    local subWidth = gameFont:getWidth(subText)
    local subHeight = gameFont:getHeight()
    love.graphics.print(subText, (screenW - subWidth) / 2, (screenH - height) / 2 + subHeight + 20)
end

function ConfigScene.mousepressed(x, y, mbtn, istouch, presses, ctx)
end

return ConfigScene
