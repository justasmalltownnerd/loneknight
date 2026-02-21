-- main.lua
require("animation")
local player = require("player")
local EnemyFactory = require("enemy")
local gamedata = require("gamedata") 
local ui = require("ui")             

-- ==========================================
-- GAME CONFIG
-- ==========================================
DEBUG_DAMAGE_NUMBERS = true -- Shows damage numbers
floating_texts = {}         -- List to hold damage numbers

gameState = "menu" 
current_level = 1
local level_data = gamedata.levels

platform = {}
active_enemies = {}
WORLD_WIDTH = 3000
camera_x = 0

sign = {
    x = 800, width = 60, height = 80,
    text = gamedata.signText, 
    isReading = false, showPrompt = false
}

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function loadLevel(level_id)
    current_level = level_id
    local data = level_data[level_id]

    platform.width = WORLD_WIDTH
    platform.height = love.graphics.getHeight()
    platform.x = 0
    platform.y = platform.height / 1.25 
    SPAWN_HEIGHT = platform.y

    sign.y = SPAWN_HEIGHT - sign.height
    sign.isReading = false
    sign.showPrompt = false
    floating_texts = {}

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
    
    -- The Vignette Shader! 
    -- It draws a black ring that fades smoothly into the center.
    vignetteShader = love.graphics.newShader[[
        extern number intensity;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec2 center = vec2(0.5, 0.5);
            vec2 uv = screen_coords.xy / love_ScreenSize.xy;
            float dist = distance(uv, center);
            // 0.4 starts the darkness halfway out, 1.0 reaches pure black at corners
            float alpha = smoothstep(0.4, 1.0, dist) * intensity;
            return vec4(0.0, 0.0, 0.0, alpha);
        }
    ]]
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
            if x >= cx and x <= cx + 200 and y >= 200 and y <= 250 then gameState = "level_select"
            elseif x >= cx and x <= cx + 200 and y >= 270 and y <= 320 then gameState = "settings"
            elseif x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then love.event.quit() end
            
        elseif gameState == "level_select" then
            if x >= cx and x <= cx + 200 and y >= 200 and y <= 250 then loadLevel(1)
            elseif x >= cx and x <= cx + 200 and y >= 270 and y <= 320 then loadLevel(2)
            elseif x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then gameState = "menu" end
            
        elseif gameState == "settings" then
            if x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then gameState = "menu" end
        end

        -- NEW: Attack Input (Left Click)
        if gameState == "playing" and not player.isAttacking and not player.isBlocking then
            player.isAttacking = true
            player.anim_attack.currentTime = 0
            
            -- Create an invisible Hitbox in front of the player
            local attack_reach = 60 
            local hitbox_x = player.x
            if player.facing == 1 then
                hitbox_x = player.x + player.width -- Project to the right
            else
                hitbox_x = player.x - attack_reach -- Project to the left
            end
            
            -- Check if any enemies are caught in the swing
            for _, enemy in ipairs(active_enemies) do
                if checkCollision(hitbox_x, player.y, attack_reach, player.height, enemy.x, enemy.y, enemy.width, enemy.height) then
                    -- Boom! Enemy hit!
                    local attack_damage = 40
                    enemy.hp = enemy.hp - attack_damage
                    
                    enemy.flash_timer = 0.15   -- Make them glow
                    enemy.speed_mod = 0.1      -- Slow them down heavily
                    enemy.slow_timer = 0.5
                    
                    if DEBUG_DAMAGE_NUMBERS then
                        table.insert(floating_texts, {
                            text = attack_damage,
                            x = enemy.x + (enemy.width/2),
                            y = enemy.y - 20,
                            timer = 1.0
                        })
                    end
                end
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

        -- Update floating damage numbers
        for i = #floating_texts, 1, -1 do
            local txt = floating_texts[i]
            txt.y = txt.y - (30 * dt)
            txt.timer = txt.timer - dt
            if txt.timer <= 0 then
                table.remove(floating_texts, i)
            end
        end

        for index, enemy in ipairs(active_enemies) do
            enemy:update(dt, player.x, player.y, player.height)
            
            -- The Collision and Damage Event
            if checkCollision(player.x, player.y, player.width, player.height, enemy.x, enemy.y, enemy.width, enemy.height) then
                if player.invincibility <= 0 then
                    -- Base damage and slow duration
                    local damage = 25
                    local incoming_slow = 0.3
                    
                    -- NEW: Block Damage Reduction!
                    if player.isBlocking then
                        damage = damage * 0.5      -- 50% damage reduction
                        incoming_slow = 0.1        -- Less slowdown penalty
                    end
                    
                    player.hp = player.hp - damage
                    if player.hp < 0 then player.hp = 0 end 
                    player.invincibility = 1.0
                    player.regen_delay_timer = 2.0 
                    
                    player.speed_mod = 0.8
                    player.slow_timer = incoming_slow
                    
                    enemy.speed_mod = 0.2
                    enemy.slow_timer = 0.6
                    
                    if DEBUG_DAMAGE_NUMBERS then
                        table.insert(floating_texts, {
                            text = "-" .. damage,
                            x = player.x + (player.width/2), -- Spawn it over the player!
                            y = player.y - 20,
                            timer = 1.0
                        })
                    end
                end
            end
        end

        for i = #active_enemies, 1, -1 do
            if active_enemies[i].hp <= 0 then
                table.remove(active_enemies, i)
            end
        end
    end
end

function love.draw()
    if gameState == "menu" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(titleFont)
        love.graphics.printf("THE KNIGHT'S SKY", 0, 100, love.graphics.getWidth(), "center")
        
        local cx = love.graphics.getWidth() / 2 - 100
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
        -- 1. WORLD SPACE
        love.graphics.push() 
        love.graphics.translate(-math.floor(camera_x), 0) 

        -- Draw Environment
        local currentColor = level_data[current_level].floor_color
        love.graphics.setColor(currentColor)
        love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

        love.graphics.setColor(0.8, 0.6, 0.4, 1) 
        love.graphics.rectangle("fill", sign.x, sign.y, sign.width, sign.height)

        -- Draw Entities
        for index, enemy in ipairs(active_enemies) do
            enemy:draw()
        end
        
        player.draw()

        -- ==========================================
        -- IN-GAME WORLD UI (Always drawn last so it stays on top!)
        -- ==========================================
        
        -- Draw floating damage numbers
        love.graphics.setFont(regularFont)
        for _, txt in ipairs(floating_texts) do
            -- Fade text out as the timer goes down
            love.graphics.setColor(1, 0, 0, txt.timer) 
            love.graphics.print(txt.text, txt.x, txt.y)
        end

        -- Draw interaction prompts
        if sign.showPrompt and not sign.isReading then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(regularFont)
            love.graphics.print("Press 'E' to read", sign.x - 20, sign.y - 30)
        end

        love.graphics.pop() 
        
        -- 2. SCREEN UI SPACE (Vignette, Menus, Text Boxes)
        
        local missing_health_percent = 1.0 - (player.hp / player.max_hp)
        if missing_health_percent > 0 then
            love.graphics.setShader(vignetteShader)
            vignetteShader:send("intensity", missing_health_percent * 7.5) 
            
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setShader() 
        end
        
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