-- animation.lua

function newAnimationFromFiles(fileNamePrefix, totalFrames, duration)
    local animation = {}
    animation.frames = {}
    
    -- Loop through 1 to totalFrames and load each individual image
    for i = 1, totalFrames do
        local imagePath = 'Sprites/' .. fileNamePrefix .. i .. '.png'
        table.insert(animation.frames, love.graphics.newImage(imagePath))
    end
    
    animation.duration = duration or 1
    animation.currentTime = 0
    
    return animation
end