-- smg drone (scout)

local path = "Drones/SMGDrone/"

local idle = Sprite.load("SMGDroneIdle", path.."Idle", 4, 6, 10)



obj.smgdrone = Object.new("SMGDrone")
obj.smgdrone.sprite = idle

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

