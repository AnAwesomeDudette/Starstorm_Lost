
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
	jumpHoverJet = Sprite.load("Scout_JumpHoverJet", path.."jumpHoverJet", 3, 6, 9),
	climb = Sprite.load("Scout_Climb", path.."climb", 2, 4, 7),
	death = Sprite.load("Scout_Death", path.."death", 11, 9, 9),
	decoy = Sprite.load("Scout_Decoy", path.."decoy", 1, 9, 10),

	shoot1_1 = Sprite.load("Scout_Shoot1_1", path.."shoot1_1", 8, 8, 13),
	shoot1_2 = Sprite.load("Scout_Shoot1_2", path.."shoot1_2", 8, 15, 7),
	shoot2 = Sprite.load("Scout_Shoot2", path.."shoot2", 4, 10, 7),
	shoot3 = Sprite.load("Scout_Shoot3", path.."shoot3", 6, 6, 15)
}
-- Hit sprites
local sprSparks3 = Sprite.load("Scout_Sparks3", path.."sparks3", 5, 36, 30)
local sprExp = Sprite.load("Scout_LaserExplosion", path.."laserExplosion", 9, 8, 8)

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
	playerData.droneMagnet = 0
	playerData.freeze = 0
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 12, 0.055)
	else
		player:survivorSetInitialStats(90, 12, 0.025)
	end
	
    player:setSkill(1, "Chain Blast", "Fire in quick succession for 6x50%. Aim down when hovering.",
    sprSkills, 1, 45)
        
    player:setSkill(2, "Recursive Bomb", "Drop a bomb which bounces 4 times dealing damage. Blasts you upwards when not hovering.",
    sprSkills, 2, 3 * 60)

    player:setSkill(3, "Backdash", "Instantly accelerate backwards, blasting away from enemies. Acceleration scales with movement speed.",
    sprSkills, 3, 2 * 60)

    player:setSkill(4, "NULL Radar", "Release a Laser Drone that surveys the area, dealing 33-100% damage per hit and locating the teleporter.",
    sprSkills, 4, 8 * 60)
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
	sprSkills, 5, 8 * 60)
end)


-- Skills

-- BULLET
local objBullet = Object.new("ScoutBullet")
local bulMask = Sprite.load("Scout_BulletMask", path.."bulletMask", 1, 0, 0)
objBullet.sprite = bulMask
local bulParticle = ParticleType.find("Heal", "Vanilla")
objBullet:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfData.parent = nil
	selfData.life = 20
	selfData.speed = 10
	selfData.angle = 0
	selfData.ignoreGround = false
	selfData.playerFired = false
	self.mask = bulMask
	self.alpha = 0
end)
objBullet:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	local newx = self.x + math.cos(math.rad(selfData.angle)) * selfData.speed
	local newy = self.y - math.sin(math.rad(selfData.angle)) * selfData.speed
	local tile = obj.B:findLine(self.x, self.y, newx, newy) or obj.BNoSpawn:findLine(self.x, self.y, newx, newy)
	if tile and not selfData.ignoreGround then
		while tile and selfData.speed > 0 do
			selfData.speed = selfData.speed - 1
			newx = self.x + math.cos(math.rad(selfData.angle)) * selfData.speed
			newy = self.y - math.sin(math.rad(selfData.angle)) * selfData.speed
			tile = obj.B:findLine(self.x, self.y, newx, newy) or obj.BNoSpawn:findLine(self.x, self.y, newx, newy)
		end
		bulParticle:burst("middle", newx, newy, 5, Color.fromHex(0x43DBB0))
		self:destroy()
	end
	
	if self:isValid() then
	local actors = pobj.actors:findAllLine(self.x, self.y, newx, newy)
	for _, actor in ipairs(actors) do
		if self:isValid() and actor:get("team") ~= selfData.parent:get("team") then
			actorObj = true
			while actorObj and selfData.speed > 0 do
				selfData.speed = selfData.speed - 1
				newx = self.x + math.cos(math.rad(selfData.angle)) * selfData.speed
				newy = self.y - math.sin(math.rad(selfData.angle)) * selfData.speed
				actorObj = actor:getObject():findLine(self.x, self.y, newx, newy)
			end
			bulParticle:burst("middle", newx, newy, 5, Color.fromHex(0x43DBB0))
			local bullet
			if selfData.playerFired then
				bullet = selfData.parent:fireBullet(self.x, self.y, 0, 1, 0.5)
				--[[for _, drone in ipairs(selfData.parent:getData().scoutDrones) do
					if drone and drone:isValid() then
						drone:getData().target = actor
					end	
				end]]
			else
				bullet = selfData.parent:fireBullet(self.x, self.y, 0, 1, 0.5, nil, DAMAGER_NO_PROC)
			end
			bullet:set("specific_target", actor.id)
			self:destroy()
		end
	end
	
		if self:isValid() then
			if selfData.life > 0 then
				selfData.life = selfData.life - 1
				self.x = newx
				self.y = newy
			else
				bulParticle:burst("middle", self.x, self.y, 5, Color.fromHex(0x43DBB0))
				self:destroy()
			end
		end
	end
