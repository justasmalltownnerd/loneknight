-- main.lua
require("animation")
local player = require("player")
local EnemyFactory = require("enemy")
local gamedata = require("gamedata") 
local ui = require("ui")
require("tileScroll")
require("tileScrollB")
require("tileScrollC")

-- ==========================================
-- GAME CONFIG & VARIABLES
-- ==========================================
DEBUG_DAMAGE_NUMBERS = false 
floating_texts = {}         

gameState = "menu"
music_volume = 0.5
current_level = 1
local level_data = gamedata.levels

platform = {}
active_enemies = {}
WORLD_WIDTH = 4000 -- Expanded world for level transitions!
camera_x = 0

-- Transition Variables
transitionState = "" 
fade_alpha = 0

current_music = nil -- NEW: Holds our currently playing track!

sign = {
    x = 800, width = 60, height = 80,
    text = gamedata.signText, 
    isReading = false, showPrompt = false
}

-- ==========================================
-- HELPER FUNCTIONS
-- ==========================================
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function playMenuMusic()
    -- Stop the level music if it's playing
    if current_music then
        current_music:stop()
    end
    
    -- Load and play the menu track (Be sure to update this file path!)
    current_music = love.audio.newSource("Audio/Music/The_Lonely_Night_Menu_Music.mp3", "stream")
    current_music:setLooping(true)
    current_music:setVolume(music_volume)
    current_music:play()
end

function loadLevel(level_id)
    current_level = level_id
    local data = level_data[level_id]

    -- Stop old music and start the new one
    if current_music then
        current_music:stop()
    end
    
    -- If this level has a music path defined in gamedata.lua, play it
    if data.musicPath then
        current_music = love.audio.newSource(data.musicPath, "stream")
        current_music:setLooping(true) 
        current_music:setVolume(music_volume)
        current_music:play()
    end

    platform.width = WORLD_WIDTH
    platform.height = love.graphics.getHeight()
    platform.x = 0
    platform.y = platform.height / 1.45 
    SPAWN_HEIGHT = platform.y

    sign.y = SPAWN_HEIGHT - sign.height
    sign.isReading = false
    sign.showPrompt = false
    floating_texts = {}
    transitionState = ""
    fade_alpha = 0

    player.load()
    --  WEIRD JANK TILE LOADING SOLUTION (MUST KEEP BOTH TO WORK)
    tileLoadC(level_data[current_level].tileNameC, level_data[current_level].tileNumC, level_data[current_level].tileWidC, level_data[current_level].tileLenC, level_data[current_level].tileMapC)
    tileLoadB(level_data[current_level].tileNameB, level_data[current_level].tileNumB, level_data[current_level].tileWidB, level_data[current_level].tileLenB, level_data[current_level].tileMapB)
    tileLoad(level_data[current_level].tileName, level_data[current_level].tileNum, level_data[current_level].tileWid, level_data[current_level].tileLen, level_data[current_level].tileMap)

    active_enemies = {} 
    for _, enemyInfo in ipairs(data.enemies) do
        table.insert(active_enemies, EnemyFactory.new(enemyInfo.type, enemyInfo.x))
    end
    
    gameState = "playing"
    sanbar = love.graphics.newImage("Sprites/UI/SanityBar.png")
    
    noteBack = love.graphics.newImage("Sprites/Puzzles/Solving/NoteBackground.png")
    chest = love.graphics.newImage("Sprites/Puzzles/Solving/NoteChest.png")
    solver = love.graphics.newImage("Sprites/Puzzles/Solving/PuzzleSolver.png")
    
end

-- ==========================================
-- LÖVE FRAMEWORK FUNCTIONS
-- ==========================================
function love.load()
    titleFont = love.graphics.newFont("Fonts/Branda-yolq.ttf", 64)
    regularFont = love.graphics.newFont("Fonts/QueensidesMedium.ttf", 20)
    bigFont = love.graphics.newFont("Fonts/GalaferaMedium.ttf", 40)
    love.graphics.setFont(regularFont)
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
    
    vignetteShader = love.graphics.newShader[[
        extern number intensity;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec2 center = vec2(0.5, 0.5);
            vec2 uv = screen_coords.xy / love_ScreenSize.xy;
            float dist = distance(uv, center);
            float alpha = smoothstep(0.4, 1.0, dist) * intensity;
            return vec4(0.0, 0.0, 0.0, alpha);
        }
    ]]
    
    playMenuMusic()
