local path = "Survivors/Duke/"

local Duke = Survivor.new("Duke")

-- Sounds
--local sDukeShoot1 = Sound.load("DukeShoot1", path.."skill1")

local sprite = Sprite.load("Duke_Idle_1", path.."idle_1", 1, 5, 11)

-- Table sprites
local sprites = {
	idle = sprite,
	idle_1 = sprite,
	idle_2 = Sprite.load("Duke_Idle_2", path.."idle_2", 1, 5, 11),
	walk = Sprite.load("Duke_Walk", path.."walk", 8, 6, 11),
	jump = Sprite.load("Duke_Jump", path.."jump", 1, 5, 11),
	climb = Sprite.load("Duke_Climb", path.."climb", 2, 4, 8),
	death = Sprite.load("Duke_Death", path.."death", 10, 5, 11),
	decoy = sprite,
	
	shoot1_1 = Sprite.load("Duke_Shoot1_1", path.."shoot1_1", 3, 5, 11),
	shoot1_2 = Sprite.load("Duke_Shoot1_2", path.."shoot1_2", 4, 5, 11),
	shoot2 = Sprite.load("Duke_Shoot2", path.."shoot2", 5, 5, 16),
	shoot3 = Sprite.load("Duke_Shoot3", path.."shoot3", 5, 31, 11)
}

-- Skill sprites
local sprSkills = Sprite.load("Duke_Skills", path.."skills", 5, 0, 0)

-- Selection sprite
Duke.loadoutSprite = Sprite.load("Duke_Select", path.."select", 14, 2, 0)

-- Selection description
Duke:setLoadoutInfo(
[[Prestigious lineage and deep pockets gives the &or&Duke&!& everything he needs to conquer.
Wielding his cherished &or&Royal Revolver&!&, this noble relies on expensive gadgets to maximize impact,
with the intent of winning the most ground in the shortest amount of time.
&g&Style,&!& &b&flair,&!& and &r&proper execution&!& are essential for victory, &or&no exceptions.&!&]], sprSkills)

-- Skill descriptions

Duke:setLoadoutSkill(1, "Royal Revolver",
[[Fire for &y&150% damage.&!&
Every &or&fourth shot&!& deals &r&600% damage.&!&]])

Duke:setLoadoutSkill(2, "Kinetic Replicator",
[[Deploy a gadget which forms a &b&kinetic field&!& around it.
Enemies caught in the kinetic field &y&share damage between eachother.&!&]])

Duke:setLoadoutSkill(3, "Ambush",
[[Slide forward on your knees, &b&passing enemies extends distance&!&.
Loads the &or&Royal Revolver's fourth bullet&!&, &b&piercing empowered by enemies you passed.&!&]])

Duke:setLoadoutSkill(4, "Watcher's Watch",
[[Toggle to &b&slow down all enemies&!& in an area around you.
&y&Affects both walking speed and attack speed.&!&
Can be stored up to &lt&12 seconds.&!& Fully recharges after &lt&36 seconds.&!&]])

-- Color of highlights during selection
Duke.loadoutColor = Color.fromHex(0xB1454D)

-- Misc. menus sprite
Duke.idleSprite = sprites.idle

-- Main menu sprite
Duke.titleSprite = sprites.walk

-- Endquote
Duke.endingQuote = "..and so he left, plotting a new conquest."

callback.register("postLoad", function()
	SurvivorVariant.setInfoStats(SurvivorVariant.getSurvivorDefault(Duke), {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 5}, {"Agility", 5}, {"Difficulty", 5}, {"Flamboyance", 5}})
	SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(Duke), "Nobody knows why this Mecurian's aboard the UES Contact Light, and few are upper-class enough to ask.")
end)

Duke:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerData._tList = {}
	playerData.dukePierce = 0
	playerData.bulletTime = 720
	playerAc.bulletCount = 0
	playerData.bulletTimeTimer = 0
	playerData.rechargeBullet = 3
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 13, 0.038)
	else
		player:survivorSetInitialStats(100, 13, 0.008)
	end
	
	player:setSkill(1, "Royal Revolver", "Fire for 150% damage. 4th bullet deals 600% damage.",
	sprSkills, 1, 40)
		
	player:setSkill(2, "Kinetic Replicator", "Deploy a gadget with an area around it, in which enemies share damage recieved.",
	sprSkills, 2, 9 * 60)
		
	player:setSkill(3, "Ambush", "Slide on your knees past your enemies. Loads 4th bullet, empowers piercing depending on enemies you passed.",
	sprSkills, 3, 7 * 60)
		
	player:setSkill(4, "Watcher's Watch", "Toggle to slow down enemies around you.",
	sprSkills, 4, 15)
end)


-- Called when the player levels up
Duke:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(25, 4, 0.0012, 2)
end)

-- Called when the player picks up the Ancient Scepter
Duke:addCallback("scepter", function(player)	
	player:setSkill(4,
		"",
		"",
		sprSkills, 9,
		15
	)
	
	player:getData().rechargeBullet = 2
end)

