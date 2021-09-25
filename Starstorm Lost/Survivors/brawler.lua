--Wrestled with a bear bare-fisted and, well, bear was buried with utmost respect.
local path = "Survivors/Brawler/"
--Credit to bruh#6900 and swuff★#2224 for a great deal of visual design and mechanical design inspiration~! ^^
local Brawler = Survivor.new("Brawler")

require("Variants/truebrawler")--um, dunno if i can do this ? only one way to fihnd out 
--require("Variants/testbrawler")
--ah, yeah i can do that :)

--for the record, it's known that Buster (special 5) causes "attempted to access invalid instance" errors sometimes


		--[[Command List: 
	Z (Punch)
	X (Throw)
	C (Pounce)
	V (Dive Drop)
		
	1 = 236/214Z (Heavy Punch), 
	2 = 623/421X OR [2]8X (Skyward), 
	3 = 252C (Charge Pounce), 
	4 = 41236/63214V (Ultra Suplex Hold),
	5 = (Buster),
	6 = 2X (Remover),
	7 = (Strong Pounce),
	8 = ZZ6CV (Wrath of a Raging Bear),
	9 = 6Z (Hook),
	10 = 8X (Yeet),
	11 = 8C (Super Jump Punch),
	12 = 2C (Head Start)
	]]
	
--These are what currentSpecial should be set to, in order to execute that move.


--local sBrawlerShoot1 = Sound.load("BrawlerShoot1", path.."skill1")

local sprite = Sprite.load("Brawler_Idle", path.."idle", 1, 9, 9)

local sprites = {
	idle = sprite,
	walk = Sprite.load("Brawler_Walk", path.."walk", 8, 10, 9),
	jump = Sprite.load("Brawler_Jump", path.."jump", 1, 9, 9),
	climb = Sprite.load("Brawler_Climb", path.."climb", 2, 5, 10),
	death = Sprite.load("Brawler_Death", path.."death", 8, 10, 9),
	decoy = sprite,
	
	shoot1 = Sprite.load("Brawler_Shoot1", path.."shoot1", 18, 6, 9),
	shoot1_1 = Sprite.load("Brawler_Shoot1_1", path.."shoot1_1", 5, 6, 9),
	shoot1_2 = Sprite.load("Brawler_Shoot1_2", path.."shoot1_2", 6, 6, 9),
	shoot2 = Sprite.load("Brawler_Shoot2", path.."shoot2", 4, 10, 14),
	shoot3 = Sprite.load("Brawler_Shoot3", path.."shoot3", 4, 7, 9),
	shoot4 = Sprite.load("Brawler_Shoot4", path.."shoot4", 7, 10, 32),
	shoot4_1 = Sprite.load("Brawler_Shoot4_1", path.."ULTRASUPLEXHOLD", 8, 10, 32),
	shoot5 = Sprite.load("Brawler_Shoot5", path.."shoot4", 7, 10, 32),
	shoot6 = Sprite.load("Brawler_Shoot6", path.."AkumaAssets", 10, 6, 19)
}

local sprSkills = Sprite.load("Brawler_Skills", path.."skills", 8, 0, 0)
local sprInputs = Sprite.load("Brawler_Inputs", path.."Inputs", 1, 0, 0)
local sprAkumaExplosion = Sprite.load("Brawler_WrathExplosion", path.."AkumaExplosion", 6, 11, 11)

Brawler.loadoutSprite = Sprite.load("Brawler_Select", path.."select", 4, 2, 0)

Brawler:setLoadoutInfo(
[[The &y&Brawler&!& is an agile melee fighter, trained to lay a beatdown unlike any other.
He can perform &b&Special Moves&!&, and string many normal attacks into
&b&devestating combos&!&, always using the right tools for the job: &y&his fists.&!&
Despite his abilities, the Brawler believes that &lt&Not every situation needs something fancy.&!&
&lt&Sometimes you just need a good ol'&!& &y&one-two&!&, something he's more than capable of.]], sprSkills)
-- his select sprite should really be a self fist bump

Brawler:setLoadoutSkill(1, "Punch",
[[Punch enemies at close range for &y&100% damage.&!&]])

Brawler:setLoadoutSkill(2, "Throw",
[[Throw enemies upwards for &y&250% damage.&!&]])

Brawler:setLoadoutSkill(3, "Pounce",
[[&b&Launch yourself&!& towards the nearest enemy in front of you.
Deal &y&250% damage&!& on impact with the enemy.]])

Brawler:setLoadoutSkill(4, "Dive Drop",
[[Become airborne and drop to the ground dealing up to &y&1000% damage.&!&
Deals more damage the &b&higher the drop&!& is executed. &b&Stuns enemies.&!&]])

Brawler.loadoutColor = Color.fromHex(0xEAB779)

Brawler.idleSprite = sprites.idle

Brawler.titleSprite = sprites.walk

Brawler.endingQuote = "..and so he left, wrestling with his past."

