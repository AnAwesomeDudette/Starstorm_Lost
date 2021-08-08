local path = "Survivors/Brawler/"

local Brawler = Survivor.new("Brawler")

require("Variants/truebrawler")--um, dunno if i can do this ? only one way to fihnd out 
--ah, yeah i can do that :)

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
	shoot1_2 = Sprite.load("Brawler_Shoot1_2", path.."shoot1_2", 5, 6, 9),
	shoot2 = Sprite.load("Brawler_Shoot2", path.."shoot2", 4, 10, 14),
	shoot3 = Sprite.load("Brawler_Shoot3", path.."shoot3", 4, 7, 9),
	shoot4 = Sprite.load("Brawler_Shoot4", path.."shoot4", 7, 10, 32),
	shoot4_1 = Sprite.load("Brawler_Shoot4_1", path.."ULTRASUPLEXHOLD", 8, 10, 32),
	shoot5 = Sprite.load("Brawler_Shoot5", path.."shoot4", 7, 10, 32),
}

local sprSkills = Sprite.load("Brawler_Skills", path.."skills", 7, 0, 0)

Brawler.loadoutSprite = Sprite.load("Brawler_Select", path.."select", 4, 2, 0)

Brawler:setLoadoutInfo(
[[The &y&Brawler&!& is an agile melee fighter, trained to lay a beatdown unlike any other.
He can perform &b&Special Moves&!&, and string many normal attacks into
&b&devestating combos&!&, always using the right tools for the job: &y&his fists.&!&
Despite his abilities, the Brawler believes that &lt&Not every situation needs something fancy.&!&
&dk&Sometimes you just need a good ol'&!& &y&one-two&!&, something he's more than capable of.]], sprSkills)
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
	SurvivorVariant.setInfoStats(SurvivorVariant.getSurvivorDefault(Brawler), {{"Strength", 9}, {"Vitality", 6}, {"Toughness", 9}, {"Agility", 5}, {"Difficulty", 4}, {"Fluff", 7}})
	SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(Brawler), "Wrestled with a bear bare-fisted and, well, bear was buried with utmost respect. \n\nThis Brawler gets the job done, with standard edition technique and power.")
	if modloader.checkFlag("ssl_debug") then
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Heavy Punch", "Down->Downforward->Forward+Z to perform a heavy punch, severely stunning opponents for &y&300% damage.&!& &g&(Lower zoom scale to see all Special Moves.)&!&", sprSkills, 1)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Skyward", "Forward->Down->Downforward+X to perform an invincible uppercut, hitting three times and launching opponents upwards for up to &y&700% damage.&!&", sprSkills, 2)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Charged Pounce", "Down->Neutral->Down+C to prepare to launch after 1 second. Pressing C further times &b&increases speed.&!& Enemies struck receive your momentum.", sprSkills, 3)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Ultra Suplex Hold", "Back->Downback->Down->Downforward->Forward+V to &y&grapple&!& the nearest foe, pummeling them mid-air for &y&100% damage&!& and slamming for &y&250% damage.&!&", sprSkills, 4)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "One-Two", "Z->Z to peform a second punch quickly after the first. &b&Special moves can be done quickly after the second blow.&!&", sprSkills, 5)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Three-Hit Jab Combo", "Z->Z->Z to peform a fast three combination attack. The final hit &b&stuns enemies&!& for &y&150% damage.&!&", sprSkills, 6)
		SurvivorVariant.setLoadoutSkill(SurvivorVariant.getSurvivorDefault(Brawler), "Pursuit", "Z->X->C to perform a &b&great leap.&!& If an enemy was thrown, &b&leap higher to chase them into the air.&!&", sprSkills, 7)
	end

end) --BASED DEPARTMENT

--PLEASEEEEEEEEEE WE NEED ARROWS TO CONVEY THESE INPUTS AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

