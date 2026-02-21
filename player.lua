-- player.lua
local player = {}

function player.load()
    player.scale = 0.15 
    
    -- Set up walking vs sprinting speeds
    player.walk_speed = 200
    player.sprint_speed = 350
    player.speed = player.walk_speed -- Default to walk speed
    
    player.isMoving = false 
    player.facing = 1 

    player.animation = newAnimationFromFiles('Sprites/PlayerWalk/PlayerFrame', 6, 0.5)    

    -- Set up animation durations to match the speeds
    -- (Lower duration = faster animation)
    player.walk_anim_duration = 0.75
    player.sprint_anim_duration = 0.5
    
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
end

function player.update(dt)
    player.isMoving = false

    -- NEW: Check for the sprint button (Left or Right Shift)
    if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
        player.speed = player.sprint_speed
        player.animation.duration = player.sprint_anim_duration
    else
        player.speed = player.walk_speed
        player.animation.duration = player.walk_anim_duration
    end

    -- 1. Check current keyboard state
    local right_down = love.keyboard.isDown('d') or love.keyboard.isDown('right')
    local left_down = love.keyboard.isDown('a') or love.keyboard.isDown('left')

    -- 2. Figure out which key was pressed MOST RECENTLY
    if right_down and not player.right_was_down then
        player.last_dir = 1
    end
    if left_down and not player.left_was_down then
        player.last_dir = -1
    end

    player.right_was_down = right_down
    player.left_was_down = left_down

    -- 3. Determine actual movement direction
    local move_dir = 0
    if right_down and left_down then
        move_dir = player.last_dir 
    elseif right_down then
        move_dir = 1
    elseif left_down then
        move_dir = -1
    end

    -- 4. Apply Movement
    if move_dir == 1 then
        if player.x < (WORLD_WIDTH - player.width) then
            player.x = player.x + (player.speed * dt)
        end
        player.isMoving = true
        player.facing = 1
    elseif move_dir == -1 then
        if player.x > 0 then 
            player.x = player.x - (player.speed * dt)
        end
        player.isMoving = true
        player.facing = -1 
    end

    -- Jumping
    if love.keyboard.isDown('space') and player.can_jump then                     
        if player.y_velocity == 0 then
            player.y_velocity = player.jump_height    
        end
    end

    -- Physics
    player.y = player.y + (player.y_velocity * dt)
    if player.y < player.ground then
        player.y_velocity = player.y_velocity + (player.gravity * dt)
    end
    if player.y >= player.ground then
        player.y = player.ground  
        player.y_velocity = 0     
    end

    -- Animation
    if player.isMoving then
        player.animation.currentTime = player.animation.currentTime + dt
        
        -- PRO-TIP: We upgraded this from an 'if' to a 'while' loop. 
        -- If the animation speed changes rapidly, this ensures the timer never gets stuck out of bounds!
        while player.animation.currentTime >= player.animation.duration do
            player.animation.currentTime = player.animation.currentTime - player.animation.duration
        end
    else
        player.animation.currentTime = 0
    end
end

function player.draw()
    love.graphics.setColor(1, 1, 1, 1)
    
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

    love.graphics.draw(
        frameToDraw, drawX, drawY, 0, 
        player.scale * player.facing, player.scale, 
        frameWidth / 2, frameHeight / 2 
    )
end

return player