-- Skills
Duke:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if player:get("activity") == 0 then
		local cd = true
		
		if skill == 1 then
			-- Z skill
			if playerAc.bulletCount == 3 then
				player:survivorActivityState(1, player:getAnimation("shoot1_2"), 0.2, true, true)
			else
				player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.2, true, true)
			end
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.2, false, false)
		elseif skill == 4 then
			-- V skill
			sfx.Crowbar:play(0.5)
			playerData.dukeTime = not playerData.dukeTime
			playerData.bulletTimeTimer = 0
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
	end
end)

local buffSlowdown = Buff.new("slowdown")
buffSlowdown.sprite = Sprite.load("SlowdownBuff", path.."buff", 1, 9, 9)

local slowdownMult = 0.8

buffSlowdown:addCallback("start", function(actor)
	local val1, val2 = actor:get("pHmax") * slowdownMult, actor:get("attack_speed") * slowdownMult
	actor:set("pHmax", actor:get("pHmax") - val1):set("attack_speed", actor:get("attack_speed") - val2)
	actor:getData().slowdownBuff = {val1, val2}
end)
buffSlowdown:addCallback("end", function(actor)
	if actor:getData().slowdownBuff then
		local val1, val2 = actor:getData().slowdownBuff[1], actor:getData().slowdownBuff[2]
		actor:set("pHmax", actor:get("pHmax") + val1):set("attack_speed", actor:get("attack_speed") + val2)
		actor:getData().slowdownBuff = nil
	end
end)

callback.register("onDamage", function(target, damage, source)
	if source and source:isValid() and isa(source, "DamagerInstance") then
		local parent = source:getParent()
		if parent and parent:isValid() and isa(parent, "PlayerInstance") then
			if target:getData().sharedPain and target:getData().sharedPain > 0 then 
				local dukeId = target:getData().painId
				local outline = obj.EfOutline:create(0, 0):set("parent", target.id):set("rate", 0.04)
				outline.blendColor = Color.RED
				target:getData().fieldDamageDealt = true
				for _,actor in ipairs(pobj.actors:findAll()) do
					if actor:getData().sharedPain and actor:getData().sharedPain > 0 and actor:getData().painId == dukeId and actor ~= target then
						actor:set("hp", actor:get("hp") - damage)
						local crit = false or source:get("critical") > 0
						
						if global.showDamage then
							misc.damage(source:get("damage_fake"), actor.x, actor.y - 10 , crit, Color.RED)
						end
						
						outline = obj.EfOutline:create(0, 0):set("parent", actor.id):set("rate", 0.04)
						outline.blendColor = Color.RED
					end
				end
			end	
		end
	end
end)

callback.register("postSelection", function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == Duke then
			player:setAnimation("idle", player:getAnimation("idle_1"))
		end
	end
end)

local objPainField = Object.new("PainField")
objPainField.sprite = Sprite.load("PainGadget", path.."gadget", 1, 5, 4)
sprPainFieldMask = Sprite.load("PainFieldMask", path.."GadgetMask", 1, 3, 2)
objPainField:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	self.mask = sprPainFieldMask
	
	selfData.team = "player"
	selfData.speed = 6
	selfData.life = 0
	selfData.radius = 0
	selfData.damageFlash = 0
end)
objPainField:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if selfData.damageFlash > 0 then
		selfData.damageFlash = selfData.damageFlash - 1
	end
	
	if self:collidesMap(self.x, self.y) then
		self.xscale = self.xscale * -1
	end
	
	self.x = self.x + self.xscale * selfData.speed
	
	if selfData.life % 7 == 0 then
		selfData.speed = math.max(selfData.speed - 1, 0)
	end
	
	if selfData.speed == 0 then
		selfData.radius = math.approach(selfData.radius, 75, (75 - selfData.radius) * 0.1)
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x + selfData.radius, self.y + selfData.radius, self.x - selfData.radius, self.y - selfData.radius)) do
			if actor:get("team") ~= selfData.team then
				actor:getData().sharedPain = 5
				actor:getData().painId = self.id
				if actor:getData().fieldDamageDealt then
					actor:getData().fieldDamageDealt = false
					selfData.damageFlash = 15
				end
			end
		end
	end
	
	if selfData.speed > 0 then
		selfData.life = selfData.life + 1
	end
end)

callback.register("onActorStep", function(actor)
	if actor:getData().sharedPain and actor:getData().sharedPain > 0 then
		actor:getData().sharedPain = actor:getData().sharedPain - 1
	end
end)

