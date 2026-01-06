
local player, coords = nil, {}
CreateThread(function()
    while true do
        player = PlayerPedId()
        coords = GetEntityCoords(player)
        Wait(500)
    end
end)

local curBank = 0
local doors = {}
local blips = {}
local pacificSafe = {}
local interacting = false
local PlaySound = false
local bagcreated = false

CreateThread(function()
    while true do 
        for i = 1, #Config.Banks do
            if #(coords - Config.Banks[i].blip.pos) < 100.0 then
                curBank = i
            end
        end
        Wait(2000)
		--print (GlobalState.CloseAllBanks)
    end
end)

--CSYON GlobalState für Cooldown
GetBankData = function(curBank, data)
    return GlobalState[GetCurrentResourceName() .. curBank .. data]
end

RegisterNetEvent('lih_bankrobbery:ResetCurrentBankCL')
AddEventHandler('lih_bankrobbery:ResetCurrentBankCL', function(id, data)
	Config.Banks[id] = data
end)

RegisterNetEvent('lih_bankrobbery:inUseCL')
AddEventHandler('lih_bankrobbery:inUseCL', function(id, state)
	Config.Banks[id].inUse = state
end)

RegisterNetEvent('lih_bankrobbery:keypadHackedCL')
AddEventHandler('lih_bankrobbery:keypadHackedCL', function(id, num, state)
	Config.Banks[id].keypads[num].hacked = state
end)

RegisterNetEvent('lih_bankrobbery:doorFreezeCL')
AddEventHandler('lih_bankrobbery:doorFreezeCL', function(id, num, state)
	Config.Banks[id].doors[num].freeze = state
end)

RegisterNetEvent('lih_bankrobbery:safeRobbedCL')
AddEventHandler('lih_bankrobbery:safeRobbedCL', function(id, num, state)
	Config.Banks[id].safes[num].robbed = state
end)

RegisterNetEvent('lih_bankrobbery:safeFailedCL')
AddEventHandler('lih_bankrobbery:safeFailedCL', function(id, num, state)
	Config.Banks[id].safes[num].failed = state
end)

RegisterNetEvent('lih_bankrobbery:pettyCashRobbedCL')
AddEventHandler('lih_bankrobbery:pettyCashRobbedCL', function(id, num, state)
    Config.Banks[id].pettyCash[num].robbed = state
end)

-- Manage & Freeze Doors:
CreateThread(function()
    while true do 
        if curBank ~= 0 then
            -- Closest Door:
            for k,v in pairs(Config.Banks[curBank].doors) do  
                if doors[k] ~= nil and DoesEntityExist(doors[k].entity) then
                    if v.freeze == true then
                        SetEntityHeading(doors[k].entity, v.setHeading)
                        FreezeEntityPosition(doors[k].entity, true)
                    else
                        if k == 'cell' or k == 'cell2' or k == 'cell3' or k == 'cell4' or 'terminal' then
                            FreezeEntityPosition(doors[k].entity, false)
                        end
                        
                    end
                else
                    local obj = GetClosestObjectOfType(v.pos.x, v.pos.y, v.pos.z, 2.0, v.model)
                    doors[k] = {entity = obj, pos = v.pos, type = k, heading = v.heading, setHeading = v.setHeading, freeze = v.freeze}
                end
            end
        end
        Wait(1000)
	end  
end)
  

