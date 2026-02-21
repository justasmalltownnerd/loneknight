if arg[2] == "debug" then
    require("lldebugger").start()
end

platform = {}
player = {}

-- Load some default values for our rectangle.
function love.load()
    x, y, w, h = 20, 20, 60, 20

    platform.width = love.graphics.getWidth()    -- This makes the platform as wide as the whole game window.
	platform.height = love.graphics.getHeight()  -- This makes the platform as tall as the whole game window.
        
    -- This is the coordinates where the platform will be rendered.
	platform.x = 0                               -- This starts drawing the platform at the left edge of the game window.
	platform.y = platform.height / 2             -- This starts drawing the platform at the very middle of the game window

    -- This is the coordinates where the player character will be rendered.
	player.x = love.graphics.getWidth() / 2   -- This sets the player at the middle of the screen based on the width of the game window. 
	player.y = love.graphics.getHeight() / 2  -- This sets the player at the middle of the screen based on the height of the game window. 

    -- This calls the file named "goku.png" and puts it in the variable called player.img.
	player.img = love.graphics.newImage('Sprites/goku.png')
end

-- Increase the size of the rectangle every frame.
function love.update(dt)

end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.setColor(1, 0, 0,1)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 64)
end
