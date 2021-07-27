-- smg drone (scout)

local path = "Drones/SMGDrone/"

local idle = Sprite.load("SMGDroneIdle", path.."Idle", 4, 6, 10)



obj.smgdrone = Object.base("Drone", "SMG Drone")
obj.smgdrone.sprite = idle

obj.smgdrone:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.cooldown = 10
	selfData.attackTimerMax = 15
	selfData.attackTimer = 15
	selfData.droneSide = 1
	selfData.droneDistance = math.random(30, 50)
	self:set("persistent", 1)
	self:set("maxhp", 120 * Difficulty.getScaling("hp"))
	self:set("armor", 1000)
	self:set("x_range", 300)
	self:set("y_range", 100)
	self:set("hp", self:get("maxhp"))
	self:setAnimation("idle", idle)
end)

obj.smgdrone:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	local target = Object.findInstance(selfAc.target)
	
	self:set("invincible", 1200)
	self:set("hp", self:get("maxhp"))
	
	if target and target:isValid() and selfAc.state == "chase" then
		local xx = target.x - self.x 
		local yy = target.y - self.y
		
		
		self.x = math.approach(self.x, target.x + selfData.droneSide * selfData.droneDistance, (self.x - target.x + selfData.droneSide * selfData.droneDistance) * 0.1)
		self.y = math.approach(self.y, target.y, yy * 0.1)
		
		self.xscale = math.sign(xx)
		
		if selfData.cooldown > 0 then
			selfData.cooldown = selfData.cooldown - 1
		else
			if selfData.attackTimer > 0 then
				if selfData.attackTimer % 3 == 0 then
					sfx.CowboyShoot1:play(1.7, 0.7)
					self:fireBullet(target.x, target.y, self:getFacingDirection(), 50, selfAc.damage * 0.2, Sprite.find("Scout_Sparks1", "SSLost")):set("specific_target", target.id)
				end
				selfData.attackTimer = selfData.attackTimer - 1
			else
				selfData.cooldown = 120
				selfData.attackTimer = selfData.attackTimerMax
				selfData.droneSide = selfData.droneSide * -1
				selfData.droneDistance = math.random(30, 50)
			end
			
			if selfAc.mortar > 0 then
				for i = 1, selfAc.mortar do
					obj.EfMissileSmall:create(self.x, self.y):set("parent", self.id):set("damage", selfAc.damage)
				end
			end
		end
	end
end)
