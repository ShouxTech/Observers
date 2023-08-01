--!strict

local ObservePlayer = require(script.Parent.ObservePlayer)

--[=[
	Creates an observer that captures a given character from a player.

	```lua
	ObserveCharacter(player, function(character)
		print("Character spawned for " .. player.Name)

		return function()
			-- Cleanup
			print("Character removed for " .. player.Name)
		end
	end)
	```
]=]
local function ObserveCharacter(player: Player, callback: (player: Player, character: Model) -> (() -> ())?): () -> ()
	return ObservePlayer(player, function()
		local cleanupFn: (() -> ())? = nil;

		local characterAddedConn: RBXScriptConnection;

		local function onCharacterAdded(character: Model)
			task.defer(function()
				local cleanup = callback(character)

				if typeof(cleanup) == "function" then
					if characterAddedConn.Connected and character.Parent then
						cleanupFn = cleanup
					else
						-- Character is already gone or observer has stopped; call cleanup immediately:
						task.spawn(cleanup);
					end;
				end;
			end);

			-- Watch for the character to be removed from the game hierarchy:
			local ancestryChangedConn: RBXScriptConnection
			ancestryChangedConn = character.AncestryChanged:Connect(function(_, newParent)
				if (not newParent) and ancestryChangedConn.Connected then
					ancestryChangedConn:Disconnect();

					if cleanupFn then
						task.spawn(cleanupFn);
						cleanupFn = nil;
					end;
				end;
			end);
		end;

		characterAddedConn = player.CharacterAdded:Connect(onCharacterAdded)

		-- Handle initial character:
		task.defer(function()
			if player.Character and characterAddedConn.Connected then
				task.spawn(onCharacterAdded, player.Character);
			end;
		end);

		-- Cleanup:
		return function()
			characterAddedConn:Disconnect()
			if cleanupFn then
				task.spawn(cleanupFn)
				cleanupFn = nil
			end
		end
	end)
end

return ObserveCharacter