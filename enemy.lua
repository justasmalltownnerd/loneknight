-- enemy.lua
local EnemyFactory = {}

local enemyTypes = {
    ["Forest Sprite"] = {
        -- Multiple animations per enemy!
        idlePrefix = 'Sprites/Forest Sprite/ForestSpriteIdle/FSIdle', idleFrames = 6, idleSpeed = 0.6,
        walkPrefix = 'Sprites/Forest Sprite/ForestSpriteIdle/FSIdle', walkFrames = 6, walkSpeed = 0.4,
        attackPrefix = 'Sprites/Forest Sprite/ForestSpriteAttack/FSAttack', attackFrames = 6, attackSpeed = 0.4,
        
        scale = 0.15,
        acceleration = 600, friction = 400, max_speed = 180,
        aggro_range = 350, hoverOffset = 150, max_hp = 75,

        attack_range = 70,   -- How close they need to be to swing
        attack_cooldown = 1.5 -- Seconds between attacks
    },
    ["brute"] = {
        idlePrefix = 'Sprites/Boo/Boo', idleFrames = 1, idleSpeed = 0.8,
        walkPrefix = 'Sprites/Boo/Boo', walkFrames = 1, walkSpeed = 0.8,
        attackPrefix = 'Sprites/Boo/Boo', attackFrames = 1, attackSpeed = 0.7,
        
        scale = 0.30,
        acceleration = 300, friction = 200, max_speed = 80,
        aggro_range = 250, hoverOffset = 80, max_hp = 250,
        
        attack_range = 100,
        attack_cooldown = 2.0
    }
}

function EnemyFactory.new(type_name, start_x)
    local e = {}
    local template = enemyTypes[type_name]
    if not template then template = enemyTypes["Forest Sprite"] end 

    e.acceleration = template.acceleration
    e.friction = template.friction
    e.max_speed = template.max_speed
    e.aggro_range = template.aggro_range
    e.scale = template.scale
    e.max_hp = template.max_hp or 100
    e.hp = e.max_hp 

    e.hover_y = SPAWN_HEIGHT - template.hoverOffset
    e.x = start_x
    e.base_y = e.hover_y
    e.y = e.base_y
    e.x_vel = 0
    e.y_vel = 0
    e.timer = 0
    e.wobble_speed = 5       
    e.wobble_amplitude = 15  

    e.speed_mod = 1.0
    e.slow_timer = 0
    e.flash_timer = 0 
    e.facing = 1
    e.color = {1, 1, 1, 1}

    -- NEW: Load all animations and set up combat states
    e.animations = {
        idle = newAnimationFromFiles(template.idlePrefix, template.idleFrames, template.idleSpeed),
        walk = newAnimationFromFiles(template.walkPrefix, template.walkFrames, template.walkSpeed),
        attack = newAnimationFromFiles(template.attackPrefix, template.attackFrames, template.attackSpeed)
    }
    e.current_anim = e.animations.idle
    
    e.attack_range = template.attack_range
    e.attack_cooldown_max = template.attack_cooldown
    e.attack_timer = 0
    e.isAttacking = false

    e.width = e.current_anim.frames[1]:getWidth() * e.scale
    e.height = e.current_anim.frames[1]:getHeight() * e.scale

    function e:update(dt, player_x, player_y, player_height)
        self.timer = self.timer + dt
        if self.flash_timer > 0 then self.flash_timer = self.flash_timer - dt end
        if self.attack_timer > 0 then self.attack_timer = self.attack_timer - dt end

        if self.slow_timer > 0 then
            self.slow_timer = self.slow_timer - dt
        else
            self.speed_mod = 1.0
        end

        local dx = player_x - self.x
        local dy = player_y - self.base_y 
        local distance = math.sqrt((dx * dx) + (dy * dy))
        local target_y = self.hover_y

        -- State Machine Logic
        if self.isAttacking then
            -- Lock movement while swinging!
            self.x_vel = 0 
            self.current_anim = self.animations.attack
            
            -- FIXED: Remove self.speed_mod from here! 
            -- This ensures they swing their weapon at normal speed even if their feet are slowed down.
            self.current_anim.currentTime = self.current_anim.currentTime + dt
            
            -- End attack when animation finishes
            if self.current_anim.currentTime >= self.current_anim.duration then
                self.isAttacking = false
                self.attack_timer = self.attack_cooldown_max
                self.current_anim.currentTime = 0
            end
        else
            -- ... (Keep the rest of your AI logic the exact same)
            -- AI Logic (Not Attacking)
            if distance <= self.attack_range and self.attack_timer <= 0 then
                -- Trigger Attack!
                self.isAttacking = true
                self.animations.attack.currentTime = 0
                -- Face the player before swinging
                if self.x < player_x then self.facing = -1 else self.facing = 1 end
                
            elseif distance < self.aggro_range then
                -- Chase Player
                self.current_anim = self.animations.walk
                target_y = player_y + (player_height / 2) - (self.height / 2)
                
                if self.x < player_x then
                    self.x_vel = self.x_vel + (self.acceleration * dt)
                    self.facing = -1 
                elseif self.x > player_x then
                    self.x_vel = self.x_vel - (self.acceleration * dt)
                    self.facing = 1
                end
            else
                -- Retreat & Idle
                if self.x_vel > 0 then
                    self.x_vel = self.x_vel - (self.friction * dt)
                    if self.x_vel < 0 then self.x_vel = 0 end
                elseif self.x_vel < 0 then
                    self.x_vel = self.x_vel + (self.friction * dt)
                    if self.x_vel > 0 then self.x_vel = 0 end
                end
                
                -- If they have slowed to a stop, stand idle. Otherwise, keep walking.
                if math.abs(self.x_vel) < 10 then
                    self.current_anim = self.animations.idle
                else
                    self.current_anim = self.animations.walk
                end
            end
            
            -- Tick Walk/Idle animations normally
            self.current_anim.currentTime = self.current_anim.currentTime + (dt * self.speed_mod)
            while self.current_anim.currentTime >= self.current_anim.duration do
                self.current_anim.currentTime = self.current_anim.currentTime - self.current_anim.duration
            end
        end

        if self.x_vel > self.max_speed then self.x_vel = self.max_speed end
        if self.x_vel < -self.max_speed then self.x_vel = -self.max_speed end

        self.x = self.x + (self.x_vel * self.speed_mod * dt)
        self.base_y = self.base_y + ((target_y - self.base_y) * 5 * dt)
        self.y = self.base_y + (math.sin(self.timer * self.wobble_speed) * self.wobble_amplitude)
    end

    function e:draw()
        if self.flash_timer > 0 then
            love.graphics.setColor(10, 10, 10, 1) 
        else
            love.graphics.setColor(self.color)
        end
        
        local frameIndex = math.floor(self.current_anim.currentTime / self.current_anim.duration * #self.current_anim.frames) + 1
        if frameIndex > #self.current_anim.frames then frameIndex = #self.current_anim.frames end
        local frameToDraw = self.current_anim.frames[frameIndex]

        local frameWidth = frameToDraw:getWidth()
        local frameHeight = frameToDraw:getHeight()
        
        local drawX = self.x + (frameWidth / 2 * self.scale)
        local drawY = self.y + (frameHeight / 2 * self.scale)

        love.graphics.draw(frameToDraw, drawX, drawY, 0, self.scale * self.facing, self.scale, frameWidth / 2, frameHeight / 2)
    end

    return e
end

return EnemyFactory