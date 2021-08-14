callback.register("postLoad", function()
if modloader.checkFlag("ssl_truebrawler") then--[]
local survivor = Survivor.find("Brawler", "SSLost")

local newVariant = SurvivorVariant.new(survivor, "True Brawler", Sprite.load("TrueBrawlerSelect", "Survivors/Brawler/Select", 4, 2, 0),
{ 
	--idle = Sprite.load("BluemandoIdle", "Bluemando/Idle", 1, 6, 6)
},
Color.fromHex(0xEAB779))

SurvivorVariant.setInfoStats(newVariant, {{"Strength", 9}, {"Vitality", 6}, {"Toughness", 9}, {"Agility", 5}, {"Difficulty", 10}, {"Fluff", 7}}) 

SurvivorVariant.setDescription(newVariant, "Wrestled with a bear bare-fisted and, well, bear was buried with utmost respect. \nTrue Brawler can use Special Moves and Normal Combos, \nusing directions and ability presses as inputs to perform them. \nFor Specials, the last direction held is most important to performing the move. \n&g&Lower zoom scale to see full movelist.&!& &r&WARNING: May be difficult to use if inexperienced.&!&")

local sprSkills = Sprite.load("True_Brawler_Skills", "Survivors/Brawler/skills", 7, 0, 0)


SurvivorVariant.setLoadoutSkill(newVariant, "Heavy Punch", "Down->Downforward->Forward+Z to perform a heavy punch, severely stunning opponents for &y&300% damage.&!&", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(newVariant, "Skyward", "Down->Forward->Downforward+X to perform an invincible uppercut, hitting three times and launching opponents upwards for up to &y&700% damage.&!&", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(newVariant, "Charged Pounce", "Down->Neutral->Down+C to prepare to launch after 1 second. Pressing C further times &b&increases speed.&!& Enemies struck receive your momentum.", sprSkills, 3)
SurvivorVariant.setLoadoutSkill(newVariant, "Ultra Suplex Hold", "Back->Downback->Down->Downforward->Forward+V to &y&grapple&!& the nearest foe, pummeling them mid-air for &y&100% damage&!& and slamming for &y&250% damage.&!&", sprSkills, 4)
SurvivorVariant.setLoadoutSkill(newVariant, "One-Two", "Z->Z to peform a second punch quickly after the first. &b&Special moves can be done quickly after the second blow.&!&", sprSkills, 5)
SurvivorVariant.setLoadoutSkill(newVariant, "Three-Hit Jab Combo", "Z->Z->Z to peform a fast three-hit combination attack. The final hit &b&stuns enemies&!& for &y&150% damage.&!&", sprSkills, 6)
SurvivorVariant.setLoadoutSkill(newVariant, "Pursuit", "Z->X->C to perform a &b&great leap.&!& If an enemy was thrown, &b&leap higher to chase them into the air.&!&", sprSkills, 7) 

--local skillSprite = Sprite.load("BluemandoSkill1", "Bluemando/Skill1", 1, 0, 0)
--SurvivorVariant.setLoadoutSkill(newVariant, "Doublue Tab", "Shoot twice for &y&2x60% &b&blue &y&damage.&!&", skillSprite)
callback.register("onSkinInit", function(player, skin) 
	if skin == newVariant then
		player:getData().trueBrawler = true
	end
--[[	if skin == newVariant then
		
		player:setSkill(1,
		"Doublue Tap",
		"Shoot twice for &y&2x60% &b&blue &y&damage.&!&",
		skillSprite, 1, 35)
	end]]
end)
end--[]
end)