LevelMaker = Class{}

function LevelMaker.createMap(level)
	local bricks = {}

	local numRows = math.random(3, 5)
	

	local maxTier = math.min(3, math.floor(level/5))
	local maxColor = math.min(5, level%5 + 2)
	local counter = 1
	keyLoc = 1--math.random(20)--numRows*10)

	for y = 1, numRows do
		local numCols = math.random(7, 13)
		numCols = numCols % 2 == 0 and numCols + 1 or numCols

		local skipPattern = math.random(1,2)==1 and true or false
		local skipFlag = math.random(1,2)==1 and true or false
		local altPattern = math.random(1,2)==1 and true or false
		local altColor = math.random(1,2)==1 and true or false
		local color1 = math.random(1, maxColor)
		local color2 = math.random(1, maxColor)
		local tier1 = math.random(0, maxTier)
		local tier2 = math.random(0, maxTier)
		

		--deciding if key brick should spawn, and which brick it should replace


		for x = 1, numCols do
			
			if keyLoc == counter then
				b = Brick(
					(x-1) * 32 + 8 + (13-numCols) * 16, y*16)
				b.color = 6
				b.tier = 3

				altColor = not altColor

				table.insert(bricks, b)
				keyExists = true
			else
				if skipPattern then
					skipFlag = not skipFlag
					if skipFlag then
						goto continue
					end
				end

				b = Brick(
					(x-1) * 32 + 8 + (13-numCols) * 16, y*16)

				--table.insert(bricks, b)

				if altPattern and altColor then
					b.color = color2
					b.tier = tier2
				else
					b.tier = tier1
					b.color = color1
				end

				altColor = not altColor

				table.insert(bricks, b)
			end
			counter = counter + 1
			::continue::
			
		end
	end

	if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end