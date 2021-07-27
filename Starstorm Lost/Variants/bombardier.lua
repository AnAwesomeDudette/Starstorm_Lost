callback.register("postLoad", function()

local path = "Variants/Bombardier/"

local survivor = Survivor.find("Artillerist", "SSLost")
local sprSelect = Sprite.load("BombardierSelect", path.."Select", 4, 0, 0)
local bombardier = SurvivorVariant.new(survivor, "Bombardier", sprSelect, {
	idle = Sprite.load("Bombardier_Idle", path.."Idle", 1, 6, 10),
	walk = Sprite.load("Bombardier_Walk", path.."Walk", 8, 8, 10),
	jump = Sprite.load("Bombardier_Jump", path.."Jump", 1, 6, 10),
	climb = Sprite.load("Bombardier_Climb", path.."Climb", 2, 5, 9),
	death = Sprite.load("Bombardier_Death", path.."Death", 8, 8, 12),
	decoy = Sprite.load("Bombardier_Decoy", path.."Decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("Bombardier_Shoot1", path.."Shoot1", 6, 21, 22),
	shoot2 = Sprite.load("Bombardier_Shoot2", path.."Shoot2", 4, 6, 10),
	shoot3 = Sprite.load("Bombardier_Shoot3", path.."Shoot3", 4, 7, 12),
	
	mortar = Sprite.load("Bombardier_Mortar", path.."Mortar", 1, 2, 3)
}, Color.fromHex(0xB5F7FF))

local sprSkills = Sprite.load("Bombardier_Skills", path.."skills", 6, 0, 0)
local sprSkills2 = Sprite.load("Bombardier_Skills2", path.."skillsCount", 9, 0, 0)

bombardier.endingQuote = "..and so he left, and so he right."

	SurvivorVariant.setInfoStats(bombardier, {{"Strength", 7}, {"Vitality", 4}, {"Toughness", 4}, {"Agility", 8}, {"Difficulty", 5}, {"Quake", 9}})
	SurvivorVariant.setDescription(bombardier, "Bombardier Moonfall in real???(3 AM)(Gone wrong)")
	SurvivorVariant.setLoadoutSkill(bombardier, "Barrage", "Shoot rocket. Wo w", sprSkills, 1)
	SurvivorVariant.setLoadoutSkill(bombardier, "Rocket Jump", "Shoot rocket beneath you, propelling you forwards. Wh oa", sprSkills, 3)


callback.register("onSkinInit", function(player, skin) 
	if skin == bombardier then
		player:setSkill(1, "Barrage", "Fire all loaded rockets for 250% damage each.",
		sprSkills, 1, 60)
		
		player:setSkill(2, "Load", "Load an extra shell onto the rocket launcher.",
		sprSkills, 2, 2 * 60)
			
		player:setSkill(3, "Rocket jump", "Launch a rocket below you that knocks all characters back.",
		sprSkills, 3, 3 * 60)

		player:setSkill(4, "Tracking Munition", "For 4 seconds, launched rockets seek enemies.",
		sprSkills, 4, 8 * 60)
		
		player:getData().mortarTime = 0
		player:getData().skin_skill1Override = true
		player:getData().skin_skill3Override = true
	end
end)

local objMortar = Object.new("BombardierRocket")
objMortar.sprite = spr.EfMortar
sprMortarMask = Sprite.load("Bombardier_RocketMask", path.."MortarMask", 1, 2, 3)
objMortar:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	self.mask = sprMortarMask
	
	selfData.scepter = false
	selfData.vspeed = 0
	selfData.direction = 0
	selfData.speed = 3
	selfData.team = "player"
	selfData.life = 0
	selfData.maxLife = 400
	
	selfData.faceDirection = 0
end)
objMortar:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if misc.getOption("video.quality") > 1 then
		if selfData.homing then
			ParticleType.find("Smoke4"):burst("middle", self.x, self.y, 1)
		else
			ParticleType.find("Smoke2"):burst("middle", self.x, self.y, 1)
		end
	end
	
	selfData.life = selfData.life + 1
	
	local pCollisionEnabled = false
	
	if selfData.homing then
		selfData.vspeed = 0
		if selfData.life > 3 then
			local turnSpeed = 0.06
			local target = nil
			
			if selfData.scepter then
				turnSpeed = 0.2
				selfData.speed = selfData.speed - 0.005
			end
			
			if selfData.push and selfData.life > 10 then
				target = selfData.parent
				turnSpeed = 0.1052
				pCollisionEnabled = true
				selfData.speed = selfData.speed - 0.02 --aaaaa cringe
			elseif not selfData.push then
				for _, instance2 in ipairs(ParentObject.find("actors"):findAll()) do
					if instance2:get("team") ~= selfData.team then
						if selfData.faceDirection == 0 or selfData.faceDirection > 0 and instance2.x > self.x - 100 or selfData.faceDirection < 0 and instance2.x < self.x + 100 then
							local dis = distance(self.x, self.y, instance2.x, instance2.y)
							if not target or dis < target.dis then
								target = {inst = instance2, dis = dis}
							end
						end
					end
				end
				if target then
					target = target.inst
				end
			end
			if target and target:isValid() then
				selfData.direction = selfData.direction + (angleDif(selfData.direction, posToAngle(self.x, target.y, target.x, self.y)) * -turnSpeed)
			end
		end
		selfData.speed = selfData.speed + 0.05
	else
		selfData.speed = selfData.speed + 0.025
	end
	
	local radAngle = math.rad(selfData.direction)
	local xx = math.cos(radAngle) * selfData.speed
	local yy =  math.sin(radAngle) * selfData.speed
	self.x = self.x + xx
	self.y = math.max(self.y + yy + selfData.vspeed, -200)
	
	local collidesEnemy = false
	for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - 10, self.y - 10, self.x + 10, self.y + 10)) do
		if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) then
			collidesEnemy = true
			break
		end
	end
	
	self.angle = posToAngle(self.x, self.y, self.x + xx, self.y + yy + selfData.vspeed)
	
	if self:collidesMap(self.x, self.y) and not selfData.scepter or collidesEnemy or pCollisionEnabled and selfData.parent and selfData.parent:isValid() and self:collidesWith(selfData.parent, self.x, self.y) then
		self:destroy()
	elseif selfData.life > selfData.maxLife then
		self:delete()
	end
