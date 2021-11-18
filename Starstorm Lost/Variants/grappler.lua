--note to self, need to fix out of bounds collision detection...,,,,,,,,,,
callback.register("postLoad", function()
		local survivor = Survivor.find("Brawler", "SSLost")
		local path = "Survivors/Brawler/"
		local path2 = "Variants/Grappler/"
		local sprite = Sprite.load("Grappler_Idle", path.."idle", 1, 9, 9)
		local newVariant = SurvivorVariant.new(survivor, "Grappler", Sprite.load("GrapplerSelect", "Survivors/Brawler/Select", 4, 2, 0),
		{ 
		idle = sprite,
		walk = Sprite.load("Grappler_Walk", path.."walk", 8, 10, 9),
		jump = Sprite.load("Grappler_Jump", path.."jump", 1, 9, 9),
		climb = Sprite.load("Grappler_Climb", path.."climb", 2, 5, 10),
		death = Sprite.load("Grappler_Death", path.."death", 8, 10, 9),
		decoy = sprite,
		
		shoot1 = Sprite.load("Grappler_Shoot1", path.."shoot1", 18, 6, 9),
		shoot1_1 = Sprite.load("Grappler_Shoot1_1", path.."shoot1_1", 5, 6, 9),
		shoot1_2 = Sprite.load("Grappler_Shoot1_2", path2.."Skullsplitter", 4, 6, 19),
		shoot2 = Sprite.load("Grappler_Shoot2", path2.."Ringout", 6, 10, 14),
		shoot3 = Sprite.load("Grappler_Shoot3", path2.."Suplex", 10, 7, 14),
		shoot3_1 = Sprite.load("Grappler_Shoot3_1", path2.."Dontblink", 11, 7, 14),
		shoot4 = Sprite.load("Grappler_Shoot4", path.."shoot4", 7, 10, 32),
		shoot4_1 = Sprite.load("Grappler_Shoot4_1", path2.."HEAVENLYPOTEMKINBUSTERedit", 9, 9, 9),
		shoot5 = Sprite.load("Grappler_Shoot5", path.."shoot4", 7, 10, 32),
		shoot6 = Sprite.load("Grappler_Shoot6", path.."AkumaAssets", 10, 6, 19)
	},
	Color.fromHex(0xEAB779))

	SurvivorVariant.setInfoStats(newVariant, {{"Strength", 9}, {"Vitality", 7}, {"Toughness", 9}, {"Agility", 3}, {"Difficulty", 7}, {"Scales", 7}}) 
	SurvivorVariant.setDescription(newVariant, "The &y&Grappler&!& is a ferocious being, using inhuman strength to erratically jolt targets around in whichever direction it likes.")
	local sprSkills = Sprite.load("GrapplerSkills", "Variants/Grappler/kit", 1, 0, 52)
	local baseSkills = Sprite.find("Brawler_Skills", "SSLost")
	SurvivorVariant.setLoadoutSkill(newVariant, "", "", sprSkills)
	
	local function setSkills(player, cargo)
		if not cargo then
			player:setSkill(1,
			"Low Blow",
			"Slug a heavy punch forward, dealing 150% damage.",
			baseSkills, 1, 50)
			
			if math.chance(50) then
			player:setSkill(2,
			"Ring Out",
			"Violently throw enemies in front of you for 300% damage. Enemies that hit a surface hard receive an additional 300% damage.",
			baseSkills, 2, 3.5*60)
			else
			player:setSkill(2,
			"Ring Out",
			"Violently yeet enemies in front of you for 300% damage. Enemies that hit a surface hard receive an additional 300% damage.",
			baseSkills, 2, 3.5*60)
			end
			
			player:setSkill(3,
			"Suplex",
			"Dash forward, grabbing any enemy you come into contact with. If an enemy is grabbed, slam it to the ground for 500% damage around you.",
			baseSkills, 3, 6*60)
			
			player:setSkill(4,
			"Cargo",
			"Grab the nearest enemy near you. If successful, become invulnerable for a short duration, and carry the enemy with you. Pressing different skills afterwards performs different throws.",
			baseSkills, 4, 8*60)
		else
			player:setSkill(1,
			"Forward Throw",
			"Throw the enemy forward. For a short duration, any enemies hit by your thrown target are stunned for 100% damage.",
			baseSkills, 5, 30)
			
			if math.chance(50) then
			player:setSkill(2,
			"Back Toss",
			"Send the enemy far behind you, dealing 750% damage to it.",
			baseSkills, 6, 30)
			else
			player:setSkill(2,
			"Back Toss",
			"Yeet the enemy far behind you, dealing 750% damage to it.",
			baseSkills, 6, 30)
			end
			
			player:setSkill(3,
			"Break Down",
			"Smash the enemy down, knocking away everything around you for 200% damage.",
			baseSkills, 7, 45)
			
			player:setSkills(4,
			"Up and Away",
			"Throw the enemy far into the air. stunning it for 100%. Become fully invulnerable for a short duration, and reset all cooldowns.",
			baseSkills, 8, 15)
		end
	end
	
	local noCollide = function (actor, reference, step, reset)
		--reference is any actor used as a reference point in the event the function fails
		--step is the precision level
		--reset determines if angle should be reset
		local sw, sh = Stage.getDimensions()
		if reset then
			actor.angle = 0
		end
		while actor:collidesMap(actor.x, actor.y) do 
			if actor.x > sw or actor.x < 0 or actor.y > sh or actor.y < 0 then
				actor.x = reference.x
				actor.y = reference.y - actor.sprite.height/1.5
				break
			end
			if actor:collidesMap(actor.x, actor.y) then
				actor.x = actor.x - step*reference.xscale
			end
			if actor:collidesMap(actor.x, actor.y) then
				actor.y = actor.y - step
			end
		end
	end
	
	callback.register("onSkinInit", function(player, skin) 
		if skin == newVariant then
			local playerData = player:getData()
			--playerData.skin_fullSkillOverride = true
			playerData.skin_skill1Override = true
			playerData.skin_skill2Override = true
			playerData.skin_skill3Override = true
			playerData.skin_skill4Override = true
			playerData.smash = false --all of these override player skill stuff
			
			playerData.canChase = nil
			playerData.cargo = false
			playerData.cargoTarget = nil
			
			--playerData.doneCurrentSpecial = {}
			
			local function cancelBuster(enemy)
				if enemy and enemy:isValid() then
					local enemyData = enemy:getData()
					enemyData.busterParent:getData().busterTarget = false
					enemyData.isBustered = nil
					enemyData.busterParent = nil
					enemyData.doneBuster = nil
					enemyData._busterx = nil
					enemyData._bustery = nil
					enemy.angle = 0
					enemyData._storeAfterBusterContact = nil
					
				end
			end
			
			playerData.onBuster = {
				[0.01] = function(player) --baseline 
					local bullet = player:fireExplosion(player.x, player.y, 19/19, 4/4, 1)
					return bullet
				end,
				[3.02] = function(player) 
					local bullet = player:fireExplosion(player.x+5*player.xscale, player.y+5, 30/19, 16/4, 3)
					bullet:set("knockback", 6)
					bullet:set("knockup", 3)
					bullet:set("stun", 1.5)
					return bullet
				end,
				[3.99] = function(player) 
					local bullet = player:fireExplosion(player.x, player.y, 50/19, 6/4, 5)
					bullet:set("knockup", 2)
					bullet:set("knockback", 4)
					bullet:set("knockback_direction", player.xscale)
					bullet:set("stun", 1/1.5)
					return bullet
				end,
				[4.01] = function(player) 
					local bullet = player:fireExplosion(player.x, player.y + player.yscale * 3, 30 / 19, 10 / 4, 10)
					bullet:set("knockup", 3)
					return bullet 
				end
			}
			
			playerData.busterMovement = {
				[0.01] = function(player, enemy) --baseline
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						enemy.x = player.x
						enemy.y = player.y
					end
				end,
				[3.02] = function(player, enemy) 
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						enemy.x = player.x
						enemy.y = player.y - enemy.sprite.width/5
						enemy.angle = 90
					end
				end,
				[3.99] = function(player, enemy)
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						local angle = player.angle
						local xx = (8 + enemy.sprite.width/10) * math.cos(math.rad(angle))
						local yy = (8 + enemy.sprite.height/10)* math.sin(math.rad(angle))
						enemy.angle = player.angle
						enemy.xscale = player.xscale*-1
						enemy.x = player.x + (xx*player.xscale) 
						enemy.y = player.y - (yy*player.xscale) 
						enemyData._busterx = enemy.x
						enemyData._bustery = enemy.y
					end
				end,
				[4.01] = function(player, enemy)
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						if enemy:get("stunned") == 0 then
							enemy:set("stunned", 1)
						end
						if player.subimage < 5 then
							enemy.angle = math.approach(enemy.angle, 90, 20*player:get("attack_speed"))
						end
						if player.subimage < 7 then 
							enemy.angle = 90
							if not enemyData._findBusterPosy then
								local y = player.y
								local min = enemy.sprite.height/5
								while enemy:collidesWith(player, player.x, y) do
									y = y - 2
									if not enemy:collidesWith(player, player.x, y) then
										y = y - player.y
										y = y + math.sqrt(enemy.sprite.width/10)
										enemyData._findBusterPosy = y
										break
									end
								end
							end
							enemy.x = player.x
							enemy.y = player.y + enemyData._findBusterPosy - 5
							enemyData._busterx = enemy.x
							enemyData._bustery = enemy.y
						end
					end
				end
			}
			
			playerData.onBusterContact = {
				[0.01] = function(player, enemy) --baseline
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
					end
				end,
				[3.02] = function(player, enemy) --baseline
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						enemy.angle = 68
						enemy.x = player.x + enemy.sprite.height/1.5*player.xscale
						enemy.y = player.y - enemy.sprite.width/5
					end
				end,
				[3.99] = function(player, enemy)
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						enemy.angle = 180
						enemy.x, enemy.y = enemyData._busterx, enemyData._bustery
					end
				end,
				[4.01] = function(player, enemy)
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						enemy.angle = 84
						enemyData._bustery = enemyData._bustery + enemy.sprite.height/7
						enemy.x = enemyData._busterx
						enemy.y = enemyData._bustery 
						enemyData._findBusterPosy = nil
						--hee hoo :)
					end
				end
			}
			
			playerData.afterBusterContact = {
				[0.01] = function(player, enemy) --baseline
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						noCollide(enemy, player, 1, true)
						cancelBuster(enemy)
					end
				end,
				[3.02] = function(player, enemy) --baseline
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						noCollide(enemy, player, 1, true)
						enemy:getModData("Starstorm").xAccel = 4.5*player.xscale
						cancelBuster(enemy)
					end
				end,
				[3.99] = function(player, enemy)
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						--if player.subimage > 8 then
							
						--end
						--if math.floor(player:get("activity")) ~= 3 then
							enemy.y = player.y - enemy.sprite.height/2 - 1
							noCollide(enemy, player, 1, true)
							enemy:set("pVspeed", -3)
							player.angle = 0
							cancelBuster(enemy)
						--end
					end
				end,
				[4.01] = function(player, enemy)
					if player and player:isValid() and enemy and enemy:isValid() then
						local playerData = player:getData()
						local enemyData = enemy:getData()
						local targetx = player.x + 30*(enemy.sprite.height/20)
						local targety = player.y - 1 - enemy.sprite.height
						local dist = distance(enemy.x, enemy.y, targetx, targety)
						local mod = player:get("attack_speed")
						if player.subimage > 7 then
							enemy.angle = math.approach(enemy.angle, 0, 10*mod)
							enemy.x = math.approach(enemy.x, targetx, 5*mod + (dist/20))
							enemy.y = math.approach(enemy.y, targety, 2*mod + (dist/20))
						else
							enemy.x = enemyData._busterx
							enemy.y = enemyData._bustery
						end
						if math.floor(player:get("activity")) ~= 4 then
							--print("aesfdirfvjs")
							noCollide(enemy, player, 1, true)
							enemy:getModData("Starstorm").xAccel = 4*player.xscale*mod
							enemy:set("pVspeed", -2+player:get("pVspeed"))
							cancelBuster(enemy)
						end
					end
				end
			}
			
			setSkills(player, false)
			
			--[[
					Movelist:
				Z (Low Blow) - done
				X (Ring Out) - done
				C (Suplex) [3.99] - done
				V (Cargo)
				
				1.01 = 8Z (Skull Splitter) - done
				1.02 = 2Z (Earthshatter) - done
				1.03 = c.8Z (Chase) - done
				2.01 = 8X (T.K.O. Up) - done
				2.02 = 2X (T.K.O. Down) - done
				3.01 = 8C (Into Orbit) - done
				3.02 = [2]6C / 236C (Don't Blink) - done
				4.01 = [4]6V (Heavenbound Buster) - done
				
				While Cargo Carry:
				Z (Forward Throw)
				X (Back Toss)
				C (Break Down)
				V (Up and Away)
				
				The following moves are not true grabs:
				Into Orbit
			]]
		end
	end)
	
	SurvivorVariant.setSkill(newVariant, 1, function(player)
		local playerData = player:getData()
		if not playerData.cargo then
			if checkInputs(player, "direction", 8, 2) then
				if playerData.canChase and playerData.canChase > 0 then -- Chase
					playerData.currentSpecial = 1.03
					playerData.debugDisplay = "c.8Z"
					SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_2"), 0.5, true, true)
				else --Skull Splitter
					playerData.currentSpecial = 1.01
					playerData.debugDisplay = "8Z"
					SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_2"), 0.25, true, false)
					playerData.canChase = 12
				end
			elseif checkInputs(player, "direction", 2, 2) then --Earthshatter
				playerData.currentSpecial = 1.02
				playerData.debugDisplay = "2Z"
				SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.1, true, true)
			else --Low Blow
				playerData.currentSpecial = 0
				playerData.debugDisplay = "Z"
				SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.25, true, false)
			end
		else --Forward Throw
			SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.25, true, true)
			setSkills(player, false)
			playerData.debugDisplay = "Cargo Z"
		end
	end)

	SurvivorVariant.setSkill(newVariant, 2, function(player)
		local playerData = player:getData()
		if not playerData.cargo then
			if checkInputs(player, "direction", 8, 2) then --T.K.O. Up
				--SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.175, true, true)
				playerData.currentSpecial = 2.01
				playerData.debugDisplay = "8X"
				SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.25, true, true)
			elseif checkInputs(player, "direction", 2, 2) then --T.K.O. Down
				playerData.currentSpecial = 2.02
				playerData.debugDisplay = "2X"
				SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.25, true, true)
			else --Ring Out
				playerData.currentSpecial = 0
				playerData.debugDisplay = "X" 
				SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.20, true, true)
				print(playerData.currentSpecial)
			end
		else --Back Toss
			SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.25, true, true)
			setSkills(player, false)
			playerData.debugDisplay = "Cargo X"
		end
	end)
	
	SurvivorVariant.setSkill(newVariant, 3, function(player)
		local playerData = player:getData()
		if not playerData.cargo then
			if checkInputs(player, "direction", 8, 2) then --Into Orbit
				SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, true, true)
				playerData.currentSpecial = 3.01
				playerData.debugDisplay = "8C"
				SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, true, false)
			elseif checkInputs(player, "direction", 2, 5, 6, 3) or checkInputs(player, "direction", 2, 5, 4, 3) then --Don't Blink
				playerData.currentSpecial = 3.02
				if checkInputs(player, "direction", 3, 4) or checkInputs(player, "direction", 1, 4) then --Don't Blink (Strong)
					playerData.dontBlinkMod = 1.35
					playerData.debugDisplay = "236C/214C"
				else
					playerData.dontBlinkMod = 1
					playerData.debugDisplay = "[2]6/[2]4C"
				end
				SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, false, false)
			else --Suplex
				playerData.currentSpecial = 3.99
				playerData.debugDisplay = "C"
				SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, true, true)
			end
		else --Break Down
			SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, false, false)
			setSkills(player, false)
			playerData.debugDisplay = "Cargo C"
		end
	end)
	
	SurvivorVariant.setSkill(newVariant, 4, function(player)
		local playerData = player:getData()
		if not playerData.cargo then
			if checkInputs(player, "direction", 4, 5, 4, 4, 6, 1) or checkInputs(player, "direction", 6, 5, 6, 4, 4, 1) then --Heavenbound Buster
				SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4_1"), 0.2, true, true)
				playerData.currentSpecial = 4.01
				playerData.debugDisplay = "[4]6/[6]4V"
			else --Cargo
				playerData.currentSpecial = 0
				SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.25, true, true)
				playerData.debugDisplay = "V"
			end
		else --Up and Away
			SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.25, true, true)
			setSkills(player, false)
			playerData.debugDisplay = "Cargo V"
		end
	end)

	callback.register("onSkinSkill", function(player, skill, relevantFrame)
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		local playerSSData = player:getModData("Starstorm")
		if SurvivorVariant.getActive(player) == newVariant then
			if skill == 1 then
				
				if playerData.currentSpecial == 0 then --Low Blow
				
					if relevantFrame == 2 then
						sfx.JanitorShoot1_2:play(1.2, 0.7)
						sfx.JanitorShoot4_2:play(0.8, 0.3)
						for i = 0, playerAc.sp do
							local bullet = player:fireExplosion(player.x + player.xscale * 15, player.y+3, 22 / 19, 12 / 4, 1.5)
							bullet:set("knockback", 3)
							bullet:set("knockback_direction", player.xscale)
							if not playerSSData.xAccel then
								playerSSData.xAccel = 2.75 * player.xscale
							else
								if math.abs(playerSSData.xAccel) < 2.75 then
									playerSSData.xAccel = 2.75 * player.xscale
								end
							end
							player:set("pHspeed", player:get("pHmax")*0.8*player.xscale)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
						if onScreen(player) then
							misc.shakeScreen(1)
						end
					end
					
				elseif playerData.currentSpecial == 1.01 then --Skull Splitter
				
					if relevantFrame == 1 then
						player:setAlarm(2, player:getAlarm(2)/1.25)
						sfx.Reflect:play(0.5, 0.7)
						sfx.PodHit:play(0.85, 0.9)
						sfx.JanitorShoot1_2:play(1.2, 0.3)
						sfx.JanitorShoot4_2:play(1.1, 0.1)
						for i = 0, playerAc.sp do
							local bullet = player:fireExplosion(player.x + player.xscale * 15, player.y+3, 19 / 19, 16 / 4, 1.5)
							bullet:set("knockback", 2)
							bullet:set("knockback_direction", player.xscale)
							bullet:set("knockup", 8+i)
							bullet:getData().findTarget = true
							if player:get("pVspeed") > -2 then
								player:set("pVspeed", -2 + i)
							end
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end

				elseif playerData.currentSpecial == 1.02 then --Earthshatter
				
					if relevantFrame == 1 then
						player:setAlarm(2, math.max(90 - (90*player:get("cdr")), 1))
					end
					
					if relevantFrame == 2 then
						sfx.Reflect:play(0.2, 0.6)
						sfx.JanitorShoot1_2:play(0.8, 0.4)
						sfx.JanitorShoot4_2:play(0.9, 1)
						for i = 0, playerAc.sp do
							local bullet = player:fireExplosion(player.x + player.xscale, player.y+3, 50 / 19, 12 / 4, 1)
							bullet:set("knockback", 6+i)
							bullet:set("knockup", 3+i/2)
							bullet:set("stun", (2+i))
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
						if onScreen(player) then
							misc.shakeScreen(1)
						end
					end
					
				elseif playerData.currentSpecial == 1.03 then --Chase
					if relevantFrame == 1 then
						player:setAlarm(2, (1.5*player:getAlarm(2))/math.sqrt(player:get("attack_speed"))) --hee hoo
						if player:get("invincible") < 30 then
							player:set("invincible", 30)
						end
					end
					
					if relevantFrame == 1 then
						sfx.PodDeath:play(1.3, 0.8)
						sfx.Reflect:play(0.9, 0.5)
						local target = nil
						for _, instance2 in ipairs(pobj.actors:findAll()) do
							if instance2:get("team") ~= playerAc.team then
								if player.xscale > 0 and instance2.x > player.x - 10 or player.xscale < 0 and instance2.x < player.x + 10 then
									local dis = distance(player.x, player.y, instance2.x, instance2.y)
									if not target or dis < target.dis then
										if dis < 100 then
											target = {inst = instance2, dis = dis}
										end
									end
								end
							end
						end
						
						local xx = 2 * player.xscale
						local yy = -2
						
						if playerData.chaseTarget then
							target = playerData.chaseTarget
							if target:isValid() then
								local angle = posToAngle(player.x, target.y, target.x, player.y)
								local angleRad = math.rad(angle)
								local dis = distance(player.x, player.y, target.x, target.y)
								xx = math.cos(angleRad) * 5
								yy = math.sin(angleRad) * (5 - (target:get("pVspeed")/2))
								print("chasing chase target...")
							end
						elseif target then
							target = target.inst
							if target:isValid() then
								local angle = posToAngle(player.x, target.y, target.x, player.y)
								local angleRad = math.rad(angle)
								local dis = distance(player.x, player.y, target.x, target.y)
								xx = math.cos(angleRad) * 5
								yy = math.sin(angleRad) * (3 + dis/50 - (target:get("pVspeed")/2)) 
							end
						end
						
						if not playerSSData.xAccel then
							playerSSData.xAccel = xx * 0.75
						end
						player:set("pVspeed", yy)
						
						playerData.canChase = -60
						playerData.chaseTarget = nil
					end
				end
				
			elseif skill == 2 then
			
				if playerData.currentSpecial == 0 then --Ring Out

					if relevantFrame == 3 then
						if onScreen(player) then
							misc.shakeScreen(2)
						end
						sfx.Reflect:play(0.8)
						for i = 0, playerAc.sp do
							local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 3)
							bullet:set("knockup", 4)
							bullet:getData().deadlyxAccel = 10 * player.xscale
							bullet:getData().deadlyxAccelDamage = 3
							bullet:set("stun", 1.5)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
							player:set("pVspeed", -2)
						end
					end
					
				elseif playerData.currentSpecial == 2.01 then --T.K.O. Up
				
					if relevantFrame == 3 then
						if onScreen(player) then
							misc.shakeScreen(1)
						end
						sfx.Reflect:play(0.95)
						for i = 0, playerAc.sp do
							local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 3)
							bullet:set("knockup", 8)
							bullet:set("max_hit_number", 2)
							bullet:getData().deadlyxAccel = 4 * player.xscale
							bullet:getData().deadlyxAccelDamage = 3
							bullet:getData().deadlypVspeed = 3
							bullet:set("stun", 1)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
							player:set("pVspeed", -3)
						end
					end
				
				elseif playerData.currentSpecial == 2.02 then --T.K.O. Down
				
					if relevantFrame == 3 then
						if onScreen(player) then
							misc.shakeScreen(3)
						end
						sfx.Reflect:play(0.65)
						for i = 0, playerAc.sp do
							local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 3)
							--bullet:set("knockup", 4)
							bullet:set("max_hit_number", 1)
							bullet:getData().deadlyxAccel = 11 * player.xscale
							bullet:getData().deadlyxAccelDamage = 1
							bullet:getData().deadlyxAccelUpgrade = true
							bullet:set("stun", 0.5)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
							player:set("pVspeed", -2)
						end
					end
					
				end
				
			elseif skill == 3 then
			
				if playerData.currentSpecial == 3.99 then --Suplex
					if relevantFrame == 1 then
						playerSSData.xAccel = 4*player.xscale
						playerData.checkedInputs = false
					end
					
					local r = 15
					if not playerData.busterTarget and player.subimage < 4 then
						
						for _, actor in ipairs(pobj.actors:findAllEllipse(player.x, player.y - r, player.x + r * player.xscale, player.y + r)) do
							if actor:get("team") ~= player:get("team") then
								local dist = distance(player.x, player.y, actor.x, actor.y)
								local angle = posToAngle(player.x, player.y, actor.x, actor.y)
								local bullet = player:fireBullet(player.x, player.y, angle, dist*1.1, 1/player:get("damage"), nil, DAMAGER_NO_PROC)
								bullet:getData().buster = true
								bullet:set("stun", 1)
								bullet:getData().staminaReturn = 5
								if playerData.canBusterBosses == false then
									bullet:set("max_hit_number", 1)
								end
							end
						end	
					end
					
					if playerData.busterTarget then
						playerData.overrideInvul = true
						if player.subimage < 4 then
							if player:get("invincible") < 30 then
								player:set("invincible", 30)
							end
						end
						
						if playerSSData.xAccel and playerSSData.xAccel > 0.00001*player.xscale then
							playerSSData.xAccel = math.approach(playerSSData.xAccel, 0, 0.75)
						end
						
						if relevantFrame == 4 then
							--player:set("pVspeed", math.min(player:get("pVspeed") -3, -2))
							player:set("pVspeed", -7)
							player:set("pHspeed", -0.7*player.xscale)
						end
						
						if relevantFrame == 5 then
							player:getData().awaitingGroundImpact = 300
						end
						
						if player.subimage > 7 and playerData.awaitingGroundImpact then
							player.subimage = 7
							if player:get("pVspeed") > -4 then
								player.angle = math.approach(player.angle, 180, 9*player:get("attack_speed"))
							end
						elseif player.subimage > 7 then
							player.angle = math.approach(player.angle, 0, 60*player:get("attack_speed"))
						end
						--[[
						if player.subimage >= 9 then
							player.subimage = player.sprite.frames
						end
						]]
					elseif player.subimage >= 4 and player.subimage < 9 then
						player.subimage = 9
					end
					
				elseif playerData.currentSpecial == 3.01 then --Into Orbit
				
					local r = 15
					
					if relevantFrame == 1 then
						playerSSData.xAccel = 3*player.xscale
						--playerData.doneCurrentSpecial[playerData.currentSpecial] = false
					end
					
					if not playerData.busterTarget and player.subimage < 4 then
						
						for _, actor in ipairs(pobj.actors:findAllEllipse(player.x, player.y - r/2, player.x + r * player.xscale, player.y + r/5)) do
							if actor:get("team") ~= player:get("team") then
								local bullet = player:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, 1/player:get("damage"), nil, DAMAGER_NO_PROC)
								bullet:set("stun", 1)
								bullet:getData().findTarget = true
								playerData.canChase = 30
								playerData.busterTarget = actor
							end
						end	
					end

					if playerData.busterTarget then
						playerData.overrideInvul = true
						player:setAlarm(4, math.max(15/player:get("attack_speed"),1))
						local actor = playerData.busterTarget
						
						if relevantFrame == 4 then
							local bullet = player:fireExplosion(actor.x, actor.y, 12/19, 6/4, 3, nil)
							bullet:set("stun", 0.3)
							bullet:set("knockup", 9)
							bullet:set("knockback", 1)
							bullet:set("knockback_direction", player.xscale)
						end
						if relevantFrame == 7 then
							player.subimage = player.sprite.frames
						end
					elseif player.subimage >= 4 and player.subimage < 9 then
						player.subimage = 9
					end
					
				elseif playerData.currentSpecial == 3.02 then --Don't Blink
				
				
					local r = 30*player:get("pHmax")
					if relevantFrame == 1 then
						player:set("pHspeed", 0)
						playerData.scoopList = {}
					end
					
					if relevantFrame == 3 then
						
						for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - r/3 * player.xscale , player.y - r/2, player.x + r * player.xscale, player.y + r/5)) do
							if actor:get("team") ~= player:get("team") and not playerData.scoopList[actor] then
								playerData.scoopList[actor] = true
								local bullet = player:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, 1/player:get("damage"), nil, DAMAGER_NO_PROC)
								bullet:set("stun", 1)
								bullet:set("specific_target", actor.id)
								bullet:getData().buster = true
								playerData.busterTarget = actor
								r = 30*player:get("pHmax")*1.5
							end
						end	
						
						local lastx, x = player.x, player.x
						local max = r
						while not player:collidesMap(x, player.x) do
							x = x+2*player.xscale
							if math.abs(x - player.x) >= max then
								break
							end
							if player:collidesMap(x, player.x) then
								x = lastx
								break
							end
							lastx = x
						end
						player.x = x
						player.xscale = -1*player.xscale
					end

					if playerData.busterTarget then
						playerData.overrideInvul = true
						--player:setAlarm(4, math.max(15/player:get("attack_speed"),1))
						local actor = playerData.busterTarget
						
						
						if relevantFrame == 8 then
							playerData.busterContact = true
						end
						
						if relevantFrame == 10 then
							player.subimage = player.sprite.frames
						end
					elseif player.subimage > 3 and player.subimage < 8 then
						player.subimage = player.sprite.frames
					end
				
				
				end
				
			elseif skill == 4 then
			
				if playerData.currentSpecial == 0 then --Cargo
					
				elseif playerData.currentSpecial == 4.01 then --Heavenbound Buster
				 --print("eeeeeee")
					if relevantFrame == 2 then
						if playerSSData.xAccel then --increases hitbox length depending on current xAccel
							local bullet = player:fireBullet(player.x + player.xscale * -4, player.y, player:getFacingDirection(), 40*math.max(1, math.sqrt(math.abs(playerSSData.xAccel))), (1/playerAc.damage), nil, DAMAGER_NO_PROC --[[+ DAMAGER_NO_RECALCULATE]])
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
						playerData.overrideInvul = true
						if player.subimage < 4 then
							if player:get("invincible") < 80 then
								player:set("invincible", 80)
							end
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
						local funnyframe = 5
						if player:get("pVspeed") > 0 then
							funnyframe = 6
						end
						if player.subimage > funnyframe and player:getData().awaitingGroundImpact then
							player.subimage = funnyframe
						end
					elseif relevantFrame == 3 then
						player.subimage = player.sprite.frames
					end
					
				end
			end
		end
	end)
	
	callback.register("onPlayerStep", function(player)
		if SurvivorVariant.getActive(player) == newVariant then
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			if playerData.canChase and player:getAlarm(2) == -1 and player:get("activity") == 0 then
				playerData.canChase = math.approach(playerData.canChase, 0, 1)
				if playerData.canChase == 0 then
					playerData.canChase = nil
					playerData.chaseTarget = nil
				end
			end
			--[[
			if playerData.currentSpecial > 0 and (playerAc.activity < 1 or playerAc.activity > 5) then
				playerData.currentSpecial = 0
				--playerData.busterTarget = false --failsafe
			end 
			]]
		end
	end)
	
	callback.register("preHit", function(damager, hit) --needs synced (i think ?)
		local parent = damager:getParent()
		if parent and parent:isValid() then
			if hit and hit:isValid() then
				if damager:getData().findTarget then
					parent:getData().chaseTarget = hit
				end
				if damager:getData().deadlyxAccel then
					hit:getData().deadlyxAccel = damager:getData().deadlyxAccel --controls raw value
					
					if not damager:getData().deadlyxAccelParent then
						hit:getData().deadlyxAccelParent = parent --controls hitbox spawner
					else
						hit:getData().deadlyxAccelParent = damager:getData().deadlyxAccelParent
					end
					
					hit:getData().deadlyxAccelDamage = damager:getData().deadlyxAccelDamage --controls how much damage to deal on contact
					
					if damager:getData().deadlyxAccelUpgrade and isa(damager:getData().deadlyxAccelUpgrade, "boolean") then
						hit:getData().deadlyxAccelUpgrade = {}
						hit:getData().deadlyxAccelUpgrade[hit] = true
					elseif damager:getData().deadlyxAccelUpgrade then
						hit:getData().deadlyxAccelUpgrade = damager:getData().deadlyxAccelUpgrade --controls knocking back other enemies
					end
				end
				if damager:getData().deadlypVspeed then
					hit:getData().deadlypVspeed = damager:getData().deadlypVspeed
					hit:getData().deadlypVspeedParent = parent
				end
			end
		end
	end)
	
	callback.register("onActorStep", function(actor)
		local actorData = actor:getData()
		if actorData.deadlyxAccel and not actor:getModData("Starstorm").positionOverride then --damage on contact
			if actorData.deadlyxAccelUpgrade then
				local parent = actor:getData().deadlyxAccelParent
				local xr = actor.sprite.width +10
				local yr = actor.sprite.height +10
				if parent and parent:isValid() then
					for _, actor2 in ipairs(pobj.actors:findAllEllipse(actor.x - xr, actor.y - yr, actor.x + xr, actor.y + yr)) do
						if actor2:get("team") == actor:get("team") and not actor:getData().deadlyxAccelUpgrade[actor2] then
							if actor2:collidesWith(actor, actor2.x, actor2.y) then
								actor:getData().deadlyxAccelUpgrade[actor2] = true
								local damage = parent:fireBullet(actor2.x, actor2.y, actor2:getFacingDirection(), 2, actorData.deadlyxAccelDamage)
								damage:set("specific_target", actor2.id)
								damage:set("stun", 1)
								damage:getData().deadlyxAccel = actorData.deadlyxAccel*1.1
								damage:getData().deadlyxAccelDamage = actorData.deadlyxAccelDamage
								damage:getData().deadlyxAccelUpgrade = actorData.deadlyxAccelUpgrade
								damage:getData().deadlyxAccelParent = actorData.deadlyxAccelParent
								
								--...,,,, , , , ,, , ,. , . ., .. ,. ,. . , .,. , ,        .
								if actor2:get("hp") - actorData.deadlyxAccelParent:get("damage")*actorData.deadlyxAccelDamage > 0 then
									actorData.deadlyxAccel = actorData.deadlyxAccel/-5
								end
								if actor:get("pVspeed") > -1.8 then
									actor:set("pVspeed", -1.8)
								end
								--hee hoo
							end
						end
					end
				end
			end
			
			if actorData.deadlyxAccel ~= 0 then
				if not actorData.deadlyxAccelUpgrade then
					actorData.deadlyxAccel = math.approach(actorData.deadlyxAccel, 0, 0.25)
					if actor:get("free") == 0 then
						actorData.deadlyxAccel = math.approach(actorData.deadlyxAccel, 0, 1)
					end
				else
					actorData.deadlyxAccel = math.approach(actorData.deadlyxAccel, 0, 0.2)
				end
				local newx = actor.x + actorData.deadlyxAccel
				if actor:collidesMap(newx, actor.y) then
					if actor:collidesMap(newx, actor.y - 1) then
						if actorData.deadlyxAccelParent and actorData.deadlyxAccelParent:isValid() then
							local damage = actorData.deadlyxAccelParent:fireExplosion(actor.x, actor.y, 30/19, 20/4, actorData.deadlyxAccelDamage, nil)
							damage:set("stun", 1.5)
							damage:set("knockback", 1)
							damage:set("knockback_direction", actorData.deadlyxAccelParent.xscale*-1)
							actor:getModData("Starstorm").xAccel = actorData.deadlyxAccel/-3
						end
						actorData.deadlyxAccel = nil
						actorData.deadlyxAccelParent = nil
						actorData.deadlyxAccelUpgrade = nil
						actorData.deadlyxAccelDamage = nil
					end
				elseif actor:get("activity") == 30 then
					actorData.deadlyxAccel = nil
					actorData.deadlyxAccelParent = nil
					actorData.deadlyxAccelUpgrade = nil
					actorData.deadlyxAccelDamage = nil
				else
					actor.x = newx
				end
			else
				actorData.deadlyxAccel = nil
				actorData.deadlyxAccelParent = nil
				actorData.deadlyxAccelUpgrade = nil
				actorData.deadlyxAccelDamage = nil
			end
		end
		if actorData.deadlypVspeed then
			local parent = actorData.deadlypVspeedParent
			if parent and parent:isValid() then
				if not actorData.lastpVspeed then 
					actorData.lastpVspeed = actor:get("pVspeed")
				else
					if actor:get("free") == 1 then
						actorData.lastpVspeed = actor:get("pVspeed")
					else
						local damage = parent:fireExplosion(actor.x, actor.y + actor.sprite.height/3, 30/19, 6/4, 1+(actorData.lastpVspeed/5))
						damage:set("stun", 0.5)
						damage:set("knockback", 3)
						damage:set("knockup", 2)
						actorData.deadlypVspeed = nil
						actorData.lastpVspeed = nil
						actorData.deadlypVspeedParent = nil
					end
				end
			else
				actorData.deadlypVspeed = nil
				actorData.lastpVspeed = nil
				actorData.deadlypVspeedParent = nil
			end
		end
	end)
	
end)