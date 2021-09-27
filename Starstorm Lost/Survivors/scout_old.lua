
-- All Scout data

local path = "Survivors/Scout/"

local scout = Survivor.new("Scout")

--local dronePath = "Drones/"
--require(dronePath.."SMGdrone")
--require(dronePath.."Laserdrone")

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

scout:setLoadoutSkill(4, "NULL Radar",
[[Release a &b&Laser Drone&!& that surveys the area, dealing &y&33-100% damage per hit&!& 
&b&increasing with distance.&!& After firing, the drone &b&locates the teleporter.&!&]])

-- Color of highlights during selection
scout.loadoutColor = Color.fromHex(0x43DBB0)

-- Misc. menus sprite
scout.idleSprite = sprites.idle

-- Main menu sprite
scout.titleSprite = sprites.walk

-- Endquote
scout.endingQuote = "..and so they left, radars and scanners still pinging onwards."

callback.register("postLoad", function()
	SurvivorVariant.setInfoStats(SurvivorVariant.getSurvivorDefault(scout), {{"Strength", 7}, {"Vitality", 3}, {"Toughness", 4}, {"Agility", 9}, {"Difficulty", 4}, {"Drones", 8}})
	SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(scout), "Scouts are known for their versatility in colonization efforts, but not so much for being the most sociable bunch, preferring drones and isolation to humans.")
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
	playerData.armsrace = 0
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 12, 0.055)
	else
		player:survivorSetInitialStats(90, 12, 0.025)
	end
	
    player:setSkill(1, "Chain Blast", "Fire in quick succession for 6x50%. Aim down when hovering.",
    sprSkills, 1, 60)
        
    player:setSkill(2, "Recursive Bomb", "Drop a bomb which bounces 4 times dealing damage. Blasts you upwards when not hovering.",
    sprSkills, 2, 3 * 60)

    player:setSkill(3, "Backdash", "Instantly accelerate backwards, blasting away from enemies. Acceleration scales with movement speed.",
    sprSkills, 3, 2 * 60)

    player:setSkill(4, "NULL Radar", "Release a Laser Drone that surveys the area, dealing 33-100% damage per hit and locating the teleporter.",
    sprSkills, 4, 15 * 60)
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
	player:survivorLevelUpStats(23, 3, 0.0025, 2)
end)

-- Called when the player picks up the Ancient Scepter
scout:addCallback("scepter", function(player)
	player:setSkill(4, "NULL Radar - Gamma", "Release a Laser Drone that surveys the area, dealing 33-100% damage per hit and locating the teleporter. Sweeps an additional time per scepter.",
	sprSkills, 5, 15 * 60)
end)


-- Skills

-- BOMB 
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

-- SMG DRONE
local smgIdle = Sprite.load("SMGDroneIdle", path.."SMGIdle", 4, 6, 10)
obj.smgdrone = Object.new("SMGDrone")
obj.smgdrone.sprite = smgIdle

obj.smgdrone:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.2
	selfData.cooldown = 10
	selfData.attackTimerMax = 6 * 4
	selfData.attackTimer = selfData.attackTimerMax
	selfData.state = "idle"
	selfData.heat = 0
	selfData.location = 1
	selfData.yOffset = 0
end)

