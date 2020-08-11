function generateQuads(atlas, tilewidth, tileheight)
	local sheetWidth = atlas:getWidth()/tilewidth
	local sheetHeight = atlas:getHeight()/tileheight

	local counter = 1
	local spritesheet = {}

	for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[counter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            counter = counter + 1
        end
    end
	return spritesheet
end

function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

function generateQuadsPaddles(atlas)
	local counter = 1
	local spritesheet = {}

	for i = 0, 3 do
		spritesheet[counter] = love.graphics.newQuad(
			0,64+i*32,32,16,atlas:getDimensions())
		counter = counter + 1

		spritesheet[counter] = love.graphics.newQuad(
			32,64+i*32,64,16,atlas:getDimensions())
		counter = counter + 1

		spritesheet[counter] = love.graphics.newQuad(
			96,64+i*32,96,16,atlas:getDimensions())
		counter = counter + 1

		spritesheet[counter] = love.graphics.newQuad(
			0,80+i*32,128,16,atlas:getDimensions())
		counter = counter + 1
	end
	return spritesheet
end

function generateQuadsBalls(atlas)
	local x = 96
	local y = 48

	local counter = 1
	local quads = {}

	for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    x = 96
    y = 56

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

	return quads
end

function generateQuadsBricks(atlas)
	local x = 0
	local y = 0

	local counter = 1
	local quads = {}
	for j = 0, 3 do
		for i = 0, 5 do
			quads[counter] = love.graphics.newQuad(
				x, y, 32, 16, atlas:getDimensions())
			counter = counter + 1
			x = x + 32
		end
		y = y + 16
		x = 0
	end



	return quads
end