-- Bank Thread:
CreateThread(function()
	while true do
        Wait(1)
        local sleep = true
        if curBank ~= 0 then
            -- keypads:
			for k,v in pairs(Config.Banks[curBank].keypads) do
				local distance = #(coords - v.pos)
				if distance <= 1.0 and not interacting then
					if k == 'start' then
					
						if IsPlayerCop == false then 
							if Config.Banks[curBank].keypads[k].hacked == false then
								sleep = false
								local text = v.text
								
								if curBank == 1 then 
									text = v.text[1]
								end
								
								--lih_DrawTxt(v.pos.x, v.pos.y, v.pos.z, text)
								exports['lih_helpnotify']:showHelpNotification(text)
								if IsControlJustPressed(0, Config.KeyControls['hack_terminal']) then
								
									local closestPlayer, dist = ESX.Game.GetClosestPlayer()
								  
									if closestPlayer ~= -1 and dist >= 1.5 or dist == -1 then
										if GetBankData(curBank, "robbable") then --CSYON CHECK FOR COOLDOWN
											-- Police Check per Server Callback
											ESX.TriggerServerCallback('lih_bankrobbery:getPoliceCount', function(policeCount)
												if policeCount >= Config.Banks[curBank].police then
													if GlobalState.CloseAllBanks == false then
														HackingKeypad(k,v)
														--print (k,v)
													else
														TriggerEvent('lih_bankrobbery:notify', ("Es findet gerade ein Raub statt. Die Banken haben die ~r~Sicherheitssysteme gesperrt"))
													end
												else
													TriggerEvent('lih_bankrobbery:notify', ("Nicht genug Polizisten im Staat"))
												end
											end)
										else
											TriggerEvent('lih_bankrobbery:notify', ("Diese Bank wurde erst ausgeraubt"))
										end
									else
										TriggerEvent('lih_bankrobbery:notify', ("Du benötigst mehr Platz zum Arbeiten"))
									end
								end
							end
						elseif IsPlayerCop == true then
							local text = Lang['draw_bank_secured']
							if GlobalState.CloseAllBanks == true then
								text = Lang['draw_secure_bank']
							end
							sleep = false
							lih_DrawTxt(v.pos.x, v.pos.y, v.pos.z, text)
							if IsControlJustPressed(0, Config.KeyControls['reset_bank']) then
								if GlobalState.CloseAllBanks == true then
									
									ResetCurrentBank(k,v)
									
								end
							end
						end
						
					elseif k == 'vault' and Config.Banks[curBank].keypads[k].hacked == false then 
						if GlobalState.CloseAllBanks == true and Config.Banks[curBank].keypads['start'].hacked == true then
							sleep = false
							local text = v.text
							
							if curBank == 1 then 
								text = v.text[1]
							end
							--lih_DrawTxt(v.pos.x, v.pos.y, v.pos.z, text)
							exports['lih_helpnotify']:showHelpNotification(text)
							if IsControlJustPressed(0, Config.KeyControls['hack_vault']) then
								local closestPlayer, dist = ESX.Game.GetClosestPlayer()
								if closestPlayer ~= -1 and dist >= 1.5 or dist == -1 then
									HackingKeypad(k,v)
								else
									TriggerEvent('lih_bankrobbery:notify', ("Du benötigst mehr Platz zum Arbeiten"))
								end
							end
							
						end
					end
				end
			end
            -- doors & petty cash:
            for k,v in pairs(Config.Banks[curBank].doors) do
                if GlobalState.CloseAllBanks == true and (k == 'cell' or k == 'cell2' or k == 'cell3' or k == 'cell4') then 
                    -- door actions:
                    if (v.freeze == true and Config.Banks[curBank].keypads['start'].hacked == true) or (curBank == 1 and v.freeze == true and GlobalState.CloseAllBanks == true) then 
                        local distance = #(coords - v.pos)
                        if distance <= 1.0 and not interacting then
                            sleep = false
                            local text = Lang['draw_place_thermite']
							
							exports['lih_helpnotify']:showHelpNotification(text)
                            if IsControlJustPressed(0, Config.KeyControls['door_action']) then
								local closestPlayer, dist = ESX.Game.GetClosestPlayer()
								if closestPlayer ~= -1 and dist >= 1.5 or dist == -1 then
									local offset = GetOffsetFromEntityInWorldCoords(doors[k].entity, v.offset.x, v.offset.y, v.offset.z)
									DoorAction(k,v,offset)
								else
									TriggerEvent('lih_bankrobbery:notify', ("Du benötigst mehr Platz zum arbeiten"))
								end
                            end
                        end
                    end
                    -- petty cash:
                    if v.freeze == false then
                        for i = 1, #Config.Banks[curBank].pettyCash do
                            local distance = #(coords - Config.Banks[curBank].pettyCash[i].pos)
                            if distance <= 1.0 and not interacting then
                                sleep = false
                                if distance <= 1.0 then 
                                    if Config.Banks[curBank].pettyCash[i].robbed then
                                        --text = Lang['draw_petty_cash_robbed']
                                    else
										local text = Lang['draw_rob_petty_cash']
										exports['lih_helpnotify']:showHelpNotification(text)
									end
                                    if IsControlJustPressed(0, Config.KeyControls['petty_cash']) and not Config.Banks[curBank].pettyCash[i].robbed then
										local closestPlayer, dist = ESX.Game.GetClosestPlayer()
										if closestPlayer ~= -1 and dist >= 1.5 or dist == -1 then
											GrabCash(i, Config.Banks[curBank].pettyCash[i].pos, Config.Banks[curBank].pettyCash[i].propanim)
										else
											TriggerEvent('lih_bankrobbery:notify', ("Es steht schon jemand vor dem Trolly"))
										end
									end
                                end
                            end
                        end
                    end
                end
            end

            -- safes:
            for k,v in pairs(Config.Banks[curBank].safes) do
                if GlobalState.CloseAllBanks == true then
                    if (curBank ~= 1 and Config.Banks[curBank].keypads[v.requireHack].hacked == true) or (curBank == 1 and Config.Banks[curBank].doors[v.requireDoor].freeze == false) then
                        local distance = #(coords - v.pos)
                        if distance <= 1.0 then
                            sleep = false
                            if distance <= 1.0 and not interacting then
                                if v.robbed then
                                    --text = Lang['draw_safe_drilled']
                                elseif v.failed then
                                    --text = Lang['draw_safe_destroyed']
                                else
									local text = Lang['draw_drill_safe']
									exports['lih_helpnotify']:showHelpNotification(text)
								end
                                if IsControlJustPressed(0, Config.KeyControls['drill_start']) and not v.robbed and not v.failed then
									local closestPlayer, dist = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= -1 and dist >= 1.5 or dist == -1 then
										DrillSafe(k,v)
									else
										TriggerEvent('lih_bankrobbery:notify', ("Du benötigst mehr Platz zum Arbeiten"))
									end
                                end
                            end
                            if IsControlJustPressed(2, Config.KeyControls['drill_stop']) then
                                TriggerEvent('lih_bankrobbery:drilling:stop')
                            end
                        end
                    end
                end
            end
        end
        if sleep then 
            Wait(1000)
        end
	end
end)

