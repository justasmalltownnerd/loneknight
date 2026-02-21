-- animation.lua

function newAnimationFromFiles(filePathPrefix, totalFrames, duration)
    local animation = {}
    animation.frames = {}
    
    for i = 1, totalFrames do
        -- Now it just glues your custom path, the number, and '.png' together!
        -- Example: "Sprites/PlayerWalk/PlayerFrame" + "1" + ".png"
        local imagePath = filePathPrefix .. i .. '.png'
        table.insert(animation.frames, love.graphics.newImage(imagePath))
    end
    
    animation.duration = duration or 1
    animation.currentTime = 0
    
    return animation
end