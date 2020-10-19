function Player.sendTibiaTime(self, hours, minutes)
	-- TODO: Migrate to protocolgame.cpp
	local msg = NetworkMessage()
	msg:addByte(0xEF)
	msg:addByte(hours)
	msg:addByte(minutes)
	msg:sendToPlayer(self)
	msg:delete()
	return true
end

local function onMovementRemoveProtection(cid, oldPos, time)
	local player = Player(cid)
	if not player then
		return true
	end

	local playerPos = player:getPosition()
	if (playerPos.x ~= oldPos.x or playerPos.y ~= oldPos.y or playerPos.z ~= oldPos.z) or player:getTarget() then
		player:setStorageValue(Storage.combatProtectionStorage, 0)
		return true
	end

	addEvent(onMovementRemoveProtection, 1000, cid, oldPos, time - 1)
end

local playerLogin = CreatureEvent("PlayerLogin")
function playerLogin.onLogin(player)
	local items = {
		{2120, 1},
		{2148, 3}
	}
	if player:getLastLoginSaved() == 0 then
		local backpack = player:addItem(1988)
		if backpack then
			for i = 1, #items do
				backpack:addItem(items[i][1], items[i][2])
			end
		end
		player:addItem(2050, 1, true, 1, CONST_SLOT_AMMO)
	else
		player:sendTextMessage(MESSAGE_STATUS_DEFAULT, string.format("Your last visit in ".. SERVER_NAME ..": %s.", os.date("%d. %b %Y %X", player:getLastLoginSaved())))
	end

	local playerId = player:getId()
	DailyReward.init(playerId)

	player:loadSpecialStorage()

	if player:getGroup():getId() >= 4 then
		player:setGhostMode(true)
	end
	-- Boosted creature
	player:sendTextMessage(MESSAGE_LOOT, "Today's boosted creature: " .. BoostedCreature.name .. " \
	Boosted creatures yield more experience points, carry more loot than usual and respawn at a faster rate.")
	
	-- Bestiary tracker
	player:refreshBestiaryTracker()
		
	-- Stamina
	nextUseStaminaTime[playerId] = 1

	-- EXP Stamina
	nextUseXpStamina[playerId] = 1

	-- Prey Small Window
	for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
		player:sendPreyData(slot)
	end

	-- New prey
	nextPreyTime[playerId] = {
		[CONST_PREY_SLOT_FIRST] = 1,
		[CONST_PREY_SLOT_SECOND] = 1,
		[CONST_PREY_SLOT_THIRD] = 1
	}

	if (player:getAccountType() == ACCOUNT_TYPE_TUTOR) then
	local msg = [[:: Tutor Rules
		1 *> 3 Warnings you lose the job.
		2 *> Without parallel conversations with players in Help, if the player starts offending, you simply mute it.
		3 *> Be educated with the players in Help and especially in the Private, try to help as much as possible.
		4 *> Always be on time, if you do not have a justification you will be removed from the staff.
		5 *> Help is only allowed to ask questions related to tibia.
		6 *> It is not allowed to divulge time up or to help in quest.
		7 *> You are not allowed to sell items in the Help.
		8 *> If the player encounters a bug, ask to go to the website to send a ticket and explain in detail.
		9 *> Always keep the Tutors Chat open. (required).
		10 *> You have finished your schedule, you have no tutor online, you communicate with some CM in-game
		or ts and stay in the help until someone logs in, if you can.
		11 *> Always keep a good Portuguese in the Help, we want tutors who support, not that they speak a satanic ritual.
		12 *> If you see a tutor doing something that violates the rules, take a print and send it to your superiors. "
		- Commands -
		Mute Player: /mute nick, 90 (90 seconds)
		Unmute Player: /unmute nick.
		- Commands -]]
		player:popupFYI(msg)
	end

	-- Open channels
	if table.contains({TOWNS_LIST.DAWNPORT, TOWNS_LIST.DAWNPORT_TUTORIAL}, player:getTown():getId())then
		player:openChannel(3) -- World chat
	else
		player:openChannel(3) -- World chat
		player:openChannel(5) -- Advertsing main
	end

	-- Rewards
	local rewards = #player:getRewardList()
	if(rewards > 0) then
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("You have %d %s in your reward chest.",
		rewards, rewards > 1 and "rewards" or "reward"))
	end

	-- Update player id
	local stats = player:inBossFight()
	if stats then
		stats.playerId = player:getId()
	end

	if player:getStorageValue(Storage.combatProtectionStorage) < 1 then
		player:setStorageValue(Storage.combatProtectionStorage, 1)
		onMovementRemoveProtection(playerId, player:getPosition(), 10)
	end
	-- Set Client XP Gain Rate
	local baseExp = 100
	if Game.getStorageValue(GlobalStorage.XpDisplayMode) > 0 then
		baseExp = getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXP))
	end

	local staminaMinutes = player:getStamina()
	local doubleExp = false --Can change to true if you have double exp on the server
	local staminaBonus = (staminaMinutes > 2400) and 150 or ((staminaMinutes < 840) and 50 or 100)
	if doubleExp then
		baseExp = baseExp * 2
	end
	player:setStaminaXpBoost(staminaBonus)
	player:setBaseXpGain(baseExp)

	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)
	local minutes = worldTime % 60
	player:sendTibiaTime(hours, minutes)

	if player:getStorageValue(Storage.isTraining) == 1 then --Reset exercise weapon storage
		player:setStorageValue(Storage.isTraining,0)
	end
	
	giveQuests(player) -- give access to quests automatically
	return true
