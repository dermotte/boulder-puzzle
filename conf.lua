-- conf.lua

function love.conf(t)
    t.window.title = "Boulder Puzzle"         -- The text at the top of the window
    t.window.width = 1920                     -- Width in pixels
    t.window.height = 1080                    -- Height in pixels
    t.window.resizable = true                -- Prevent user from resizing it
    t.window.msaa = 4 
end
