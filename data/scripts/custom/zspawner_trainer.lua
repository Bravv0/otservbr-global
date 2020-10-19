local config = {
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
	for i=1,config.columns do
		for j=1,config.rows do			
			Game.createMonster("Training Monk", {x = TrainersPos[i][j].x-1, y = TrainersPos[i][j].y-1, z = TrainersPos[i][j].z}, true, false)
	        Game.createMonster("Training Monk", {x = TrainersPos[i][j].x+1, y = TrainersPos[i][j].y-1, z = TrainersPos[i][j].z}, true, false)
		end	
	end
end


function getTrainersPos()
	local array = {}
	for i=1,config.columns do
		array[i] = {}	
		for j=1,config.rows do			
			array[i][j] = {x = config.firstRoomPos.x + (config.nextPosX*(i-1)), y = config.firstRoomPos.y + (config.nextPosY*(j-1)), z = 7}
		end	
	end
	return array
end


local spawnerTrainer = GlobalEvent("spawn trainers")
function spawnerTrainer.onStartup()
	addEvent(function()
				spawnTrainers()
				print("> Spawned Training Monks.")
			end, 7 * 1000)
end


spawnerTrainer:register()

