local configTrainers = { -- trainers
	-- Position of the first position (line 1 column 1)
	firstRoomPos = {x = 9037, y = 12516, z = 7},
	-- X distance between each room (on the same line)
	nextPosX = 17,
	-- Y distance between each room (on the same line)
	nextPosY = 16,
	-- Number of columns
	columns = 10,
	-- Number of lines 
	rows = 10
}

function spawnTrainers()
	local TrainersPos = getTrainersPos()
	for i=1,configTrainers.columns do
		for j=1,configTrainers.rows do			
			Game.createMonster("Training Monk", {x = TrainersPos[i][j].x-1, y = TrainersPos[i][j].y-1, z = TrainersPos[i][j].z}, true, false)
	        Game.createMonster("Training Monk", {x = TrainersPos[i][j].x+1, y = TrainersPos[i][j].y-1, z = TrainersPos[i][j].z}, true, false)
		end	
	end
end

function getTrainersPos()
	local array = {}
	for i=1,configTrainers.columns do
		array[i] = {}	
		for j=1,configTrainers.rows do			
			array[i][j] = {x = configTrainers.firstRoomPos.x + (configTrainers.nextPosX*(i-1)), y = configTrainers.firstRoomPos.y + (configTrainers.nextPosY*(j-1)), z = 7}
		end	
	end
	return array
end


local customStartup = GlobalEvent("spawn trainers")
function customStartup.onStartup()
	addEvent(function()
		spawnTrainers()
		print("> Spawned Training Monks.")
	end, 5 * 1000)
	
	print(Game.getLastServerSave())
end


customStartup:register()

