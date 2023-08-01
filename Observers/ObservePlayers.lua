--!strict

local Players = game:GetService("Players")

local ObservePlayer = require(script.Parent.ObservePlayer);

--[=[
	Creates an observer that captures each player in the game.

	```lua
	ObservePlayers(function(player)
		print("Player entered game", player.Name)

		return function()
			-- Cleanup
			print("Player left game (or observer stopped)", player.Name)
		end
	end)
	```
]=]
local function ObservePlayers(callback: (player: Player) -> (() -> ())?): () -> ()
	local playerAddedConn: RBXScriptConnection;

	local playerObservers: {[Player]: () -> ()} = {};

	local function playerAdded(player: Player)
		if not playerAddedConn.Connected then return; end;

		playerObservers[player] = ObservePlayer(player, function()
			local cleanup = callback(player);

			return function()
				cleanup();
			end;
		end);
	end;

	playerAddedConn = Players.PlayerAdded:Connect(playerAdded);

	-- Initial:
	task.defer(function()
		if not playerAddedConn.Connected then return; end;

		for _, player in Players:GetPlayers() do
			task.spawn(playerAdded, player);
		end;
	end);

	-- Cleanup:
	return function()
		playerAddedConn:Disconnect();

		for _, stopObserver in playerObservers do
			stopObserver();
		end;
	end;
end;

return ObservePlayers