-- player.lua
local player = {}

function player.load()
    player.scale = 0.50 
    
    player.walk_speed = 200
    player.sprint_speed = 350
    player.speed = player.walk_speed 
    
    player.facing = 1 

    -- Load all your different animations!
    player.anim_idle = newAnimationFromFiles('Sprites/Player/PlayerIdle/PlayerWalk', 1, 0.6)
    player.anim_walk = newAnimationFromFiles('Sprites/Player/PlayerWalk/PlayerWalk', 6, 0.5) 
    player.anim_attack = newAnimationFromFiles('Sprites/Player/PlayerAttack/PlayerAttack', 7, 0.3) 
    player.anim_block = newAnimationFromFiles('Sprites/Player/PlayerBlock/PlayerBlock', 2, 0.2) 
    
    -- Set the active animation to idle by default
    player.animation = player.anim_idle
    
    player.walk_anim_duration = 0.5
    player.sprint_anim_duration = 0.25
    
    player.width = player.animation.frames[1]:getWidth() * player.scale
    player.height = player.animation.frames[1]:getHeight() * player.scale

    player.x = 100
    player.y = SPAWN_HEIGHT - player.height + (player.height / 9)
    player.ground = player.y     
    player.y_velocity = 0        
    player.jump_height = -600    
    player.gravity = 1500        
    player.can_jump = false

    player.right_was_down = false
    player.left_was_down = false
    player.last_dir = 1 
    
    player.max_hp = 100
    player.max_san = 100
    player.hp = player.max_hp
    player.san = player.max_san
    player.invincibility = 0
    player.speed_mod = 1.0  
    player.slow_timer = 0
    player.regen_rate = 5 
    player.regen_delay_timer = 0 
    
    -- Combat States
    player.isMoving = false 
    player.isAttacking = false
    player.isBlocking = false
end

function player.update(dt)
    -- Tick down general timers
    if player.invincibility > 0 then player.invincibility = player.invincibility - dt end
    if player.slow_timer > 0 then
        player.slow_timer = player.slow_timer - dt
    else
        player.speed_mod = 1.0 
    end

    if player.regen_delay_timer > 0 then
        player.regen_delay_timer = player.regen_delay_timer - dt
    end

    if player.hp < player.max_hp and player.regen_delay_timer <= 0 then
        local old_hp_floor = math.floor(player.hp)
        player.hp = player.hp + (player.regen_rate * dt)
        if player.hp > player.max_hp then player.hp = player.max_hp end
        if math.floor(player.hp) > old_hp_floor then
            print("Regenerating... HP: " .. math.floor(player.hp) .. "/" .. player.max_hp)
        end
    end

    -- Check for Block Input (Using 'K' or Right-Click as an example)
    -- We only allow blocking if they aren't currently swinging their sword!
    player.isBlocking = (love.keyboard.isDown('k') or love.mouse.isDown(2)) and not player.isAttacking

    -- Movement Input
    if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
        player.speed = player.sprint_speed
        player.anim_walk.duration = player.sprint_anim_duration
    else
        player.speed = player.walk_speed
        player.anim_walk.duration = player.walk_anim_duration
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

    player.isMoving = (move_dir ~= 0)

    -- Adjust speed if attacking or blocking (stop moving entirely)
    local current_speed = player.speed * player.speed_mod
    if player.isBlocking then 
        current_speed = 0 
    end

    if move_dir == 1 then
        if player.x < (WORLD_WIDTH - player.width) then player.x = player.x + (current_speed * dt) end
        if not player.isAttacking then player.facing = 1 end
    elseif move_dir == -1 then
        if player.x > 0 then player.x = player.x - (current_speed * dt) end
        if not player.isAttacking then player.facing = -1 end
    end

    if love.keyboard.isDown('space') and player.can_jump and not player.isAttacking then                     
        if player.y_velocity == 0 then player.y_velocity = player.jump_height end
    end

    player.y = player.y + (player.y_velocity * dt)
    if player.y < player.ground then player.y_velocity = player.y_velocity + (player.gravity * dt) end
    if player.y >= player.ground then
        player.y = player.ground  
        player.y_velocity = 0     
    end

    -- Animation State Machine!
    if not player.isBlocking then
        player.anim_block.currentTime = 0
    end
    if player.isAttacking then
        player.animation = player.anim_attack
        player.animation.currentTime = player.animation.currentTime + dt
        -- When attack finishes, unlock the player state
        if player.animation.currentTime >= player.animation.duration then
            player.isAttacking = false
            player.animation.currentTime = 0
        end
    elseif player.isBlocking then
        player.animation = player.anim_block
        player.animation.currentTime = player.animation.currentTime + dt
        if player.animation.currentTime >= player.animation.duration then
            player.animation.currentTime = player.animation.duration - 0.001
        end
    elseif player.isMoving then
        player.animation = player.anim_walk
        player.animation.currentTime = player.animation.currentTime + (dt * player.speed_mod)
        while player.animation.currentTime >= player.animation.duration do
            player.animation.currentTime = player.animation.currentTime - player.animation.duration
        end
        -- Reset idle animation so it starts fresh next time we stop
        player.anim_idle.currentTime = 0 
    else
        -- NEW: Idle Animation Logic!
        player.animation = player.anim_idle
        player.animation.currentTime = player.animation.currentTime + dt
        while player.animation.currentTime >= player.animation.duration do
            player.animation.currentTime = player.animation.currentTime - player.animation.duration
        end
        -- Reset walk animation so it starts from frame 1 next time we move
        player.anim_walk.currentTime = 0
    end
end

function player.draw()
    if player.invincibility > 0 and math.floor(player.invincibility * 10) % 2 == 0 then
        love.graphics.setColor(1, 0, 0, 0.5) 
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    -- Determine which frame to draw based on current animation
    local frameIndex = math.floor(player.animation.currentTime / player.animation.duration * #player.animation.frames) + 1
    if frameIndex > #player.animation.frames then frameIndex = #player.animation.frames end
    local frameToDraw = player.animation.frames[frameIndex]

    local frameWidth = frameToDraw:getWidth()
    local frameHeight = frameToDraw:getHeight()
    
    local drawX = player.x + (frameWidth / 2 * player.scale)
    local drawY = player.y + (frameHeight / 2 * player.scale)

    love.graphics.draw(frameToDraw, drawX, drawY, 0, player.scale * player.facing, player.scale, frameWidth / 2, frameHeight / 2)
end

return player