Brawler:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if modloader.checkFlag("ssl_truebrawler") then
		playerData.trueBrawler = true
	end
	
	playerData.currentInput = 5 -- number 1-9 representing one of 8 possible directions + a neutral direction
	playerData.currentButtonInput = 0 -- number 0-4 representing one of 4 possible ability inputs + no input
	playerData.bufferTimer = 12 -- used as frame counter for when a new directional input should be registered
	playerData.bufferTimer2 = 45 -- used as frame counter for when a new ability input should be registered
	playerData.diagonalBufferTimer = 12 -- deprecated of method of preventing excessive diagonal inputs
	playerData.currentSpecial = 0 -- used to control when special moves occur
	playerData.currentNormal = 0 --used to control after normal move is triggered, and prevent it from checking for a normal move that is in progress
	
	if modloader.checkFlag("ssl_debug") then
		playerData.debug = true
	else
		playerData.debug = false
	end
	playerData.debugDisplay = "Debug display active."
	
	playerData.inputHandler = {} --tracks the last 10 directional inputs (including diagonals) so they can be read
	for i=1, 10 do playerData.inputHandler[i] = 5 end
	
	playerData.buttonInputHandler = {} --tracks the last 6 ability inputs (ZXCV) so they can be read
	for i=1, 6 do playerData.buttonInputHandler[i] = 0 end
	
	playerData.inputs = {} -- used to read cardinal direction inputs, helps with gamepad functionality (still needs tweaked)
	for i=1, 4 do playerData.inputs[i] = 0 end
	
	--buster refers to Suplex
	playerData.busterTarget = false --accessor that points towards enemy/enemies hit with Suplex
	playerData.busterContact = false --boolean that triggers when contact is made with the ground while Suplex occurs
	playerData.canBusterBosses = false --self explanatory

	playerData.pounceCharge = 0 --counter used to increase strength of Charge Pounce when C inputs are made
	playerData.pounceTimer = 0 --frame counter used to provide charge input window
	
	playerData.canPursue = false --boolean that determines if pursuit should go max range
	
	playerData.canCancel = true --self explanatory, but not yet implemented
	
	--info on how inputs are handled in step callback
	--info on how inputs are read in useSkill callback
	--info on what desperately needs synced can be found by ctrl-F (--needs synced)
	
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
	sprSkills, 3, 3 * 60)
		
	player:setSkill(4, "Dive Drop", "Become airborne and drop to the ground dealing up to 1000% damage. Deals more damage the higher the drop is executed. Stuns enemies.",
	sprSkills, 4, 4 * 60)
end)

Brawler:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(25, 4, 0.0012, 2)
end)

Brawler:addCallback("scepter", function(player)
	player:setSkill(4,
		"True Buster",
		"On True Brawler, Ultra Suplex Hold can now be performed on most bosses.",
		sprSkills, 4,
		3 * 60
	)
	player:getData().canBusterBosses = true
end)

