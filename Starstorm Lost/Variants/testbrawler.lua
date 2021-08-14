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
local dumbStat = ""
local dumbNumber = 0
if math.chance(50) then
	dumbStat = "Skill Issue"
	dumbNumber = 12
else
	dumbStat = "Difficulty"
	dumbNumber = 2
end
SurvivorVariant.setInfoStats(newVariant, {{"Strength", 9}, {"Vitality", 6}, {"Toughness", 9}, {"Agility", 5}, {dumbStat, dumbNumber}, {"Fluff", 7}}) 


SurvivorVariant.setDescription(newVariant, "Wrestled with a bear bare-fisted and, well, bear was buried with utmost respect. \n\nThis Brawler can perform a variant version of his X, C, and V skill attacks using &g&Stamina&!&, \nperformed by inputting X, C, or V a second time. \n\nEach X/C/V input &b&costs Stamina,&!& regain by &y&landing blows.&!& \n &y&Light&!& &lt&(X)&!& - &g&10 Stamina&!& &dk&|&!& &or&Medium&!& &lt&(C)&!& - &g&20 Stamina&!& &dk&|&!& &r&Heavy&!& &lt&(V)&!& - &g&40 Stamina&!&")

local sprSkills = Sprite.load("Test_Brawler_Skills", "Survivors/Brawler/skills", 7, 0, 0)

--local skillSprite = Sprite.load("BluemandoSkill1", "Bluemando/Skill1", 1, 0, 0)
--SurvivorVariant.setLoadoutSkill(newVariant, "Doublue Tab", "Shoot twice for &y&2x60% &b&blue &y&damage.&!&", skillSprite)
callback.register("onSkinInit", function(player, skin) 
	if skin == newVariant then
		player:getData().trueBrawler = true
		player:getData().skin_fullSkillOverride = true
		player:getData().skin_skill1Override = false
		player:getData().skin_skill2Override = false
		player:getData().skin_skill3Override = false
		player:getData().skin_skill4Override = false 
		player:getData().mainInputTimer = 20
		player:getData().currentStamina = 80
		player:getData().newStamina = 80
		player:getData().maxStamina = 100
		player:getData().pounceInput = "ability4"
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

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == newVariant then
	
		local function check(input)
			if player:getData().buttonInputHandler[2] == input then
				return true;
			end
		end
		
		local function cancel()
			for i=1, 6 do player:getData().buttonInputHandler[i] = 0 end
		end
		
		local function sCheck(stamina)
			if player:getData().currentStamina >= stamina then
				return true;
			else
				return false;
			end
		end
		
		local function useStamina(stamina)
			player:getData().newStamina = math.max(player:getData().newStamina - stamina, 0)
		end
		
		local decayRate = 8
		if player:getData().newStamina < player:getData().currentStamina then
			decayRate = decayRate + math.abs(player:getData().newStamina - player:getData().currentStamina)/4
		end --smooth decay rate, scales with difference
		
		if player:getData().newStamina < player:getData().currentStamina then
			player:getData().currentStamina = math.approach(player:getData().currentStamina, player:getData().newStamina, decayRate/60)
		end --decay
		
		if player:getData().newStamina > player:getData().currentStamina then
			player:getData().currentStamina = player:getData().newStamina
		end --instant
		
		--[[The only way I found for this to work is to function purely in the step callback.]]
		local bufferWindow = 20 --sets how long an input can be made until it is cancelled and given default light version
		--X ending skills
		if player:getData().buttonInputHandler[1] == 2 then
			if sCheck(10) then
				if player:get("activity") == 0 then 
					if player:getData().mainInputTimer == 0 then
						player:getData().mainInputTimer = bufferWindow
					elseif player:getData().buttonInputHandler[2] ~= 0 then
						player:getData().mainInputTimer = 0 --beginning
						if check(2) and sCheck(10) then
							player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
							useStamina(20)
						elseif check(3) and sCheck(20) then
							player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
							useStamina(30)
						elseif check(4) and sCheck(40) then
							player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
							useStamina(50)
						end
						cancel() --end
					end
				end
			end
		end
		--C ending skills
		if player:getData().buttonInputHandler[1] == 3 then
			if sCheck(20) then
				if player:get("activity") == 0 then
					if player:getData().mainInputTimer == 0 then
						player:getData().mainInputTimer = bufferWindow
					elseif player:getData().buttonInputHandler[2] ~= 0 then
						player:getData().mainInputTimer = 0
						if check(2) and sCheck(10) then
							player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
							useStamina(30)
							player:getData().currentSpecial = 6
						elseif check(3) and sCheck(20) then
							player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, true)
							useStamina(40)
							player:getData().currentSpecial = 7
						elseif check(4) and sCheck(40) then
							player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
							useStamina(60)
							player:getData().currentSpecial = 4
						end
						cancel()
					end
				end
			end
		end
		--V ending skills	
		if player:getData().buttonInputHandler[1] == 4 then
			if sCheck(40) then
				if player:get("activity") == 0 then
					if player:getData().mainInputTimer == 0 then
						player:getData().mainInputTimer = bufferWindow
					elseif player:getData().buttonInputHandler[2] ~= 0 then
						player:getData().mainInputTimer = 0
						if check(2) and sCheck(10) then
							player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
							useStamina(50)
							player:getData().currentSpecial = 2
						elseif check(3) and sCheck(20) then
							player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, true)
							useStamina(60)
							player:getData().currentSpecial = 3
						elseif check(4) and sCheck(40) then
							player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
							useStamina(80)
							player:getData().currentSpecial = 5
						end
						cancel()
					end
				end
			end
		end
		--20 frame window enders

		if player:getData().buttonInputHandler[1] == 2 and player:getData().buttonInputHandler[2] == 0 and player:getData().mainInputTimer == 1 then
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
			useStamina(10)
			cancel()
		end

		if player:getData().buttonInputHandler[1] == 3 and player:getData().buttonInputHandler[2] == 0 and player:getData().mainInputTimer == 1 then
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
			useStamina(20)
			cancel()
		end

		if player:getData().buttonInputHandler[1] == 4 and player:getData().buttonInputHandler[2] == 0 and player:getData().mainInputTimer == 1 then
			player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
			useStamina(40)
			cancel()
		end

--[[]]

		if player:getData().mainInputTimer > 0 then
			player:getData().mainInputTimer = player:getData().mainInputTimer - 1
		end
	end
end)

callback.register("preHit", function(damager, hit) --needs synced (i think ?)
	local parent = damager:getParent()
	if parent and parent:isValid() then
		if hit and hit:isValid() then
			if parent:getData().currentStamina then
				if damager:getData().staminaReturn then
					parent:getData().newStamina = math.min(parent:getData().maxStamina, parent:getData().newStamina + damager:getData().staminaReturn)
				else
					parent:getData().newStamina = math.min(parent:getData().maxStamina, parent:getData().newStamina + 10)
				end
			end
		end
	end
end)

end)