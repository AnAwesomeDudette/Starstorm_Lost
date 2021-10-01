callback.register("onPlayerInit", function(player)
	local playerData = player:getData()
	if playerData.hasInputs then
		if modloader.checkFlag("fgc_debug") then
			playerData.inputDebug = true
			playerData.inputDebugDisplay = "Debug display active." --used for testing execution of special moves
		end
		playerData.inputHandler = {} --tracks the last 10 directional inputs (including diagonals) so they can be read
		for i=1, 10 do playerData.inputHandler[i] = 5 end
	
		playerData.buttonInputHandler = {} --tracks the last 6 ability inputs (ZXCV) so they can be read
		for i=1, 6 do playerData.buttonInputHandler[i] = 0 end
	
		playerData.inputs = {} -- used to store cardinal direction inputs, helps with gamepad functionality (still needs tweaked)
		for i=1, 4 do playerData.inputs[i] = 0 end
		
		playerData.currentInput = 5 -- number 1-9 representing one of 8 possible directions + a neutral direction
		playerData.currentButtonInput = 0 -- number 0-4 representing one of 4 possible ability inputs + no input
		playerData.bufferTimer = 12 -- used as frame counter for when a new directional input should be registered (Up, Right, Left, Down, Etc.)
		playerData.bufferTimer2 = 45 -- used as frame counter for when a new ability input should be registered (ZXCV)
		playerData.currentSpecial = 0 -- used to control when special moves can occur (not necessary but suggested to avoid conflict)
	end
end)