end)
objMortar:addCallback("destroy", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if selfData.push then
		local range = 28
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - range, self.y - range, self.x + range, self.y + range)) do
			if actor:isClassic() and actor ~= selfData.parent then
				--local angle = posToAngle(self.x, self.y, actor.x, actor.y)
				local xx = math.sign(actor.x - self.x)
				local yy = math.sign(actor.y - self.y)
				actor:getData().xAccel = 4 * xx
				actor:set("pVspeed", 4 * yy)
			end
		end
		if selfData.parent and selfData.parent:isValid() then
			selfData.parent:fireExplosion(self.x, self.y, 26 / 9, 18 / 4, 1, spr.EfExplosive)
		end
		
		sfx.GiantJellyExplosion:play()
	else
		if selfData.parent and selfData.parent:isValid() then
			selfData.parent:fireExplosion(self.x, self.y, 26 / 9, 18 / 4, 2.5, spr.EfExplosive)
		end
		sfx.GiantJellyExplosion:play(1.4)
	end
	
end)

SurvivorVariant.setSkill(bombardier, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
end)

SurvivorVariant.setSkill(bombardier, 3, function(player)
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.16, true, false)
end)

survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if SurvivorVariant.getActive(player) == bombardier then 
		if skill == 1.01 then
			local angleDown = 0
			if playerAc.free == 1 then 
				angleDown = 90
			end
			if relevantFrame == 1 then
				sfx.RiotGrenade:play(1.2)
				if playerData.homingMortars > 0 then
					sfx.MissileLaunch:play(0.8, 0.6)
				end
				playerData.mortarTime = playerAc.mortarPellets
				if playerAc.free == 1 then
					playerAc.pVspeed = -1.5 * playerAc.pVmax
				else
					player:getData().xAccel = -1 * player.xscale
				end
				for ii = 0, playerAc.sp do
					local angle = ii * 2 - angleDown
					local speed = 3.8 + math.abs(playerAc.pHspeed)
					local mortar = objMortar:create(player.x + player.xscale * 2, player.y - 2)
					mortar.sprite = player:getAnimation("mortar")
					mortar:getData().direction = player:getFacingDirection() + angle * player.xscale * -1
					mortar:getData().speed = speed
					mortar:getData().team = playerAc.team
					mortar:getData().parent = player
					if playerData.homingMortars > 0 then
						mortar:getData().scepter = playerAc.scepter
						mortar:getData().homing = true
						mortar:getData().speed = speed - 1
						mortar:getData().faceDirection = player.xscale
							
						mortar:getData().scepter = playerAc.scepter > 0
					end
				end
				playerAc.mortarPellets = 0
			end
			
			if player.subimage == 2 and playerData.mortarTime > 0 then
				player.subimage = 1
			end
			
			if player.subimage == 1 and playerData.mortarTime > 0 then
				sfx.RiotGrenade:play(1.2)
				if playerData.homingMortars > 0 then
						sfx.MissileLaunch:play(0.8, 0.6)
				end
				if playerAc.mortarPellets > 0 then 
					playerData.mortarTime = 2 * playerAc.mortarPellets + 4
				end
				if playerAc.free == 1 then
					playerAc.pVspeed = -1.5 * playerAc.pVmax
				else
					player:getData().xAccel = -1 * player.xscale
				end
				for ii = 0, playerAc.sp do
					local angle = math.random(-5, 15) - angleDown
					local speed = 3.8 + math.abs(playerAc.pHspeed)
					local mortar = objMortar:create(player.x + player.xscale * 2, player.y - 2)
					mortar.sprite = player:getAnimation("mortar")
					mortar:getData().direction = player:getFacingDirection() + angle * player.xscale * -1
					mortar:getData().speed = speed
					mortar:getData().team = playerAc.team
					mortar:getData().parent = player
					if playerData.homingMortars > 0 then
						mortar:getData().scepter = playerAc.scepter
						mortar:getData().homing = true
						mortar:getData().speed = speed - 1
						mortar:getData().faceDirection = player.xscale
									
						mortar:getData().scepter = playerAc.scepter > 0
					end
				end					
				playerData.mortarTime = playerData.mortarTime - 1
			end
			
		elseif skill == 3.01 then
			if relevantFrame == 1 then
				sfx.RiotGrenade:play(1)
				if playerAc.pHspeed ~= 0 then
					player:getData().xAccel = 3 * player.xscale
				end
				player:set("pVspeed", -1.5 * playerAc.pVmax)
				for i = 0, playerAc.sp do
					local mortar = objMortar:create(player.x, player.y + 1)
					mortar.sprite = player:getAnimation("mortar")
					if playerAc.pHspeed ~= 0 then
						mortar:getData().direction = player:getFacingDirection() + player.xscale * 120
					else
						mortar:getData().direction = player:getFacingDirection() + 90 * player.xscale
					end
					mortar:getData().push = true
					mortar:getData().team = playerAc.team
					mortar:getData().parent = player
					if playerData.homingMortars > 0 then
						mortar:getData().homing = true
					end
				end
			end
		end
	end
end)

callback.register("onPlayerHUDDraw", function(player, x, y)
	if player:getSurvivor() == survivor and SurvivorVariant.getActive(player) == bombardier then
		local bullets = player:get("mortarPellets")
		
		graphics.drawImage{
			image = sprSkills2,
			subimage = bullets + 1,
			y = y - 11,
			x = x
		}
	end
end)

survivor:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if playerAc.mortarPellets >= 7 then
		player:setSkillIcon(2, sprSkills, 6)
	else
		player:setSkillIcon(2, sprSkills, 2)
	end
end)

end)

