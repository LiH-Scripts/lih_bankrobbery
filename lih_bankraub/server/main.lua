ESX = exports["es_extended"]:getSharedObject()

-- Globale Variablen
local cooldowns = {}
local bankStates = {}

-- Initialisiere Bank States
CreateThread(function()
    for i = 1, #Config.Banks do
        bankStates[i] = {
            inUse = false,
            robbable = true,
            cooldownEnd = 0,
            keypadsHacked = {},
            doorsFreeze = {},
            safesRobbed = {},
            safesFailed = {},
            pettyCashRobbed = {}
        }
        
        -- Initialisiere GlobalStates
        GlobalState[GetCurrentResourceName() .. i .. "robbable"] = true
    end
    
    GlobalState.CloseAllBanks = false
end)

-- Timer für Cooldown
RegisterNetEvent('lih_bankrobbery:TimerSV')
AddEventHandler('lih_bankrobbery:TimerSV', function(bankId)
    local src = source
    
    if bankStates[bankId] then
        bankStates[bankId].robbable = false
        bankStates[bankId].cooldownEnd = os.time() + (Config.Cooldown or 3600)
        GlobalState[GetCurrentResourceName() .. bankId .. "robbable"] = false
        
        -- Cooldown Timer
        SetTimeout((Config.Cooldown or 3600) * 1000, function()
            bankStates[bankId].robbable = true
            GlobalState[GetCurrentResourceName() .. bankId .. "robbable"] = true
            print(string.format("Bank %d ist wieder raubbar", bankId))
        end)
    end
end)