end)
objBullet:addCallback("draw", function(self)
	local selfData = self:getData()
	
	graphics.color(Color.fromHex(0x43DBB0))
	local dis = 12
	local xx = self.x - math.cos(math.rad(selfData.angle)) * dis
	local yy = self.y + math.sin(math.rad(selfData.angle)) * dis
	local length = distance(self.x, self.y, xx, yy)
	local count = 0
	while count <= length do
		graphics.alpha(math.sqrt((length - count) / length))
		local posx, posy = pointInLine(self.x, self.y, xx, yy, count)
		graphics.pixel(posx, posy)
		count = count + 1
	end
end)

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

-- PING OBJECT
local objPing = Object.new("ScoutPing")
objPing.sprite = bulMask
objPing:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.alpha = 0
	selfData.angle = math.random(0, 360)
	selfData.speed = 1.5
	selfData.life = 180
end)
objPing:addCallback("step", function(self)
	local selfData = self:getData()
	
	self.x = self.x + math.cos(math.rad(selfData.angle)) * selfData.speed 
	self.y = self.y - math.sin(math.rad(selfData.angle)) * selfData.speed
	
	selfData.speed = math.approach(selfData.speed, 0, selfData.speed * 0.025)
	
	selfData.life = selfData.life - 1
	if selfData.life == 0 then
		self:destroy()
	end
end)
objPing:addCallback("draw", function(self)
	local selfData = self:getData()
	
	graphics.color(Color.fromHex(0x43DBB0))
	graphics.alpha(0.1)
	graphics.setBlendMode("additive")
	for i = math.ceil((180 - selfData.life) / 20), 9 do 
		graphics.circle(self.x, self.y, i, false)
	end
	
	graphics.alpha(selfData.life / 210)
	local tele = nearestMatchingOp(self, obj.Teleporter, "isBig", "~=", 1)
	if tele then
		local r = 30
		local direction = posToAngle(self.x, self.y, tele.x, tele.y, false)
		
		local x1 = self.x + math.cos(math.rad(direction)) * r
		local y1 = self.y - math.sin(math.rad(direction)) * r 
		
		local x2 = self.x + math.cos(math.rad(direction - 10)) * r * 0.8 
		local y2 = self.y - math.sin(math.rad(direction - 10)) * r * 0.8
		
		local x3 = self.x + math.cos(math.rad(direction + 10)) * r * 0.8 
		local y3 = self.y - math.sin(math.rad(direction + 10)) * r * 0.8
		
		graphics.triangle(x1, y1, x2, y2, x3, y3, false)
	end
end)

