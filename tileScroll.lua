-- load tiles: goes in love.load()
function tileLoad()
	-- REPLACE WITH ACTUAL GAME TILES
	tile = {}
	for i=0,3 do -- change 3 to the number of tile images minus 1.
		tile[i] = love.graphics.newImage( "tile"..i..".png" )
	end
	
	-- test map-- redo with actual values
	map={ 0, 1, 0, 2, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 0, 0, 1, 2, 0, 3, 0, 0, 0, 2, 3, 0, 1}
		
	-- map variables
	map_w = #map -- Obtains the width of the map (# GETS THE LENGTH OF AN ELEMENT)
	map_x = 0
	map_y = 0
	map_display_buffer = 2 -- We have to buffer one tile before and behind our viewpoint.
                               -- Otherwise, the tiles will just pop into view, and we don't want that.
	map_display_w = 20
	map_display_h = 15
	tile_w = 150
	tile_h = 100
end
	
-- draw map: goes in love.draw()
function draw_map()
	offset_x = map_x % tile_w
	offset_y = map_y % tile_h
	firstTile_x = math.floor(map_x / tile_w)
	firstTile_y = math.floor(map_y / tile_h)
	
 	for y=1, (map_display_h + map_display_buffer) do
		for x=1, (map_display_w + map_display_buffer) do
			-- Note that this condition block allows us to go beyond the edge of the map.
			if y+firstTile_y >= 1
				and x+firstTile_x >= 1 and x+firstTile_x <= map_w
			then
				love.graphics.draw(tile[map[x+firstTile_x]], 
					((x-1)*tile_w) - offset_x - tile_w/2, 
					1080-tile_h)
			end
		end
	end
end

-- updates the tile position based on keyboard input: goes in love.update()
function updateTile( dt, int )
	local speed = int * dt
	-- get input
	if love.keyboard.isDown( "a" ) then
		map_x = map_x - speed
	end
	if love.keyboard.isDown( "d" ) then
		map_x = map_x + speed
	end
	-- check boundaries. remove this section if you don't wish to be constrained to the map.
	if map_x < 0 then
		map_x = 0
	end

	if map_y < 0 then
		map_y = 0
	end	
 
	if map_x > map_w * tile_w - map_display_w * tile_w - 1 then
		map_x = map_w * tile_w - map_display_w * tile_w - 1
	end
 
end

return tileScroll