callback.register("postLoad", function() -- AWESOME LOOK HERE
	SurvivorVariant.setInfoStats(SurvivorVariant.getSurvivorDefault(Brawler), {{"Strength", 10}, {"Vitality", 4}, {"Toughness", 7}, {"Agility", 7}, {"Difficulty", 7}, {"Fluff", 7}})
	--SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(Brawler), "Wrestled with a bear bare-fisted and, well, bear was buried with utmost respect. \n\nThis Brawler gets the job done, with standard edition technique and power. \n&or&His true potential rests.&!&")
	SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(Brawler), "Wrestled with a bear bare-fisted and, well, bear was buried with utmost respect. \n&y&Hold 'Use' in-game to bring up movelist.&!& \n&g&Decrease zoom scale to see full movelist here.&!&")
	--if modloader.checkFlag("ssl_debug") then
	
		--[[
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Heavy Punch", "Down->Downforward->Forward+Z to perform a heavy punch, severely stunning opponents for &y&300% damage.&!& &g&(Lower zoom scale to see all Special Moves.)&!&", sprSkills, 1)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Skyward", "Forward->Down->Downforward+X to perform an invincible uppercut, hitting three times and launching opponents upwards for up to &y&700% damage.&!&", sprSkills, 2)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Charged Pounce", "Down->Neutral->Down+C to prepare to launch after 1 second. Pressing C further times &b&increases speed.&!& Enemies struck receive your momentum.", sprSkills, 3)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Ultra Suplex Hold", "Back->Downback->Down->Downforward->Forward+V to &y&grapple&!& the nearest foe, pummeling them mid-air for &y&100% damage&!& and slamming for &y&250% damage.&!&", sprSkills, 4)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "One-Two", "Z->Z to peform a second punch quickly after the first. &b&Special moves can be done quickly after the second blow.&!&", sprSkills, 5)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Three-Hit Jab Combo", "Z->Z->Z to peform a fast three-hit combination attack. The final hit &b&stuns enemies&!& for &y&125% damage.&!&", sprSkills, 6)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Pursuit", "Z->X->C to perform a &b&great leap.&!& If an enemy was thrown, &b&leap higher to chase them into the air.&!&", sprSkills, 7)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Wrath of a Raging Bear", "Z->Z->Forward->C->V to &r&perform the ultimate technique.&!&", sprSkills, 8)
		]]
		
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Hook", "&lt&Up+Z&!& to deliver a quick hook, &y&stunning&!& enemies for &y&90% damage.&!&", sprSkills, 1)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Heavy Punch", "&lt&Down+Z&!& to deliver devestating, slow punch for &y&200% damage&!&, &b&knocking enemies away.&!&", sprSkills, 2)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Removal", "Throw can be &lt&angled up or down&!& to &b&change where enemies are thrown.&y&", sprSkills, 3)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Skyward", "&lt&Hold Down, then Up+X&!& to perform an &b&invincible uppercut&!&, hitting three times and launching opponents upwards for up to &y&700% damage.&!&", sprSkills, 4)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Super Jump Punch", "&lt&Up+C&!& to &b&shoot straight for the sky.&!& &y&Deal 400% damage to extremely close enemies.&!&", sprSkills, 5)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Head Start", "&lt&Down+C&!& to begin &y&charging&!& a &b&fully actionable ground slide.&!& \n&lt&Can be held for up to 1 second.&!&", sprSkills, 6)
		--SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Buster", "&lt&Hold Down, then Up+V&!& to &y&grapple&!& the nearest foe. &y&Deal 500% damage on impact around you.&!&", sprSkills, 7)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Ultra Suplex Hold", "&lt&Hold Forward, then Back+V (any direction)&!& to &y&grapple&!& the nearest foe, pummeling mid-air for &y&100% damage&!& and slamming for &y&250% damage.&!&", sprSkills, 7)
		
	--end

end) --BASED DEPARTMENT

--PLEASEEEEEEEEEE WE NEED ARROWS TO CONVEY THESE INPUTS AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

Brawler:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if modloader.checkFlag("ssl_debug") then
		playerData.debug = true
		playerData.inputDebug = true
	end
	
	playerData.hasInputs = true --allows use of the input library
	playerData.smash = true --currently being used to override brawler's skills in favor of a simpler system
	
	playerData.punch = 1 --handles 3 hit Z skill
	
	playerData.pounceCharge = 0 --counter used to increase strength of Charge Pounce when charging inputs are made
	playerData.pounceTimer = 0 --frame counter used to provide charge input window
	playerData.pounceInput = "ability3" --sets the ability to be used for Charge Pounce charging inputs
	
	playerData.canPursue = false --boolean that determines if pursuit should go max range
	--(deprecated)
	
	--buster refers to any sort of command grab, something that grabs the opponent and moves them with the player instead of just hitting them
	--likewise, buster also generally refers to Suplex
	playerData.busterTarget = false --accessor that points towards enemy/enemies hit with Suplex
	playerData.busterContact = false --boolean that triggers when contact is made with the ground while Suplex occurs
	playerData.canBusterBosses = false --self explanatory
	
	playerData.wrath = false --controls the wrath of a raging bear
	playerData.doWrath = false --weird dumb workaround :c
	
	playerAc.armor = playerAc.armor + 30
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 13, 0.038)
	else
		player:survivorSetInitialStats(100, 13, 0.008)
	end
	
	player:setSkill(1, "Punch", "Punch enemies at close range for 100% damage.",
	sprSkills, 1, 25)
		
	player:setSkill(2, "Throw", "Throw enemies upwards for 250% damage.",
	sprSkills, 2, 2 * 60)
		
	player:setSkill(3, "Pounce", "Launch yourself towards the nearest enemy in front of you. Deal 250% damage on impact with the enemy.",
	sprSkills, 3, 2 * 60)
		
	player:setSkill(4, "Dive Drop", "Become airborne and drop to the ground dealing up to 1000% damage. Deals more damage the higher the drop is executed. Stuns enemies.",
	sprSkills, 4, 4 * 60)
end)

Brawler:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(25, 4, 0.0012, 2)
end)

Brawler:addCallback("scepter", function(player)
	player:setSkill(4,
		"Wrath of a Raging Bear",
		"Ultra Suplex Hold can now be performed on most bosses. \n\nZ->Z->Forward->C->V to perform Wrath of a Raging Bear, dealing 444.4%(+444.4% per enemy visible) to the enemy grabbed and 444.4% damage to every enemy in sight.",
		sprSkills, 8,
		3 * 60
	)
	player:getData().canBusterBosses = true
end)