Brawler:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	local function inputReader(input, window) 
		for i=1, window do
			if player:getData().inputHandler then
			local inputHandler = player:getData().inputHandler
				if inputHandler[i] == input then
					return true;
				end
			end
		end
	end
	
	if player:get("activity") == 0 then 
		local cd = true					

		if skill == 1 then
			-- Z skill
			if playerData.currentInput == 6 then
				if inputReader(3, 5) then
					if inputReader(2, 4) then
						playerData.currentSpecial = 1
						playerData.debugDisplay = "236Z"
						player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.15, true, true)
					end
				end
			elseif playerData.currentInput == 4 then
				if inputReader(1, 5) then
					if inputReader(2, 4) then
						playerData.currentSpecial = 1
						playerData.debugDisplay = "214Z"
						player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.15, true, true)
					end
				end
			end
			if playerData.currentSpecial ~= 1 then
				player:survivorActivityState(1, player:getAnimation("shoot1"), 0.25, true, true)
			end
		
		elseif skill == 2 then
			-- X skill
			
			--for the sake of leniency, a forward input is an acceptable end to the DP motion
			if playerData.currentInput == 3 or playerData.currentInput == 6 then
				if inputReader(2, 5) then
					if inputReader(6, 4) then
						playerData.currentSpecial = 2
						playerData.debugDisplay = "623C"
					end
				end
			elseif playerData.currentInput == 1 or playerData.currentInput == 4 then
				if inputReader(2, 5) then
					if inputReader(4, 4) then
						playerData.currentSpecial = 2
						playerData.debugDisplay = "421C"
					end
				end
			end
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
		elseif skill == 3 then
			-- C skill
			if playerData.currentInput == 2 then
				if inputReader(2, 4) then
					if inputReader(5, 3) then
						playerData.currentSpecial = 3
						playerData.debugDisplay = "252C"
					end
				end
			end
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif skill == 4 then
			-- V skill
			
			--for the sake of leniency, a down input isnt necessary in the half circle motion
			if playerData.currentInput == 4 then
					if inputReader(6, 8) then
						if inputReader(3, 7) then
							--if inputReader(2, 5) then
								if inputReader(1, 5) then
									playerData.currentSpecial = 4
									playerData.debugDisplay = "63214V"
									player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
								end
							--end
						end
					end
			elseif playerData.currentInput == 6 then
				if inputReader(4, 8) then
					if inputReader(1, 7) then
						--if inputReader(2, 5) then
							if inputReader(3, 5) then
								playerData.currentSpecial = 4
								playerData.debugDisplay = "41236V"
								player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.2, true, false)
							end
						--end
					end
				end
			end
			
			if playerData.currentSpecial ~= 4 then
				if playerAc.scepter > 0 then
					player:survivorActivityState(4, player:getAnimation("shoot5"), 0.25, true, false)
				else
					player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
				end
			end
			
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
		--[[
					Special Moves are typically handled in useSkill, while Normal Combos are handled in onSkill.
					This is because Specials are often used *in place* of the typical move, and need to be set before it triggers,
					while Normal Combos, or ability input strings, change the outcome of a use while it's being used.
					This convention can be broken as necessary.
					
					In useSkill, the inputReader() function reads for two parameters: 
					the first one is the directional input being checked for,
					and the second one is the max window it can check over.
					This means it reads starting at the first place in the list of the most recent inputs, 
					ending at the given window length.
					Larger windows mean the player has more time to perform the special after the input, 
					as long as the correct final input is held.
					This only works with directional inputs.
					
					In onSkill, the inputReader() function reads for two parameters: 
					the first one is the ability input being checked for,
					and the second one is its place in the list it should be expected, 
					such as being the second or third step in the move.
					This only works for ability/skill inputs.
					
					Creating a move involves first checking playerData.currentInput for directional input or playerData.currentButtonInput for ability inputs.
					Then, using inputReader(), all of the other necessary steps of the move are read from least to most recent, with the window decreasing.
					Finally, playerData.currentNormal or playerData.currentSpecial is set, so the move can occur properly.
					Reference existing moves to see how the data of currentSpecial and currentNormal is used.
					
					The point of having two completely different systems like this is to open up the most opportunities for new moves,
					done by either setting them before they execute, or altering them while they're occurring.
			]]
			
		--[[Command List: 
	1 = 236/214Z (Heavy Punch), 
	2 = 623/421X (Skyward), 
	3 = 252C (Charge Pounce), 
	4 = 41236/63214V (Ultra Suplex Hold)
	
	Normals List:
	1 = ZZ (Jab 2)
	2 = ZZZ (Jab 3 Finisher)
	3 = ZXC (Pursuit)]]
	end


	
end)

