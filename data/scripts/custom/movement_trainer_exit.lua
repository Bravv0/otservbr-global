local trainerIslandExit = MoveEvent()

function trainerIslandExit.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	--local oldPosition = fromPosition
--	local newPosition = Position(5023, 5039, 7)
	local newPosition = {x=9235, y=12519, z=7}
	creature:teleportTo(newPosition)
--	oldPosition:sendMagicEffect(CONST_ME_TELEPORT)
	Position(newPosition):sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

trainerIslandExit:aid(40018)
trainerIslandExit:register()