Brawler:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if (playerData.skin_fullSkillOverride ~= true or playerData.trueBrawler) and not playerData.smash then --brawler is so complicated i felt he deserved the ability to have all of his skills overwritten
	--ALL of this code is currently disabled. all of it. go down to the part under playerData.smash
		if skill == 4 and playerData.doWrath and player:get("activity") ~= 4 then --forces player to do Wrath of a Raging Bear
			playerData.doWrath = false
			playerData.currentSpecial = 8
			playerData.debugDisplay = "ZZ->CV (thanks swuff)"
			player:survivorActivityState(4, player:getAnimation("shoot6"), 0.05, false, true)
			player:activateSkillCooldown(4)
			fgc.reset(player)
		elseif player:get("activity") == 0 then 
		
			local cd = true					
			
			playerData.canPunch = nil
			playerData.punch = 1
			
			if skill == 1 then
				-- Z skill
				if checkInputs(player, "direction", 2, 5, 3, 4, 6, 3) then
					playerData.currentSpecial = 1
					playerData.debugDisplay = "236Z"
					playerData.heavyPunchMod = 1
					player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.15, true, true)
				elseif checkInputs(player, "direction", 2, 5, 1, 4, 4, 3) then
					playerData.currentSpecial = 1
					playerData.debugDisplay = "214Z"
					playerData.heavyPunchMod = 1
					playerData.heavyPunchStunMod = 1
					player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.15, true, true)
				else
					player:survivorActivityState(1, player:getAnimation("shoot1"), 0.25, true, true)
				end
		
			elseif skill == 2 then
				-- X skill
			
				--for the sake of leniency, a forward input is an acceptable end to the DP motion
				if checkInputs(player, "direction", 6, 5, 2, 4, 3, 3) or checkInputs(player, "direction", 6, 5, 2, 4, 6, 3) then
					playerData.currentSpecial = 2
					playerData.debugDisplay = "623C"
				elseif checkInputs(player, "direction", 4, 5, 2, 4, 1, 3) or checkInputs(player, "direction", 4, 5, 2, 4, 4, 3) then
					playerData.currentSpecial = 2
					playerData.debugDisplay = "421C"
				end
				player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
			elseif skill == 3 then
				-- C skill
				if checkInputs(player, "direction", 2, 5, 5, 4, 2, 3) then
					playerData.currentSpecial = 3
					playerData.debugDisplay = "252C"
					player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
				elseif checkInputs(player, "skill", 1, 3, 2, 2, 3, 1) then
					playerData.currentSpecial = 9
					playerData.debugDisplay = "ZXC"
					if playerData.canPursue then
						player:set("pVspeed", player:get("pVmax")*-2)
					else
						player:set("pVspeed", player:get("pVmax")*-1)
					end
					fgc.reset(player)
				else
					player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
				end
			elseif skill == 4 then
				-- V skill
			
				--oh god im really doing this . why am i doing this . why
				if checkInputs(player, "skill", 1, 4, 1, 3) then
					if checkInputs(player, "direction", 6, 3) or checkInputs(player, "direction", 4, 3) then
						if checkInputs(player, "skill", 3, 2, 4, 1) then
							player.subimage = player.sprite.frames
							playerData.currentSpecial = 8
							playerData.doWrath = true
							cd = false
						end
					end
				end
				if not playerData.doWrath then
					--for the sake of leniency, a down input isnt necessary in the half circle motion
					if checkInputs(player, "direction", 6, 7, 3, 6, --[[2, 5,]] 1, 4, 4, 3) then
						playerData.currentSpecial = 4
						playerData.debugDisplay = "63214V"
						player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
					elseif checkInputs(player, "direction", 4, 7, 1, 6, --[[2, 5,]] 3, 4, 6, 3) then
						playerData.currentSpecial = 4
						playerData.debugDisplay = "41236V"
						player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
					else
						if playerAc.scepter > 0 then
							player:survivorActivityState(4, player:getAnimation("shoot5"), 0.25, true, false)
						else
							player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
						end
					end
				end
			end
			if cd then
				player:activateSkillCooldown(skill)
			end	
		elseif player:get("activity") == 1 then--handles Z skills more thoroughly
		--nope ! nope !!! doing this in the step callback screw this
		end
	elseif playerData.smash then
	-- code that's being run
		if skill == 4 and playerData.doWrath and player:get("activity") ~= 4 then --forces player to do Wrath of a Raging Bear
			if player:get("activity") ~= 0 then
				player.subimage = player.sprite.frames
			else
				playerData.doWrath = false
				playerData.currentSpecial = 8
				player:survivorActivityState(4, player:getAnimation("shoot6"), 0.05, false, true)
				player:activateSkillCooldown(4)
				player:setAlarm(5, player:getAlarm(5)*3)
				fgc.reset(player)
			end
		elseif player:get("activity") == 0 then 
		
			local cd = true	
			
			playerData.canPunch = nil
			playerData.punch = 1
			
			if skill == 1 then
				if checkInputs(player, "direction", 8, 2) then
					playerData.currentSpecial = 9
					playerData.debugDisplay = "8Z"
					player:survivorActivityState(1, player:getAnimation("shoot1_2"), 0.3, true, true)
				elseif checkInputs(player, "direction", 2, 2) then
					playerData.currentSpecial = 1
					playerData.heavyPunchMod = 2/3
					playerData.heavyPunchStunMod = 1/3
					playerData.debugDisplay = "2Z"
					player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.125, true, true)
				else
					player:survivorActivityState(1, player:getAnimation("shoot1"), 0.25, true, true)
				end
			elseif skill == 2 then
				if checkInputs(player, "direction", 2, 5, 2, 4, 8, 1) then
					playerData.currentSpecial = 2
					playerData.debugDisplay = "[2]8X"
				elseif checkInputs(player, "direction", 8, 2) then
					playerData.currentSpecial = 10
					playerData.debugDisplay = "8X"
				elseif checkInputs(player, "direction", 2, 2) then
					playerData.currentSpecial = 6
					playerData.debugDisplay = "2X"
				end
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
			elseif skill == 3 then
				if checkInputs(player, "direction", 8, 2) then
					playerData.currentSpecial = 11
					playerData.debugDisplay = "8C"
					player:survivorActivityState(3, player:getAnimation("shoot2"), 0.2, true, false)
				elseif checkInputs(player, "direction", 2, 2) then
					playerData.currentSpecial = 12
					playerData.headStartTimer = 60
					playerData.headStartCharge = 0
					playerData.debugDisplay = "2C"
					player:survivorActivityState(3, player:getAnimation("shoot3"), 0.3, false, false)
				else
					player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, true, false)
				end
			elseif skill == 4 then
				if playerAc.scepter > 0 then
					if checkInputs(player, "skill", 1, 4, 1, 3) then
						if checkInputs(player, "direction", 6, 3) or checkInputs(player, "direction", 4, 3) then
							if checkInputs(player, "skill", 3, 2, 4, 1) then
								playerData.debugDisplay = "ZZ6/4CV (thanks swuff)"
								player.subimage = player.sprite.frames
								playerData.currentSpecial = 8
								playerData.doWrath = true
								cd = false
							end
						end
					end
				end
				if not playerData.doWrath then
					if checkInputs(player, "direction", 4, 5, 4, 4, 6, 1) or checkInputs(player, "direction", 6, 5, 6, 4, 4, 1) then
						playerData.currentSpecial = 4
						playerData.debugDisplay = "[4]6Z"
						player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
					--[[elseif checkInputs(player, "direction", 2, 5, 2, 4, 8, 1) then
						playerData.currentSpecial = 5
						player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)]]
					else
						player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
					end
				end
			end
			
			if cd then
				player:activateSkillCooldown(skill)
			end	
		end
	end
