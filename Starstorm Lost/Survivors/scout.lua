
-- All Scout data

local path = "Survivors/Scout/"

local scout = Survivor.new("Scout")

local dronePath = "Drones/"
require(dronePath.."SMGdrone")
require(dronePath.."Laserdrone")

-- Scout

--[[ Sounds
local sScoutShoot1 = Sound.load("ScoutShoot1", path.."skill1")
local sScoutShoot2 = Sound.load("ScoutShoot2", path.."skill2")
local sScoutSkill3a = Sound.load("ScoutSkill3A", path.."skill3a")
local sScoutSkill3b = Sound.load("ScoutSkill3B", path.."skill3b")
local sScoutSkill3c = Sound.load("ScoutSkill3C", path.."skill3c")
local sScoutSkill4 = Sound.load("ScoutSkill4", path.."skill4")]]

-- Table sprites
local sprites = {
	idle = Sprite.load("Scout_Idle", path.."idle", 1, 6, 10),
	walk = Sprite.load("Scout_Walk", path.."walk", 8, 6, 9),
	jump = Sprite.load("Scout_Jump", path.."jump", 1, 6, 9),
	jumpHover = Sprite.load("Scout_JumpHover", path.."jumpHover", 3, 6, 9),
	climb = Sprite.load("Scout_Climb", path.."climb", 2, 4, 7),
	death = Sprite.load("Scout_Death", path.."death", 11, 9, 9),
	decoy = Sprite.load("Scout_Decoy", path.."decoy", 1, 9, 10),

	shoot1_1 = Sprite.load("Scout_Shoot1_1", path.."shoot1_1", 8, 8, 13),
	shoot1_2 = Sprite.load("Scout_Shoot1_2", path.."shoot1_2", 8, 15, 7),
	shoot2 = Sprite.load("Scout_Shoot2", path.."shoot2", 4, 10, 7),
	shoot3 = Sprite.load("Scout_Shoot3", path.."shoot3", 6, 6, 15)
}
-- Hit sprites
local sprSparks1 = Sprite.load("Scout_Sparks1", path.."sparks1", 3, 15, 7)
local sprSparks2 = Sprite.load("Scout_Sparks2", path.."sparks2", 3, 7, 15)
local sprSparks3 = Sprite.load("Scout_Sparks3", path.."sparks3", 5, 36, 30)

-- Skill sprites
local sprSkills = Sprite.load("Scout_Skills", path.."skills", 5, 0, 0)
local sprSkills2 = Sprite.load("Scout_Skills2", path.."skillsCount", 11, 0, 0)

-- Selection sprite
scout.loadoutSprite = Sprite.load("Scout_Select", path.."select", 5, 2, 0)

-- Selection description
scout:setLoadoutInfo(
[[The &y&Scout is a super agile, fast hitting fighter&!& who excels at
exploration and moving about tricky landscapes. 
Their drone arsenal provides a variety of tools for any hostile environment.
&y&Hold space to hover for a short time.&!&]], sprSkills)