Duke:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 1 then
		-- Mortar
		if relevantFrame == 1 and not player:getData().skin_skill1Override then
			playerAc.bulletCount = playerAc.bulletCount + 1
			local r = 500
			if playerAc.bulletCount == 4 then
				sfx.CowboyShoot4_2:play(1.5)
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 500, 6, nil, DAMAGER_BULLET_PIERCE)
					bullet:set("damage_degrade", 1 / (playerData.dukePierce + 1))
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				playerAc.bulletCount = 0
				playerData.dukePierce = 0
			else
				sfx.Bullet2:play(1.3)
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 300, 1.5, nil)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		player:setAnimation("idle", player:getAnimation("idle_2"))
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Overcharge
		if relevantFrame == 2 then
			sfx.JanitorShoot2_1:play(1.3)
			for _,field in ipairs(objPainField:findAll()) do
				if field:isValid() and field:getData().parent == player then
					field:destroy()
				end
			end
			local painField = objPainField:create(player.x, player.y - 4)
			painField.xscale = player.xscale
			painField.yscale = player.yscale
			painField:getData().team = playerAc.team
			painField:getData().parent = player
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- Launch
		
		if relevantFrame == 1 then
			sfx.ClayShoot1:play(1.3)
			player:set("pHspeed", playerAc.pHmax * 2.5 * player.xscale)
			playerAc.bulletCount = 3
			playerData.dukeSlideTimer = 15
			playerData.kneed = {}
		end
		
		if player.subimage < 4 and playerData.dukeSlideTimer > 0 then
			local r = 10
			for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do 
				if actor:get("team") ~= player:get("team") and not playerData.kneed[actor] then 
					playerData.dukeSlideTimer = playerData.dukeSlideTimer + 5
					playerData.dukePierce = playerData.dukePierce + 1
					playerData.kneed[actor] = true
				end
			end
		end
		
		if playerAc.invincible < 15 then
			playerAc.invincible = 15
		end		
	
		if playerData.dukeSlideTimer > 0 then 
			playerData.dukeSlideTimer = playerData.dukeSlideTimer - 1
		end
		
		if player.subimage >= 4 and playerData.dukeSlideTimer > 0 then
			player.subimage = 2
		end
	end
end)

callback.register("postSelection", function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == Duke then
			player:setAnimation("idle", player:getAnimation("idle_1"))
		end
	end
end)

Duke:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	
	if playerAc.activity == 0 and player:getAnimation("idle") ~= player:getAnimation("idle_1") then
		if playerAc.moveRight == 1 or playerAc.moveLeft == 1 or playerAc.free == 1 then
			player:setAnimation("idle", player:getAnimation("idle_1"))
		end
	end
	
	if playerData.dukeTime and playerData.bulletTime > 0 then
		playerData.bulletTime = playerData.bulletTime - 1
	end
		
	if not playerData.dukeTime and playerData.bulletTime < 720 then 
		if playerData.bulletTimeTimer % playerData.rechargeBullet == 0 then 
			playerData.bulletTime = playerData.bulletTime + 1
		end
		playerData.bulletTimeTimer = playerData.bulletTimeTimer + 1
	end	
	
	if playerData.dukeTime and playerData.bulletTime > 0 then 
		local r = 300
		for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - r, player.y - r, player.x + r, player.y + r)) do
			if actor:get("team") ~= playerAc.team then
				actor:applyBuff(buffSlowdown, 5)
			end
		end	
	end
	
	if playerData.dukeTime and playerData.bulletTime == 0 then 
		playerData.dukeTime = false
	end
end)

Duke:addCallback("draw", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	for _,field in ipairs(objPainField:findAll()) do
		local r = field:getData().radius
		local xcenter = field.x
		local ycenter = field.y
		if math.chance(10) then
			xcenter = xcenter + math.random(-1, 1)
			ycenter = ycenter + math.random(-1, 1)
		end
		graphics.color(Color.RED)
		graphics.circle(xcenter, ycenter, r, true)
		
		if math.chance(10) then
			for i = 1, 20 do 
				graphics.alpha(0.5)
				if math.chance(50) then
					local xx = xcenter + math.random(-1 * r - 1, r - 1)
					local yy = math.sqrt(r^2 - (xx - xcenter)^2) + ycenter + 1
					if math.chance(50) then
						yy = -1 * math.sqrt(r^2 - (xx - xcenter)^2) + ycenter + 1
					end
				
					local xx2 = xcenter + math.random(-1 * r - 1, r - 1)
					local yy2 = math.sqrt(r^2 - (xx2 - xcenter)^2) + ycenter + 1
					if math.chance(50) then
						yy2 = -1 * math.sqrt(r^2 - (xx2 - xcenter)^2) + ycenter + 1
					end
					
					local xx3 = xx
					local yy3 = yy
					local length = distance(xx, yy, xx2, yy2)
					local count = 1
					while count <= length do
						xx3, yy3 = pointInLine(xx, yy, xx2, yy2, count)
						local dis = distance(xx3, yy3, xcenter, ycenter) 
						graphics.alpha(dis / r)
						graphics.pixel(xx3, yy3)
						count = count + 1
					end
					
				end
			end
		end
		
		if field:getData().damageFlash > 0 then
			graphics.alpha(field:getData().damageFlash / 50)
			graphics.color(Color.RED)
			graphics.circle(field.x, field.y, r, false)
		end
		
	end	
end)

callback.register("onPlayerHUDDraw", function(player, x, y)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if player:getSurvivor() == Duke then 
		
	end
end)

sur.Duke = Duke
