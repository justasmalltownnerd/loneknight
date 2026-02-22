--  TERTIARY TILE SCROLL FOR PARALLAX
-- all tiles are 400x500

-- load tiles: goes in love.load()

-- loads tiles with title name[0-num] (ex. tree 0, tree 1, tree 2)
-- and tile WIDth and LENgth
-- tile map too
function tileLoadC(nameC, numC, widC, lenC, mapC)
	tileC = {}
	for iC=0,numC do -- change 3 to the number of tile images minus 1.
		tileC[iC] = love.graphics.newImage( "Sprites/TilesC/level"..current_level.."tilesC/" ..nameC.."C".. iC..".png" )
	end
	
	-- can grab any map
		mapC = mapC
	-- map variables
	map_wC = #mapC -- Obtains the width of the map (# GETS THE LENGTH OF AN ELEMENT)
	map_xC = 0
	map_yC = 0
	map_display_bufferC = 2 -- We have to buffer one tile before and behind our viewpoint.
                               -- Otherwise, the tiles will just pop into view, and we don't want that.
	map_display_wC = 20
	map_display_hC = 15
	tile_wC = widC
	tile_hC = lenC
end
	
-- draw map: goes in love.draw()
-- requires map
function draw_mapC(mapC)
	offset_xC = map_xC % tile_wC
	offset_yC = map_yC % tile_hC
	firstTile_xC = math.floor(map_xC / tile_wC)
	firstTile_yC = math.floor(map_yC / tile_hC)
	
 	for yC=1, (map_display_hC + map_display_bufferC) do
		for xC=1, (map_display_wC + map_display_bufferC) do
			-- Note that this condition block allows us to go beyond the edge of the map.
			if yC+firstTile_yC >= 1
				and xC+firstTile_xC >= 1 and xC+firstTile_xC <= map_wC
			then
				love.graphics.draw(tileC[mapC[xC+firstTile_xC]], 
					((xC-1)*tile_wC) - offset_xC - tile_wC/2, 
					600-tile_hC+200)
			end
		end
	end
end

-- updates the tile position based on keyboard input: goes in love.update()
function updateTileC( dtC)
	local speedC = 100 * dtC
	-- get input
	if love.keyboard.isDown( "a" ) then
		map_xC = map_xC - speedC
	end
	if love.keyboard.isDown( "d" ) then
		map_xC = map_xC + speedC
	end
	-- check boundaries. remove this section if you don't wish to be constrained to the map.
	if map_xC < 0 then
		map_xC = 0
	end

	if map_yC < 0 then
		map_yC = 0
	end	
 
	if map_xC > map_wC * tile_wC - map_display_wC * tile_wC - 1 then
		map_xC = map_wC * tile_wC - map_display_wC * tile_wC - 1
	end
 
end