-- Skill descriptions
scout:setLoadoutSkill(1, "Chain Blast",
[[Fire in quick succession for &y&6x50% damage.&!&
&b&Aims downwards if you're hovering.&!&]])

scout:setLoadoutSkill(2, "Recursion Bomb",
[[Drop a bomb which bounces 4 times dealing damage, &y&blasting you upwards when not hovering.&!&
&b&Deals more damage the higher the distance it is dropped from.&!&]])

scout:setLoadoutSkill(3, "Backdash",
[[Instantly accelerate backwards, blasting away from enemies.
&b&Acceleration increases with movement speed.&!&]])

scout:setLoadoutSkill(4, "Relay Beacon",
[[Become a &b&Headhunter Katana ZERO Real.&!&]])

-- Color of highlights during selection
scout.loadoutColor = Color.fromHex(0x43DBB0)

-- Misc. menus sprite
scout.idleSprite = sprites.idle

-- Main menu sprite
scout.titleSprite = sprites.walk

-- Endquote
scout.endingQuote = "..and so they left, with one final beacon activated."

callback.register("postLoad", function()
	SurvivorVariant.setInfoStats(SurvivorVariant.getSurvivorDefault(scout), {{"Strength", 9}, {"Vitality", 4}, {"Toughness", 4}, {"Agility", 7}, {"Difficulty", 4}, {"Flying lmao", 9}})
	SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(scout), "Scouts are known for their versatility in colonization efforts, but not so much for being the most orderly bunch.")
end)

-- Stats & Skills
scout:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerAc.pGravity2 = 0.1
	
	playerAc.pVmax = 3.1
	playerAc.pHmax = playerAc.pHmax * 1.15
	
	player:setAnimations(sprites)
	
	playerData.shootAnim = player:getAnimation("shoot1_1")
	playerData.scoutPercent = 0
	playerData.scoutPercentPersistent = 0
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(160, 12, 0.055)
	else
		player:survivorSetInitialStats(110, 12, 0.025)
	end
	
    player:setSkill(1, "Chain Blast", "Fire in quick succession for 6x50%.",
    sprSkills, 1, 60)
        
    player:setSkill(2, "Recursive Bomb", "Drop a bomb which bounces 4 times dealing damage. Blasts you upwards when not hovering.",
    sprSkills, 2, 3 * 60)

    player:setSkill(3, "Backdash", "Instantly accelerate backwards, blasting away from enemies. Acceleration scales with movement speed.",
    sprSkills, 3, 2 * 60)

    player:setSkill(4, "Relay Beacon", "Place relay beacons that currently do nothing.",
    sprSkills, 4, 1 * 60)
end)

scout:addCallback("step", function(player)
	if player:get("activity") == 99 then
		player:getData().teleAvailable = 0
	end
	if player:get("moveUpHold") == 0 then
		player:getData().shootAnim = player:getAnimation("shoot1_1")
	else
		player:getData().shootAnim = player:getAnimation("shoot1_2")
	end
end)

-- Called when the player levels up
scout:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(26, 3, 0.0025, 3)
end)

-- Called when the player picks up the Ancient Scepter
scout:addCallback("scepter", function(player)
	player:setSkill(4, "", "",
	sprSkills, 5, 6 * 60)
end)


-- Skills

local objBomb = Object.new("ScoutBomb")
local mask = Sprite.load("Scout_BombMask", path.."bombMask", 1, 2, 2)
objBomb.sprite = Sprite.load("Scout_Bomb", path.."bomb", 10, 5, 5)
objBomb.depth = -4

objBomb:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfData.team = "player"
	selfData.damage = 0
	selfData.life = 0.1
	selfData.bounces = 3
	selfData.vSpeed = 0
	selfData.angleSpeed = math.random(-10, 10)
	self.spriteSpeed = math.random(10, 50) * 0.01
	selfData.range = 28
	self.mask = mask
end)
objBomb:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	self.angle = self.angle + selfData.angleSpeed
	
	if selfData.vSpeed > 0 then
		selfData.life = selfData.life + 0.1
	end
	
	self.y = self.y + selfData.vSpeed
	
	selfData.vSpeed = selfData.vSpeed + 0.1
	
	if selfData.vSpeed < 0 and self:collidesMap(self.x, self.y - 2) then
		selfData.vSpeed = selfData.vSpeed * -0.6
		for i = 1, 20 do
			if not self:collidesMap(self.x, self.y + i + 1) then
				self.y = self.y + i
				break
			end
		end
	elseif self:collidesMap(self.x, self.y) then
		local mult = math.abs(selfData.vSpeed) * 0.6
		--print(selfData.vSpeed * selfData.damage)
		for i = 1, 20 do
			if not self:collidesMap(self.x, self.y - i + 1) then
				self.y = self.y - i
				break
			end
		end
		if selfData.parent and selfData.parent:isValid() then
			selfData.parent:fireExplosion(self.x, self.y + 3, selfData.range / 19, selfData.range / 4, mult, sprSparks3)
		else
			misc.fireExplosion(self.x, self.y, selfData.range / 19, selfData.range / 4, selfData.damage * mult, selfData.team, sprSparks3)
		end
		
		selfData.bounces = selfData.bounces - 1
		selfData.vSpeed = selfData.vSpeed * -0.8
		
		selfData.angleSpeed = math.random(-10, 10)
		self.spriteSpeed = math.random(10, 50) * 0.01
	end
	
	if selfData.bounces < 0 then
		self:destroy()
	end
