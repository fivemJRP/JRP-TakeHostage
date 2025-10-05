-- done by the JGN Development Team made for the JRP Server etc

local takeHostage = {
	allowedWeapons = {
		`WEAPON_PISTOL`,
		`WEAPON_COMBATPISTOL`,
	},
	InProgress = false,
	type = "",
	targetSrc = -1,
	aggressor = {
		animDict = "anim@gangops@hostage@",
		anim = "perp_idle",
		flag = 49,
	},
	hostage = {
		animDict = "anim@gangops@hostage@",
		anim = "victim_idle",
		attachX = -0.24,
		attachY = 0.11,
		attachZ = 0.0,
		flag = 49,
	}
}

local function drawNativeNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

local function drawNativeText(str)
	SetTextEntry_2("STRING")
	AddTextComponentString(str)
	EndTextCommandPrint(1000, 1)
end

RegisterCommand("takehostage",function()
	TriggerServerEvent("TakeHostage:checkPermission")
end, false)

RegisterCommand("th",function()
	TriggerServerEvent("TakeHostage:checkPermission")
end, false)

-- Register key mapping for easier access (optional, players can set their own keybind in Settings > Keybinds > FiveM)
RegisterKeyMapping('th', 'Take Hostage', 'keyboard', '')

RegisterNetEvent("TakeHostage:proceed")
AddEventHandler("TakeHostage:proceed", function()
	callTakeHostage()
end)

function callTakeHostage()
	local playerPed = PlayerPedId()
	ClearPedSecondaryTask(playerPed)
	DetachEntity(playerPed, true, false)

	local canTakeHostage = false
	local foundWeapon
	for i = 1, #takeHostage.allowedWeapons do
		if HasPedGotWeapon(playerPed, takeHostage.allowedWeapons[i], false) then
			if GetAmmoInPedWeapon(playerPed, takeHostage.allowedWeapons[i]) > 0 then
				canTakeHostage = true
				foundWeapon = takeHostage.allowedWeapons[i]
				break
			end
		end
	end

	if not canTakeHostage then
		drawNativeNotification("You need a pistol with ammo to take a hostage at gunpoint!")
		return
	end

	if not takeHostage.InProgress then
		local closestPlayer = GetClosestPlayer(3)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			if targetSrc ~= -1 then
				SetCurrentPedWeapon(playerPed, foundWeapon, true)
				takeHostage.InProgress = true
				takeHostage.targetSrc = targetSrc
				TriggerServerEvent("TakeHostage:sync", targetSrc)
				ensureAnimDict(takeHostage.aggressor.animDict)
				takeHostage.type = "aggressor"
				TaskPlayAnim(playerPed, takeHostage.aggressor.animDict, takeHostage.aggressor.anim, 8.0, -8.0, 100000, takeHostage.aggressor.flag, 0, false, false, false)
			else
				drawNativeNotification("~r~No one nearby to take as hostage!")
			end
		else
			drawNativeNotification("~r~No one nearby to take as hostage!")
		end
	end
end 

RegisterNetEvent("TakeHostage:syncTarget")
AddEventHandler("TakeHostage:syncTarget", function(target)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	takeHostage.InProgress = true
	ensureAnimDict(takeHostage.hostage.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, takeHostage.hostage.attachX, takeHostage.hostage.attachY, takeHostage.hostage.attachZ, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
	takeHostage.type = "hostage" 
end)

RegisterNetEvent("TakeHostage:releaseHostage")
AddEventHandler("TakeHostage:releaseHostage", function()
	takeHostage.InProgress = false 
	takeHostage.type = ""
	DetachEntity(PlayerPedId(), true, false)
	ensureAnimDict("reaction@shove")
	TaskPlayAnim(PlayerPedId(), "reaction@shove", "shoved_back", 8.0, -8.0, -1, 0, 0, false, false, false)
	Wait(250)
	ClearPedSecondaryTask(PlayerPedId())
end)

RegisterNetEvent("TakeHostage:killHostage")
AddEventHandler("TakeHostage:killHostage", function()
	takeHostage.InProgress = false 
	takeHostage.type = ""
	SetEntityHealth(PlayerPedId(),0)
	DetachEntity(PlayerPedId(), true, false)
	ensureAnimDict("anim@gangops@hostage@")
	TaskPlayAnim(PlayerPedId(), "anim@gangops@hostage@", "victim_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
end)

RegisterNetEvent("TakeHostage:cl_stop")
AddEventHandler("TakeHostage:cl_stop", function()
	takeHostage.InProgress = false
	takeHostage.type = "" 
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent("TakeHostage:notify")
AddEventHandler("TakeHostage:notify", function(msg)
    drawNativeNotification(msg)
end)

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if takeHostage.type == "aggressor" then
			if not IsEntityPlayingAnim(playerPed, takeHostage.aggressor.animDict, takeHostage.aggressor.anim, 3) then
				TaskPlayAnim(playerPed, takeHostage.aggressor.animDict, takeHostage.aggressor.anim, 8.0, -8.0, 100000, takeHostage.aggressor.flag, 0, false, false, false)
			end
		elseif takeHostage.type == "hostage" then
			if not IsEntityPlayingAnim(playerPed, takeHostage.hostage.animDict, takeHostage.hostage.anim, 3) then
				TaskPlayAnim(playerPed, takeHostage.hostage.animDict, takeHostage.hostage.anim, 8.0, -8.0, 100000, takeHostage.hostage.flag, 0, false, false, false)
			end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if takeHostage.type == "aggressor" then
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 58, true)
			DisableControlAction(0, 21, true)
			DisablePlayerFiring(playerPed, true)
			drawNativeText("~b~[G]~w~ Release Hostage  ~r~[H]~w~ Kill Hostage")

			if IsEntityDead(playerPed) then
				takeHostage.type = ""
				takeHostage.InProgress = false
				ensureAnimDict("reaction@shove")
				TaskPlayAnim(playerPed, "reaction@shove", "shove_var_a", 8.0, -8.0, -1, 168, 0, false, false, false)
				TriggerServerEvent("TakeHostage:releaseHostage", takeHostage.targetSrc)
			end

			if IsDisabledControlJustPressed(0, 47) then
				takeHostage.type = ""
				takeHostage.InProgress = false
				ensureAnimDict("reaction@shove")
				TaskPlayAnim(playerPed, "reaction@shove", "shove_var_a", 8.0, -8.0, -1, 168, 0, false, false, false)
				TriggerServerEvent("TakeHostage:releaseHostage", takeHostage.targetSrc)
			elseif IsDisabledControlJustPressed(0, 74) then
				takeHostage.type = ""
				takeHostage.InProgress = false
				ensureAnimDict("anim@gangops@hostage@")
				TaskPlayAnim(playerPed, "anim@gangops@hostage@", "perp_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
				TriggerServerEvent("TakeHostage:killHostage", takeHostage.targetSrc)
				TriggerServerEvent("TakeHostage:stop", takeHostage.targetSrc)
				Citizen.Wait(100)
				SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
			end
		elseif takeHostage.type == "hostage" then
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 58, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 268, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 269, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 270, true)
			DisableControlAction(0, 35, true)
			DisableControlAction(0, 271, true)
		end
		Citizen.Wait(0)
	end
end)