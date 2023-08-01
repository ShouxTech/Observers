--!strict

local ObservePlayers = require(script.Parent.ObservePlayers);
local ObserveCharacter = require(script.Parent.ObserveCharacter);

--[=[
	Creates an observer that captures each character in the game.

	```lua
	ObserveCharacters(function(character, player)
		print("Character spawned for " .. player.Name)

		return function()
			-- Cleanup
			print("Character removed for " .. player.Name)
		end
	end)
	```
]=]
local function ObserveCharacters(callback: (character: Model, player: Player) -> (() -> ())?): () -> ()
	return ObservePlayers(function(player)
		return ObserveCharacter(player, function(char: Model)
			local cleanup = callback(char, player);

			return cleanup;
		end);
	end);
end;

return ObserveCharacters;