-- Function to hack keypads:
function HackingKeypad(id,val)
    interacting = true
    local has_item = HasRequiredItems('hacking_laptop')
    --print(has_item)
    if has_item then
        RemoveRequiredItems('hacking_laptop')
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
        Wait(250)
        FreezeEntityPosition(player, true)
        TaskStartScenarioInPlace(player, 'WORLD_HUMAN_STAND_MOBILE', -1, true)
        Wait(3000)
        local busy, hacked = true, false
        if id == 'start' then 
            TriggerEvent('mhacking:show')
            TriggerEvent('mhacking:start', 4, 20, function(success)
                TriggerEvent('mhacking:hide')
                hacked = success
                busy = false
            end)
        elseif id == 'vault' then
            TriggerEvent("utk_fingerprint:Start", 3, 3, 2, function(success, reason)
                hacked = success
                busy = false
            end)
		
        end
        while busy do 
            Wait(100)
        end
        ClearPedTasks(player)
        FreezeEntityPosition(player, false)
        Wait(2000)
        if hacked then
            TriggerServerEvent('lih_bankrobbery:keypadHackedSV', curBank, id, true)
            local openVault = false
			
            if id == 'start' then
				TriggerServerEvent('lih_bankrobbery:TimerSV', curBank)  --CSYON Start Cooldown
                if GlobalState.CloseAllBanks == false then
					ProgressBar()
                    TriggerServerEvent('lih_bankrobbery:CloseBanks', curBank)
                end
                if curBank == 1 then
                    TriggerServerEvent('lih_bankrobbery:doorFreezeSV', curBank, 'terminal', false)
                else
                    openVault = true
                end
				
				--CSYON ALERT & ALARM TRIGGER
				BankRobberyAlert(Config.Banks[curBank].name, Config.Banks[curBank])
				local alarmposition = (Config.Banks[curBank].blip.pos)
				TriggerServerEvent("lih_bankrobbery:alarm_s", alarmposition)
				--CSYON ALERT & ALARM TRIGGER

            elseif id == 'vault' then
                if curBank == 1 then 
                    openVault = true
                else
                    TriggerServerEvent('lih_bankrobbery:doorFreezeSV', curBank, 'terminal', false)
                end
            end
            
            if openVault then
                TriggerServerEvent('lih_bankrobbery:openVaultSV', true, curBank) 
            end
        else
            TriggerEvent('lih_bankrobbery:notify', Lang['hacking_failed'])
            Wait(1000)
        end
    end
    interacting = false
