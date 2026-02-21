-- main.lua
require("animation")

platform = {}
player = {}

function love.load()
    -- Platform Setup
    x, y, w, h = 20, 20, 60, 20
    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()
    platform.x = 0
    platform.y = platform.height / 2

    -- Player Setup
    player_scale = 0.15 
    player.speed = 200
    player.isMoving = false 
    player.facing = 1 -- NEW: 1 means facing right, -1 means facing left

    -- Initialize the animation
    player.animation = newAnimationFromFiles('PlayerFrame', 6, 0.5) 

    player.x = love.graphics.getWidth() / 2
    player.y = (love.graphics.getHeight() / 2) - (player.animation.frames[1]:getHeight() * player_scale)
end

function love.update(dt)
    player.isMoving = false

    -- Player Movement
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        -- FIXED: We now get the width from the first animation frame and multiply by your scale!
        if player.x < (love.graphics.getWidth() - (player.animation.frames[1]:getWidth() * player_scale)) then
            player.x = player.x + (player.speed * dt)
        end
        player.isMoving = true
        player.facing = 1 
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        -- Left wall boundary check
        if player.x > 0 then 
            player.x = player.x - (player.speed * dt)
        end
        player.isMoving = true
        player.facing = -1 
    end

    if player.isMoving then
        player.animation.currentTime = player.animation.currentTime + dt
        if player.animation.currentTime >= player.animation.duration then
            player.animation.currentTime = player.animation.currentTime - player.animation.duration
        end
    else
        player.animation.currentTime = 0
    end
end

function love.draw()
    -- Draw Rectangles
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", x, y, w, h)

    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

    -- Draw the Character
    love.graphics.setColor(1, 1, 1, 1)
    
    local frameToDraw
    if player.isMoving then
        local walkFrameIndex = math.floor(player.animation.currentTime / player.animation.duration * 5)
        frameToDraw = player.animation.frames[walkFrameIndex + 2] 
    else
        frameToDraw = player.animation.frames[1] 
    end

    -- NEW: Calculate the width and height of the current frame
    local frameWidth = frameToDraw:getWidth()
    local frameHeight = frameToDraw:getHeight()
    
    -- NEW: Shift the drawing point to the center of the sprite so they don't teleport when turning
    local drawX = player.x + (frameWidth / 2 * player_scale)
    local drawY = player.y + (frameHeight / 2 * player_scale)

    -- The love.graphics.draw arguments are: drawable, x, y, rotation, scaleX, scaleY, originX, originY
    love.graphics.draw(
        frameToDraw, 
        drawX, 
        drawY, 
        0, 
        player_scale * player.facing, -- Multiplying scale by our facing direction flips it horizontally!
        player_scale, 
        frameWidth / 2, -- Set the X anchor to the middle of the frame
        frameHeight / 2 -- Set the Y anchor to the middle of the frame
    )
end