-- Bank zurücksetzen
RegisterNetEvent('lih_bankrobbery:ResetCurrentBank')
AddEventHandler('lih_bankrobbery:ResetCurrentBank', function(bankId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer and xPlayer.job.name == 'police' then
        if Config.Banks[bankId] then
            -- Setze alle States zurück
            bankStates[bankId].inUse = false
            bankStates[bankId].keypadsHacked = {}
            bankStates[bankId].doorsFreeze = {}
            bankStates[bankId].safesRobbed = {}
            bankStates[bankId].safesFailed = {}
            bankStates[bankId].pettyCashRobbed = {}
            
            -- Sende Reset an alle Clients
            TriggerClientEvent('lih_bankrobbery:ResetCurrentBankCL', -1, bankId, Config.Banks[bankId])
            
            -- Schließe alle Banken
            GlobalState.CloseAllBanks = false
            
            -- Benachrichtige Polizei
            TriggerClientEvent('esx:showNotification', src, 'Bank wurde zurückgesetzt')
        end
    end
end)

-- Bank Status setzen
RegisterNetEvent('lih_bankrobbery:inUseSV')
AddEventHandler('lih_bankrobbery:inUseSV', function(bankId, state)
    if bankStates[bankId] then
        bankStates[bankId].inUse = state
        TriggerClientEvent('lih_bankrobbery:inUseCL', -1, bankId, state)
    end
end)

-- Keypad gehackt
RegisterNetEvent('lih_bankrobbery:keypadHackedSV')
AddEventHandler('lih_bankrobbery:keypadHackedSV', function(bankId, keypadId, state)
    if bankStates[bankId] then
        bankStates[bankId].keypadsHacked[keypadId] = state
        TriggerClientEvent('lih_bankrobbery:keypadHackedCL', -1, bankId, keypadId, state)
    end
end)

-- Tür Freeze Status
RegisterNetEvent('lih_bankrobbery:doorFreezeSV')
AddEventHandler('lih_bankrobbery:doorFreezeSV', function(bankId, doorId, state)
    if bankStates[bankId] then
        bankStates[bankId].doorsFreeze[doorId] = state
        TriggerClientEvent('lih_bankrobbery:doorFreezeCL', -1, bankId, doorId, state)
    end
end)

-- Safe ausgeraubt
RegisterNetEvent('lih_bankrobbery:safeRobbedSV')
AddEventHandler('lih_bankrobbery:safeRobbedSV', function(bankId, safeId, state)
    if bankStates[bankId] then
        bankStates[bankId].safesRobbed[safeId] = state
        TriggerClientEvent('lih_bankrobbery:safeRobbedCL', -1, bankId, safeId, state)
    end
end)

-- Safe zerstört
RegisterNetEvent('lih_bankrobbery:safeFailedSV')
AddEventHandler('lih_bankrobbery:safeFailedSV', function(bankId, safeId, state)
    if bankStates[bankId] then
        bankStates[bankId].safesFailed[safeId] = state
        TriggerClientEvent('lih_bankrobbery:safeFailedCL', -1, bankId, safeId, state)
    end
end)

-- Petty Cash ausgeraubt
RegisterNetEvent('lih_bankrobbery:pettyCashRobbedSV')
AddEventHandler('lih_bankrobbery:pettyCashRobbedSV', function(bankId, cashId, state)
    if bankStates[bankId] then
        bankStates[bankId].pettyCashRobbed[cashId] = state
        TriggerClientEvent('lih_bankrobbery:pettyCashRobbedCL', -1, bankId, cashId, state)
    end
end)

-- Alle Banken schließen
RegisterNetEvent('lih_bankrobbery:CloseBanks')
AddEventHandler('lih_bankrobbery:CloseBanks', function(bankId)
    GlobalState.CloseAllBanks = true
    
    -- Nach AllCooldown wieder öffnen
    SetTimeout(Config.AllCooldown * 1000, function()
        GlobalState.CloseAllBanks = false
    end)
end)

-- Tresor öffnen
RegisterNetEvent('lih_bankrobbery:openVaultSV')
AddEventHandler('lih_bankrobbery:openVaultSV', function(open, bankId)
    TriggerClientEvent('lih_bankrobbery:openVaultCL', -1, open, bankId)
end)

-- Heading syncen
RegisterNetEvent('lih_bankrobbery:setHeadingSV')
AddEventHandler('lih_bankrobbery:setHeadingSV', function(bankId, doorType, heading)
    TriggerClientEvent('lih_bankrobbery:setHeadingCL', -1, bankId, doorType, heading)
end)

-- Particle Effects
RegisterNetEvent('lih_bankrobbery:particleFxSV')
AddEventHandler('lih_bankrobbery:particleFxSV', function(pos, dict, name)
    TriggerClientEvent('lih_bankrobbery:particleFxCL', -1, pos, dict, name)
end)

-- Model Swap
RegisterNetEvent('lih_bankrobbery:modelSwapSV')
AddEventHandler('lih_bankrobbery:modelSwapSV', function(pos, radius, oldModel, newModel)
    TriggerClientEvent('lih_bankrobbery:modelSwapCL', -1, pos, radius, oldModel, newModel)
end)

-- Alarm Sound
RegisterNetEvent('lih_bankrobbery:alarm_s')
AddEventHandler('lih_bankrobbery:alarm_s', function(alarmpos)
    TriggerClientEvent('lih_bankrobbery:alarm', -1, alarmpos)
end)

-- Items prüfen
ESX.RegisterServerCallback('lih_bankrobbery:getInventoryItem', function(source, cb, itemName, itemAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        local item = xPlayer.getInventoryItem(itemName)
        
        if item and item.count >= itemAmount then
            cb(true, item)
        else
            cb(false, item)
        end
    else
        cb(false, nil)
    end
end)

-- Item entfernen
RegisterNetEvent('lih_bankrobbery:removeItem')
AddEventHandler('lih_bankrobbery:removeItem', function(itemName, itemAmount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        xPlayer.removeInventoryItem(itemName, itemAmount)
    end
end)

-- Safe Belohnung
RegisterNetEvent('lih_bankrobbery:safeReward')
AddEventHandler('lih_bankrobbery:safeReward', function(bankId, safeId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer and Config.Banks[bankId] and Config.Banks[bankId].safes[safeId] then
        local reward = Config.Banks[bankId].safes[safeId].reward
        
        if reward then
            if reward.type == 'item' then
                local amount = math.random(reward.min or 1, reward.max or 1)
                xPlayer.addInventoryItem(reward.name, amount)
                TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~b~%dx %s ~s~erhalten', amount, reward.name))
            elseif reward.type == 'money' then
                local amount = math.random(reward.min or 1000, reward.max or 5000)
                if reward.account == 'black_money' then
                    xPlayer.addAccountMoney('black_money', amount)
                    TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~g~$%d Schwarzgeld ~s~erhalten', amount))
                else
                    xPlayer.addMoney(amount)
                    TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~y~$%d ~s~erhalten', amount))
                end
            end
        end
    end
end)

-- Petty Cash Belohnung
RegisterNetEvent('lih_bankrobbery:pettyCashReward')
AddEventHandler('lih_bankrobbery:pettyCashReward', function(bankId, cashId, propType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    if Config.Banks[bankId] and Config.Banks[bankId].pettyCash[cashId] then
        local pettyCash = Config.Banks[bankId].pettyCash[cashId]
        
        -- FORMAT 1: reward System (Fleeca Banken)
        if pettyCash.reward then
            local reward = pettyCash.reward
            local amount = math.random(reward.min or 500, reward.max or 2000)
            
            if reward.dirty then
                xPlayer.addAccountMoney('black_money', amount)
                TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~g~$%d Schwarzgeld ~s~erhalten', amount))
            else
                xPlayer.addMoney(amount)
                TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~y~$%d ~s~erhalten', amount))
            end
            
        -- FORMAT 2: items + cash System (Nationalbank)
        elseif pettyCash.items or pettyCash.cash then
            
            -- Items mit Chance System vergeben
            if pettyCash.items and #pettyCash.items > 0 then
                for _, itemData in ipairs(pettyCash.items) do
                    math.randomseed(GetGameTimer() + _)
                    local roll = math.random(1, 100)
                    
                    if roll <= itemData.chance then
                        local amount = math.random(itemData.amount.min, itemData.amount.max)
                        xPlayer.addInventoryItem(itemData.name, amount)
                        TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~b~%dx %s ~s~erhalten', amount, itemData.name))
                    end
                end
            end
            
            -- Cash vergeben (falls aktiviert) - nur, wenn propType money
            if pettyCash.cash and pettyCash.cash.enable and propType == "money" then
                local cashAmount = math.random(pettyCash.cash.min, pettyCash.cash.max)
                xPlayer.addAccountMoney('black_money', cashAmount)
                TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~g~$%d Schwarzgeld ~s~erhalten', cashAmount))
            end
            
        -- FORMAT 3: FALLBACK - Basierend auf propType
        elseif propType then
            local pt = string.lower(propType)
            if pt == "gold" then
                local amount = math.random(15, 30)
                xPlayer.addInventoryItem('gold', amount)
                TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~b~%dx Gold ~s~erhalten', amount))
            elseif pt == "diamond" then
                local amount = math.random(1, 3)
                xPlayer.addInventoryItem('diamond', amount)
                TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~b~%dx Diamanten ~s~erhalten', amount))
            elseif pt == "money" then
                local amount = math.random(80000, 200000)
                xPlayer.addAccountMoney('black_money', amount)
                TriggerClientEvent('esx:showNotification', src, string.format('Du hast ~g~$%d Schwarzgeld ~s~erhalten', amount))
            end
        end
    else
        print(string.format("^1[ERROR] Bank %d oder pettyCash %d nicht gefunden!^7", bankId, cashId))
    end
end)


-- Polizei Alert
RegisterNetEvent('lih_bankrobbery:alert_police')
AddEventHandler('lih_bankrobbery:alert_police', function(bankData)
    local src = source
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    
    for _, xPlayer in pairs(xPlayers) do
        TriggerClientEvent('lih_bankrobbery:alert_police', xPlayer.source, bankData, src)
    end
end)

-- Debug Commands
if Config.Debug then
    RegisterCommand('resetbank', function(source, args)
        local bankId = tonumber(args[1]) or 1
        
        if Config.Banks[bankId] then
            bankStates[bankId].inUse = false
            bankStates[bankId].robbable = true
            bankStates[bankId].keypadsHacked = {}
            bankStates[bankId].doorsFreeze = {}
            bankStates[bankId].safesRobbed = {}
            bankStates[bankId].safesFailed = {}
            bankStates[bankId].pettyCashRobbed = {}
            
            GlobalState[GetCurrentResourceName() .. bankId .. "robbable"] = true
            GlobalState.CloseAllBanks = false
            
            TriggerClientEvent('lih_bankrobbery:ResetCurrentBankCL', -1, bankId, Config.Banks[bankId])
            
            print(string.format("Bank %d wurde zurückgesetzt", bankId))
        end
    end, true)
    
    RegisterCommand('bankstatus', function(source, args)
        local bankId = tonumber(args[1]) or 1
        
        if bankStates[bankId] then
            print(json.encode(bankStates[bankId], {indent = true}))
        end
    end, true)
end

-- Server Callback für Polizisten-Anzahl
ESX.RegisterServerCallback('lih_bankrobbery:getPoliceCount', function(source, cb)
    local policeCount = 0
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    
    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.job.name == 'police' then
            policeCount = policeCount + 1
        end
    end
    
    cb(policeCount)
end)

print('^2[Bank Robbery]^7 Server erfolgreich gestartet')