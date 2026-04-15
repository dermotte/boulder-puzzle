-- main.lua
local Sprite = require("sprite")
local FontManager = require("font_manager")
local Easing = require("easing")

local VIRTUAL_WIDTH = 1920
local VIRTUAL_HEIGHT = 1080
local canvas
local scale = 1
local offsetX = 0
local offsetY = 0

--- UI color themes for the game.
local Themes = {
    ocean = {
        bg      = {0.04, 0.08, 0.15}, -- Deep Midnight Blue
        text_1  = {0.95, 0.98, 1.0},  -- Ice White (Title)
        text_2  = {0.7, 0.85, 0.9},   -- Sky Blue (Body)
        text_3  = {0.6, 0.9, 0.8},    -- Mint (Accent)
        white   = {1, 1, 1},
        name    = "Deep Ocean"
    },
    sunset = {
        bg      = {0.1, 0.12, 0.15},  -- Dark Slate
        text_1  = {1.0, 1.0, 1.0},    -- Pure White (Title)
        text_2  = {1.0, 0.7, 0.5},    -- Peach/Coral (Body)
        text_3  = {1.0, 0.9, 0.4},    -- Golden Sun (Accent)
        white   = {1, 1, 1},
        name    = "Sunset Pop"
    }
}

--- Color palette for the 'hold' indicator text.
local holdColors = {
    {0.5, 1.0, 0.6},  -- Green (Minty/Bright)
    {0.5, 0.8, 1.0},  -- Blue (Sky Blue)
    {1.0, 1.0, 0.6},  -- Yellow (Soft Lemon)
    {1.0, 0.5, 0.5},  -- Red (Soft Coral)
    {1.0, 0.7, 0.4},  -- Orange (Warm Peach)
    {0.2, 0.2, 0.2},  -- Black (Dark Grey for visibility)
    {1.0, 1.0, 1.0},  -- White (Pure White)
    {0.8, 0.7, 1.0}   -- Purple (Lavender)
}

local myColors = Themes.ocean
local gameFont
local screenW
local screenH

-- Scene Management
local scenes = {
    menu = require("menu"),
    puzzle = require("puzzle"),
    config = require("config")
}
local currentScene = nil

-- Persistent Context
local ctx = {}

--- Initializes game state, assets, and UI elements.
local function updateScale()
    local windowW = love.graphics.getWidth()
    local windowH = love.graphics.getHeight()

    local scaleX = windowW / VIRTUAL_WIDTH
    local scaleY = windowH / VIRTUAL_HEIGHT
    scale = math.min(scaleX, scaleY)

    offsetX = (windowW - VIRTUAL_WIDTH * scale) / 2
    offsetY = (windowH - VIRTUAL_HEIGHT * scale) / 2
end

function love.load()
    -- android specific code
    local os = love.system.getOS()
    
    if os == "Android" then
        love.window.setMode(0, 0, {fullscreen = true})
    end
    -- Get screen dimensions for virtual space
    screenW = VIRTUAL_WIDTH
    screenH = VIRTUAL_HEIGHT
    
    -- Initialize canvas
    canvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    updateScale()

    -- Load font assets
    gameFont = FontManager.get("assets/fonts/CarterOne-Regular.ttf", 256)
    smallGameFont = FontManager.get("assets/fonts/CarterOne-Regular.ttf", 160)

    -- Setup persistent context
    ctx.screenW = screenW
    ctx.screenH = screenH
    ctx.gameFont = gameFont
    ctx.smallGameFont = smallGameFont
    ctx.myColors = myColors
    ctx.holdColors = holdColors
    ctx.switchScene = function(sceneName)
        currentScene = scenes[sceneName]
        if currentScene and currentScene.load then
            currentScene.load(ctx)
        end
    end

    -- Start with menu
    currentScene = scenes.menu
    currentScene.load(ctx)
end 

function love.resize(w, h)
    updateScale()
end

--- Handles mouse click events.
function love.mousepressed(x, y, mbtn, istouch, presses)
    -- Transform mouse coordinates to virtual space
    local virtualX = (x - offsetX) / scale
    local virtualY = (y - offsetY) / scale

    if currentScene and currentScene.mousepressed then
        currentScene.mousepressed(virtualX, virtualY, mbtn, istouch, presses, ctx)
    end
end

function love.update(dt)
    if currentScene and currentScene.update then
        currentScene.update(dt, ctx)
    end
end

function love.draw()
    -- 1. Render everything to the canvas
    love.graphics.setCanvas(canvas)
        -- Clear canvas with background color
        love.graphics.clear(myColors.bg[1], myColors.bg[2], myColors.bg[3])
        
    if currentScene and currentScene.draw then
        currentScene.draw(ctx)
    end

    love.graphics.setCanvas()

    -- 2. Draw the canvas to the screen with scaling and offsets
    love.graphics.clear(myColors.bg[1], myColors.bg[2], myColors.bg[3]) -- Clear window with game background color
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end