end

function checkQuest(player, storage, value)
	if player:getStorageValue(storage) < value then 
		player:setStorageValue(storage, value)
	end
end

function giveQuests(player)
--Quests Liberadas
--In Service of Yalahar 
	checkQuest(player, Storage.isTraining, 0)
	checkQuest(player, Storage.InServiceofYalahar.Questline, 51)
	checkQuest(player, Storage.InServiceofYalahar.Mission01, 6)
	checkQuest(player, Storage.InServiceofYalahar.Mission02, 8)
	checkQuest(player, Storage.InServiceofYalahar.Mission03, 6)
	checkQuest(player, Storage.InServiceofYalahar.Mission04, 6)
	checkQuest(player, Storage.InServiceofYalahar.Mission05, 8)
	checkQuest(player, Storage.InServiceofYalahar.Mission06, 5)
	checkQuest(player, Storage.InServiceofYalahar.Mission07, 5)
	checkQuest(player, Storage.InServiceofYalahar.Mission08, 4)
	checkQuest(player, Storage.InServiceofYalahar.Mission09, 2)
	checkQuest(player, Storage.InServiceofYalahar.Mission10, 1)
	checkQuest(player, Storage.InServiceofYalahar.DoorToLastFight, 1)
	
--WOTE
	checkQuest(player, Storage.WrathoftheEmperor.Questline, 1)
	checkQuest(player, Storage.WrathoftheEmperor.Mission01, 3)
	checkQuest(player, Storage.WrathoftheEmperor.Mission02, 3)
	checkQuest(player, Storage.WrathoftheEmperor.Mission03, 3)
	checkQuest(player, Storage.WrathoftheEmperor.Mission04, 3)
	checkQuest(player, Storage.WrathoftheEmperor.Mission05, 3)
	checkQuest(player, Storage.WrathoftheEmperor.Mission06, 4)
	checkQuest(player, Storage.WrathoftheEmperor.Mission07, 6)
	checkQuest(player, Storage.WrathoftheEmperor.Mission08, 2)
	checkQuest(player, Storage.WrathoftheEmperor.Mission09, 2)
	checkQuest(player, Storage.WrathoftheEmperor.Mission10, 1)
--Imbuiment
	checkQuest(player, Storage.ForgottenKnowledge.Tomes, 1)
	checkQuest(player, Storage.ForgottenKnowledge.LastLoreKilled, 1)    
	checkQuest(player, Storage.ForgottenKnowledge.TimeGuardianKilled, 1)
	checkQuest(player, Storage.ForgottenKnowledge.HorrorKilled, 1)
	checkQuest(player, Storage.ForgottenKnowledge.DragonkingKilled, 1)
	checkQuest(player, Storage.ForgottenKnowledge.ThornKnightKilled, 1)
	checkQuest(player, Storage.ForgottenKnowledge.LloydKilled, 1)
	checkQuest(player, Storage.ForgottenKnowledge.LadyTenebrisKilled, 1)
	checkQuest(player, Storage.ForgottenKnowledge.AccessMachine, 1)
--SearoutsYalahar
	checkQuest(player, Storage.SearoutesAroundYalahar.Darashia, 1)
	checkQuest(player, Storage.SearoutesAroundYalahar.AbDendriel, 1)
	checkQuest(player, Storage.SearoutesAroundYalahar.Venore, 1)
	checkQuest(player, Storage.SearoutesAroundYalahar.Ankrahmun, 1)
	checkQuest(player, Storage.SearoutesAroundYalahar.PortHope, 1)
	checkQuest(player, Storage.SearoutesAroundYalahar.Thais, 1)
	checkQuest(player, Storage.SearoutesAroundYalahar.LibertyBay, 1)
	checkQuest(player, Storage.SearoutesAroundYalahar.Carlin, 1)	
	