-- PING CIRCLE (WHICH ALSO TURNS OUT TO BE AN OBJECT)
local objPingCircle = Object.new("ScoutPingCircle")
objPingCircle.sprite = bulMask
objPingCircle:addCallback("create", function(self)
	self.alpha = 0
	self:getData().life = 60
	self:getData().radius = 0
end)
objPingCircle:addCallback("step", function(self)
	self:getData().life = self:getData().life - 1
	if self:getData().life == 0 then 
		self:destroy()
	end
end)
objPingCircle:addCallback("draw", function(self)
	graphics.color(Color.fromHex(0x43DBB0))
	graphics.alpha((self:getData().life) / 120)
	self:getData().radius = math.approach(self:getData().radius, 120, (120 - self:getData().radius) * 0.05)
	
	graphics.circle(self.x, self.y, self:getData().radius, true)
end)

-- DRONES CONTROLLER
local function RandomStuff()
	local mult = 1
	for i = 1, 3 do
		if math.chance(40) then
			mult = mult * -1
		end
	end
	return mult
end
local function NoZeroesPlease(num)
	if num == 0 then
		if math.chance(50) then
			return 1
		else
			return -1
		end
	else
		return num
	end
end
local ctrl = Object.new("ScoutDroneController")
ctrl.sprite = bulMask
ctrl:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.parent = nil
	selfData.setup = false
	selfData.peons = {}
	selfData.target = nil
	selfData.state = "passive" -- "passive" "laser"
	selfData.heat = 0
	self.alpha = 0
	selfData.newx = nil
	selfData.newy = nil
	selfData.speed = 0
	selfData.currentFire = 1
	selfData.laserCount = 0
	selfData.laserCountPrevious = 0
	selfData.direction = 0
	selfData.newdirection = 0
	selfData.turnSpeed = 0.05
	selfData.lockOn = false
	selfData.droneTimer = 0
