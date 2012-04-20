--A Conway's Game of Life Implementation
--Drew Dudash


function love.load() --Intial Values
	draw = {} --Sets the draw variable to a list
	grid = {} --Sets the grid variable to a list
	
	game = "play" --can be "menu", "play", or "pause"
	
	alivecell_img = love.graphics.newImage("alive.bmp") --White Cell
	deadcell_img = love.graphics.newImage("dead.bmp") --Black Cell
	
	fontWidth = 8 --The width of the font
	fontHeight = 8 --The height of the font
	
	gridWidth = 90 --The length of a row of characters across the screen
	gridHeight = 70 --The heigh of a  column of characters across the screen
	
	do
		local x
		local y
		for x = 1, gridWidth do --For each section of the first row
			grid[x] = {} --Make a column down a list
			for  y = 1, gridHeight do --For each list
				grid[x][y] = false --Make a dead cell character
			end
		end
	end
	
	gridUp = grid
	
	function blankgrid()
		local x
		local y
		local grid = {}
		for x = 1, gridWidth do --For each section of the first row
			grid[x] = {} --Make a column down a list
			for  y = 1, gridHeight do --For each list
				grid[x][y] = false --Make a dead cell character
			end
		end
		return grid
	end
	
	function givetake(boolvalue) --Finds which cell the mouse is hovering over.
		local mouse_x
		local mouse_y
		mouse_x = love.mouse.getX()
		mouse_y = love.mouse.getY()
		gridUp[((mouse_x - (mouse_x % fontWidth)) / fontWidth) + 1][((mouse_y - (mouse_y % fontHeight)) / fontHeight) + 1] = boolvalue
	end	
end

function love.draw() --Draws the game
	local i
	local j
	for i = 1,gridWidth do
		for j = 1,gridHeight do
			if grid[i][j] == false then
				love.graphics.draw(deadcell_img,(i - 1) * fontWidth + 1,(j - 1) * fontHeight + 1)
			else
				love.graphics.draw(alivecell_img,(i - 1) * fontWidth + 1,(j - 1) * fontHeight + 1)
			end
		end
	end
	if game == "pause" then love.graphics.print("PAUSE",1,fontHeight * gridHeight) end
end

function love.keypressed() --Handles keyboard input
	if game == "pause" then --While the game is paused
		if love.keyboard.isDown(" ") then --Unpauses life
			game = "play"
		end
		if love.keyboard.isDown("r") then --Resets the board
			grid = blankgrid()
		end
		if love.keyboard.isDown("q") then
			love.event.push("q")
		end
	elseif game == "play" then --While the game is in play
		if love.keyboard.isDown(" ") then --Pauses life
			game = "pause"
		end
	end
end

function love.mousepressed() --Handles mouse input
	if game == "pause" then
		if love.mouse.isDown("l") then --Left mouse breathes life into cells
			givetake(true)
		end
		if love.mouse.isDown("r") then --Right mouse blots out cells
			givetake(false)	
		end
	end
end

function love.update(dt) --Runs game logic
	if game == "play" then --While game is in play
		gridUp = blankgrid() --Resets the secondary grid to blank (A secondary grid exists so that all cells change simateanisaly.
		local i
		local j
		--This takes care of updating squares based ont he adjacent ones, YEAH!
		for i = 1,gridWidth do --Counts 'x' of the grid
			for j = 1,gridHeight do --Count 'y' of the grid
				local bordercount --Keeps count of adjacent 'true' squares
				bordercount = 0
				local k
				local v
				for k = -1,1 do --Checks the grid point along with the ones to the left and right
					if grid[i + k] ~= nil then --Stops if the first array is non-existant
						for v = -1,1 do --Checks the grid points above and below the left right and center points
							if grid[i + k][j + v] ~= nil then --Stops if the second array is non-existant
								if k ~= 0 or v ~= 0 then --If the point is at grid[i][j] do nothing
									if grid[i + k][j + v] == true then --If the point is true add to bordercount
										bordercount = bordercount + 1
									end
								end
							end
						end
					end
				end
				--Conways Rules
				if grid[i][j] == true and bordercount < 2 then gridUp[i][j] = false end --Any live cell with fewer than two live neighbours dies, as if caused by under-population.
				if grid[i][j] == true and bordercount == 2 or bordercount == 3 then gridUp[i][j] = true end --Any live cell with two or three live neighbours lives on to the next generation.
				if grid[i][j] == true and bordercount > 3 then gridUp[i][j] = false end --Any live cell with more than three live neighbours dies, as if by overcrowding.
				if grid[i][j] == false and bordercount == 3 then gridUp[i][j] = true end --Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
			end
		end
		grid = gridUp --Sets the grid that is read for drawing to the new pattern
		love.timer.sleep(80) --Delays the game so it runs slower
	end
end