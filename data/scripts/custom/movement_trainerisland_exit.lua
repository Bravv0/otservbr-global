local function removeTrainers(position)
	local arrayPos = {
		{x = position.x - 1, y = position.y + 1, z = position.z},
		{x = position.x + 1 , y = position.y + 1, z = position.z}
	}

	for places = 1, #arrayPos do
		local trainer = Tile(arrayPos[places]):getTopCreature()
		if trainer then
			if trainer:isMonster() then
				trainer:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				trainer:remove()
			end
		end
	end
end

local trainerExit = MoveEvent()

function trainerExit.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	local lastTownID = getPlayerStorageValue(creature, 420420)
	local oldPosition = fromPosition
	if lastTownID > 1 then
		local lastTown = Town(tonumber(lastTownID))
		local templePos = lastTown:getTemplePosition()
		creature:teleportTo(templePos)
		oldPosition:sendMagicEffect(CONST_ME_TELEPORT)
		templePos:sendMagicEffect(CONST_ME_TELEPORT)
		setPlayerStorageValue(creature, 420420, 0)		
	else
		local playerTown = creature:getTown()
		local templePos = playerTown:getTemplePosition()
		creature:teleportTo(templePos)
		oldPosition:sendMagicEffect(CONST_ME_TELEPORT)
		templePos:sendMagicEffect(CONST_ME_TELEPORT)		
		setPlayerStorageValue(creature, 420420, 0)			
	end
	return true
end

trainerExit:aid(40016)
trainerExit:register()