end

function ProgressBar()
	CreateThread(function()
		exports["lih_progressbar"]:OpenProgressBar({
			allowcancel = true,
			time = Config.AllCooldown,
			label = "Tresor schließt",
		})
	end)
end
							
-- Function to interact with cell doors:
function DoorAction(id,val,offset)
    interacting = true
    local has_item = HasRequiredItems(val.action)
    if has_item then
        RemoveRequiredItems(val.action)
        local success = false
        if val.action == 'thermite' then
            --SetPedComponentVariation(player, 5, 0, 0, 0)
            local scene_pos, scene_rot = offset, vector3(0.0,0.0,val.heading)
            local anim = {dict = 'anim@heists@ornate_bank@thermal_charge', name = 'thermal_charge'}
            local objHash = GetHashKey('hei_prop_heist_thermite')
            -- Load Anim:
                        local rotplus = 270.0
            -- New animation
            local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
            local bagscene = NetworkCreateSynchronisedScene(scene_pos, scene_rot, 2, false, false, 1065353216, 0, 1.3)
            --if bagcreated == false then 
            --if bag == nil then
                --local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), scene_pos,  true,  true, false)
                --bagcreated = true
           -- end
            --SetEntityCollision(bag, false, true)
            NetworkAddPedToSynchronisedScene(player, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
            --SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(bagscene)
            Wait(1500)


            lih_LoadAnim(anim.dict)
            -- Scene:
            local scene = NetworkCreateSynchronisedScene(scene_pos, scene_rot, 2, false, false, 1065353216, 0, 1.3)
            -- Add Ped to scene:
            NetworkAddPedToSynchronisedScene(player, scene, anim.dict, anim.name, 1.5, -4.0, 1, 16, 1148846080, 0)
            -- Start Scene:
            
            --NetworkStartSynchronisedScene(scene)
            Wait(1000)
            lih_LoadModel(objHash)
            local object = CreateObject(objHash, coords.x, coords.y, coords.z + 0.2, true, true, true)
            SetEntityCollision(object, false, false)
            AttachEntityToEntity(object, player, GetPedBoneIndex(player, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
            Wait(3500)
            DetachEntity(object, true, true)
            FreezeEntityPosition(object, true)
            -- Particle Effects:
            TriggerServerEvent('lih_bankrobbery:particleFxSV', GetEntityCoords(object), 'scr_ornate_heist', 'scr_heist_ornate_thermal_burn')
            -- Stop Scene:
            --NetworkStopSynchronisedScene(scene)
           
                --SetPedComponentVariation(player, 5, 45, 0, 0)
          
            DeleteObject(bag)
            NetworkStopSynchronisedScene(bagscene)
            -- Play Anim:
            TaskPlayAnim(player, anim.dict, 'cover_eyes_loop', 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
            Wait(3000)
            DeleteObject(object)
            -- Replace Model:
            
            ClearPedTasks(player)
            success = true
        
        end
        if success then
            TriggerServerEvent('lih_bankrobbery:doorFreezeSV', curBank, id, false)
            Wait(1000)
            interacting = false
        end
    else
        interacting = false
    end
end

-- Function to drill closest safe:
function DrillSafe(id, val)
    Wait(math.random(100, 500))
    if not val.robbed then
        local anim = {dict = 'anim@heists@fleeca_bank@drilling', lib = 'drill_straight_idle'}
        local closestPlayer, dist = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and dist <= 1.0 then
            if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), anim.dict, anim.lib, 3) then
                return TriggerEvent('lih_bankrobbery:notify', Lang['safe_drilled_by_ply'])
            end
        end

        interacting = true
        local has_item = HasRequiredItems('drilling')
        if not has_item then
            interacting = false
            return
        end

        TriggerServerEvent('lih_bankrobbery:safeRobbedSV', curBank, id, true)
        RemoveRequiredItems('drilling')

        FreezeEntityPosition(player, true)
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
        Wait(250)

        local objHash = GetHashKey('hei_prop_heist_drill')

        -- Load Anim & Model
        lih_LoadAnim(anim.dict)
        lih_LoadModel(objHash)

        -- Set Position & Heading
        SetEntityCoords(player, val.anim.x, val.anim.y, val.anim.z - 0.95)
        SetEntityHeading(player, val.anim.w)

        -- Play Animation
        TaskPlayAnimAdvanced(player, anim.dict, anim.lib, val.anim.x, val.anim.y, val.anim.z,
            0.0, 0.0, val.anim.w, 3.0, -4.0, -1, 2, 0, 0, 0 )

        -- Create Drill Object
        local object = CreateObject(objHash, coords.x, coords.y, coords.z + 0.2, true, true, true)
        AttachEntityToEntity(object, player, GetPedBoneIndex(player, 28422),
            0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
        SetEntityAsMissionEntity(object, true, true)

        -- Play Sound
        RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
        RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
        RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
        local soundID = GetSoundId()
        Wait(100)
        PlaySoundFromEntity(soundID, "Drill", object, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
        Wait(100)

        -- Particle FX
        local ptfx = {dict = 'core', name = 'ent_anim_pneumatic_drill'}
        lih_LoadPtfxAsset(ptfx.dict)
        SetPtfxAssetNextCall(ptfx.dict)
        ptfx.effect = StartParticleFxLoopedOnEntity(ptfx.name, object, 0.0, -0.5, 0.0,
            0.0, 0.0, 0.0, 0.9, 0, 0, 0)
        ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 1.0)
        Wait(100)

        -- Drilling Minigame
        TriggerEvent('lih_bankrobbery:drilling:start', function(status)
            if status == 1 then
                -- SUCCESS: Reward korrekt vergeben
                local rewardType = val.propType or "money" -- gold, diamond, money
                TriggerServerEvent('lih_bankrobbery:pettyCashReward', curBank, id, rewardType)

            elseif status == 2 then
                -- FAIL
                TriggerServerEvent('lih_bankrobbery:safeFailedSV', curBank, id, true)
                TriggerEvent('lih_bankrobbery:notify', Lang['you_destroyed_safe'])
            elseif status == 3 then
                -- PAUSE
                TriggerEvent('lih_bankrobbery:notify', Lang['drilling_paused'])
            end

            -- Cleanup
            ClearPedTasksImmediately(player)
            StopSound(soundID)
            ReleaseSoundId(soundID)
            DeleteObject(object)
            DeleteEntity(object)
            FreezeEntityPosition(player, false)
            StopParticleFxLooped(ptfx.effect, 0)
            StopGameplayCamShaking(true)
            Wait(1000)
            interacting = false
        end)
    end
end

-- Function to rob petty cash:
function GrabCash(id, pos, itemnames)
	
	for _, item in ipairs(itemnames) do
		itempropname = item
	end

	Wait(math.random(100, 500))
	if not Config.Banks[curBank].pettyCash[id].robbed then
		TriggerServerEvent('lih_bankrobbery:pettyCashRobbedSV', curBank, id, true)
		local Pped = PlayerPedId()
		FreezeEntityPosition(Pped, true)
		local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and dist <= 1.0 then
			if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), anim.dict, anim.lib, 3) then
				return TriggerEvent('lih_bankrobbery:notify', 'Die Beute wurde bereits gestohlen')
			end
		end
		interacting = true 
		SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
		Wait(250)
		
		TaskTurnPedToFaceEntity(player, cash_stack, -1)

		GrabAnim(itempropname)
		DeleteObject(cash_stack)

		TriggerServerEvent('lih_bankrobbery:pettyCashReward', curBank, id, itempropname)
		Wait(10)
		FreezeEntityPosition(Pped, false)
		interacting = false
	end
end

-- Alert Police Function:
function BankRobberyAlert(name, id)
	exports['lih_dispatch']:BankRobbery(name)
    --TriggerEvent('lih_bankrobbery:police_notify', name, id)
end

function CreateBankBlips()
    CreateThread(function()
        for i = 1, #Config.Banks do
            blips[i] = CreateBlip(Config.Banks[i].blip)
        end
    end)
end

-- Function to reset heist:
function ResetCurrentBank(id,val)
    interacting = true
	TriggerServerEvent('lih_bankrobbery:ResetCurrentBank', curBank)
    Wait(1000)
    interacting = false 
end

-- Function to check if ply has required items:
function HasRequiredItems(action)
    local checked, has_item = false, false
    if Config.Banks[curBank].reqItems[action] ~= nil then
        for k,v in pairs(Config.Banks[curBank].reqItems[action]) do
            ESX.TriggerServerCallback('lih_bankrobbery:getInventoryItem', function(cb, item) 
                has_item = cb
                if not has_item then
                    TriggerEvent('lih_bankrobbery:notify', Lang['need_item_for_task']:format(item.label))
                    checked = true
                end
                if k == #Config.Banks[curBank].reqItems[action] then
                    checked = true
                end
            end, v.name, v.amount)
            if checked then
                break
            end
        end
    else
        checked = true
        has_item = true
    end
    while not checked do
        Wait(100)
    end
    return has_item
end

-- Function to remove required items:
function RemoveRequiredItems(action)
    if Config.Banks[curBank].reqItems[action] ~= nil then
        for k,v in pairs(Config.Banks[curBank].reqItems[action]) do
            if v.remove == true then
                math.randomseed(GetGameTimer())
                if math.random(0,100) <= v.chance then
                    TriggerServerEvent('lih_bankrobbery:removeItem', v.name, v.amount)
                end
            end
        end
    end
end

-- Blips:
function CreateBlip(data)
    local blip = nil
    if data.enable then 
        blip = AddBlipForCoord(data.pos.x, data.pos.y, data.pos.z)
		SetBlipSprite (blip, data.sprite)
		SetBlipDisplay(blip, data.display)
		SetBlipScale  (blip, data.scale)
		SetBlipColour (blip, data.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(data.name)
		EndTextCommandSetBlipName(blip)
    end
    return blip
end

-- Event to apply ptfx:
RegisterNetEvent('lih_bankrobbery:particleFxCL')
AddEventHandler('lih_bankrobbery:particleFxCL', function(pos, dict, name)
    lih_LoadPtfxAsset(dict)
    SetPtfxAssetNextCall(dict)
    local offset = vector3(pos.x, pos.y+1.0, pos.z-0.07)
    local ptfx = StartParticleFxLoopedAtCoord(name, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Wait(3000)
    StopParticleFxLooped(ptfx, 0)
end)

-- Event to model swap:
RegisterNetEvent('lih_bankrobbery:modelSwapCL')
AddEventHandler('lih_bankrobbery:modelSwapCL', function(pos, radius, old_model, new_model)
    CreateModelSwap(pos, radius, old_model, new_model, 1)
end)

-- Event to open vault:
RegisterNetEvent('lih_bankrobbery:openVaultCL')
AddEventHandler('lih_bankrobbery:openVaultCL', function(open, id)
    local setHeading = 0
    TriggerEvent('lih_bankrobbery:vaultSound', Config.Banks[id].doors['vault'].pos, Config.Banks[id].doors['vault'].count)
	if doors['vault'].entity ~= nil then
		if DoesEntityExist(doors['vault'].entity) then 
			for i = 1, Config.Banks[id].doors['vault'].count do
				Wait(10)
				local heading = GetEntityHeading(doors['vault'].entity)
				if open then
					if id == 2 then 
						setHeading = (round(heading, 1) + 0.4)
					else
						setHeading = (round(heading, 1) - 0.4)
					end
				else
					if id == 2 then 
					   setHeading = (round(heading, 1) - 0.4)
				  else
						setHeading = (round(heading, 1) + 0.4)
				   end   
				end
				SetEntityHeading(doors['vault'].entity, setHeading)
				-- Sync:
				Config.Banks[id].doors['vault'].setHeading = setHeading
			end
			TriggerServerEvent('lih_bankrobbery:setHeadingSV', id, 'vault', setHeading)
		end
	end
end)

RegisterNetEvent('lih_bankrobbery:vaultSound')
AddEventHandler('lih_bankrobbery:vaultSound', function(pos, count)
    if #(coords - pos) <= 10.0 then
        local newCount = count*0.015
        for i = 1, newCount, 1 do 
            PlaySoundFrontend(-1, "OPENING", "MP_PROPERTIES_ELEVATOR_DOORS" , 1)
            Wait(800)
        end
    end
end)

-- Event to sync vault heading:
RegisterNetEvent('lih_bankrobbery:setHeadingCL')
AddEventHandler('lih_bankrobbery:setHeadingCL', function(id, type, heading)
	Config.Banks[id].doors[type].setHeading = heading
end)

-- Debug:
RegisterCommand('door', function(source, args)
    if Config.Debug then 
		curBank = 1
        --local id = tonumber(args[1])
		TriggerServerEvent('lih_bankrobbery:keypadHackedSV', curBank, 1, true)
		TriggerServerEvent('lih_bankrobbery:CloseBanks', curBank)
        TriggerServerEvent('lih_bankrobbery:openVaultSV', true, 1)
		openVault = true
    end
end, false)

RegisterCommand('open', function(source, args)
    if Config.Debug then 
		curBank = 1
        TriggerServerEvent('lih_bankrobbery:openVaultSV', true, 1)
    end
end, false)

RegisterCommand('ani', function(source, args)
	if Config.Debug then
		TriggerServerEvent('lih_bankrobbery:safeReward', 1, 1)
		--GrabAnim("money")
	end
end, false)

--CSYON GRAB ANIMATION
function GrabAnim(item)
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	-- Standard Model
	local model = "hei_prop_heist_cash_pile"
	local propType = "money" -- Default auf money

	-- PropType basierend auf Item setzen
	if item == "ch_prop_gold_bar_01a" then
		model = "ch_prop_gold_bar_01a"
		propType = "gold"
	elseif item == "ch_prop_vault_dimaondbox_01a" then
		model = "ch_prop_vault_dimaondbox_01a"
		propType = "diamond"
	elseif item == "hei_prop_heist_cash_pile" then
		model = "hei_prop_heist_cash_pile"
		propType = "money"
	end

	local grabmodel = GetHashKey(model)

	RequestModel(grabmodel)
	while not HasModelLoaded(grabmodel) do
		Wait(100)
	end

	local grabobj = CreateObject(grabmodel, pedCoords, true)

	FreezeEntityPosition(grabobj, true)
	SetEntityInvincible(grabobj, true)
	SetEntityNoCollisionEntity(grabobj, ped)
	SetEntityVisible(grabobj, false, false)
	AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 28422), 0.05, 0.0, -0.04, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

	isgrabbing = true
	GrabIt(grabobj)

	if lib.progressCircle({
		duration = Config.ProgressWait,
		useWhileDead = false,
		canCancel = false,
		disable = {
			move = true,
			car = true,
			combat = true,
		},
		anim = {
			dict = 'mp_take_money_mg',
			clip = 'stand_cash_in_bag_loop',
		},
	}) then
		isgrabbing = false
		DeleteObject(grabobj)
		SetModelAsNoLongerNeeded(grabmodel)

		-- Server Event triggern mit korrektem propType
		TriggerServerEvent('lih_bankrobbery:pettyCashReward', curBank, curCashId, propType)
	end
end

function GrabIt(obj)
	CreateThread(function() 
		while isgrabbing do
			Wait(720)
			SetEntityVisible(obj, true, false)
			Wait(720)
			SetEntityVisible(obj, false, false)
		end
	end)
end

-- Police Alert
AddEvent = function(eventname, handler)
    RegisterNetEvent(eventname)
    AddEventHandler(eventname, handler)
end

AddBlip = function(coords, sprite, colour, label, scale, category)
    local blip = AddBlipForCoord(coords)
    if category then
        SetBlipCategory(blip, category)
    end
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale or 1.0)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)

    return blip
end

AddEvent("lih_bankrobbery:alert_police", function(curentBank, robber)
    curBank = curentBank.id
    local blip = AddBlip(Config.Banks[curBank].blip.pos.xyz, 161, 3 ,"Raub im Gange", 2.0)
    PulseBlip(blip)
    --while not ESX do Wait(0) end
        --ESX.ShowNotification("~r~~h~BANKÜBERFALL! ~n~~c~Check die Map.")

    Wait(60*1000)
    RemoveBlip(blip)

end)

RegisterNetEvent('lih_bankrobbery:alarm')
AddEventHandler('lih_bankrobbery:alarm', function(bankpositionreturn)
    if bankpositionreturn then
		alarmpos = bankpositionreturn
		exports['lao_sound']:PlayUrlPos('alarmsound', './sounds/alarm.ogg', 0.3, alarmpos, false)
		exports['lao_sound']:Distance('alarmsound',80)
	end
end)
