-- Variables --
local isUsingCrutch = false
local crutchObject = nil
local walkStyle = nil

-- Functions --
local function LoadClipSet(set)
	RequestClipSet(set)
	while not HasClipSetLoaded(set) do
		Citizen.Wait(10)
	end
end

local function LoadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

local function DisplayNotification(msg)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostTicker(false, false)
end

local function DisplayHelpText(msg)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, 0, 1, 50)
end

local function CreateCrutch()
	if not HasModelLoaded(Config.crutchModel) then
		RequestModel(Config.crutchModel)
		while not HasModelLoaded(Config.crutchModel) do
			Citizen.Wait(10)
		end
	end
	local playerPed = GetPlayerPed(-1)
	crutchObject = CreateObject(Config.crutchModel, GetEntityCoords(playerPed), true, false, false)
	AttachEntityToEntity(crutchObject, playerPed, 70, 1.18, -0.36, -0.20, -20.0, -87.0, -20.0, true, true, false, true, 1, true)
end

local function CanPlayerEquipCrutch()
	local playerPed = GetPlayerPed(-1)
	local hasWeapon, weaponHash = GetCurrentPedWeapon(playerPed)

	if hasWeapon then
		return false, Lang:t('info.weapon')
	elseif IsPedInAnyVehicle(playerPed, false) then
		return false, Lang:t('info.vehicle')
	elseif IsEntityDead(playerPed) then
		return false, Lang:t('info.dead')
	elseif IsPedInMeleeCombat(playerPed) then
		return false, Lang:t('info.combat')
	elseif IsPedFalling(playerPed) then
		return false, Lang:t('info.falling')
	elseif IsPedRagdoll(playerPed) then
		return false, Lang:t('info.ragdoll')
	end
	return true
end

local function UnequipCrutch()
	if DoesEntityExist(crutchObject) then
		DeleteEntity(crutchObject)
	end
	isUsingCrutch = false
	local playerPed = GetPlayerPed(-1)
	if walkStyle then
		LoadClipSet(walkStyle)
		SetPedMovementClipset(playerPed, walkStyle, 1.0)
		RemoveClipSet(walkStyle)
	else
		ResetPedMovementClipset(playerPed)
	end
end

local function EquipCrutch()
	local playerPed = GetPlayerPed(-1)
	local canEquip, msg = CanPlayerEquipCrutch()
	if not canEquip then
		DisplayNotification(msg)
		return
	end
	LoadClipSet(Config.clipSet)
	SetPedMovementClipset(playerPed, Config.clipSet, 1.0)
	RemoveClipSet(Config.clipSet)
	CreateCrutch()
	isUsingCrutch = true
	Citizen.CreateThread(function()
		local fallCount = 0
		while true do
			Citizen.Wait(250)
			if not isUsingCrutch then
				break
			end
			local playerPed = GetPlayerPed(-1)
			local isCrutchHidden = false
			local hasWeapon, weaponHash = GetCurrentPedWeapon(playerPed)
			if IsPedInAnyVehicle(playerPed, true) or hasWeapon then
				if not isCrutchHidden then
					isCrutchHidden = true
					if DoesEntityExist(crutchObject) then
						DeleteEntity(crutchObject)
					end
				end
			elseif not DoesEntityExist(crutchObject) then
				Citizen.Wait(750)
				CreateCrutch()
				isCrutchHidden = false
			elseif not IsEntityAttachedToEntity(crutchObject, playerPed) then
				local traceObject = true
				while traceObject do
					local wait = 0
					if DoesEntityExist(crutchObject) then
						playerPed = GetPlayerPed(-1)
						if not IsPedFalling(playerPed) and not IsPedRagdoll(playerPed) then
							local dist = #(GetEntityCoords(playerPed)-GetEntityCoords(crutchObject))
							if dist < 2.0 then
								DisplayHelpText(Lang:t('info.pickup'))
								if IsControlJustReleased(0, 38) then
									LoadAnimDict(Config.pickupAnim.dict)
									TaskPlayAnim(playerPed, Config.pickupAnim.dict, Config.pickupAnim.name, 2.0, 2.0, -1, 0, 0, false, false, false)
									local failCount = 0
									while not IsEntityPlayingAnim(playerPed, Config.pickupAnim.dict, Config.pickupAnim.name, 3) and failCount < 25 do
										failCount = failCount + 1
										Citizen.Wait(50)
									end
									if failCount >= 25 then
										ClearPedTasks(playerPed)
									else
										Citizen.Wait(800)
									end
									RemoveAnimDict(Config.pickupAnim.dict)
									DeleteEntity(crutchObject)
									Citizen.Wait(900)
									CreateCrutch()
									traceObject = false
								end
							elseif dist < 200.0 then
								wait = dist * 10
							else
								traceObject = false
							end
						else
							wait = 250
						end
					else
						traceObject = false
					end
					Citizen.Wait(wait)
				end
			elseif IsPedRagdoll(playerPed) or IsEntityDead(playerPed) then
				DetachEntity(crutchObject, true, true)
			elseif IsPedInMeleeCombat(playerPed) then
				Citizen.Wait(400)
				DetachEntity(crutchObject, true, true)
			elseif IsPedFalling(playerPed) then
				fallCount = fallCount + 1
				if fallCount > 3 then
					DetachEntity(crutchObject, true, true)
					fallCount = 0
				end
			elseif fallCount > 0 then
				fallCount = fallCount - 1
			end
		end
	end)
end

local function ToggleCrutch()
	if isUsingCrutch then
		UnequipCrutch()
	else
		EquipCrutch()
	end
end

-- Exports --
exports('SetWalkStyle', function(walk)
	walkStyle = walk
end)

RegisterNetEvent('mh-crutches:client:crutch', function()
	if isUsingCrutch then
		UnequipCrutch()
	else
		EquipCrutch()
	end
end)