obj.smgdrone:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	local parent = Object.findInstance(selfData.parentId)
	
	if parent and parent:isValid() and parent:get("dead") == 0 then
		-- Awesome's code here
		if math.chance(50) then
			selfData.yOffset = selfData.yOffset + 1/30
		end
		if selfData.yOffset > math.pi then
			selfData.yOffset = -math.pi
		end
		local offset = math.sin(selfData.yOffset) * 5
		-- thanks for making drone idle more interesting! :)
		
		if selfData.state == "idle" then
			local xx = parent.x + 12 * selfData.location - self.x
			local yy = parent.y - 8 - offset - self.y
			self.x = math.approach(self.x, parent.x + 12 * selfData.location, xx * 0.1)
			self.y = math.approach(self.y, parent.y - 8 - offset, yy * 0.1)
			self.xscale = parent.xscale
			if selfData.heat >= 75 then
				selfData.state = "attack"
			end
		end
			
		if selfData.heat > 0 then
			selfData.heat = selfData.heat - 1
		end
		
		if selfData.state == "attack" then
			local r = 100
			local target = parent
			local dis = r * 3
           	for _, actor in ipairs(pobj.actors:findAllEllipse(self.x + r * 2, self.y + r, self.x - r * 2, self.y - r)) do
               	if actor and actor:isValid() and actor:get("team") ~= parent:get("team") then
                    if distance(self.x, self.y, actor.x, actor.y) < dis then
                        target = actor
                      	dis = distance(self.x, self.y, actor.x, actor.y)
                  	end
                end
            end
			
            if target and target ~= parent then
				local xx = target.x - self.x 
				local yy = target.y - self.y
				
				
				self.y = math.approach(self.y, target.y, yy * 0.1)
				
				if xx ~= 0 then
					self.xscale = math.sign(xx)
				end
				
				if selfData.cooldown > 0 and math.chance(50) then
					selfData.cooldown = selfData.cooldown - 1
				else
					if selfData.attackTimer > 0 then
						if selfData.attackTimer % 4 == 0 then
							sfx.ChildDeath:play(2.4 + math.random(-2, 3) * 0.1, 0.4)
							misc.fireBullet(self.x, self.y, self.xscale * -90 + 90, 100, parent:get("damage") * 0.2, parent:get("team"), Sprite.find("Scout_Sparks1", "SSLost")):set("specific_target", target.id)
							local chance = 0
							for i = 1, parent:getData().armsrace do
								chance = math.approach(chance, 100, (100 - chance) * 0.05)
							end
							if math.chance(chance) then
								obj.EfMissileSmall:create(self.x, self.y):set("parent", self.id):set("damage", parent:get("damage"))
							end
						end
						selfData.attackTimer = selfData.attackTimer - 1
					else
						selfData.cooldown = 60
						selfData.attackTimer = selfData.attackTimerMax
					end
					
				end
			else
				selfData.state = "idle"
			end
			if selfData.heat == 0 and selfData.cooldown > 0 then
				selfData.state = "idle"
			end
		end
	end
end)

local armsraceSpr = Sprite.find("EfArmsrace", "Vanilla")
obj.smgdrone:addCallback("draw", function(self)
	local parent = Object.findInstance(self:getData().parentId)
	if parent:getData().armsrace > 0 then
		graphics.drawImage{
		image = armsraceSpr,
		x = self.x,
		y = self.y,
		xscale = self.xscale
		}
	end
end)

local armsrace = Item.find("Arms Race", "Vanilla")
armsrace:addCallback("pickup", function(player)
	if player:getSurvivor() == Survivor.find("Scout", "SSlost") then
		player:getData().armsrace = player:getData().armsrace + 1
	end
end)

callback.register("onItemRemoval", function(player, item, amount)
	if item == armsrace and player:getSurvivor() == Survivor.find("Scout", "SSlost") then
		player:getData().armsrace = player:getData().armsrace - amount
	end
end)
-- SMG DRONE END 

--LASER DRONE
local laserIdle = Sprite.load("LaserDroneIdle", path.."SMGIdle", 4, 6, 10)
obj.laserdrone = Object.new("LaserDrone")
obj.laserdrone.sprite = laserIdle

obj.laserdrone:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.2
	selfData.state = "idle"
	selfData.direction = {
	spin = 1,
	laserStart = 0,
	laserEnd = 180
	}
	selfData.scepter = 0
end)

