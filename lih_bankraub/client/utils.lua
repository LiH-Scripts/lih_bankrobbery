
PlayerData 	= {}
IsPlayerCop = false

CreateThread(function()
	while ESX == nil do
		Wait(10)
	end
	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	IsPlayerCop = IsPlayerJobCop()
	Wait(1000)
	CreateBankBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	IsPlayerCop = IsPlayerJobCop()
end)

-- Notification
RegisterNetEvent('lih_bankrobbery:notify')
AddEventHandler('lih_bankrobbery:notify', function(msg)
	ESX.ShowNotification(msg)
end)

-- Advanced Notification
RegisterNetEvent('lih_bankrobbery:notifyAdvanced')
AddEventHandler('lih_bankrobbery:notifyAdvanced', function(sender, subject, msg, textureDict, iconType)
	ESX.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, false, false, false)
end)

-- Police Notification
RegisterNetEvent('lih_bankrobbery:police_notify')
AddEventHandler('lih_bankrobbery:police_notify', function(name, id)
	local coords = GetEntityCoords(PlayerPedId(), false)
	local street_name = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
	local message = Lang['police_notify']:format(name, street_name)
	TriggerServerEvent('lih_bankrobbery:sendPoliceAlertSV', coords, message, id)
	TriggerServerEvent("esx_bankrobbery:alarm_s", 1)
end)

--Police Notification Blip:
RegisterNetEvent('lih_bankrobbery:sendPoliceAlertCL')
AddEventHandler('lih_bankrobbery:sendPoliceAlertCL', function(target_coords, message)
	if IsPlayerCop then
		TriggerEvent('chat:addMessage', { args = {(Lang['dispatch_name']).. message}})
		-- blip
		local cfg = Config.AlertBlip
		if cfg.show then
			local alpha = cfg.Alpha
			local blip = AddBlipForRadius(target_coords.x, target_coords.y, target_coords.z, cfg.Radius)
			SetBlipHighDetail(blip, true)
			SetBlipColour(blip, cfg.Color)
			SetBlipAlpha(blip, alpha)
			SetBlipAsShortRange(blip, true)
			while alpha ~= 0 do
				Wait(cfg.Time * 4)
				alpha = alpha - 1
				SetBlipAlpha(blip, alpha)
				if alpha == 0 then
					RemoveBlip(blip)
					return
				end
			end
		end
	end
end)

-- Is Player A cop?
function IsPlayerJobCop()	
	if not PlayerData then return false end
	if not PlayerData.job then return false end
	for k,v in pairs(Config.PoliceJobs) do
		if PlayerData.job.name == v then return true end
	end
	return false
end

-- Draw 3D Text:
function lih_DrawTxt(x, y, z, text)
	local boolean, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.32, 0.32); SetTextFont(4); SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING"); SetTextCentre(1); AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text) / 500)
    DrawRect(_x, (_y + 0.0125), (0.015 + factor), 0.03, 0, 0, 0, 80)
end

-- Create Blip:
function lih_CreateBlip(pos, data)
	local blip = nil
	if data.enable then 
		blip = AddBlipForCoord(pos.x, pos.y, pos.z)
		SetBlipSprite(blip, data.sprite)
		SetBlipDisplay(blip, data.display)
		SetBlipScale(blip, data.scale)
		SetBlipColour(blip, data.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(data.label)
		EndTextCommandSetBlipName(blip)
		if data.route then 
			SetBlipRoute(blip, data.route)
			SetBlipRouteColour(blip, data.color)
		end
	end
	return blip
end

function lih_GetControlOfEntity(entity)
	local netTime = 15
	NetworkRequestControlOfEntity(entity)
	while not NetworkHasControlOfEntity(entity) and netTime > 0 do 
		NetworkRequestControlOfEntity(entity)
		Wait(100)
		netTime = netTime -1
	end
end

-- Function to create job ped(s):
function lih_CreatePed(type, model, x, y, z, heading)
	lih_LoadModel(model)
	local NPC = CreatePed(type, GetHashKey(model), x, y, z, heading, true, true)
	SetEntityAsMissionEntity(NPC)
	return NPC
end

-- Load Anim
function lih_LoadAnim(animDict)
	RequestAnimDict(animDict); while not HasAnimDictLoaded(animDict) do Wait(1) end
end

-- Load Model
function lih_LoadModel(model)
	RequestModel(model); while not HasModelLoaded(model) do Wait(1) end
end

-- Load Ptfx
function lih_LoadPtfxAsset(dict)
	RequestNamedPtfxAsset(dict); while not HasNamedPtfxAssetLoaded(dict) do Wait(1) end
end

-- Round function
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end