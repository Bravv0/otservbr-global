local mType = Game.createMonsterType("Fury")
local monster = {}

monster.description = "a fury"
monster.experience = 3600
monster.outfit = {
	lookType = 149,
	lookHead = 94,
	lookBody = 77,
	lookLegs = 96,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "blood"
monster.corpse = 20399
monster.speed = 400
monster.summonCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Ahhhhrrrr!", yell = false},
	{text = "Waaaaah!", yell = false},
	{text = "Caaarnaaage!", yell = false},
	{text = "Dieee!", yell = false}
}

monster.loot = {
	{id = 2124, chance = 410},
	{id = "gold coin", chance = 30000, maxCount = 100},
	{id = "gold coin", chance = 30000, maxCount = 100},
	{id = "gold coin", chance = 38000, maxCount = 69},
	{id = "platinum coin", chance = 2800, maxCount = 4},
	{id = "terra rod", chance = 20000},
	{id = "golden legs", chance = 130},
	{id = "steel boots", chance = 790},
	{id = "orichalcum pearl", chance = 1500, maxCount = 4},
	{id = "red piece of cloth", chance = 4000},
	{id = "soul orb", chance = 21500},
	{id = "soul orb", chance = 50},
	{id = 6301, chance = 60},
	{id = "demonic essence", chance = 22500},
	{id = "concentrated demonic blood", chance = 35000, maxCount = 3},
	{id = "assassin dagger", chance = 660},
	{id = "noble axe", chance = 2000},
	{id = "great health potion", chance = 10500},
	{id = "jalapeno pepper", chance = 29280, maxCount = 4}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -510, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 2000, chance = 10, minDamage = -200, maxDamage = -300, type = COMBAT_FIREDAMAGE, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 5, minDamage = -120, maxDamage = -700, type = COMBAT_DEATHDAMAGE, length = 8, spread = 3, effect = CONST_ME_DRAWBLOOD, target = false},
	{name ="combat", interval = 2000, chance = 10, minDamage = -120, maxDamage = -300, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_DRAWBLOOD, target = false},
	{name ="combat", interval = 2000, chance = 5, target = false},
	{name ="combat", interval = 2000, chance = 10, minDamage = -120, maxDamage = -300, type = COMBAT_LIFEDRAIN, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, minDamage = -125, maxDamage = -250, type = COMBAT_DEATHDAMAGE, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -800, duration = 30000}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="speed", interval = 2000, chance = 15, speedChange = 800, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
