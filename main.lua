-- main.lua
require("animation")
local player = require("player")
local EnemyFactory = require("enemy")
local gamedata = require("gamedata") -- NEW: Pull in our data locker
local ui = require("ui")             -- NEW: Pull in our UI tools

-- ==========================================
-- GAME STATE & LEVEL DATA
-- ==========================================
gameState = "menu" 
current_level = 1

-- Tell the game to grab the levels from our new file!
local level_data = gamedata.levels

platform = {}
active_enemies = {}
WORLD_WIDTH = 3000
camera_x = 0

sign = {
    x = 800,
    width = 60,
    height = 80,
    text = gamedata.signText, -- Tell the sign to grab the text from our new file!
    isReading = false,
    showPrompt = false
}

-- ==========================================
-- CORE FUNCTIONS
-- ==========================================

function loadLevel(level_id)
    current_level = level_id
    local data = level_data[level_id]

    platform.width = WORLD_WIDTH
    platform.height = love.graphics.getHeight()
    platform.x = 0
    platform.y = platform.height / 1.5 
    SPAWN_HEIGHT = platform.y

    sign.y = SPAWN_HEIGHT - sign.height
    sign.isReading = false
    sign.showPrompt = false

    player.load()

    active_enemies = {} 
    for _, enemyInfo in ipairs(data.enemies) do
        table.insert(active_enemies, EnemyFactory.new(enemyInfo.type, enemyInfo.x))
    end
    
    gameState = "playing"
end

function love.load()
    titleFont = love.graphics.newFont("Fonts/Branda-yolq.ttf", 64)
    regularFont = love.graphics.newFont("Fonts/QueensidesMedium.ttf", 20)
    love.graphics.setFont(regularFont)
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
end

function love.keypressed(key)
    if gameState == "playing" then
        if key == "e" and sign.showPrompt then
            sign.isReading = not sign.isReading
        end
        if key == "escape" then
            gameState = "menu"
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then 
        local cx = love.graphics.getWidth() / 2 - 100 
        
        if gameState == "menu" then
            if x >= cx and x <= cx + 200 and y >= 200 and y <= 250 then
                gameState = "level_select"
            elseif x >= cx and x <= cx + 200 and y >= 270 and y <= 320 then
                gameState = "settings"
            elseif x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then
                love.event.quit()
            end
            
        elseif gameState == "level_select" then
            if x >= cx and x <= cx + 200 and y >= 200 and y <= 250 then
                loadLevel(1)
            elseif x >= cx and x <= cx + 200 and y >= 270 and y <= 320 then
                loadLevel(2)
            elseif x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then
                gameState = "menu" 
            end
            
        elseif gameState == "settings" then
            if x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then
                gameState = "menu" 
            end
        end
    end
end

function love.update(dt)
    if gameState == "playing" then
        if sign.isReading then return end 

        player.update(dt)
        
        camera_x = player.x - (love.graphics.getWidth() / 2) + (player.width / 2)
        if camera_x < 0 then camera_x = 0 end
        if camera_x > WORLD_WIDTH - love.graphics.getWidth() then 
            camera_x = WORLD_WIDTH - love.graphics.getWidth() 
        end

        local dist = math.abs((player.x + player.width/2) - (sign.x + sign.width/2))
        if dist < 100 and player.y >= SPAWN_HEIGHT - player.height - 10 then 
            sign.showPrompt = true
        else
            sign.showPrompt = false
            sign.isReading = false 
        end

        for index, enemy in ipairs(active_enemies) do
            enemy:update(dt, player.x, player.y, player.height)
        end
    end
end

function love.draw()
    if gameState == "menu" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(titleFont)
        love.graphics.printf("THE KNIGHT'S SKY", 0, 100, love.graphics.getWidth(), "center")
        
        local cx = love.graphics.getWidth() / 2 - 100
        -- Notice we call ui.drawButton instead of just drawButton now!
        ui.drawButton("Play", cx, 200, 200, 50)
        ui.drawButton("Settings", cx, 270, 200, 50)
        ui.drawButton("Quit", cx, 340, 200, 50)
        
    elseif gameState == "level_select" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("SELECT LEVEL", 0, 100, love.graphics.getWidth(), "center")
        
        local cx = love.graphics.getWidth() / 2 - 100
        ui.drawButton("Level 1", cx, 200, 200, 50)
        ui.drawButton("Level 2", cx, 270, 200, 50)
        ui.drawButton("Back", cx, 340, 200, 50)
        
    elseif gameState == "settings" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("SETTINGS\n(Coming Soon)", 0, 100, love.graphics.getWidth(), "center")
        
        local cx = love.graphics.getWidth() / 2 - 100
        ui.drawButton("Back", cx, 340, 200, 50)
        
    elseif gameState == "playing" then
        love.graphics.push() 
        love.graphics.translate(-math.floor(camera_x), 0) 

        local currentColor = level_data[current_level].floor_color
        love.graphics.setColor(currentColor)
        love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

        love.graphics.setColor(0.8, 0.6, 0.4, 1) 
        love.graphics.rectangle("fill", sign.x, sign.y, sign.width, sign.height)

        if sign.showPrompt and not sign.isReading then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print("Press 'E' to read", sign.x - 20, sign.y - 30)
        end

        for index, enemy in ipairs(active_enemies) do
            enemy:draw()
        end
        
        player.draw()

        love.graphics.pop() 
        
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.print("Press ESC to return to menu", 10, 10)

        if sign.isReading then
            local margin = 100
            local box_w = love.graphics.getWidth() - (margin * 2)
            local box_h = love.graphics.getHeight() - (margin * 2)
            
            love.graphics.setColor(0, 0, 0, 0.85)
            love.graphics.rectangle("fill", margin, margin, box_w, box_h, 10, 10)
            
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle("line", margin, margin, box_w, box_h, 10, 10)

            love.graphics.printf(sign.text, margin + 30, margin + 30, box_w - 60, "left")
        end
    end
end