callback.register("onPlayerStep", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if playerData.hasInputs then
		local function addInput(newInput)
			table.insert(playerData.inputHandler, 1, newInput)
			table.remove(playerData.inputHandler, 11)
		end --adds new directional input, pushes everything down, removes the end
		
		if playerData.bufferTimer ~= 0 then
			playerData.bufferTimer = playerData.bufferTimer - 1
		end --ticks down the bufferTimer frame counter to 0
		
		--begin directional input check
		--local gamepad = input.getPlayerGamepad(player)
		if not gamepad then
			--[[
			playerData.inputs[1] = input.checkControl("up", player) --needs synced
			playerData.inputs[2] = input.checkControl("right", player) --needs synced
			playerData.inputs[3] = input.checkControl("down", player) --needs synced
			playerData.inputs[4] = input.checkControl("left", player) --needs synced
			]]
			
			local up = playerData.inputs[1]
			local right = playerData.inputs[2]
			local down = playerData.inputs[3]
			local left = playerData.inputs[4]
			
			local moveLeft = player:get("moveLeft")
			local ropeDown = player:get("ropeDown")
			local moveRight = player:get("moveRight")
			local ropeUp = player:get("ropeUp")
			
			if up == 3 then
				up = 2
			elseif up == 2 and ropeUp == 1 then
				up = 2
			elseif up == 2 then
				up = 1
			elseif up == 1 then
				up = 0
			end
	
			if down == 3 then
				down = 2
			elseif down == 2 and ropeDown == 1 then
				down = 2
			elseif down == 2 then
				down = 1
			elseif down == 1 then
				down = 0
			end

			if right == 3 then
				right = 2
			elseif right == 2 and moveRight == 1 then
				right = 2
			elseif right == 2 then
				right = 1
			elseif right == 1 then
				right = 0
			end
	
			if left == 3 then
				left = 2
			elseif left == 2 and moveLeft == 1 then
				left = 2
			elseif left == 2 then
				left = 1
			elseif left == 1 then
				left = 0
			end
	
			if moveLeft > 0 or ropeUp > 0 or moveRight > 0 or ropeDown > 0 then
				if ropeUp == 1 and up == 0 then
					up = 3
				elseif ropeDown == 1 and down == 0 then
					down = 3
				end
				if moveRight == 1 and right == 0 then
					right = 3
				elseif moveLeft == 1 and left == 0 then
					left = 3
				end
			end
			
			playerData.inputs[1] = up
			playerData.inputs[2] = right
			playerData.inputs[3] = down
			playerData.inputs[4] = left
			
		end
		
		--[[controller support
			--for the record there's totally a better way to do this, but its not about if i should, its about if i could,
			-- and the answer . is still no
		if gamepad then 
		
		--OKAY UM. THE FUCKIG
		-- i could make it so that, inputs are tighter if a direction IS held and lenient if they ARENT
		-- or specify it as rolling points ??? iunno !!! Gog
		
			local up = playerData.inputs[1]
			local right = playerData.inputs[2]
			local down = playerData.inputs[3]
			local left = playerData.inputs[4]
	
			local deadzone = 0.25
			--local deadzone = 0.2
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
		--end controller support]]
		
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
			addInput(playerData.currentInput)
		end	

		if down == input.HELD 
		and left == input.HELD
		and playerData.bufferTimer < bW then
			playerData.currentInput = 1
			playerData.bufferTimer = 12
			addInput(playerData.currentInput)
		end

		if up == input.HELD 
		and  right == input.HELD
		and playerData.bufferTimer < bW then
			playerData.currentInput = 9
			playerData.bufferTimer = 12
			addInput(playerData.currentInput)
		end	
	
		if up == input.HELD 
		and left == input.HELD
		and playerData.bufferTimer < bW then
			playerData.currentInput = 7
			playerData.bufferTimer = 12
			addInput(playerData.currentInput)
		end

		if up == input.HELD and playerData.bufferTimer < bW then
			playerData.currentInput = 8
			playerData.bufferTimer = 12
			addInput(playerData.currentInput)
		end

		if right == input.HELD and playerData.bufferTimer < bW then
			playerData.currentInput = 6
			playerData.bufferTimer = 12
			addInput(playerData.currentInput)
		end	

		if down == input.HELD and playerData.bufferTimer < bW then
			playerData.currentInput = 2
			playerData.bufferTimer = 12
			addInput(playerData.currentInput)
		end

		if left == input.HELD and playerData.bufferTimer < bW then
			playerData.currentInput = 4
			playerData.bufferTimer = 12
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

		local function addButtonInput(newInput)
			table.insert(playerData.buttonInputHandler, 1, newInput)
			table.remove(playerData.buttonInputHandler, 7)
		end --adds new ability input, pushes everything down, removes the end
		
		local buffer2Max = 15

		if player:get("activity") < 1 or player:get("activity") > 4 then
			if playerData.bufferTimer2 ~= 0 then
				playerData.bufferTimer2 = playerData.bufferTimer2 - 1
			else
				for i=1, 6 do playerData.buttonInputHandler[i] = 0 end
				playerData.bufferTimer2 = buffer2Max
			end
		end --resets the handler if no inputs are made for a set amount of frames (45)

		if primary == input.PRESSED or secondary == input.PRESSED or utility == input.PRESSED or ultimate == input.PRESSED then
			playerData.bufferTimer2 = buffer2Max
		end

		if primary == input.PRESSED then
			addButtonInput(1)
			playerData.currentButtonInput = 1
		end
		if secondary == input.PRESSED then
			addButtonInput(2)
			playerData.currentButtonInput = 2
		end

		if utility == input.PRESSED then
			addButtonInput(3)
			playerData.currentButtonInput = 3
		end
		if ultimate == input.PRESSED then
			addButtonInput(4)
			playerData.currentButtonInput = 4
		end
		--end ability input check
		
		if playerData.currentSpecial > 0 and (playerAc.activity < 1 or playerAc.activity > 5) then
			playerData.currentSpecial = 0
		end --resets special state when not executing
		
		if player:get("activity") == 30 then
			playerData.currentButtonInput = 0
			for i=1, 6 do playerData.buttonInputHandler[i] = 0 end
		end --at no reasonable point should the player be able to perform a combo on a rope . if you disagree meet me in the ring
		
	end
end)