--The Ape City
	checkQuest(player, Storage.TheApeCity.Started, 1)	
	checkQuest(player, Storage.TheApeCity.Questline, 18)
	checkQuest(player, Storage.TheApeCity.DworcDoor, 1)
	checkQuest(player, Storage.TheApeCity.ChorDoor, 1)
	checkQuest(player, Storage.TheApeCity.ParchmentDecyphering, 1)
	checkQuest(player, Storage.TheApeCity.FibulaDoor, 1)
	checkQuest(player, Storage.TheApeCity.WitchesCapSpot, 1)
	checkQuest(player, Storage.TheApeCity.CasksDoor, 1)
	checkQuest(player, Storage.TheApeCity.Casks, 1)
	checkQuest(player, Storage.TheApeCity.HolyApeHair, 1)
	checkQuest(player, Storage.TheApeCity.SnakeDestroyer, 1)
	
--The Inquisition
	checkQuest(player, Storage.TheInquisition.Questline, 20)
	checkQuest(player, Storage.TheInquisition.Mission01, 7)
	checkQuest(player, Storage.TheInquisition.Mission02, 3)
	checkQuest(player, Storage.TheInquisition.Mission03, 6)
	checkQuest(player, Storage.TheInquisition.Mission04, 3)
	checkQuest(player, Storage.TheInquisition.Mission05, 3)
	checkQuest(player, Storage.TheInquisition.Mission06, 3)
	
--Djinns
	checkQuest(player, Storage.DjinnWar.EfreetFaction.Start, 1)
	checkQuest(player, Storage.DjinnWar.EfreetFaction.Mission01, 3)
	checkQuest(player, Storage.DjinnWar.EfreetFaction.Mission02, 3)
	checkQuest(player, Storage.DjinnWar.EfreetFaction.Mission03, 3)

	checkQuest(player, Storage.DjinnWar.MaridFaction.Start, 1)
	checkQuest(player, Storage.DjinnWar.MaridFaction.Mission01, 2)
	checkQuest(player, Storage.DjinnWar.MaridFaction.Mission02, 2)
	checkQuest(player, Storage.DjinnWar.MaridFaction.RataMari, 2)
	checkQuest(player, Storage.DjinnWar.MaridFaction.Mission03, 3)
	checkQuest(player, Storage.DjinnWar.Faction.Greeting, 2)
	checkQuest(player, Storage.DjinnWar.Faction.EfreetDoor, 1)
	checkQuest(player, Storage.DjinnWar.Faction.MaridDoor, 1)
	
--post man quest
	checkQuest(player, Storage.Postman.Mission01, 6)
	checkQuest(player, Storage.Postman.Mission02, 3)
	checkQuest(player, Storage.Postman.Mission03, 3)
	checkQuest(player, Storage.Postman.Mission04, 2)
	checkQuest(player, Storage.Postman.Mission05, 4)
	checkQuest(player, Storage.Postman.Mission06, 13)
	checkQuest(player, Storage.Postman.Mission07, 8)
	checkQuest(player, Storage.Postman.Mission08, 3)
	checkQuest(player, Storage.Postman.Mission09, 4)
	checkQuest(player, Storage.Postman.Mission10, 3)
	checkQuest(player, Storage.Postman.Rank, 5)
	checkQuest(player, Storage.Postman.Door, 1)
	
--warzones 
	checkQuest(player, Storage.BigfootBurden.QuestLine, 30)
	checkQuest(player, Storage.BigfootBurden.QuestLineComplete, 2)
	checkQuest(player, Storage.BigfootBurden.Shooting, 5)
	checkQuest(player, Storage.BigfootBurden.Rank, 1450)
	checkQuest(player, Storage.BigfootBurden.Warzone1Access, 2)
	checkQuest(player, Storage.BigfootBurden.Warzone2Access, 2)
	checkQuest(player, Storage.BigfootBurden.Warzone3Access, 2)
	checkQuest(player, Storage.BigfootBurden.WarzoneStatus, 1)
	
	
--the new frontier, farmine access
	checkQuest(player, Storage.TheNewFrontier.Questline, 25)
	checkQuest(player, Storage.TheNewFrontier.Mission01, 3)
	checkQuest(player, Storage.TheNewFrontier.Mission02, 6)
	checkQuest(player, Storage.TheNewFrontier.Mission03, 3)
	checkQuest(player, Storage.TheNewFrontier.Mission04, 2)
	checkQuest(player, Storage.TheNewFrontier.Mission05, 7)
	checkQuest(player, Storage.TheNewFrontier.Mission06, 3)
	checkQuest(player, Storage.TheNewFrontier.Mission07, 3)
	checkQuest(player, Storage.TheNewFrontier.Mission08, 2)
	checkQuest(player, Storage.TheNewFrontier.Mission09, 3)
	checkQuest(player, Storage.TheNewFrontier.Mission10, 1) 
	checkQuest(player, Storage.TheNewFrontier.TomeofKnowledge, 12)
	checkQuest(player, Storage.TheNewFrontier.TomeofKnowledge, 12)	
end

playerLogin:register()