end

function love.keypressed(key)
    if gameState == "playing" then
        if key == "e" and sign.showPrompt then
            sign.isReading = not sign.isReading
        end
if key == "escape" then
            gameState = "menu"
            if current_music then current_music:stop() end 
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
            elseif x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then loadLevel(3) 
            elseif x >= cx and x <= cx + 200 and y >= 410 and y <= 460 then loadLevel(4) 
            elseif x >= cx and x <= cx + 200 and y >= 480 and y <= 530 then loadLevel(5) 
            elseif x >= cx and x <= cx + 200 and y >= 550 and y <= 600 then loadLevel(6)
            elseif x >= cx and x <= cx + 200 and y >= 620 and y <= 670 then loadLevel(7)
            elseif x >= cx and x <= cx + 200 and y >= 690 and y <= 740 then 
                gameState = "menu"
                -- NEW: Stop music if returning from a level (if applicable)
                if current_music then current_music:stop() end
        end
            
        elseif gameState == "settings" then
            if x >= cx and x <= cx + 200 and y >= 340 and y <= 390 then gameState = "menu" end
        end

        -- Player Attack Input (Left Click)
        if gameState == "playing" and not player.isAttacking and not player.isBlocking and transitionState == "" then
            player.isAttacking = true
            player.anim_attack.currentTime = 0
            
            local attack_reach = 60 
            local hitbox_x = player.x
            if player.facing == 1 then
                hitbox_x = player.x + player.width 
            else
                hitbox_x = player.x - attack_reach 
            end
            
            for _, enemy in ipairs(active_enemies) do
                if checkCollision(hitbox_x, player.y, attack_reach, player.height, enemy.x, enemy.y, enemy.width, enemy.height) then
                    local attack_damage = 40
                    enemy.hp = enemy.hp - attack_damage
                    
                    enemy.flash_timer = 0.15   
                    enemy.speed_mod = 0.1      
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
        updateTileC(dt)
        updateTileB(dt)
        updateTile(dt, 400)
        -- ^ replace 400 with player.speed, add functionality to C and B too
        if sign.isReading then return end 

        -- ==========================================
        -- LEVEL TRANSITION LOGIC
        -- ==========================================
        if transitionState == "out" then
            fade_alpha = fade_alpha + (dt * 1.5) 
            if fade_alpha >= 1 then
                fade_alpha = 1
                if level_data[current_level + 1] then
                    loadLevel(current_level + 1)
      -- SECOND WEIRD JANK TILE LOADING SOLUTION (MUST KEEP BOTH TO WORK)
                    tileLoadC(level_data[current_level].tileNameC, level_data[current_level].tileNumC, level_data[current_level].tileWidC, level_data[current_level].tileLenC, level_data[current_level].tileMapC)
                    tileLoadB(level_data[current_level].tileNameB, level_data[current_level].tileNumB, level_data[current_level].tileWidB, level_data[current_level].tileLenB, level_data[current_level].tileMapB)
                    tileLoad(level_data[current_level].tileName, level_data[current_level].tileNum, level_data[current_level].tileWid, level_data[current_level].tileLen, level_data[current_level].tileMap)
                    transitionState = "in" 
                    
                else
                    gameState = "menu"
                    transitionState = ""
                    fade_alpha = 0
                    if current_music then current_music:stop() end
                end
            end
            return -- Pause all player/enemy updates while fading out!
            
        elseif transitionState == "in" then
            fade_alpha = fade_alpha - (dt * 1.5)
            if fade_alpha <= 0 then
                fade_alpha = 0
                transitionState = "" 
            end
        end

        -- Check if player crossed the finish line!
        if transitionState == "" and player.x >= level_data[current_level].end_x then
            transitionState = "out"
        end
        -- ==========================================

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
            
            -- Enemy Hitbox Projection
            local e_hitbox_x = enemy.x
            if enemy.facing == 1 then
                e_hitbox_x = enemy.x - enemy.attack_range
            end
            local e_hitbox_w = enemy.width + enemy.attack_range

            if enemy.isAttacking and checkCollision(player.x, player.y, player.width, player.height, e_hitbox_x, enemy.y, e_hitbox_w, enemy.height) then
                if player.invincibility <= 0 then
                    local damage = 25
                    local incoming_slow = 0.3
                    
                    if player.isBlocking then
                        damage = damage * 0.5      
                        incoming_slow = 0.1
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
                            x = player.x + (player.width/2), 
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
        
        -- add puzzle logic / playing state here
        -- if click on PUZZLE CHEST then see PUZZLE SCREEN
            -- enter PUZZLE SCREEN state
        -- if press esc then go back to PLAYING state
        -- puzzle hitboxes for puzzle state
    end

    if gameState == "settings" then
        local cx = love.graphics.getWidth() / 2 - 100
        
        -- Get the potentially updated volume from our UI module
        local new_vol = ui.updateSlider(cx, 200, 200, 20, music_volume)
        
        -- If the slider was moved, update the global variable and the actual music
        if new_vol ~= music_volume then
            music_volume = new_vol
            if current_music then 
                current_music:setVolume(music_volume) 
            end
        end
        return -- Skip the rest of update() while in settings
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
        love.graphics.setFont(bigFont)
        love.graphics.printf("SELECT LEVEL", 0, 100, love.graphics.getWidth(), "center")
        
        local cx = love.graphics.getWidth() / 2 - 100
        ui.drawButton("Level 1", cx, 200, 200, 50)
        ui.drawButton("Level 2", cx, 270, 200, 50)
        ui.drawButton("Level 3", cx, 340, 200, 50)
        ui.drawButton("Level 4", cx, 410, 200, 50)
        ui.drawButton("Level 5", cx, 480, 200, 50)
        ui.drawButton("Level 6", cx, 550, 200, 50)
        ui.drawButton("Level 7", cx, 620, 200, 50)
        ui.drawButton("Back", cx, 690, 200, 50)
        
    elseif gameState == "settings" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(bigFont)
        love.graphics.printf("SETTINGS", 0, 80, love.graphics.getWidth(), "center")
        
        local cx = love.graphics.getWidth() / 2 - 100
        
        ui.drawSlider("Music Volume", cx, 200, 200, 20, music_volume)
        ui.drawButton("Back", cx, 340, 200, 50)
        
    elseif gameState == "playing" then
        -- 1. WORLD SPACE
        -- background?
        love.graphics.draw(level_data[current_level].background, 0, 0, 0, 1)
        --before
        love.graphics.push() 
        love.graphics.translate(-math.floor(camera_x), 0) 

      -- PLACEHOLDER rectangle maker and color selecter
       -- local currentColor = level_data[current_level].floor_color
      --  love.graphics.setColor(currentColor)
      --  love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
        
        -- LEVEL TILE SELECTOR
        draw_mapC(level_data[current_level].tileMapC)
        draw_mapB(level_data[current_level].tileMapB)
        draw_map(level_data[current_level].tileMap)

      -- SANITY BAR
        love.graphics.rectangle("fill", 35, 323+273-(273*(player.san/100)), 110, 273*(player.san/100))
        love.graphics.draw(sanbar, 0, 300, 0, .22)
      --SIGN THINGS
        love.graphics.setColor(0.8, 0.6, 0.4, 1) 
        love.graphics.rectangle("fill", sign.x, sign.y, sign.width, sign.height)
        
        -- PUZZLE PIECES IN BACKGROUND
        love.graphics.draw(level_data[current_level].hintA, level_data[current_level].hintAX, level_data[current_level].hintAY)
        love.graphics.draw(level_data[current_level].hintB, level_data[current_level].hintBX, level_data[current_level].hintBY)
        love.graphics.draw(level_data[current_level].hintC, level_data[current_level].hintCX, level_data[current_level].hintCY)

        for index, enemy in ipairs(active_enemies) do
            enemy:draw()
        end
        
        player.draw()

        -- In-Game World UI
        love.graphics.setFont(regularFont)
        for _, txt in ipairs(floating_texts) do
            love.graphics.setColor(1, 0, 0, txt.timer) 
            love.graphics.print(txt.text, txt.x, txt.y)
        end

        if sign.showPrompt and not sign.isReading then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(regularFont)
            love.graphics.print("Press 'E' to read", sign.x - 20, sign.y - 30)
        end

        love.graphics.pop() 

        
        -- 2. SCREEN UI SPACE
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
        
        -- Transition Overlay (Always drawn last!)
        if fade_alpha > 0 then
            love.graphics.setColor(0, 0, 0, fade_alpha)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        end
    end
end