end)
ctrl:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	
	if parent and not selfData.setup then
		selfData.setup = true
		selfData.peons = parent:getData().scoutDrones
	end
	
	local parentSpeed = math.sqrt((parent:getAccessor().pHmax + parent:getAccessor().pVmax) / 2)
	if not selfData.laserCharge then
		selfData.speed = math.approach(selfData.speed, parentSpeed, 0.1 * (parentSpeed - selfData.speed))
		if selfData.dirSwapped then
			selfData.dirSwapped = false
		end
	else
		if not selfData.dirSwapped then 
			selfData.dirSwapped = true
			for i = 1, 3 do
				selfData.peons[i]:getData().spinDir = selfData.peons[i]:getData().spinDir * -1
			end	
			selfData.laserAngleStart = posToAngle(self.x, self.y, parent.x, parent.y) + 60 * selfData.peons[1]:getData().spinDir
			selfData.laserAngleEnd = selfData.laserAngleStart - 120 * selfData.peons[1]:getData().spinDir
			selfData.laserDir = math.sign(selfData.laserAngleStart - selfData.laserAngleEnd)
			selfData.laserAngle = selfData.laserAngleStart
		end
		selfData.speed = math.approach(selfData.speed, 0, 0.2 * selfData.speed)
	end
	selfData.direction = selfData.direction - angleDif(selfData.direction, selfData.newdirection) * selfData.turnSpeed
	selfData.turnSpeed = selfData.turnSpeed + 0.005
	
	if selfData.state == "passive" and parent:getData().droneMagnet == 0 and parent:getData().freeze == 0 then
		if not selfData.target then
			local targets = {}
			local r = 120
			for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
				if actor and actor:isValid() and actor:get("team") ~= parent:get("team") then
					table.insert(targets, actor)
				end
			end
			
			if #targets > 0 then
				selfData.target = targets[math.random(1, #targets)]
				selfData.newx = nil
				selfData.newy = nil
			end
		elseif not selfData.target:isValid() then
			selfData.target = nil
			selfData.newx = nil
			selfData.newy = nil
		else
			if global.timer % 12 == 0 then
				selfData.peons[selfData.currentFire]:getData().target = selfData.target
				selfData.currentFire = selfData.currentFire % 3 + 1
			end
			if global.timer % 120 == 0 then
				selfData.target = nil
			end
		end
		
		if not selfData.newx and not selfData.newy then
			if selfData.target then
				selfData.newx = math.clamp(self.x + math.random(selfData.target.sprite.width * 2 + 20, selfData.target.sprite.width * 2 + 40) * NoZeroesPlease(math.sign(selfData.target.x - self.x)) * RandomStuff(), selfData.target.x - 80, selfData.target.x + 80)
				selfData.newy = math.clamp(self.y + math.random(selfData.target.sprite.height * 2 + 20, selfData.target.sprite.height * 2 + 40) * NoZeroesPlease(math.sign(selfData.target.y - self.y)) * RandomStuff(), selfData.target.y - 80, selfData.target.y + 80)
			else
				selfData.newx = math.clamp(self.x + math.random(10, 40) * NoZeroesPlease(math.sign(parent.x - self.x)) * RandomStuff(), parent.x - 60, parent.x + 60)
				selfData.newy = math.clamp(self.y + math.random(10, 40) * NoZeroesPlease(math.sign(parent.y - self.y)) * RandomStuff(), parent.y - 60, parent.y + 60)
			end
			--selfData.speed = math.sqrt(distance(self.x, self.y, selfData.newx, selfData.newy)) / 3
			selfData.newdirection = posToAngle(self.x, self.y, selfData.newx, selfData.newy)
			selfData.turnSpeed = 0.01
			selfData.droneTimer = 0
		else
			selfData.droneTimer = selfData.droneTimer + 1
			self.x = self.x + math.cos(math.rad(selfData.direction)) * selfData.speed
			self.y = self.y - math.sin(math.rad(selfData.direction)) * selfData.speed
			if selfData.laserCharge and math.floor(selfData.speed * 2) == 0 then 
				selfData.state = "laser"
				selfData.laserChargeTimer = 30
				for i = 1, 3 do
					selfData.peons[i]:getData().target = nil
				end
				selfData.newx = nil
				selfData.newy = nil
			elseif math.floor(selfData.direction / 20) == math.floor(selfData.newdirection / 20) or selfData.droneTimer > 20 then
				selfData.newx = nil
				selfData.newy = nil
			end
		end
	end
	
	if parent:getData().droneMagnet > 0 then
		self.x = math.approach(self.x, parent.x, (parent.x - self.x) * 0.05)
		self.y = math.approach(self.y, parent.y, (parent.y - self.y) * 0.05)
	end
	
	if selfData.state == "laser" then 
		if selfData.laserChargeTimer > 0 then 
			selfData.laserChargeTimer = selfData.laserChargeTimer - 1
		end
		if selfData.laserChargeTimer == 0 then
			local r = 180
			local direction = math.rad(selfData.laserAngle)
			selfData.xLaser = self.x + math.cos(direction) * r
			selfData.yLaser = self.y - math.sin(direction) * r
			local boom = false
			while r > 0 do
				selfData.xLaser = self.x + math.cos(direction) * r
				selfData.yLaser = self.y - math.sin(direction) * r
				local tile = obj.B:findLine(self.x, self.y, selfData.xLaser, selfData.yLaser) or obj.BNoSpawn:findLine(self.x, self.y, selfData.xLaser, selfData.yLaser)
				if tile then
					r = r - 1
					boom = true
				else
					break
				end
			end
			
			while r > 0 do
				local actors = pobj.actors:findAllLine(self.x, self.y, selfData.xLaser, selfData.yLaser)
				selfData.xLaser = self.x + math.cos(direction) * r
				selfData.yLaser = self.y - math.sin(direction) * r
				local enemy
				if actors then 
					for _, actor in ipairs(actors) do
						if actor and actor:isValid() and actor:get("team") ~= parent:get("team") then
							r = r - 1
							boom = true
							enemy = true
							break
						end
					end
				else
					break
				end
				if not enemy then
					break
				end
			end
			
			if boom then 
				sfx.GiantJellyExplosion:play(1.7, 0.2)
				misc.fireExplosion(selfData.xLaser, selfData.yLaser, 16/19, 16/4, parent:get("damage") * ((r + 90) / 270), parent:get("team"), sprExp, nil)
			end	
			
			if selfData.laserAngle == selfData.laserAngleEnd then 
				selfData.state = "passive"
				selfData.laserCharge = false
				selfData.laserChargeTimer = nil
				objPing:create(self.x, self.y)
				objPingCircle:create(self.x, self.y)
			end
			
			selfData.laserAngle = selfData.laserAngle - 3 * selfData.laserDir
		end
	end
end)
ctrl:addCallback("draw", function(self)
	local selfData = self:getData()
	
	graphics.color(Color.fromHex(0x43DBB0))
	graphics.alpha(0.8)
	--graphics.line(self.x, self.y, self.x + math.cos(math.rad(selfData.newdirection)) * 20, self.y - math.sin(math.rad(selfData.newdirection)) * 20)
	--graphics.color(Color.BLUE)
	--graphics.line(self.x, self.y, self.x + math.cos(math.rad(selfData.direction)) * 20, self.y - math.sin(math.rad(selfData.direction)) * 20)
	--graphics.print(selfData.heat, self.x, self.y, graphics.FONT_SMALL, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
	
	if selfData.laserCharge then
		if selfData.laserChargeTimer then
			graphics.alpha(0.1)
			graphics.setBlendMode("additive")
			for i = 1, 9 - selfData.laserChargeTimer / 10 * 3 do 
				graphics.circle(self.x, self.y, i, false)
			end
			graphics.alpha(0.15)
			if selfData.state == "laser" and selfData.laserChargeTimer == 0 then
				local pogAngle = selfData.laserAngle + 3 * selfData.laserDir
				local pogDistance = distance(self.x, self.y, selfData.xLaser, selfData.yLaser)
				for i = 1, 5 do
					local pogX = self.x + math.cos(math.rad(pogAngle)) * (pogDistance - (i - 1) * 2)
					local pogY = self.y - math.sin(math.rad(pogAngle)) * (pogDistance - (i - 1) * 2)
					graphics.line(self.x, self.y, pogX, pogY, i)
				end
			end
		end
	end
	
end)

-- SCOUT DRONES (USED)
local droneRadius = 15
local droneIdle = Sprite.load("ScoutDroneIdle", path.."droneIdle", 4, 5, 5)
local objDrone = Object.new("ScoutDrone")
objDrone.sprite = droneIdle
objDrone:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.parent = nil
	selfData.laserAttack = 0
	selfData.target = nil
	selfData.angle = 0
	self.spriteSpeed = 0.2
	selfData.radius = 0
	selfData.radiusApproach = droneRadius
	selfData.spinDir = 1
	selfData.spinSpeed = 5
	selfData.speed = 0
	selfData.direction = 0
	selfData.newdirection = 0
	selfData.turnSpeed = 0.05
end)
objDrone:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	local control = selfData.control
	
	selfData.radius = math.approach(selfData.radius, selfData.radiusApproach, 0.1 * (selfData.radius - selfData.radiusApproach))
	self.x = control.x + math.cos(math.rad(selfData.angle)) * selfData.radius
	self.y = control.y - math.sin(math.rad(selfData.angle)) * selfData.radius
	
	if control:getData().state == "laser" then 
		selfData.spinSpeed = math.approach(selfData.spinSpeed, 15, 0.05 * (15 - selfData.spinSpeed))
	else
		selfData.spinSpeed = math.approach(selfData.spinSpeed, 5, 0.05 * (selfData.spinSpeed - 5))
	end
	
	if selfData.target and selfData.target:isValid() then
		sfx.ChildDeath:play(2.4 + math.random(-2, 3) * 0.1, 0.4)
		local angleStuff = control:getData().heat / 40
		local angle = posToAngle(self.x, self.y, selfData.target.x, selfData.target.y, false) + math.random(-25 - angleStuff, 25 + angleStuff) * 0.5
		local xx = self.x + math.cos(math.rad(angle)) * 6
		local yy = self.y - math.sin(math.rad(angle)) * 6
		local bullet = objBullet:create(xx, yy)
		bullet:getData().parent = parent
		bullet:getData().angle = angle
		bullet:getData().ignoreGround = true
		selfData.target = nil
	end
	
	selfData.angle = (selfData.angle + selfData.spinSpeed * selfData.spinDir) % 360
end)