Brawler:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	local function inputReader(input, window)
		if player:getData().buttonInputHandler then
		local inputHandler = player:getData().buttonInputHandler
			if inputHandler[window] == input then
				return true;
			end
		end
	end
	--[[I needed a lot of functions to shorthand the implementation of some Normal Combos, so here they are.]]
	local function cancel() --just resets handler
		for i=1, 6 do playerData.buttonInputHandler[i] = 0 end
	end
	
	local function lastFrame() --resets handler and currentNormal on last frame automatically
		if player.subimage == (player.sprite.frames-1) and playerData.currentNormal > 0 then
			playerData.currentNormal = 0
			cancel()
		end
	end
	
	local function cancelOn(frame) --cancels the move on a given frame, resets handler and currentNormal
		if player.subimage == frame then
			player.subimage = player.sprite.frames --this is where shizzle gets frizzled, thanku neik
			playerData.currentNormal = 0
			cancel()
		end
	end
	
	local function cancelIn(frame, buffer, cancel) --cancels the move on a given frame, but gives finer control over the remaining buffer and currentNormal
		if player.subimage == frame then
			player.subimage = player.sprite.frames
			playerData.bufferTimer2 = buffer
			if cancel then
				playerData.currentNormal = 0
				cancel()
			end
		end
	end
	
	--[[
		it's important to note that you want to have *precise* control of if/when your move is cancelled when making a normal combo
		use the above functions appropriately
		
		typically, any use of relevantFrame is done *after* it's confirmed the player is executing the combo
		be wary about how/when it's checked
	]]
	
	if skill == 1 and not player:getData().skin_skill1Override then
		
		-- Punch
		if relevantFrame == 2 and playerData.currentSpecial == 0 and playerData.currentNormal == 0 then
			sfx.PodHit:play(0.8)
			for i = 0, playerAc.sp do
				local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 1)
				--bullet:set("stun", 0.25)
				bullet:getData().shakeScreen = 1
				bullet:getData().pushSide = 1.2 * player.xscale
				player:getData().xAccel = 1 * player.xscale
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
		end
		
		--Heavy Punch
		if playerData.currentSpecial == 1 then
			if playerData.currentNormal == 0 or playerData.currentNormal == 1 then
				cancelOn(5)
				if relevantFrame == 2 then
					sfx.JanitorShoot4_2:play(0.8)
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + player.xscale * 8, player.y, 19 / 19, 9 / 4, 3)
						bullet:set("stun", 1)
						bullet:set("knockback", 6)
						bullet:set("knockback_direction", player.xscale)
						bullet:getData().shakeScreen = 1
						bullet:getData().pushSide = 1.2 * player.xscale
						if not playerData.xAccel then
							player:getData().xAccel = 1 * player.xscale
						end
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
		
		--One-Two / Three-Hit Jab Combo
		
		if playerData.currentSpecial == 0 then
			if playerData.currentNormal == 0 or playerData.currentNormal == 1 then
				if playerData.currentNormal == 0 then
					if playerData.currentButtonInput == 1 then
						if inputReader(1, 2) then
							player.subimage = 6
							sfx.PodHit:play(0.8)
							for i = 0, playerAc.sp do
								local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 1)
								bullet:set("knockback", 1)
								bullet:set("knockback_direction", player.xscale)
								bullet:getData().shakeScreen = 1
								bullet:getData().pushSide = 1.2 * player.xscale
								player:getData().xAccel = 1 * player.xscale
								if i ~= 0 then
									bullet:set("climb", i * 8)
								end
							end
							playerData.currentNormal = 1
						end
					end
				elseif playerData.currentNormal == 1 then
					if playerData.currentButtonInput == 1 then
						if inputReader(1, 3) then
							if inputReader(1, 2) then
								player.subimage = 11
								sfx.PodHit:play(0.8)
								for i = 0, playerAc.sp do
									local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 1.5)
									bullet:set("stun", 0.25)
									bullet:getData().shakeScreen = 1
									bullet:getData().pushSide = 1.2 * player.xscale
									player:getData().xAccel = 1 * player.xscale
									if i ~= 0 then
										bullet:set("climb", i * 8)
									end
								end
								playerData.currentNormal = 2
							end
						end
					end
				end
			end
		end
		
		if playerData.currentNormal == 0 then
			--cancelIn(5, 30, false)
			cancelOn(5)
		elseif playerData.currentNormal == 1 then
			cancelOn(10) --i really need to revamp cancelIn because it's kinda useless
		elseif playerData.currentNormal == 2 then
			lastFrame()
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Throw
		if relevantFrame == 1 and playerData.currentSpecial == 0 then
			if onScreen(player) then
				misc.shakeScreen(2)
			end
			sfx.Reflect:play(0.8)
			for i = 0, playerAc.sp do
				local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 2.5)
				--bullet:set("stun", 1)
				bullet:set("knockup", 7)
				bullet:getData().canPursue = true
				bullet:getData().pushSide = 4 * player.xscale * -1
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
				player:set("pVspeed", -2.5)
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
					bullet:set("stun", 1)
					bullet:set("knockup", 3)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
			if relevantFrame == 2 or relevantFrame == 3 then
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 12, player.y + player.yscale * 3, 19 / 19, 20 / 4, 2.5)
					bullet:set("stun", 1)
					bullet:set("knockup", 7)
					bullet:getData().pushSide = 4 * player.xscale * -1
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
	
		if playerData.currentSpecial == 0 then --pursuit checker
			if playerData.currentNormal == 0 then
				if playerData.currentButtonInput == 3 then
					if inputReader(2, 2) then
						if inputReader(1, 3) then
							playerData.currentNormal = 3
						end
					end
				end
			end
		end 
	
        -- Pounce
		if playerData.currentNormal == 0 then
			if playerData.currentSpecial ~= 3 then
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
		end
		
		-- Charge Pounce
		if playerData.currentNormal == 0 then
			if playerData.currentSpecial == 3 then
			
				if relevantFrame == 1 then
					playerData.pounceTimer = 60
				end
				if playerData.pounceTimer > 0 then
					if input.checkControl("ability3", player) == input.PRESSED then --needs synced
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
		end
		
		--Pursuit
		if playerData.currentNormal == 3 then
			if relevantFrame == 1 then
				if playerData.canPursue then
					player:set("pVspeed", -7)
					playerData.canPursue = false
					--print("can't pursue :(")
				else
					player:set("pVspeed", -4)
				end
			end
			cancelOn(2)
			if player.subimage == 2 then
				playerData.currentNormal = 0
			end
		end
		
	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Dive Drop
		if playerData.currentSpecial ~= 4 then
			playerAc.pHspeed = math.approach(playerAc.pHspeed, 0, 0.025)
			if playerAc.moveRight == 1 then
				playerAc.pHspeed = playerAc.pHmax
			elseif playerAc.moveLeft == 1 then
				playerAc.pHspeed = -playerAc.pHmax
			end
			
			if relevantFrame == 2 then
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
					if playerData.canBusterBosses == false then
						bullet:set("max_hit_number", 1)
					end
				else 
					local bullet = player:fireBullet(player.x + player.xscale * -4, player.y, player:getFacingDirection(), 35, (1/playerAc.damage), nil, DAMAGER_NO_PROC --[[+ DAMAGER_NO_RECALCULATE]])
					bullet:getData().buster = true
					bullet:set("stun", 0.5)
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
	end
