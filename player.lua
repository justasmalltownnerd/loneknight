-- player.lua
local player = {}

function player.load()
    player.scale = 0.15 
    player.speed = 300
    player.isMoving = false 
    player.facing = 1 

    player.animation = newAnimationFromFiles('PlayerFrame', 6, 0.5) 

    -- NEW: Store the width and height directly so other files can see them!
    player.width = player.animation.frames[1]:getWidth() * player.scale
    player.height = player.animation.frames[1]:getHeight() * player.scale

    player.x = love.graphics.getWidth() / 2
    player.y = (love.graphics.getHeight() / 2) - player.height

    player.ground = player.y     
    player.y_velocity = 0        
    player.jump_height = -600    
    player.gravity = 1500        
    player.can_jump = false
end

function player.update(dt)
    player.isMoving = false

    -- Movement (Notice how much cleaner the wall collision check is now!)
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        if player.x < (love.graphics.getWidth() - player.width) then
            player.x = player.x + (player.speed * dt)
        end
        player.isMoving = true
        player.facing = 1 
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
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
        if player.animation.currentTime >= player.animation.duration then
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