-- ALL OTHER STUFF
scout:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		local cd = true
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
		elseif skill == 4 and not playerData.controller:getData().laserCharge then
			playerData.droneMagnet = 2
			cd = false
		end
		
		if cd then
			player:activateSkillCooldown(skill)
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
					else
						angle = angle + math.random(-5, 5) * 0.5
						add = -3
					end
					local xx = player.x + math.cos(math.rad(angle)) * 6
					local yy = player.y - math.sin(math.rad(angle)) * 6
					local bullet = objBullet:create(xx, yy + add)
					bullet:getData().parent = player
					bullet:getData().angle = angle
					bullet:getData().playerFired = true
				end
				--[[for _, droneId in ipairs(player:getData().scoutDrones) do
					local drone = Object.findInstance(droneId)
					
				end]]
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
				hovernum = 0.4
			if playerData.hovering then
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
	
	if playerData.freeze > 0 then
		playerData.freeze = playerData.freeze - 1
		if playerData.freeze == 0 then
			playerData.controller:getData().laserCharge = true
		end
	end
	
	if playerData.droneMagnet and playerData.droneMagnet > 0 then 
		playerData.droneMagnet = playerData.droneMagnet - 1
		if playerData.droneMagnet == 0 then
			playerData.freeze = 15
			player:activateSkillCooldown(4)
		end
	end