end)

Brawler:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	-- awesome makes horrible mistakes starting here (beginning of my main code)
	
	if playerData.busterContact then
		local bullet = player:fireExplosion(player.x, player.y + player.yscale * 3, 40 / 19, 20 / 4, 2.5)
		bullet:set("knockup", 3)
		playerData.busterContact = false
	end --buster :)
	
	if playerData.currentSpecial > 0 and (playerAc.activity < 1 or playerAc.activity > 5) then
		playerData.currentSpecial = 0
		playerData.busterTarget = false --failsafe
		playerData.pounceCharge = 0 -- pounce reset
		playerData.pounceTimer = 0 -- pounce reset
		
	end --resets special state when not executing
	
	if playerData.busterTarget then
		playerData.canCancel = false
	else
		playerData.canCancel = true
	end --self explanatory, unimplemented
	
	local function addInput(newInput)
		table.insert(playerData.inputHandler, 1, newInput)
		table.remove(playerData.inputHandler, 11)
	end --adds new directional input, pushes everything down, removes the end
	
	--[[
			Fighting game notation is done alongside the typical representation of numbers on a numpad.
			
			7  8  9
			4  5  6
			1  2  3
		
			"6" would be read as right, while "2" would be read as down, so on and so forth.
			
			
			Down (2) -> Down-right (3) -> Right (6) + Primary (Z) 
			is translated to
			236Z
				or
			2->3->6+Z
			
			This is how inputHandler works, and by extension currentInput. 
			These numbers are interpreted as corresponding directions.
			
			It's important to note that any input that uses left or right should have a flipped version, 
			unless you only want the player to be able to use it facing one direction.
			
			playerData.inputHandler works by reading the latest directional input two frames after a direction is pressed or released.
			If a new input is not made within 12 frames, a neutral direction input of 5 is placed instead.
			
			playerData.buttonInputHandler works by reading the latest ability/skill input after a button is pressed or released.
			If a new input is not made within 45 frames, the list is reset.
			Some Normal Combos set the buffer window of 45 frames to a different number, 
			in order to provide a short frame window that allows for another button input.
			The last input of a Normal Combo should reset the buffer window and buttonInputHandler, 
			either through a relevant function or direct control.
	]]
	
	if playerData.bufferTimer ~= 0 then
		playerData.bufferTimer = playerData.bufferTimer - 1
	end --ticks down the bufferTimer frame counter to 0
	
	if playerData.diagonalBufferTimer ~= 0 then
		playerData.diagonalBufferTimer = playerData.diagonalBufferTimer - 1
	end --kinda dated ??? dont know if this is necessary anymore
	