obj.laserdrone:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	local parent = Object.findInstance(selfData.parentId)
	
	if not selfData.yloc then
		selfData.yloc = parent.y - 65
	end
	
	if parent and parent:isValid() and parent:get("dead") == 0 then
	
		if selfData.state == "idle" then
			local yy = selfData.yloc - self.y
			self.y = math.approach(self.y, selfData.yloc, yy * 0.1)
			if math.round(self.y) == math.round(selfData.yloc) then
				selfData.state = "attack"
			end
		end
		
		self.angle = (global.timer % 30) * -12 * selfData.direction.spin
		
		if selfData.state == "attack" then
			if not selfData.laser then
				selfData.laser = selfData.direction.laserStart
			end
			local r = 180
			local boom = false
			local direction = math.rad(selfData.laser)
			while r > 0 do
				selfData.xLaser = self.x + math.cos(direction) * r
				selfData.yLaser = self.y + math.sin(direction) * r
				local tile = obj.B:findLine(self.x, self.y, selfData.xLaser, selfData.yLaser) or obj.BNoSpawn:findLine(self.x, self.y, selfData.xLaser, selfData.yLaser)
				if tile then
					r = r - 1
					boom = true
				else
					break
				end
			end
			
			while r > 0 do
				local actor = pobj.actors:findLine(self.x, self.y, selfData.xLaser, selfData.yLaser)
				selfData.xLaser = self.x + math.cos(direction) * r
				selfData.yLaser = self.y + math.sin(direction) * r
				if actor and actor:isValid() and actor:get("team") ~= parent:get("team") then
					r = r - 1
					boom = true
				else
					break
				end
			end
			
			if boom then 
				sfx.GiantJellyExplosion:play(1.7, 0.2)
				misc.fireExplosion(selfData.xLaser, selfData.yLaser, 16/19, 16/4, parent:get("damage") * ((r + 90) / 270), parent:get("team"), spr.EfExplosive, nil)
			end
			
			if selfData.laser ~= selfData.direction.laserEnd then
				selfData.laser = math.approach(selfData.laser, selfData.direction.laserEnd, 4)
			else
				selfData.laser = nil
				if selfData.scepter > 0 then
					selfData.direction.spin = selfData.direction.spin * -1
					selfData.direction.laserStart = 90 + selfData.direction.spin * -90
					selfData.direction.laserEnd = 90 + selfData.direction.spin * 90
					selfData.laser = nil
					selfData.scepter = selfData.scepter - 1
				else
					selfData.state = "pulse"
				end
			end
		end
		
		if selfData.state == "pulse" then
			if not selfData.pulse then
				selfData.pulse = 60
			end
			if math.round(selfData.pulse) > 0 then
				selfData.pulse = math.approach(selfData.pulse, 0, selfData.pulse * 0.05)
			else
				selfData.pulse = nil
				selfData.state = "retract"
			end
		end
		
		if selfData.state == "retract" then 
			local xx = self.x - parent.x
			local yy = self.y - parent.y
			self.x = math.approach(self.x, parent.x, xx * 0.05 + math.sign(xx) * 2)
			self.y = math.approach(self.y, parent.y, yy * 0.05 + math.sign(yy) * 2)
			local r = 10
			if self.x > parent.x - r and self.x < parent.x + r and self.y > parent.y - r and self.y < parent.y + r then
				self:destroy()
			end
		end
	end
end)

obj.laserdrone:addCallback("draw", function(self)
	local selfData = self:getData()
	
	if selfData.state == "pulse" then
		local tele = nearestMatchingOp(self, obj.Teleporter, "isBig", "~=", 1)
		graphics.color(Color.fromHex(0x43DBB0))
		graphics.alpha(selfData.pulse / 100 + 0.2)
		graphics.circle(self.x, self.y, 60 - selfData.pulse, true)
		
			local r = (60 - selfData.pulse) * 0.75
			local direction = math.random(0, 360)
			if tele then
				direction = posToAngle(self.x, self.y, tele.x, tele.y, false)
			end
			local circlex = self.x + math.cos(math.rad(direction)) * r 
			local circley = self.y - math.sin(math.rad(direction)) * r
			--local circlex, circley = pointInLine(self.x, self.y, tele.x, tele.y, r)
			--graphics.line(self.x, self.y, circlex, circley)
			
			local dir1 = math.rad(direction + 10)
			local xx1 = self.x + math.cos(dir1) * r * 0.8
			local yy1 = self.y - math.sin(dir1) * r * 0.8
			
			local dir2 = math.rad(direction - 10)
			local xx2 = self.x + math.cos(dir2) * r * 0.8
			local yy2 = self.y - math.sin(dir2) * r * 0.8
			
			graphics.triangle(circlex, circley, xx1, yy1, xx2, yy2, false)
	end
	
	if selfData.state == "attack" then
		if selfData.xLaser and selfData.yLaser then
			graphics.color(Color.fromHex(0x43DBB0))
			graphics.alpha(0.8)
			graphics.line(self.x, self.y, selfData.xLaser, selfData.yLaser, 5)
		end
	end
end)
-- LASER DRONE END 

-- ALL OTHER STUFF
scout:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getData().shootAnim, 0.25, true, true)
		elseif skill == 2 then
			-- X skill
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
			laser:getData().direction.spin = player.xscale
			laser:getData().direction.laserStart = 90 + player.xscale * -90
			laser:getData().direction.laserEnd = 90 + player.xscale * 90
			laser:getData().scepter = playerAc.scepter
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
			--sfx.CowboyShoot1:play(1.7, 0.6)
			sfx.ChildDeath:play(2.4 + math.random(-2, 3) * 0.1, 0.4)
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
					else
						angle = angle + math.random(-5, 5) * 0.5
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
						drone:getData().heat = drone:getData().heat + 15
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
			local hovernum = 0
			if playerData.hovering then
				hovernum = 0.4
			end
			playerAc.pHspeed = math.sqrt(playerAc.pHmax + hovernum) * player.xscale * 0.5
			playerData.xAccel = player.xscale * -3 * math.sqrt(playerAc.pHmax + hovernum)
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

scout:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
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