end)

local objPOI = Object.new("ScoutPOI")
objPOI.sprite = Sprite.load("Scout_POI", path.."poi", 11, 6, 26)

objPOI:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfData.team = "player"
	selfData.damage = 0
	--selfData.life = 0.1
	selfData.range = 200
	self.spriteSpeed = 0.2
	selfData.coverage = 0
	
	for i = 0, 400 do
		if self:collidesMap(self.x, self.y + i + 1) then
			self.y = self.y + i
			break
		end
	end
	
	local r = selfData.range
	for _,b in ipairs(obj.B:findAllEllipse(self.x + r, self.y + r, self.x - r, self.y - r)) do
		if not b:getData().POImarked then
			selfData.coverage = selfData.coverage + 1
			b:getData().POImarked = true
		end
	end
	
end)

objPOI:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if self.subimage >= self.sprite.frames then
		self.spriteSpeed = 0
		
		if not selfData.active then
			--for _, 
		end
	end
	
end)
objPOI:addCallback("draw", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	local tele = nearestMatchingOp(self, obj.Teleporter, "isBig", "~=", 1)
	
	if tele then
		local str = "<"
		if tele.x >= self.x then
			str = ">"
		end
		--graphics.alpha((-global.timer % 100) * 0.01)
		--graphics.color(scout.loadoutColor)
		--graphics.print(str, self.x + 4, self.y - 40, nil, graphics.ALIGN_MIDDLE)
	end
	
	local parent = selfData.parent
	local cover = math.round(parent:getData().scoutPercent)
	
	graphics.alpha((-global.timer % 100) * 0.005)
	graphics.color(scout.loadoutColor)
	graphics.circle(self.x, self.y, selfData.range, true)
	graphics.print(cover.."%", self.x, self.y - 45, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE)
end)

scout:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getData().shootAnim, 0.25, true, true)
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.2, true, false)
			sfx.RiotGrenade:play(1.5, 1)
			local bomb = objBomb:create(player.x, player.y):getData()
			bomb.vSpeed = -2
			bomb.team = playerAc.team
			bomb.damage = playerAc.damage
			bomb.parent = player
			if not playerData.hovering then
				if playerData.hoverTimer then
					playerAc.pVspeed = -3 * math.max((playerData.hoverTimer / 120), 4/3)
				else
					playerAc.pVspeed = -4
				end
			end
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.4, false, false)
			--print(playerAc.pHmax)
		elseif skill == 4 then
			-- V skill
			--player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, false, false)
			local laser = obj.laserdrone:create(player.x, player.y)
			laser:getData().parentId = player.id
		end
		player:activateSkillCooldown(skill)
	end
end)

callback.register("onImpact", function(damager, x, y)
	if damager:getData().verticalSparks then
		local sparks = obj.EfSparks:create(x, y)
		sparks.sprite = damager:getData().verticalSparks
		sparks.yscale = 1
		if math.chance(50) then
			sparks.xscale = 1
		else
			sparks.xscale = -1
		end
	end
end)

