-- enemy.lua
local enemy = {}

function enemy.load()
    enemy.size = 40
    enemy.hover_y = (love.graphics.getHeight() / 2) - 150 
    
    enemy.x = 600 
    
    -- NEW: Separate the logical position from the visual position
    enemy.base_y = enemy.hover_y 
    enemy.y = enemy.base_y 
    
    enemy.speed = 100
    enemy.aggro_range = 300 
    enemy.color = {1, 0, 0, 1} 
    
    -- NEW: Wobble animation variables
    enemy.timer = 0
    enemy.wobble_speed = 5       -- How fast it bobs up and down
    enemy.wobble_amplitude = 15  -- How high and low it travels (in pixels)
end

function enemy.update(dt, player_x, player_y, player_height)
    -- Tick the timer forward for the sine wave
    enemy.timer = enemy.timer + dt

    -- AI Logic: Use base_y for the distance math so the wobble doesn't confuse the AI!
    local dx = player_x - enemy.x
    local dy = player_y - enemy.base_y 
    local distance = math.sqrt((dx * dx) + (dy * dy))

    if distance < enemy.aggro_range then
        -- Move X
        if enemy.x < player_x then
            enemy.x = enemy.x + (enemy.speed * dt)
        elseif enemy.x > player_x then
            enemy.x = enemy.x - (enemy.speed * dt)
        end

        -- Move Y (Adjusting base_y instead of y)
        local target_y = player_y + (player_height / 2) - (enemy.size / 2)
        if enemy.base_y < target_y then 
            enemy.base_y = enemy.base_y + (enemy.speed * dt)
        elseif enemy.base_y > target_y then 
            enemy.base_y = enemy.base_y - (enemy.speed * dt)
        end
    else
        -- Retreat (Adjusting base_y instead of y)
        if enemy.base_y < enemy.hover_y then
            enemy.base_y = enemy.base_y + (enemy.speed * dt)
        elseif enemy.base_y > enemy.hover_y then
            enemy.base_y = enemy.base_y - (enemy.speed * dt)
        end
    end
    
    -- Apply the sine wave to the base_y to get the final wobbling position.
    enemy.y = enemy.base_y + (math.sin(enemy.timer * enemy.wobble_speed) * enemy.wobble_amplitude)
end

function enemy.draw()
    love.graphics.setColor(enemy.color)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.size, enemy.size)
end

return enemy