end)

Brawler:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	
	--every skill is structured by checking the current special move *before* executing any code
	
	
	if skill == 1 and not player:getData().skin_skill1Override then
		
		local function cancelOn(frame)
			if math.floor(player.subimage) == frame then
				player.subimage = player.sprite.frames
				playerData.punch = 1
			end
		end
		
		-- Punch
		
		if syncControlRelease(player, "ability1") then
			playerData.canPunch = true
		end
		
		if playerData.currentSpecial == 0 then
			if playerData.punch == 1 then
				if relevantFrame == 2 then
					sfx.PodHit:play(0.8)
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 1)
						--bullet:set("stun", 0.25)
						bullet:getData().shakeScreen = 1
						bullet:getData().pushSide = 1.2 * player.xscale
						bullet:getData().staminaReturn = 5
						player:getData().xAccel = 1 * player.xscale
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				cancelOn(5)
			elseif playerData.punch == 2 then
				if relevantFrame == 7 then
					sfx.PodHit:play(0.82)
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 1)
						--bullet:set("stun", 0.25)
						bullet:getData().shakeScreen = 1
						bullet:getData().pushSide = 1.2 * player.xscale
						bullet:getData().staminaReturn = 5
						player:getData().xAccel = 1 * player.xscale
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				cancelOn(10)
			elseif playerData.punch == 3 then
				if relevantFrame == 12 then
					sfx.PodHit:play(1)
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 1.25)
						bullet:set("stun", 0.25)
						bullet:getData().shakeScreen = 1
						bullet:getData().pushSide = 1.2 * player.xscale
						bullet:getData().staminaReturn = 5
						player:getData().xAccel = 1 * player.xscale
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
		
		--Heavy Punch
		if playerData.currentSpecial == 1 then
			if relevantFrame == 2 then
				sfx.JanitorShoot4_2:play(0.8, 1.2)
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 8, player.y, 19 / 19, 9 / 4, 3 * playerData.heavyPunchMod)
					bullet:set("stun", 1 * playerData.heavyPunchStunMod)
					bullet:set("knockback", 5 + 2/playerData.heavyPunchMod)
					bullet:set("knockback_direction", player.xscale)
					bullet:getData().shakeScreen = 1
					bullet:getData().pushSide = 1.2 * player.xscale
					bullet:getData().staminaReturn = 10
					if not playerData.xAccel then
						player:getData().xAccel = 1 * player.xscale
					end
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
			if relevantFrame == 2 then
				if onScreen(player) then
					misc.shakeScreen(4)
				end
			end
			if playerData.smash then 
				player:activateSkillCooldown(1)
			end
		end
		
		--Hook
		if playerData.currentSpecial == 9 then
			if relevantFrame == 2 then
				sfx.Reflect:play(0.5, 0.7)
				sfx.PodHit:play(0.85, 0.7)
				sfx.JanitorShoot1_2:play(1.2, 0.2)
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 18 / 19, 7 / 4, 0.9)
					bullet:set("stun", 1)
					bullet:getData().shakeScreen = 1
					bullet:getData().pushSide = 1.2 * player.xscale
					bullet:getData().staminaReturn = 5
					player:getData().xAccel = 1 * player.xscale
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				if onScreen(player) then
					misc.shakeScreen(2)
				end
			end
			if playerData.smash then
				player:activateSkillCooldown(1)
			end
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Throw
		if playerData.currentSpecial == 0 then
			if relevantFrame == 1 then
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				sfx.Reflect:play(0.8)
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 2.5)
					--bullet:set("stun", 1)
					bullet:set("knockback", 7)
					bullet:set("knockback_direction", player.xscale)
					bullet:set("knockup", 6)
					bullet:getData().canPursue = true
					bullet:getData().pushSide = 4 * player.xscale * -1
					bullet:getData().staminaReturn = 5
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
					player:set("pVspeed", -2)
				end
			end
		end
		
		-- Remover
		if playerData.currentSpecial == 6 then
			if relevantFrame == 1 then
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				sfx.Reflect:play(0.6, 0.9)
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 2.5)
					--bullet:set("stun", 1)
					bullet:set("knockback", 11)
					bullet:set("knockback_direction", player.xscale)
					bullet:set("knockup", 1.2)
					bullet:getData().staminaReturn = 5
					bullet:getData().canPursue = true
					bullet:getData().pushSide = 4 * player.xscale * -1
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
		--Yeet
		if playerData.currentSpecial == 10 then
			if relevantFrame == 1 then
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				sfx.Reflect:play(0.9, 0.85)
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 2.5)
					--bullet:set("stun", 1)
					bullet:set("knockback", 1)
					bullet:set("knockback_direction", player.xscale)
					bullet:set("knockup", 10)
					bullet:getData().staminaReturn = 5
					bullet:getData().canPursue = true
					bullet:getData().pushSide = 4 * player.xscale * -1
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				player:set("pVspeed", -3)
			end
		end
		
		-- Skyward
		if playerData.currentSpecial == 2 then
			if relevantFrame == 1 then
				if player:get("invincible") < 40 then
					player:set("invincible", 40)
				end
				sfx.Reflect:play(0.7, 1.1)
				playerAc.pVspeed = -5.5
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y + player.yscale * 5, 15 / 19, 20 / 4, 2)
					bullet:set("stun", 0.3)
					bullet:set("knockup", 3)
					bullet:getData().staminaReturn = 10
					bullet:getData().canPursue = true
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				
				if playerData.smash then
					if player:getAlarm(3) ~= -1 then
						player:setAlarm(3, player:getAlarm(3)*2)
					end
				end
				
			end
			if relevantFrame == 2 or relevantFrame == 3 then
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 12, player.y + player.yscale * 3, 19 / 19, 20 / 4, 2.5)
					--bullet:set("stun", 1)
					bullet:set("knockup", 6.5)
					bullet:getData().pushSide = 4 * player.xscale * -1
					bullet:getData().staminaReturn = 5
					bullet:getData().canPursue = true
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
	
       -- Pounce
		if playerData.currentSpecial == 0 then
			if player:get("invincible") < 30 then
				player:set("invincible", 30)
			end
			if relevantFrame == 1 then
				sfx.PodDeath:play(1.3)
				local target = nil
				for _, instance2 in ipairs(pobj.actors:findAll()) do
					if instance2:get("team") ~= playerAc.team then
						if player.xscale > 0 and instance2.x > player.x - 10 or player.xscale < 0 and instance2.x < player.x + 10 then
							local dis = distance(player.x, player.y, instance2.x, instance2.y)
							if not target or dis < target.dis then
								if dis < 200 then
									target = {inst = instance2, dis = dis}
								end
							end
						end
					end
				end
				local xx = 4 * player.xscale
				local yy = 0
				if target then
					target = target.inst
					if target:isValid() then
						local angle = posToAngle(player.x, target.y, target.x, player.y)
						local angleRad = math.rad(angle)
						xx = math.cos(angleRad) * 5
						yy = math.sin(angleRad) * 5
					end
				end
			
				player:getData().awaitingContact = target
				player:getData().awaitingContactTimer = 30
				player:getData().xAccel = xx * 0.75
				player:set("pVspeed", yy)
			end
		end
		
		-- Strong Pounce
		if playerData.currentSpecial == 7 then
			if relevantFrame == 1 then
				sfx.PodDeath:play(1.3)
				local target = nil
				for _, instance2 in ipairs(pobj.actors:findAll()) do
					if instance2:get("team") ~= playerAc.team then
						if player.xscale > 0 and instance2.x > player.x - 10 or player.xscale < 0 and instance2.x < player.x + 10 then
							local dis = distance(player.x, player.y, instance2.x, instance2.y)
							if not target or dis < target.dis then
								if dis < 200 then
									target = {inst = instance2, dis = dis}
								end
							end
						end
					end
				end
				local xx = 4 * player.xscale
				local yy = 0
				if target then
					target = target.inst
					if target:isValid() then
						local angle = posToAngle(player.x, target.y, target.x, player.y)
						local angleRad = math.rad(angle)
						xx = math.cos(angleRad) * 5
						yy = math.sin(angleRad) * 5
					end
				end
			
				player:getData().awaitingContact = target
				player:getData().awaitingContactTimer = 30
				player:getData().xAccel = xx * 1.25
				player:set("pVspeed", yy*2)
			end
		end
		
		-- Charge Pounce
		if playerData.currentSpecial == 3 then
		
			if relevantFrame == 1 then
				playerData.pounceTimer = 60
			end
			if playerData.pounceTimer > 0 then
				if input.checkControl(playerData.pounceInput, player) == input.PRESSED then --needs synced
				--this seriously needs to be redone with the button input system
					playerData.pounceCharge = playerData.pounceCharge + 1
				end
			end
			if player.subimage > 1 and playerData.pounceTimer > 0 then
				player.subimage = 1
				playerData.pounceTimer = playerData.pounceTimer - 1
			end
			if relevantFrame == 3 then
				player.subimage = 1
				sfx.PodDeath:play(1.5, 1.3)
				local target = nil
				for _, instance2 in ipairs(pobj.actors:findAll()) do
					if instance2:get("team") ~= playerAc.team then
						if player.xscale > 0 and instance2.x > player.x - 10 or player.xscale < 0 and instance2.x < player.x + 10 then
							local dis = distance(player.x, player.y, instance2.x, instance2.y)
							if not target or dis < target.dis then
								if dis < 200 then
									target = {inst = instance2, dis = dis}
								end
							end
						end
					end
				end
				local xx = 4 * player.xscale
				local yy = 0
				if target then
					target = target.inst
					if target:isValid() then
						local angle = posToAngle(player.x, target.y, target.x, player.y)
						local angleRad = math.rad(angle)
						xx = math.cos(angleRad) * 5
						yy = math.sin(angleRad) * 5
					end
				end
		
				player:getData().awaitingContact = target
				player:getData().awaitingContactTimer = 30
				player:getData().xAccel = xx * (1 + (playerData.pounceCharge/10) * math.sqrt(player:get("pHmax")))
				player:set("pVspeed", yy*3)
			end	
		end
		
		--Super Jump Punch
		if playerData.currentSpecial == 11 then
			if relevantFrame == 1 then
			sfx.PodDeath:play(1.8)
				player:set("pVspeed", -2*player:get("pVmax"))
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 5, player.y + player.yscale * -3, 6 / 19, 3 / 4, 4)
					bullet:set("stun", 0.4)
					bullet:set("knockup", 10)
					bullet:getData().staminaReturn = 5
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
		--Head Start
		if playerData.currentSpecial == 12 then
			playerData.headStartTimer = math.approach(playerData.headStartTimer, 0, 1)
			playerData.headStartCharge = math.approach(playerData.headStartCharge, 3, 1/20)
			
			if syncControlRelease(player, "ability3") then
				playerData.headStartTimer = 0
			end
			
			if playerData.headStartTimer == 0 then
				sfx.PodDeath:play(1.1)
				playerData.xAccel = (2 + math.sqrt(player:get("pHmax")))*playerData.headStartCharge*player.xscale
				player.subimage = player.sprite.frames
			else
				player.subimage = 1
			end
			
			if playerData.smash then
				player:activateSkillCooldown(3)
			end
		end
	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Dive Drop
		
		if playerData.currentSpecial == 0 then
			playerAc.pHspeed = math.approach(playerAc.pHspeed, 0, 0.025)
			if playerAc.moveRight == 1 then
				playerAc.pHspeed = playerAc.pHmax
			elseif playerAc.moveLeft == 1 then
				playerAc.pHspeed = -playerAc.pHmax
			end
			
			if relevantFrame == 2 then
				playerData.doMidAirAttack = true
				player:set("pVspeed", math.min(player:get("pVspeed") -3, -2))
			end
			if relevantFrame == 4 then
				player:getData().awaitingGroundImpact = 300
			end
			if player.subimage > 4 and player:getData().awaitingGroundImpact then
				player.subimage = 4
			end
		end
		
		--ULTRA SUPLEX HOLD
		
		if playerData.currentSpecial == 4 then
			if relevantFrame == 2 then
				if playerData.xAccel then --increases hitbox length depending on current xAccel
					local bullet = player:fireBullet(player.x + player.xscale * -4, player.y, player:getFacingDirection(), 40*math.max(1, math.sqrt(math.abs(playerData.xAccel))), (1/playerAc.damage), nil, DAMAGER_NO_PROC --[[+ DAMAGER_NO_RECALCULATE]])
					bullet:getData().buster = true
					bullet:set("stun", 0.5)
					bullet:getData().staminaReturn = 5
					if playerData.canBusterBosses == false then
						bullet:set("max_hit_number", 1)
					end
				else 
					local bullet = player:fireBullet(player.x + player.xscale * -4, player.y, player:getFacingDirection(), 35, (1/playerAc.damage), nil, DAMAGER_NO_PROC --[[+ DAMAGER_NO_RECALCULATE]])
					bullet:getData().buster = true
					bullet:set("stun", 0.5)
					bullet:getData().staminaReturn = 5
					if playerData.canBusterBosses == false then
						bullet:set("max_hit_number", 1)
					end
				end
			end
			
			if playerData.busterTarget then

				if player:get("invincible") < 5 then
					player:set("invincible", 5)
				end
			
				if player.subimage > 4 then
					playerAc.pHspeed = math.approach(playerAc.pHspeed, 0, 0.025)
					if playerAc.moveRight == 1 then
						playerAc.pHspeed = playerAc.pHmax
					elseif playerAc.moveLeft == 1 then
						playerAc.pHspeed = -playerAc.pHmax
					end
				else
					playerAc.pHspeed = 0
				end

				if relevantFrame == 4 then
					--player:set("pVspeed", math.min(player:get("pVspeed") -3, -2))
					player:set("pVspeed", -6)
					playerData.doMidAirAttack = true
				end
				if relevantFrame == 5 then
					player:getData().awaitingGroundImpact = 300
				end
				if player.subimage > 5 and player:getData().awaitingGroundImpact then
					player.subimage = 5
				end
			elseif relevantFrame == 3 then
				player.subimage = player.sprite.frames
			end
			player:activateSkillCooldown(4)
		end
		
		--Buster
		
		if playerData.currentSpecial == 5 then
			if relevantFrame == 2 then
				if playerData.xAccel then --increases hitbox length depending on current xAccel
					local bullet = player:fireBullet(player.x + player.xscale * -4, player.y, player:getFacingDirection(), 40*math.max(1, math.sqrt(math.abs(playerData.xAccel))), (1/playerAc.damage), nil, DAMAGER_NO_PROC --[[+ DAMAGER_NO_RECALCULATE]])
					bullet:getData().buster = true
					bullet:set("stun", 1)
					bullet:getData().staminaReturn = 5
					if playerData.canBusterBosses == false then
						bullet:set("max_hit_number", 1)
					end
				else 
					local bullet = player:fireBullet(player.x + player.xscale * -4, player.y, player:getFacingDirection(), 35, (1/playerAc.damage), nil, DAMAGER_NO_PROC --[[+ DAMAGER_NO_RECALCULATE]])
					bullet:getData().buster = true
					bullet:set("stun", 1)
					bullet:getData().staminaReturn = 5
					if playerData.canBusterBosses == false then
						bullet:set("max_hit_number", 1)
					end
				end
			end
			
			if playerData.busterTarget then
			
				if player:get("invincible") < 5 then
					player:set("invincible", 5)
				end
			
				if player.subimage > 4 and player.subimage < 6 then
					playerAc.pHspeed = 0
				end

				if relevantFrame == 4 then
					--player:set("pVspeed", math.min(player:get("pVspeed") -3, -2))
					player:set("pVspeed", -6)
				end
				if relevantFrame == 5 then
					player:getData().awaitingGroundImpact = 300
				end
				if player.subimage > 5 and player:getData().awaitingGroundImpact then
					player.subimage = 5
				end
			elseif relevantFrame == 3 then
				player.subimage = player.sprite.frames
			end
		end
		
		--Wrath of a Raging Bear
		if playerData.currentSpecial == 8 then

			if relevantFrame == 1 then
				playerData.wrath = true
				playerData.maxWrathDuration = 2*60
			end
			playerData.maxWrathDuration = math.approach(playerData.maxWrathDuration, 0, 1)
			if playerData.maxWrathDuration == 0 then
				playerData.wrath = false
				player.subimage = player.sprite.frames
			end
			if relevantFrame == 3 then
				misc.setTimeStop(100)
			end
			if playerData.wrath == true then
				player.subimage = 2
				player:set("pHspeed", playerAc.pHmax * 1.5 * player.xscale)
				local r = 8
				for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do 
					if actor:get("team") ~= player:get("team") then
						if player:get("invincible") < 120 then
							player:set("invincible", 120)
						end
						playerData.wrath = false
						local bullet = player:fireBullet(player.x + player.xscale * -4, player.y, player:getFacingDirection(), 40*math.max(1, math.sqrt(math.abs(playerData.xAccel or 1))), (1/playerAc.damage), nil, DAMAGER_NO_PROC --[[+ DAMAGER_NO_RECALCULATE]])
						player.subimage = 3
						bullet:getData().buster = true
						--bullet:getData().frickingDie = 5*60
						bullet:set("stun", 1.6)
					end
				end
			elseif relevantFrame == 4 then
				playerData.busterContact = true
			--Fcucking augury code
				
				misc.shakeScreen(10)
				local flash = obj.WhiteFlash:create(0, 0)
				flash.blendColor = Color.BLACK
				flash.alpha = 0.85
				flash:set("rate", 0.008*player:get("attack_speed"))
				local mult = 0
				
				for _, actor in ipairs(pobj.actors:findAll()) do
					local actorObj = actor:getObject()
					if actor:get("team") ~= player:get("team") then
						if actor:isValid() then
							if not actor:getData().isBustered then
								mult = mult + 4.444
								local bullet = player:fireExplosion(actor.x, actor.y, 10/19, 10/4, 4.444, sprAkumaExplosion, nil)
								bullet:set("stun", 1)
							end
						end
						
						if onScreen(actor) and global.quality > 1 then
							local sprite = actor.sprite or spr.Nothing
							for i = 0, 10 do
								local xx = math.random(actor.x - sprite.xorigin + sprite.boundingBoxLeft, actor.x - sprite.xorigin + sprite.boundingBoxRight)
								local yy = math.random(actor.y - sprite.yorigin + sprite.boundingBoxTop, actor.y - sprite.yorigin + sprite.boundingBoxBottom)
								par.Dust2:burst("above", xx, yy, 1, Color.DARK_GREY)
								par.TempleSnow:burst("above", xx, yy, 1, Color.fromHex(0x695338))
							end
						end
						--[[
						actor.blendColor = Color.BLACK
						actor:kill()
						actor:getData().frickingDie = 3*60
						]]
					end
				end
				
				local bullet = player:fireExplosion(player.x+5*player.xscale, player.y, 25/19, 15/4, 4.444+mult, sprAkumaExplosion, nil)
				bullet:set("stun", 1 + mult*0.05)
				--[[
				misc.director:set("points", 0)
				misc.director:setAlarm(1, 200)
				]]
				if playerData.smash then
					player:activateSkillCooldown(4)
					player:setAlarm(5, player:getAlarm(5)*3)
				end
			end
		end
	end
