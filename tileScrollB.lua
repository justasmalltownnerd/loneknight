-- SECONDARY TILE SCROLL FOR PARALLAX

-- load tiles: goes in love.load()

-- loads tiles with title name[0-num] (ex. tree 0, tree 1, tree 2)
-- and tile WIDth and LENgth
-- tile map too
function tileLoadB(nameB, numB, widB, lenB, mapB)
	tileB = {}
	for iB=0,numB do -- change 3 to the number of tile images minus 1.
		tileB[iB] = love.graphics.newImage( "Sprites/TilesB/level"..current_level.."tilesB/" ..nameB.."B"..iB..".png" )
	end
	
	-- can grab any map
		mapB = mapB
	-- map variables
	map_wB = #mapB -- Obtains the width of the map (# GETS THE LENGTH OF AN ELEMENT)
	map_xB = 0
	map_yB = 0
	map_display_bufferB = 2 -- We have to buffer one tile before and behind our viewpoint.
                               -- Otherwise, the tiles will just pop into view, and we don't want that.
	map_display_wB = 20
	map_display_hB = 15
	tile_wB = widB
	tile_hB = lenB
end
	
-- draw map: goes in love.draw()
-- requires map
function draw_mapB(mapB)
	offset_xB = map_xB % tile_wB
	offset_yB = map_yB % tile_hB
	firstTile_xB = math.floor(map_xB / tile_wB)
	firstTile_yB = math.floor(map_yB / tile_hB)
	
 	for yB=1, (map_display_hB + map_display_bufferB) do
		for xB=1, (map_display_wB + map_display_bufferB) do
			-- Note that this condition block allows us to go beyond the edge of the map.
			if yB+firstTile_yB >= 1
				and xB+firstTile_xB >= 1 and xB+firstTile_xB <= map_wB
			then
				love.graphics.draw(tileB[mapB[xB+firstTile_xB]], 
					((xB-1)*tile_wB) - offset_xB - tile_wB/2, 
					900-tile_hB+200)
			end
		end
	end
end

-- updates the tile position based on keyboard input: goes in love.update()
function updateTileB( dtB)
	local speedB = 200 * dtB
	-- get input
	if love.keyboard.isDown( "a" ) then
		map_xB = map_xB - speedB
	end
	if love.keyboard.isDown( "d" ) then
		map_xB = map_xB + speedB
	end
	-- check boundaries. remove this section if you don't wish to be constrained to the map.
	if map_xB < 0 then
		map_xB = 0
	end

	if map_yB < 0 then
		map_yB = 0
	end	
 
	if map_xB > map_wB * tile_wB - map_display_wB * tile_wB - 1 then
		map_xB = map_wB * tile_wB - map_display_wB * tile_wB - 1
	end
 
end