end)

callback.register("onStageEntry", function()
	scoutPlayers = {}
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == scout then
			
			--[[player:getData().scoutDrones = {}
			local smg = obj.smgdrone:create(player.x, player.y)
			smg:getData().parentId = player.id
			table.insert(player:getData().scoutDrones, smg.id)
			smg = obj.smgdrone:create(player.x, player.y)
			smg:getData().parentId = player.id
			smg:getData().location = -1
			table.insert(player:getData().scoutDrones, smg.id)]]
			
			player:getData().scoutDrones = {}
			local control = ctrl:create(player.x, player.y)
			player:getData().controller = control
			control:getData().parent = player
			for i = 0, 2 do 
				local drone = objDrone:create(player.x, player.y)
				drone:getData().angle = i * 120
				drone:getData().parent = player
				drone:getData().control = control
				table.insert(player:getData().scoutDrones, drone)		
			end
			table.insert(scoutPlayers, player)
		end
	end
end)

callback.register("onPlayerDrawBelow", function(player)
	local playerData = player:getData()
	if playerData.hovering and player:get("activity") ~= 1 and player:get("activity") ~= 3 and player:get("activity") ~= 30 then
		graphics.drawImage{
			image = player:getAnimation("jumpHoverJet"),
			x = player.x,
			y = player.y,
			xscale = player.xscale,
			yscale = player.yscale,
			subimage = math.ceil((global.timer % 12 + 1) / 4)
		}
	end
end)

callback.register("onActorStep", function(actor)
	if actor and actor:isValid() then
		if actor:getData().laserCd and actor:getData().laserCd > 0 then
			actor:getData().laserCd = actor:getData().laserCd - 1
		end
		--[[if actor:getData().laserMince and actor:getData().laserMince > 0 then
			actor:getData()laserMince = actor:getData().laserMince - 1
			if actor:getData().laserMince == 0 then
				actor:getData().laserHits = 0
			end
		end]]
	end
end)

sur.Scout = scout
