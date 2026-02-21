-- main.lua
require("animation")
local player = require("player")
local EnemyFactory = require("enemy") -- Notice the name change!

platform = {}
active_enemies = {} -- NEW: A list to hold all spawned enemies

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function love.load()
    x, y, w, h = 20, 20, 60, 20
    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()
    platform.x = 0
    platform.y = platform.height / 1.5 
    SPAWN_HEIGHT = platform.y

    player.load()

    -- Spawn some enemies!
    table.insert(active_enemies, EnemyFactory.new("scout", 600))
    table.insert(active_enemies, EnemyFactory.new("brute", 900))
end

function love.update(dt)
    player.update(dt)
    
    -- Loop through every enemy in the list
    for index, enemy in ipairs(active_enemies) do
        enemy:update(dt, player.x, player.y, player.height)

        -- Collision Check (Notice we use enemy.width and enemy.height now)
        local isColliding = checkCollision(
            player.x, player.y, player.width, player.height, 
            enemy.x, enemy.y, enemy.width, enemy.height
        )

        if isColliding then
            -- Tint them red to prove they touched the player!
            enemy.color = {1, 0, 0, 1}
        else
            -- Keep them normal
            enemy.color = {1, 1, 1, 1}
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", x, y, w, h)

    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

    -- Draw every enemy in the list
    for index, enemy in ipairs(active_enemies) do
        enemy:draw()
    end
    
    player.draw()
end