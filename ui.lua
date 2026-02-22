-- ui.lua
local ui = {}

-- A helper function to easily draw UI buttons
function ui.drawButton(text, bx, by, bw, bh)
    local mx, my = love.mouse.getPosition()
    local isHovering = mx >= bx and mx <= bx + bw and my >= by and my <= by + bh
    
    -- Highlight button if hovering
    if isHovering then
        love.graphics.setColor(0.3, 0.3, 0.3, 1)
    else
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
    end
    
    love.graphics.rectangle("fill", bx, by, bw, bh, 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", bx, by, bw, bh, 5, 5)
    
    -- Lock the font to regular before printing button text!
    if regularFont then love.graphics.setFont(regularFont) end
    love.graphics.printf(text, bx, by + (bh/2) - 15, bw, "center")
    
    return isHovering 
end
-- Handles the math for clicking and dragging
function ui.updateSlider(bx, by, bw, bh, currentValue)
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        
        -- Check if mouse is interacting with the slider area
        if mx >= bx and mx <= bx + bw and my >= by - 10 and my <= by + bh + 10 then
            local newValue = (mx - bx) / bw
            
            -- Clamp it so it doesn't go below 0 or above 1
            if newValue < 0 then newValue = 0 end
            if newValue > 1 then newValue = 1 end
            
            return newValue
        end
    end
    
    return currentValue -- Return the unchanged value if not interacting
end

-- Handles drawing the track, fill, knob, and text
function ui.drawSlider(label, bx, by, bw, bh, currentValue)
    -- Draw Label Text
    if regularFont then love.graphics.setFont(regularFont) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(label .. ": " .. math.floor(currentValue * 100) .. "%", 0, by - 40, love.graphics.getWidth(), "center")
    
    -- Draw empty track (Dark Gray)
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", bx, by, bw, bh)
    
    -- Draw filled track (Wood color)
    love.graphics.setColor(0.8, 0.6, 0.4, 1) 
    love.graphics.rectangle("fill", bx, by, bw * currentValue, bh)
    
    -- Draw the draggable slider knob (White)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", bx + (bw * currentValue) - 5, by - 5, 10, bh + 10)
end

return ui