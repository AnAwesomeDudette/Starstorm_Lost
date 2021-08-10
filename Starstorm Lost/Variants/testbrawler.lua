callback.register("postLoad", function()
local survivor = Survivor.find("Brawler", "SSLost")
local path = "Survivors/Brawler/"
local sprite = Sprite.load("Test_Brawler_Idle", path.."idle", 1, 9, 9)
local newVariant = SurvivorVariant.new(survivor, "Test Brawler", Sprite.load("TestBrawlerSelect", "Survivors/Brawler/Select", 4, 2, 0),
{ 
	
	idle = sprite,
	walk = Sprite.load("Test_Brawler_Walk", path.."walk", 8, 10, 9),
	jump = Sprite.load("Test_Brawler_Jump", path.."jump", 1, 9, 9),
	climb = Sprite.load("Test_Brawler_Climb", path.."climb", 2, 5, 10),
	death = Sprite.load("Test_Brawler_Death", path.."death", 8, 10, 9),
	decoy = sprite,
	
	shoot1 = Sprite.load("Test_Brawler_Shoot1", path.."shoot1", 18, 6, 9),
	shoot1_1 = Sprite.load("Test_Brawler_Shoot1_1", path.."shoot1_1", 5, 6, 9),
	shoot1_2 = Sprite.load("Test_Brawler_Shoot1_2", path.."shoot1_2", 5, 6, 9),
	shoot2 = Sprite.load("Test_Brawler_Shoot2", path.."shoot2", 4, 10, 14),
	shoot3 = Sprite.load("Test_Brawler_Shoot3", path.."shoot3", 4, 7, 9),
	shoot4 = Sprite.load("Test_Brawler_Shoot4", path.."shoot4", 7, 10, 32),
	shoot4_1 = Sprite.load("Test_Brawler_Shoot4_1", path.."ULTRASUPLEXHOLD", 8, 10, 32),
	shoot5 = Sprite.load("Test_Brawler_Shoot5", path.."shoot4", 7, 10, 32),
},
Color.fromHex(0xEAB779))

SurvivorVariant.setInfoStats(newVariant, {{"Strength", 9}, {"Vitality", 6}, {"Toughness", 9}, {"Agility", 5}, {"Difficulty", 2}, {"Fluff", 7}}) 

SurvivorVariant.setDescription(newVariant, "Wrestled with a bear bare-fisted and, well, bear was buried with utmost respect. \nThis Brawler is currently a test character, to find an adequate input system for release.")

local sprSkills = Sprite.load("Test_Brawler_Skills", "Survivors/Brawler/skills", 7, 0, 0)

--local skillSprite = Sprite.load("BluemandoSkill1", "Bluemando/Skill1", 1, 0, 0)
--SurvivorVariant.setLoadoutSkill(newVariant, "Doublue Tab", "Shoot twice for &y&2x60% &b&blue &y&damage.&!&", skillSprite)
callback.register("onSkinInit", function(player, skin) 
	if skin == newVariant then
		player:getData().trueBrawler = true
		player:getData().skin_fullSkillOverride = true
		player:getData().skin_skill3Override = false
		player:getData().skin_skill3Override = false
		player:getData().skin_skill3Override = false
		player:getData().skin_skill3Override = false 
		player:getData().mainInputTimer = 20
	end
--[[	if skin == newVariant then
		
		player:setSkill(1,
		"Doublue Tap",
		"Shoot twice for &y&2x60% &b&blue &y&damage.&!&",
		skillSprite, 1, 35)
	end]]
end)


SurvivorVariant.setSkill(newVariant, 1, function(player)
if player:get("activity") == 0 then
	player:survivorActivityState(1, player:getAnimation("shoot1"), 0.25, true, true)
end
end)
--[[The way that I have to have this work, is by binding it by the end input. For example, if an ability uses
Utility->Ultimate, it has to be bound to Ultimate, and then check for a Utility input.]]
SurvivorVariant.setSkill(newVariant, 2, function(player)
local function check(input) --finds the relevant input
	if player:getData().buttonInputHandler[2] == input then
		return true;
	end
end


end)

SurvivorVariant.setSkill(newVariant, 3, function(player)
local function check(input)
	if player:getData().buttonInputHandler[2] == input then
		return true;
	end
end

end)

SurvivorVariant.setSkill(newVariant, 4, function(player)
local function check(input)
	if player:getData().buttonInputHandler[2] == input then
		return true;
	end
end

end)

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == newVariant then
	
		local function check(input)
			if player:getData().buttonInputHandler[2] == input then
				return true;
			end
		end
--[[The only way I found for this to work is to function purely in the step callback.]]
--X ending skills
if player:getData().buttonInputHandler[1] == 2 then
if player:get("activity") == 0 then 
	if player:getData().mainInputTimer == 0 then
		player:getData().mainInputTimer = 20
	elseif player:getData().buttonInputHandler[2] ~= 0 then
		player:getData().mainInputTimer = 0 --beginning
		if check(2) then
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
		elseif check(3) then
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif check(4) then
			player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
		end
		for i=1, 6 do player:getData().buttonInputHandler[i] = 0 end --end
	end
end
end
--C ending skills
if player:getData().buttonInputHandler[1] == 3 then
if player:get("activity") == 0 then
	if player:getData().mainInputTimer == 0 then
		player:getData().mainInputTimer = 20
	elseif player:getData().buttonInputHandler[2] ~= 0 then
		player:getData().mainInputTimer = 0
		if check(2) then
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
			player:getData().currentSpecial = 6
		elseif check(3) then
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, true)
			player:getData().currentSpecial = 7
		elseif check(4) then
			player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
			player:getData().currentSpecial = 4
		end
		for i=1, 6 do player:getData().buttonInputHandler[i] = 0 end
	end
end
end
--V ending skills	
if player:getData().buttonInputHandler[1] == 4 then
if player:get("activity") == 0 then
	if player:getData().mainInputTimer == 0 then
		player:getData().mainInputTimer = 20
	elseif player:getData().buttonInputHandler[2] ~= 0 then
		player:getData().mainInputTimer = 0
		if check(2) then
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
			player:getData().currentSpecial = 2
		elseif check(3) then
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, true)
			player:getData().currentSpecial = 3
		elseif check(4) then
			player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
			player:getData().currentSpecial = 5
		end
		for i=1, 6 do player:getData().buttonInputHandler[i] = 0 end
	end
end
end
--[[]]
		if player:getData().mainInputTimer > 0 then
			player:getData().mainInputTimer = player:getData().mainInputTimer - 1
		end
	end
end)

end)