scout:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 1 and not playerData.skin_skill1Override then
		if relevantFrame >= 1 and relevantFrame <= 6 then 
			sfx.CowboyShoot1:play(1.7+math.random(0, 0.1), 0.6)
			if relevantFrame ~= 1 or not player:survivorFireHeavenCracker(1) then
				for i = 0, playerAc.sp do
					local midair = player.sprite == player:getAnimation("shoot1_2")
					
					local sparks = sprSparks1
					local angle = player:getFacingDirection()
					local add = 0
					if midair then
						sparks = nil
						angle = -90 + math.random(-20, 20) * 0.5
						add = math.random(-5, 5)
					--[[else
						angle = angle + math.random(-5, 5) * 0.5]]
	--[[im really thinkin scout's primary could use for a degree of inaccuracy]]
					end
					local bullet = player:fireBullet(player.x + add, player.y, angle, 340, 0.5, sparks)
					bullet:set("climb", (i + relevantFrame) * 8)
					if midair then
						bullet:getData().verticalSparks = sprSparks2
					end
				end
				for _, droneId in ipairs(player:getData().scoutDrones) do
					local drone = Object.findInstance(droneId)
					if drone and drone:isValid() then
						drone:getData().heat = drone:getData().heat + 10
					end
				end
			end
			if player.sprite == player:getAnimation("shoot1_1") then
				playerData.xAccel = playerData.xAccel or 0 - player.xscale
			end
		end
		
	elseif skill == 2 and not playerData.skin_skill2Override then

	elseif skill == 3 and not playerData.skin_skill3Override then
		if relevantFrame == 1 then
			sfx.SpiderShoot1:play(1.5, 0.7)
			--[[playerAc.pHspeed = (playerAc.pHmax-1.095) / 4 * math.sign(playerAc.pHspeed)
			if playerData.hovering then
				playerData.xAccel = player.xscale * -3 * math.sqrt(playerAc.pHmax)
			else
				playerData.xAccel = player.xscale * -3 * math.sqrt(playerAc.pHmax - 0.4)
			end]]
			
	--[[scout's utility *NEEDS* a hover check, because the acceleration gained increases with pHmax, and pHmax is increased
		by the hover.  
		for the pHspeed formula though, mine is just different and linearly increases with pHmax increase subtracted by minus base pHmax,
		instead of using a square root formula]]
			playerAc.pHspeed = math.sqrt(playerAc.pHmax) * player.xscale
			playerData.xAccel = player.xscale * -3 * math.sqrt(playerAc.pHmax)
			if not net.online or player == net.localPlayer then
				misc.shakeScreen(3)
			end
		end
		if playerAc.invincible < 2 then
			playerAc.invincible = 2
		end
		if playerAc.pVspeed > 0 then
			playerAc.pVspeed = 0
		end
	elseif skill == 4 and not playerData.skin_skill4Override then
		
	end
end)

callback.register("onPlayerHUDDraw", function(player, x, y)
	if player:getSurvivor() == scout and not player:getData().skin_skill4Override then
		
	end
end)

scout:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if playerAc.activity == 30 then
		
	end
	
	if playerAc.moveUpHold == 1 and playerAc.free == 1 then
		if playerAc.pVspeed > 0 then
			local add = 0
			if playerData.hoverTimer then
				add = 0.3
			end
			playerAc.pVspeed = math.approach(playerAc.pVspeed, 0, add + playerAc.pVspeed * 0.1)
		else
			playerAc.pVspeed = math.max(playerAc.pVspeed, -8)
		end
		if not playerData.hovering then
			playerData.hovering = true
			playerAc.pHmax = playerAc.pHmax - 0.4
			if not player:getAnimation("jump_b") then
				player:setAnimation("jump_b", player:getAnimation("jump"))
			end
			player:setAnimation("jump", player:getAnimation("jumpHover"))
			--playerData.hoverTimer = 240
		end
	elseif playerData.hovering then
		playerAc.pHmax = playerAc.pHmax + 0.4
		player:setAnimation("jump", player:getAnimation("jump_b"))
		playerData.hovering = false
	end
	
	if playerAc.free == 0 then
		playerData.hoverTimer = 240
	end
	
	if playerData.hoverTimer then
		if playerData.hoverTimer > 0 then
			playerData.hoverTimer = playerData.hoverTimer - 1
		else
			playerData.hoverTimer = nil
		end
	end
end)

callback.register("onStep", function()

end)

callback.register("onStageEntry", function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == scout then
			player:getData().scoutDrones = {}
			local smg = obj.smgdrone:create(player.x, player.y)
			smg:getData().parentId = player.id
			table.insert(player:getData().scoutDrones, smg.id)
			smg = obj.smgdrone:create(player.x, player.y)
			smg:getData().parentId = player.id
			smg:getData().location = -1
			table.insert(player:getData().scoutDrones, smg.id)
		end
	end
end)

sur.Scout = scout