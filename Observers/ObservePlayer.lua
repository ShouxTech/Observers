--!strict

local Players = game:GetService('Players');

--[=[
	Creates an observer that captures each player in the game.

	```lua
	ObservePlayer(player, function()
		print("Player entered game", player.Name)

		return function()
			-- Cleanup
			print("Player left game (or observer stopped)", player.Name)
		end
	end)
	```
]=]
local function ObservePlayer(player: Player, callback: () -> (() -> ())?): () -> ()
	local playerRemovingConn: RBXScriptConnection

    local cleanup: (() -> ())?;

	local function onPlayerAdded(player: Player)
		if not playerRemovingConn.Connected then return; end;

		task.spawn(function()
			cleanup = callback();

			if typeof(cleanup) == 'function' then
				if (not playerRemovingConn.Connected) or (not player.Parent) then
					task.spawn(cleanup);
				end;
			end;
		end);
	end;

	local function onPlayerRemoving(removingPlayer: Player)
        if removingPlayer ~= player then return; end;

		if typeof(cleanup) == 'function' then
			task.spawn(cleanup)
		end;
	end;

	playerRemovingConn = Players.PlayerRemoving:Connect(onPlayerRemoving);

	-- Initial:
	task.defer(function()
		if not playerRemovingConn.Connected then return; end;

        task.spawn(onPlayerAdded, player);
	end);

	-- Cleanup:
	return function()
		playerRemovingConn:Disconnect();

        onPlayerRemoving(player);
	end;
end;

return ObservePlayer