end)

Brawler:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	--print(player:get("activity"))
	-- awesome makes horrible mistakes starting here (beginning of my main code)
	
	if player:get("activity") == 1 and playerData.currentSpecial == 0 then
		if player:get("z_skill") == 1 then
			if playerData.canPunch then
				if playerData.punch == 1 then
					player.subimage = 6
					playerData.punch = 2
				elseif playerData.punch == 2 then
					player.subimage = 11
					playerData.punch = 3
				end
				playerData.canPunch = nil
			end
		end
	else
		playerData.punch = 1
	end
	
	if playerData.busterContact then
		if playerData.currentSpecial == 4 then
			local bullet = player:fireExplosion(player.x, player.y + player.yscale * 3, 30 / 19, 10 / 4, 2.5)
			bullet:set("knockup", 3)
			bullet:getData().staminaReturn = 30
		elseif playerData.currentSpecial == 5 then
			local bullet = player:fireExplosion(player.x, player.y + player.yscale * -2, 50 / 19, 12 / 4, 5)
			bullet:set("knockup", 5)
			bullet:getData().staminaReturn = 40
		end
		playerData.busterContact = false
	end --buster :)
	
	if playerData.currentSpecial > 0 and (playerAc.activity < 1 or playerAc.activity > 5) then
		playerData.currentSpecial = 0
		playerData.busterTarget = false --failsafe
		playerData.pounceCharge = 0 -- pounce reset
		playerData.pounceTimer = 0 -- pounce reset
		
	end --resets move data when nothing is being used

	if playerData.canPursue then
		playerData.canPursueTimer = math.approach(playerData.canPursueTimer or 0, 30, 1)
		if playerData.canPursueTimer == 30 then
			playerData.canPursue = false
		end
	else
		playerData.canPursueTimer = 0
	end	-- resets pursuit if not followed through
	
	--if not playerData.debug then
		--playerData.doWrath = nil 
	--end --you arent triggering pseudoaugury in main play . i will fight you over this
	--statement retracted: i lost the fight
	
	if player:get("activity") ~= 3 then 
		playerData.pounceCharge = math.approach(playerData.pounceCharge, 0, 3)
	end
	
	-- awesome pays for her crimes (end of my main code)
	
	if playerData.awaitingContact and playerData.awaitingContact:isValid() then
		if player:get("pVspeed") == 0 and not player:getData().xAccel then
			playerData.awaitingContact = nil
		elseif player:collidesWith(playerData.awaitingContact, player.x, player.y) then
			if onScreen(player) then
				misc.shakeScreen(2)
			end
			sfx.RiotGrenade:play(1.2)
			for i = 0, player:get("sp") do
				local bullet = player:fireExplosion(player.x + player.xscale * 10, player.y, 20 / 19, 5 / 4, 2.5)
				bullet:set("stun", 1)
				bullet:getData().pushSide = playerData.xAccel
				if playerData.currentSpecial == 3 then --allows Charge Pounce to deliver momentum
					bullet:set("knockup", 0.5)
					bullet:getData().deliverxAccel = playerData.xAccel
				else
					bullet:set("knockup", 1)
				end
				bullet:getData().staminaReturn = 20
				playerData.awaitingContact = nil
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
		end
	end
	
	if playerData.awaitingGroundImpact then
		if playerData.awaitingGroundImpact > 0 then
			player:set("invincible", math.max(player:get("invincible"), 5))
			playerData.awaitingGroundImpact = playerData.awaitingGroundImpact - 1
		end
		if playerData.midAirDamageTimer then
			if playerData.midAirDamageTimer > 0 then
				playerData.midAirDamageTimer = playerData.midAirDamageTimer - 1
			else
				playerData.midAirDamageTimer = nil
			end
		else
			if playerData.doMidAirAttack then
				local r = 25
				for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
					if actor:get("team") ~= player:get("team") and player:collidesWith(actor, player.x, player.y) and not actor:collidesMap(actor.x, actor.y + 1) then
						player:fireExplosion(player.x, player.y + player.yscale*10, 25 / 19, 12 / 4, 1) --used to be 27/19,27/4
						playerData.midAirDamageTimer = 8
					end
				end
			end
		end
		if player:collidesMap(player.x, player.y + 1) then
			local lastVspeed = playerData.lastVerticalSpeed or 0
			if onScreen(player) then
				misc.shakeScreen(3 + lastVspeed)
			end
			if playerData.currentSpecial ~= 5 then
				local mult = lastVspeed * 0.5
				for i = 0, player:get("sp") do
					local bullet = player:fireExplosion(player.x, player.y, 30 / 19, 5 / 4, math.min(1 + mult, 10))
					bullet:getData().staminaReturn = 40
					bullet:set("stun", 1)
					bullet:set("knockup", mult)
					bullet:set("knockback", mult)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
			playerData.awaitingGroundImpact = nil
			playerData.doMidAirAttack = nil
			sfx.RiotGrenade:play(0.9)
			--player:setAnimation("jump", player:getData()._ogJumpBk)
			player.subimage = 5
			if playerData.busterTarget and playerData.busterTarget:isValid() and (playerData.currentSpecial == 4 or playerData.currentSpecial == 5) then --not sure if i need this ? --i do need it . gog
				playerData.busterContact = true
			end
			player:set("pVspeed", -2)
		end
		playerData.lastVerticalSpeed = player:get("pVspeed")
	end