--begin directional input check
	local gamepad = input.getPlayerGamepad(player)
	if not gamepad then
		playerData.inputs[1] = input.checkControl("up", player) --needs synced
		playerData.inputs[2] = input.checkControl("right", player) --needs synced
		playerData.inputs[3] = input.checkControl("down", player) --needs synced
		playerData.inputs[4] = input.checkControl("left", player) --needs synced
	end
	--controller support
			--for the record there's totally a better way to do this, but its not about if i should, its about if i could,
			-- and the answer . is still no
	if gamepad then
		local up = playerData.inputs[1]
		local right = playerData.inputs[2]
		local down = playerData.inputs[3]
		local left = playerData.inputs[4]
		
		local deadzone = 0.2
		-- used to determine how far the player needs to push the stick to perform an input, from 1 to 0
		-- default is 0.25
		
		--print(input.getGamepadAxis("lh", gamepad)..input.getGamepadAxis("lv", gamepad))
		local leftStickH = input.getGamepadAxis("lh", gamepad) --needs synced
		local leftStickV = input.getGamepadAxis("lv", gamepad) --needs synced
		-- neutral = 0, pressed = 3, held = 2, released = 1
		if up == 3 then
			up = 2
		elseif up == 2 and leftStickV < -deadzone then
			up = 2
		elseif up == 2 then
			up = 1
		elseif up == 1 then
			up = 0
		end
		
		if down == 3 then
			down = 2
		elseif down == 2 and leftStickV > deadzone then
			down = 2
		elseif down == 2 then
			down = 1
		elseif down == 1 then
			down = 0
		end
		
		if right == 3 then
			right = 2
		elseif right == 2 and leftStickH > deadzone then
			right = 2
		elseif right == 2 then
			right = 1
		elseif right == 1 then
			right = 0
		end
		
		if left == 3 then
			left = 2
		elseif left == 2 and leftStickH < -deadzone then
			left = 2
		elseif left == 2 then
			left = 1
		elseif left == 1 then
			left = 0
		end
		
		if math.abs(leftStickH) > deadzone or math.abs(leftStickV) > deadzone then
			if leftStickV < -deadzone and up == 0 then
				up = 3
			elseif leftStickV > deadzone and down == 0 then
				down = 3
			end
			if leftStickH > deadzone and right == 0 then
				right = 3
			elseif leftStickH < -deadzone and left == 0 then
				left = 3
			end
		end
		playerData.inputs[1] = up
		playerData.inputs[2] = right
		playerData.inputs[3] = down
		playerData.inputs[4] = left
		--print(up..right..down..left)
	end
	--end controller support
	local up = playerData.inputs[1]
	local right = playerData.inputs[2]
	local down = playerData.inputs[3]
	local left = playerData.inputs[4]
	
	--updates
	local bW = 4 --stands for Buffer Window, currently used to set input leniency and make inputting easier
	
	if up == input.PRESSED or right == input.PRESSED or down == input.PRESSED or left == input.PRESSED then
		playerData.bufferTimer = bW
	end
	if up == input.RELEASED or right == input.RELEASED or down == input.RELEASED or left == input.RELEASED then
		playerData.bufferTimer = bW
	end
	--end updates
	
	if down == input.HELD 
	and right == input.HELD 
	and playerData.bufferTimer < bW then
		playerData.currentInput = 3 
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 30
		addInput(playerData.currentInput)
	end	
	
	if down == input.HELD 
	and left == input.HELD
	and playerData.bufferTimer < bW then
		playerData.currentInput = 1
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 30
		addInput(playerData.currentInput)
	end
	
	if up == input.HELD 
	and  right == input.HELD
	and playerData.bufferTimer < bW then
		playerData.currentInput = 9
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 30
		addInput(playerData.currentInput)
	end	
	
	if up == input.HELD 
	and left == input.HELD
	and playerData.bufferTimer < bW then
		playerData.currentInput = 7
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 30
		addInput(playerData.currentInput)
	end
	
	if up == input.HELD and playerData.bufferTimer < bW then
		playerData.currentInput = 8
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 0
		addInput(playerData.currentInput)
	end

	if right == input.HELD and playerData.bufferTimer < bW then
		playerData.currentInput = 6
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 0
		addInput(playerData.currentInput)
	end	

	if down == input.HELD and playerData.bufferTimer < bW then
		playerData.currentInput = 2
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 0
		addInput(playerData.currentInput)
	end

	if left == input.HELD and playerData.bufferTimer < bW then
		playerData.currentInput = 4
		playerData.bufferTimer = 12
		playerData.diagonalBufferTimer = 0
		addInput(playerData.currentInput)
	end
	
	if playerData.bufferTimer == 0 then
		playerData.currentInput = 5
		addInput(playerData.currentInput)
		playerData.bufferTimer = 12
	end
