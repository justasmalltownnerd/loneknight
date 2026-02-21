-- player.lua
local player = {}

function player.load()
    player.scale = 0.15 
    
    player.walk_speed = 200
    player.sprint_speed = 350
    player.speed = player.walk_speed 
    
    player.isMoving = false 
    player.facing = 1 

    player.animation = newAnimationFromFiles('Sprites/PlayerWalk/PlayerFrame', 6, 0.5) 
    
    player.walk_anim_duration = 0.5
    player.sprint_anim_duration = 0.25
    
    player.width = player.animation.frames[1]:getWidth() * player.scale
    player.height = player.animation.frames[1]:getHeight() * player.scale

    player.x = 100
    player.y = SPAWN_HEIGHT - player.height

    player.ground = player.y     
    player.y_velocity = 0        
    player.jump_height = -600    
    player.gravity = 1500        
    player.can_jump = false

    player.right_was_down = false
    player.left_was_down = false
    player.last_dir = 1 
    
    player.max_hp = 100
    player.hp = player.max_hp
    player.invincibility = 0
    player.speed_mod = 1.0  
    player.slow_timer = 0
    
    player.regen_rate = 5 
    player.regen_delay_timer = 0
end

function player.update(dt)
    player.isMoving = false

    -- Tick down general timers
    if player.invincibility > 0 then player.invincibility = player.invincibility - dt end
    if player.slow_timer > 0 then
        player.slow_timer = player.slow_timer - dt
    else
        player.speed_mod = 1.0 
    end

    -- NEW: Tick down the regeneration delay timer
    if player.regen_delay_timer > 0 then
        player.regen_delay_timer = player.regen_delay_timer - dt
    end

    -- UPDATED: Only regenerate if the delay timer has hit zero!
    if player.hp < player.max_hp and player.regen_delay_timer <= 0 then
        local old_hp_floor = math.floor(player.hp)
        
        player.hp = player.hp + (player.regen_rate * dt)
        if player.hp > player.max_hp then player.hp = player.max_hp end
        
        local new_hp_floor = math.floor(player.hp)
        if new_hp_floor > old_hp_floor then
            print("Regenerating... HP: " .. new_hp_floor .. "/" .. player.max_hp)
        end
    end

    if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
        player.speed = player.sprint_speed
        player.animation.duration = player.sprint_anim_duration
    else
        player.speed = player.walk_speed
        player.animation.duration = player.walk_anim_duration
    end

    local right_down = love.keyboard.isDown('d') or love.keyboard.isDown('right')
    local left_down = love.keyboard.isDown('a') or love.keyboard.isDown('left')

    if right_down and not player.right_was_down then player.last_dir = 1 end
    if left_down and not player.left_was_down then player.last_dir = -1 end

    player.right_was_down = right_down
    player.left_was_down = left_down

    local move_dir = 0
    if right_down and left_down then move_dir = player.last_dir 
    elseif right_down then move_dir = 1
    elseif left_down then move_dir = -1 end

    -- NEW: Multiply movement by the speed_mod so slowdown affects the player!
    local current_speed = player.speed * player.speed_mod

    if move_dir == 1 then
        if player.x < (WORLD_WIDTH - player.width) then
            player.x = player.x + (current_speed * dt)
        end
        player.isMoving = true
        player.facing = 1 
    elseif move_dir == -1 then
        if player.x > 0 then 
            player.x = player.x - (current_speed * dt)
        end
        player.isMoving = true
        player.facing = -1 
    end

    if love.keyboard.isDown('space') and player.can_jump then                     
        if player.y_velocity == 0 then player.y_velocity = player.jump_height end
    end

    player.y = player.y + (player.y_velocity * dt)
    if player.y < player.ground then player.y_velocity = player.y_velocity + (player.gravity * dt) end
    if player.y >= player.ground then
        player.y = player.ground  
        player.y_velocity = 0     
    end

    if player.isMoving then
        -- Also slow down the animation so the slowdown feels visceral
        player.animation.currentTime = player.animation.currentTime + (dt * player.speed_mod)
        while player.animation.currentTime >= player.animation.duration do
            player.animation.currentTime = player.animation.currentTime - player.animation.duration
        end
    else
        player.animation.currentTime = 0
    end
end

function player.draw()
    -- If invincible, flash the player by changing alpha
    if player.invincibility > 0 and math.floor(player.invincibility * 10) % 2 == 0 then
        love.graphics.setColor(1, 0, 0, 0.5) -- Flash transparent red
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    local frameToDraw
    if player.isMoving then
        local walkFrameIndex = math.floor(player.animation.currentTime / player.animation.duration * 5)
        frameToDraw = player.animation.frames[walkFrameIndex + 2] 
    else
        frameToDraw = player.animation.frames[1] 
    end

    local frameWidth = frameToDraw:getWidth()
    local frameHeight = frameToDraw:getHeight()
    
    local drawX = player.x + (frameWidth / 2 * player.scale)
    local drawY = player.y + (frameHeight / 2 * player.scale)

    love.graphics.draw(frameToDraw, drawX, drawY, 0, player.scale * player.facing, player.scale, frameWidth / 2, frameHeight / 2)
end

return player