-- smg drone (scout)

local path = "Drones/SMGDrone/"

local idle = Sprite.load("LaserDroneIdle", path.."Idle", 4, 6, 10)



obj.laserdrone = Object.new("LaserDrone")
obj.laserdrone.sprite = idle

obj.laserdrone:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.2
	selfData.state = "idle"
	selfData.location = 1
	selfData.direction = {
	spin = 1,
	laserStart = 0,
	laserEnd = 180
	}
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
				local tile = obj.B:findLine(self.x, self.y, selfData.xLaser, selfData.yLaser)
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
				misc.fireExplosion(selfData.xLaser, selfData.yLaser, 16/19, 16/4, parent:get("damage") * 0.5, parent:get("team"), spr.EfExplosive, nil)
			end
			
			if selfData.laser ~= selfData.direction.laserEnd then
				selfData.laser = math.approach(selfData.laser, selfData.direction.laserEnd, 4)
			else
				selfData.laser = nil
				selfData.state = "pulse"
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
			self.x = math.approach(self.x, parent.x, xx * 0.1 + math.sign(xx))
			self.y = math.approach(self.y, parent.y, yy * 0.1 + math.sign(yy))
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
		if tele then
			local circlex, circley = pointInLine(self.x, self.y, tele.x, tele.y, 60 - selfData.pulse)
			graphics.line(self.x, self.y, circlex, circley)
		end
	end
	
	if selfData.state == "attack" then
		if selfData.xLaser and selfData.yLaser then
			graphics.color(Color.fromHex(0x43DBB0))
			graphics.alpha(0.8)
			graphics.line(self.x, self.y, selfData.xLaser, selfData.yLaser, 5)
		end
	end
end)
