-- main.lua
require("animation")
local player = require("player")
local enemy = require("enemy")

platform = {}

-- THE COLLISION FUNCTION
-- Checks if Rectangle 1 overlaps with Rectangle 2
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function love.load()
    -- Platform Setup
    x, y, w, h = 20, 20, 60, 20
    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()
    platform.x = 0
    platform.y = platform.height / 2

    player.load()
    enemy.load()
end

function love.update(dt)
    player.update(dt)
    
    -- Pass the player's height to the enemy so it can calculate the center
    enemy.update(dt, player.x, player.y, player.height)

    -- NEW: The Collision Check!
    local isColliding = checkCollision(
        player.x, player.y, player.width, player.height, 
        enemy.x, enemy.y, enemy.size, enemy.size
    )

    if isColliding then
        -- If they touch, turn the enemy yellow
        enemy.color = {1, 1, 0, 1}
    else
        -- If they aren't touching, stay red
        enemy.color = {1, 0, 0, 1}
    end
end

function love.draw()
    -- Draw Environment
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", x, y, w, h)

    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

    -- Draw Entities
    enemy.draw()
    player.draw()
end