callback.register("onPlayerDraw", function(player)
	local playerData = player:getData()
	if playerData.inputDebug and playerData.hasInputs then --draws the last performed move, buttonInputHandler and inputHandler underneath Brawler
		if playerData.inputHandler then
			local inputs = playerData.inputHandler
			graphics.color(Color.fromHex(0x9bd1cd))
			graphics.print(inputs, player.x, player.y+20, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
		end
		if playerData.buttonInputHandler then
			local inputs = playerData.buttonInputHandler
			graphics.color(Color.fromHex(0x9bb8d1))
			graphics.print(inputs, player.x, player.y+35, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
		end
		if playerData.debugDisplay then
			graphics.color(Color.fromHex(0xa59bd1))
			graphics.print(playerData.debugDisplay, player.x, player.y+50, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
		end
	end
end) --debug display data

--[[
	Input Types
	
	For directions, inputs are read from 1-9, for each number on a numpad corresponding to a direction; e.g., 6 is right, 5 is neutral.
	Directions are read from earliest in the list, to the last index given as its "buffer" window, up to 10.
	
	For skills, inputs are read as 1, 2, 3, or 4, corresponding to Z (Primary), X (Secondary), C (Utility), and V (Ultimate).
	Skills are read at a specific given index, up to 4.
]]
function checkInputs(player, --The player instance who's inputs are being checked. Returns true if all parameters are passed, nil (equivalent to false) otherwise.
inputType, --What kind of input is being read. Can be "skill" (ZXCV) or "direction".
input1, buffer1, --The input to be read. 
input2, buffer2, 
input3, buffer3, 
input4, buffer4, --Maximum inputs for skill input checks.
input5, buffer5, 
input6, buffer6, 
input7, buffer7, 
input8, buffer8, 
input9, buffer9, 
input10, buffer10) --Maximum inputs for directional input checks.

	if player then
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
		end --checks for the given directional input over a specified window
		
		local function inputReader2(input, window)
			if player:getData().buttonInputHandler then
				local inputHandler = player:getData().buttonInputHandler
				if inputHandler[window] == input then
					return true;
				end
			end
		end --checks for the given ability/skill input within a specified point in a sequence
		
		if inputType == "direction" then
		
			if inputReader(input1, buffer1) then
				if input2 then
					if inputReader(input2, buffer2) then
						if input3 then
							if inputReader(input3, buffer3) then
								if input4 then
									if inputReader(input4, buffer4) then
										if input5 then
											if inputReader(input5, buffer5) then
												if input6 then
													if inputReader(input6, buffer6) then
														if input7 then
															if inputReader(input7, buffer7) then
																if input8 then
																	if inputReader(input8, buffer8) then
																		if input9 then 
																			if inputReader(input9, buffer9) then
																				if input10 then
																					if inputReader(input10, buffer10) then
																						return true;
																					end
																				else return true; end
																			end
																		else return true; end
																	end
																else return true; end
															end
														else return true; end
													end
												else return true; end
											end
										else return true; end
									end
								else return true; end
							end
						else return true; end
					end
				else return true; end
			end
			
		elseif inputType == "skill" then
		
			if inputReader2(input1, buffer1) then
				if input2 then
					if inputReader2(input2, buffer2) then
						if input2 then 
							if inputReader2(input3, buffer3) then
								if input3 then
									if inputReader2(input4, buffer4) then
										return true;
									end
								else return true; end
							end
						else return true; end
					end
				else return true; end
			end

		else
			error("FGCInputs | No valid input type received!")
		end
	else
		error("FGCInputs | No player received!")
	end
end

--I need to sync this by creating a packet every time this is run.

export("checkInputs")

fgc = {} --functions that can be drag and dropped into player callbacks (remember to identify the player in the first function argument)

function fgc.cancel(player)
	player.subimage = player.sprite.frames
end --cancels current animation. careful: doesnt reset ability state until next tick, and trying to set it on the same tick will give an error

function fgc.reset(player)
	for i=1, 6 do player:getData().buttonInputHandler[i] = 0 end
end --resets ability/skill input handler

function fgc.set(player, special)
	player:getData().currentSpecial = special
end --sets special state

export("fgc") --dont know how well they work rn ? and 100% will not work if you dont have this as a dependency
--but youre free to see if you wanna mess around with them
	
	--[[
			Fighting game notation is done alongside the typical representation of numbers on a numpad.
			
			7  8  9
			4  5  6
			1  2  3
		
			"6" would be read as right, while "2" would be read as down, so on and so forth.
			
			So a motion such as
			Down (2) -> Down-right (3) -> Right (6) + Primary (Z) 
			is translated to
			236Z
				or
			2 -> 3 -> 6 + Z
			
			This is how inputHandler works, and by extension currentInput. 
			These numbers are interpreted as corresponding directions.
			
			It's important to note that any input that uses left or right should likely have a flipped version, 
			unless you only want the player to be able to use it facing one direction.
			
			playerData.inputHandler works by reading the latest directional input two frames after a direction is pressed or released.
			If a new input is not made within 12 frames, a neutral direction input of 5 is placed instead.
			
			playerData.buttonInputHandler works by reading the latest ability/skill input after a button is pressed or released.
			If a new input is not made within 45 frames, the list is fully reset.
			The buffer window of 45 frames is simply the baseline, and can be reduced by setting playerData.bufferTimer2
			in order to provide a different frame window that allows for another button input.
			
			It's suggested that a move executed using playerData.buttonInputHandler should reset the handler and/or buffer window
			either through a relevant function or direct control.
			
			playerData.currentSpecial is simply an indicator of whether or not a special is being used. 
			It can be used to specify when a special is being executed to prevent conflicts.
			It is reset when the player is not using any abilities.
	]]
