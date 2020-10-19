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

function getAllTrainersPos()
	local array = {}
	for i=1,config.columns do
		array[i] = {}	
		for j=1,config.rows do			
			array[i][j] = {x = config.firstRoomPos.x + (config.nextPosX*(i-1)), y = config.firstRoomPos.y + (config.nextPosY*(j-1)), z = 7}
		end	
	end
	return array
end


local function isBusy(position)
	local creature = Tile(position):getTopCreature()
	if creature then
		if creature:isPlayer() then
			return true
		end
	end
	return false
end


local trainerEntrance = MoveEvent()
local town = 0

function trainerEntrance.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	
	local TrainersPos = getAllTrainersPos()
	local tempPos = Position(0,0,0)
	for i=1,config.columns do
		if not tempPos.x == 0 then 
			break 
		end
		for j=1,config.rows do	
			if not tempPos.x == 0 then 
				break 
			end		
			if not isBusy(TrainersPos[j][i]) then
				tempPos = TrainersPos[j][i]
			end
		end	
	end
	
	
	
	
	local oldPosition = fromPosition
	local closestTownID = getClosestTownID(oldPosition)
	if closestTownID > 0 then
		setPlayerStorageValue(creature, 420420, closestTownID)
		creature:teleportTo(tempPos)
		oldPosition:sendMagicEffect(CONST_ME_TELEPORT)
		Position(tempPos):sendMagicEffect(CONST_ME_TELEPORT)		
	else
		local playerTown = player:getTown()
		setPlayerStorageValue(creature, 420420, playerTown.getId())
		creature:teleportTo(tempPos)
		oldPosition:sendMagicEffect(CONST_ME_TELEPORT)
		Position(tempPos):sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

trainerEntrance:aid(40020)
trainerEntrance:register()


function getClosestTownID(pos)
	local townNames = {
		"Carlin",
		"Venore",
		"Thais",
		"Edron",
		"Ab'Dendriel",
		"Yalahar",
		"Roshamuul",
		"Port Hope",
		"Ankrahmun",
		"Darashia",
		"Farmine",
		"Kazordoon",
		"Liberty Bay",
		"Svargrond",
		"Rathleton",
		"Gray Beach",
		"Krailos",
		"Issavi"
	}
	local city = ''
	local distance = 0
	for _, name in ipairs(townNames) do
		local town = Town(name)
		if town then
			local v = town:getTemplePosition()
			local dist = ((pos.x-v.x)^2+(pos.y-v.y)^2)^(1/2)
			if (dist < 0) then
				dist = 0-dist
			end
			if city == '' then
				city = name
				distance = dist
			elseif (distance > dist)then
				city = name
				distance = dist
			end
		end 
	end
	local townID = Town(city):getId()
	return townID
end