end)

local busterBlacklist = {
	[obj.Turtle] = true,
	--[obj.Worm] = true,
	--[obj.WormBody] = true,
	[obj.WormHead] = true,
	--[obj.WurmBody] = true,
	[obj.WurmHead] = true,
	[obj.GolemG] = true,
	[obj.Boar] = true--[[,
	[obj.Ifrit] = true,]]
	--it's only fair
}
--[[
if obj.ArcherBugHive then
	busterBlacklist[obj.ArcherBugHive] = true
end
]]
if obj.TotemPart then
	busterBlacklist[obj.TotemPart] = true
end
if obj.Arraign1 then
	busterBlacklist[obj.Arraign1] = true
	--busterBlacklist[obj.Arraign2] = true
	--it's fair game ^^
end

callback.register("preHit", function(damager, hit) --needs synced (i think ?)
	local parent = damager:getParent()
	if parent and parent:isValid() then
		if hit and hit:isValid() then
			if damager:getData().frickingDie then --because swuff challenged me
				print("AAAAAAAAAAAAAAAAAA")
				hit:getData().frickingDie = damager:getData().frickingDie
			end
			if damager:getData().buster then --allows the bustering to commence
				if modloader.checkFlag("ssl_heckbosses") then
					parent:getData().busterTarget = hit
					hit:getData().isBustered = true
					hit:getData().busterParent = parent
				elseif parent:getData().canBusterBosses then
					if not busterBlacklist[hit:getObject()] then
						parent:getData().busterTarget = hit
						hit:getData().isBustered = true
						hit:getData().busterParent = parent
					end
				else
					if not hit:isBoss() then
						parent:getData().busterTarget = hit
						hit:getData().isBustered = true
						hit:getData().busterParent = parent
					end
				end
			end
		end
	end
	if damager:getData().deliverxAccel then -- gives enemy the player's xAccel minus its sqrt, gives player sqrt of current xAccel
		hit:getData().xAccel = damager:getData().deliverxAccel - math.sign(damager:getData().deliverxAccel)*(math.sqrt(math.abs(damager:getData().deliverxAccel)))
		parent:getData().xAccel = math.sign(parent:getData().xAccel)*math.sqrt(math.abs(damager:getData().deliverxAccel))
		--print(parent:getData().xAccel)
	end
	if damager:getData().canPursue then --enables pursuit on hit
		parent:getData().canPursue = true
		--print("can pursue :)")
	end
end)

