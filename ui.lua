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

return ui