--end directional input check

--begin ability input check
	local primary = input.checkControl("ability1", player) --needs synced
	local secondary = input.checkControl("ability2", player) --needs synced
	local utility = input.checkControl("ability3", player) --needs synced
	local ultimate = input.checkControl("ability4", player) --needs synced
	
	local function addInput2(newInput)
		table.insert(playerData.buttonInputHandler, 1, newInput)
		table.remove(playerData.buttonInputHandler, 7)
	end --adds new ability input, pushes everything down, removes the end
	
	if player:get("activity") < 1 or player:get("activity") > 4 then --note: this is variable! add as many checks as you want for when you do and dont want countdown
		if playerData.bufferTimer2 ~= 0 then
			playerData.bufferTimer2 = playerData.bufferTimer2 - 1
		else
			if playerData.currentNormal > 0 then
				playerData.currentNormal = 0
			end --failsafe, if the combo did not reset currentNormal at the end
			--THIS . REALLY NEEDS A REWORK . GOT DAM
			playerData.bufferTimer2 = 45
			for i=1, 6 do playerData.buttonInputHandler[i] = 0 end
		end
	end
	
	if primary == input.PRESSED or secondary == input.PRESSED or utility == input.PRESSED or ultimate == input.PRESSED then
		playerData.bufferTimer2 = 45
	end
	
	if primary == input.PRESSED then
		addInput2(1)
		playerData.currentButtonInput = 1
	end
	if secondary == input.PRESSED then
		addInput2(2)
		playerData.currentButtonInput = 2
	end
	
	if utility == input.PRESSED then
		addInput2(3)
		playerData.currentButtonInput = 3
	end
	if ultimate == input.PRESSED then
		addInput2(4)
		playerData.currentButtonInput = 4
	end
	
