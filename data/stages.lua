-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 8,
		multiplier = 30
	},
	{
		minlevel = 9,
		maxlevel = 45,
		multiplier = 30
	},
	{
		minlevel = 46,
		maxlevel = 80,
		multiplier = 15
	},
	{
		minlevel = 81,
		maxlevel = 130,
		multiplier = 10
	},
	{
		minlevel = 131,
		maxlevel = 160,
		multiplier = 7
	},
	{
		minlevel = 161,
		maxlevel = 190,
		multiplier = 4
	},
		{
		minlevel = 191,
		maxlevel = 220,
		multiplier = 2
	},
		{
		minlevel = 221,
		maxlevel = 250,
		multiplier = 1.5
	},
		{
		minlevel = 251,
		multiplier = 1
	}
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 59,
		multiplier = 20
	}, {
		minlevel = 60,
		maxlevel = 69,
		multiplier = 10
	}, {
		minlevel = 70,
		maxlevel = 79,
		multiplier = 5
	}, {
		minlevel = 80,
		maxlevel = 99,
		multiplier = 4
	}, {
		minlevel = 100,
		multiplier = 1
	}
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 59,
		multiplier = 15
	}, {
		minlevel = 60,
		maxlevel = 79,
		multiplier = 5
	}, {
		minlevel = 80,
		maxlevel = 89,
		multiplier = 2
	}, {
		minlevel = 90,
		multiplier = 1
	}
}