table.insert(call.onHit, function(damager, hit)
	if damager:getData().shakeScreen then
		if onScreen(hit) then
			misc.shakeScreen(damager:getData().shakeScreen)
		end
	end
end)

callback.register("onStep", function() 
	for _, enemy in ipairs(pobj.actors:findAll()) do
		if enemy:isValid() then
			local enemyData = enemy:getData()
			if enemyData.isBustered then
				--print("TARGET BUSTERED.")
				if enemyData.busterParent:getData().currentSpecial ~= 8 then
					enemy.angle = math.approach(enemy.angle, 90, 22*(14/enemy.sprite.height)) -- thanks neik :)
				end
				if enemyData.busterParent:getData().busterContact == true then
					--print("RELEASING BUSTER.")
					enemyData.busterParent:getData().busterTarget = false
					enemyData.isBustered = nil
					enemyData.busterParent = nil
					enemy.angle = 0
				end
				if enemyData.busterParent then --a BUNCH of collision checks because i dont wanna have provi in a wall
					if not enemy:collidesMap(enemyData.busterParent.x + enemyData.busterParent:get("pHspeed"), enemyData.busterParent.y) then
						enemy.x = enemyData.busterParent.x
					else
						enemy.x = enemy.x
					end
					if not enemy:collidesMap(enemyData.busterParent.x, enemyData.busterParent.y + enemyData.busterParent:get("pVspeed")) then
						enemy.y = enemyData.busterParent.y
					else
						enemy.y = enemy.y
					end
					
					local enemySprite = enemy.sprite
					if enemy:collidesMap(enemy.x, enemy.y * enemy.yscale + enemyData.busterParent:get("pVspeed")*2*(enemySprite.height/14--[[approximate player sprite height]])) then
						enemy.angle = math.approach(enemy.angle, 0, (-15*enemyData.busterParent:get("pVspeed"))) --approximates a rate to return the enemy's angle to 0 before it hits the ground
						--print(-15*enemyData.busterParent:get("pVspeed"))
					end
				end
			end
		end
	end