--end ability input check

	if playerData.canPursue then
		if playerData.bufferTimer2 == 0 then
			playerData.canPursue = false
		end
	end -- resets pursuit if not followed through

	if playerData.currentSpecial ~= 0 then --test
		for i=1, 6 do playerData.buttonInputHandler[i] = 0 end
	end -- causes specials to automatically reset the ability/skill input handler

	if not playerData.trueBrawler and not playerData.debug then
		for i=1, 6 do playerData.buttonInputHandler[i] = 0 end 
		for i=1, 10 do playerData.inputHandler[i] = 5 end
	end --disables normal combos and special moves entirely if the player doesn't have the trueBrawler flag or debug flag
	
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
			local r = 25
			for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
				if actor:get("team") ~= player:get("team") and player:collidesWith(actor, player.x, player.y) and not actor:collidesMap(actor.x, actor.y + 1) then
					player:fireExplosion(player.x, player.y + player.yscale*10, 25 / 19, 12 / 4, 1) --used to be 27/19,27/4
					playerData.midAirDamageTimer = 8
				end
			end
		end
		if player:collidesMap(player.x, player.y + 1) then
			local lastVspeed = playerData.lastVerticalSpeed or 0
			if onScreen(player) then
				misc.shakeScreen(3 + lastVspeed)
			end
			
			local mult = lastVspeed * 0.5
			for i = 0, player:get("sp") do
				local bullet = player:fireExplosion(player.x, player.y, 30 / 19, 5 / 4, math.min(1 + mult, 10))
				bullet:set("stun", 1)
				bullet:set("knockup", mult)
				bullet:set("knockback", mult)
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
			playerData.awaitingGroundImpact = nil
			sfx.RiotGrenade:play(0.9)
			--player:setAnimation("jump", player:getData()._ogJumpBk)
			player.subimage = 5
			if playerData.busterTarget then --not sure if i need this ?
				playerData.busterContact = true
			end
			player:set("pVspeed", -2)
		end
		playerData.lastVerticalSpeed = player:get("pVspeed")
	end
end)

callback.register("preHit", function(damager, hit) --needs synced (i think ?)
	local parent = damager:getParent()
	if parent and parent:isValid() then
		if hit and hit:isValid() then
			if damager:getData().buster then --allows the bustering to commence
				if modloader.checkFlag("ssl_heckbosses") or parent:getData().canBusterBosses then
					parent:getData().busterTarget = hit
					hit:getData().isBustered = true
					hit:getData().busterParent = parent
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

callback.register("onStep", function() --needs synced (i thinkkk ???)
	for _, enemy in ipairs(pobj.actors:findAll()) do
		local enemyData = enemy:getData()
		if enemy:isValid() then
			if enemyData.isBustered then
				--print("TARGET BUSTERED.")
				enemy.angle = math.approach(enemy.angle, 90, 22*(14/enemy.sprite.height)) -- thanks neik :)
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

callback.register("onPlayerDraw", function(player)
	local playerData = player:getData()
	if playerData.debug then --draws the last performed move, buttonInputHandler and inputHandler underneath Brawler
		if playerData.inputHandler then
			local inputs = playerData.inputHandler
			graphics.print(inputs, player.x, player.y+20, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
		end
		if playerData.buttonInputHandler then
			local inputs = playerData.buttonInputHandler
			graphics.print(inputs, player.x, player.y+35, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
		end
		if playerData.debugDisplay then
			graphics.print(playerData.debugDisplay, player.x, player.y+50, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
		end
	end
end)	

sur.Brawler = Brawler