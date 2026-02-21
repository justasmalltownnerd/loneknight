-- enemy.lua
local EnemyFactory = {}

-- 1. The Enemy Types Dictionary
local enemyTypes = {
    ["scout"] = {
        spritePrefix = 'Sprites/Boo/Boo',        frames = 1,
        animSpeed = 1.0,
        scale = 0.06,
        acceleration = 300,
        friction = 100,
        max_speed = 180,
        aggro_range = 650,
        hoverOffset = 200
    },
    ["brute"] = {
        spritePrefix = 'Sprites/Boo/Boo', -- You can change this to 'BruteFrame' when you have art!
        frames = 1,
        animSpeed = 1.5,    -- Slower animation
        scale = 0.12,       -- Twice as big!
        acceleration = 200, -- Sluggish to start
        friction = 150,     -- Slides further like on ice
        max_speed = 80,     -- Slow top speed
        aggro_range = 450,  -- Player has to get closer
        hoverOffset = 250    -- Hovers lower to the ground
    }
}

-- 2. The Spawn Function
function EnemyFactory.new(type_name, start_x)
    local e = {}
    local template = enemyTypes[type_name]
    
    if not template then template = enemyTypes["scout"] end 

    -- Copy all the stats from the template into this specific enemy
    e.acceleration = template.acceleration
    e.friction = template.friction
    e.max_speed = template.max_speed
    e.aggro_range = template.aggro_range
    e.scale = template.scale
    
    e.hover_y = SPAWN_HEIGHT - template.hoverOffset
    e.x = start_x
    e.base_y = e.hover_y
    e.y = e.base_y
    e.x_vel = 0
    e.y_vel = 0
    
    e.timer = 0
    e.wobble_speed = 5       
    e.wobble_amplitude = 15  

    e.hp = 100
    e.speed_mod = 1.0
    e.slow_timer = 0
    e.flash_timer = 0 
    
    e.animation = newAnimationFromFiles(template.spritePrefix, template.frames, template.animSpeed)
    
    -- Initialize Animation
    e.animation = newAnimationFromFiles(template.spritePrefix, template.frames, template.animSpeed)
    e.width = e.animation.frames[1]:getWidth() * e.scale
    e.height = e.animation.frames[1]:getHeight() * e.scale
    
    e.facing = 1
    e.color = {1, 1, 1, 1} -- White by default (shows original image colors)

-- 3. The Update Method
    function e:update(dt, player_x, player_y, player_height)
        self.timer = self.timer + dt
        
        if self.flash_timer > 0 then
            self.flash_timer = self.flash_timer - dt
        end

        -- Update Animation
        self.animation.currentTime = self.animation.currentTime + dt
        while self.animation.currentTime >= self.animation.duration do
            self.animation.currentTime = self.animation.currentTime - self.animation.duration
        end

        -- AI Logic
        local dx = player_x - self.x
        local dy = player_y - self.base_y 
        local distance = math.sqrt((dx * dx) + (dy * dy))
        
        -- NEW: We set a target_y variable to track exactly where the enemy wants to go
        local target_y = self.hover_y

        if distance < self.aggro_range then
            -- Keep the X-axis sliding physics!
            if self.x < player_x then
                self.x_vel = self.x_vel + (self.acceleration * dt)
                self.facing = -1 
            elseif self.x > player_x then
                self.x_vel = self.x_vel - (self.acceleration * dt)
                self.facing = 1
            end

            -- Update the target_y to dive bomb the player
            target_y = player_y + (player_height / 2) - (self.height / 2)
        else
            -- Keep the X-axis friction!
            if self.x_vel > 0 then
                self.x_vel = self.x_vel - (self.friction * dt)
                if self.x_vel < 0 then self.x_vel = 0 end
            elseif self.x_vel < 0 then
                self.x_vel = self.x_vel + (self.friction * dt)
                if self.x_vel > 0 then self.x_vel = 0 end
            end
            
            -- If out of range, the target_y stays as self.hover_y
        end
        
        -- Near the bottom of e:update inside enemy.lua
        if self.x_vel > self.max_speed then self.x_vel = self.max_speed end
        if self.x_vel < -self.max_speed then self.x_vel = -self.max_speed end

        -- Handle enemy slowdown timer
        if self.slow_timer > 0 then
            self.slow_timer = self.slow_timer - dt
        else
            self.speed_mod = 1.0
        end

        -- Apply the speed modifier to their velocity!
        self.x = self.x + (self.x_vel * self.speed_mod * dt)
        self.base_y = self.base_y + ((target_y - self.base_y) * 5 * dt)
        self.y = self.base_y + (math.sin(self.timer * self.wobble_speed) * self.wobble_amplitude)
    end

    -- 4. The Draw Method
    function e:draw()
        if self.flash_timer > 0 then
            love.graphics.setColor(10, 10, 10, 1) -- Intense white glow
        else
            love.graphics.setColor(self.color)
        end

        -- Setting the color allows us to "tint" the sprite if they hit the player!
        love.graphics.setColor(self.color)
        
        local frameIndex = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.frames) + 1
        -- Safeguard just in case the math ever outputs a number slightly too high
        if frameIndex > #self.animation.frames then frameIndex = #self.animation.frames end
        local frameToDraw = self.animation.frames[frameIndex]

        local frameWidth = frameToDraw:getWidth()
        local frameHeight = frameToDraw:getHeight()
        
        local drawX = self.x + (frameWidth / 2 * self.scale)
        local drawY = self.y + (frameHeight / 2 * self.scale)

        love.graphics.draw(
            frameToDraw, drawX, drawY, 0, 
            self.scale * self.facing, self.scale, 
            frameWidth / 2, frameHeight / 2 
        )
    end

    return e
end

return EnemyFactory