end)
--[[
callback.register("onDraw", function()
    for _, actor in ipairs(ParentObject.find("actors"):findAll()) do
		--if actor:get("team") ~= player:get("team") then
			if actor:getData().frickingDie then
				graphics.color(Color.RED)
				graphics.print("999999999", actor.x, actor.y-actor.sprite.height, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
				if actor:getData().frickingDie == 0 then
					actor:getData().frickingDie = nil
				else
					actor:getData().frickingDie = actor:getData().frickingDie - 1
				end
			end
		--end
	end
end)
]]
callback.register("onPlayerDraw", function(player)
	local playerData = player:getData()
	if playerData.smash then
		if not playerData.inputDisplayTimer then playerData.inputDisplayTimer = 0 end
		if player:control("use") == input.HELD then
			playerData.inputDisplayTimer = math.approach(playerData.inputDisplayTimer, 90, 1)
		else
			playerData.inputDisplayTimer = math.approach(playerData.inputDisplayTimer, 0, 2)
		end
		if playerData.inputDisplayTimer > 60 then
		
			local disp = global.timer
			local sat = 128
			local m = 1
			local i = 1
			local color = Colour.fromHSV(((i * 20 * m) + disp * m) % 255, sat, 250)
			graphics.drawImage{
				image = sprInputs,
				x = player.x - 100,
				y = player.y - 100,
				xscale = 1,
				yscale = 1,
				scale = 1,
				alpha = (playerData.inputDisplayTimer-60)/30,
				color = color--,
				--alpha = 
			}
		end
	end
end)


--[[
		if playerData.currentStamina then
			graphics.color(Color.fromHex(0xbb9bd1))
			graphics.print("Stamina: "..math.floor(playerData.currentStamina), player.x, player.y+65, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
		end
	end
	if playerData.currentStamina then
	--	customBar(player.x - 15, player.y + 10, player.x + 15, player.y + 11, playerData.currentStamina, playerData.maxStamina, true)
	end
]] --deprecated stamina bar code

sur.Brawler = Brawler