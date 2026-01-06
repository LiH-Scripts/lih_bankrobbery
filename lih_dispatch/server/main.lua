local ESX = exports['es_extended']:getSharedObject()
local calls = {}
local callId = 0

-- Helper Functions
local function generateCallId()
    callId = callId + 1
    return callId
end

local function getPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        return xPlayer.identifier
    end
    return nil
end

local function isJobAllowed(source, jobs)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    
    if type(jobs) == "string" then
        return xPlayer.job.name == jobs
    elseif type(jobs) == "table" then
        for _, job in pairs(jobs) do
            if xPlayer.job.name == job then
                return true
            end
        end
    end
    return false
end

local function getOnlineJobPlayers(jobs)
    local players = {}
    local xPlayers = ESX.GetExtendedPlayers()
    
    for _, xPlayer in pairs(xPlayers) do
        if type(jobs) == "string" then
            if xPlayer.job.name == jobs then
                table.insert(players, xPlayer.source)
            end
        elseif type(jobs) == "table" then
            for _, job in pairs(jobs) do
                if xPlayer.job.name == job then
                    table.insert(players, xPlayer.source)
                    break
                end
            end
        end
    end
    
    return players
end

-- Create Dispatch Call
function CreateDispatchCall(data)
    if not data.coords then return end
    if not data.jobs then return end
    
    local id = generateCallId()
    local callData = {
        id = id,
        uuid = data.uuid or 'unknown',
        code = data.code or '10-00',
        codeName = data.codeName or 'generic',
        message = data.message or 'Unknown Incident',
        coords = data.coords,
        jobs = data.jobs,
        gender = data.gender or 'Unbekannt',
        name = data.name or 'Unbekannt',
        alertTime = data.alertTime or Config.AlertTime,
        blip = data.blip or {},
        sprite = data.sprite,
        color = data.color,
        scale = data.scale,
        length = data.length,
        radius = data.radius,
        offset = data.offset,
        sound = data.sound,
        sound2 = data.sound2,
        flash = data.flash,
        units = {},
        timestamp = os.time(),
        street = data.street,
        area = data.area,
        number = data.number,
        vehicle = data.vehicle,
        plate = data.plate,
        heading = data.heading,
        description = data.description,
        priority = data.priority or 'normal',
    }
    
    table.insert(calls, callData)
    
    -- Notify all relevant job players
    local players = getOnlineJobPlayers(data.jobs)
    for _, playerId in pairs(players) do
        TriggerClientEvent('lih_dispatch:client:notify', playerId, callData)
    end
    
    return id
end

exports('CreateDispatchCall', CreateDispatchCall)

-- Server Events
RegisterNetEvent('lih_dispatch:server:notify', function(data)
    CreateDispatchCall(data)
end)

RegisterNetEvent('lih_dispatch:server:attachSelf', function(callId, playerData)
    local source = source
    
    for i, call in ipairs(calls) do
        if call.id == callId then
            local alreadyAttached = false
            
            for _, unit in ipairs(call.units) do
                if unit.playerid == playerData.playerid then
                    alreadyAttached = true
                    break
                end
            end
            
            if not alreadyAttached then
                table.insert(calls[i].units, playerData)
                
                -- Notify all relevant job players about the update
                local players = getOnlineJobPlayers(call.jobs)
                for _, playerId in pairs(players) do
                    local updatedCalls = {}
                    for _, c in ipairs(calls) do
                        if isJobAllowed(playerId, c.jobs) then
                            table.insert(updatedCalls, c)
                        end
                    end
                    TriggerClientEvent('lih_dispatch:client:openMenu', playerId, updatedCalls)
                end
            end
            break
        end
    end
end)

RegisterNetEvent('lih_dispatch:server:detachSelf', function(callId, playerData)
    local source = source
    
    for i, call in ipairs(calls) do
        if call.id == callId then
            for j, unit in ipairs(call.units) do
                if unit.playerid == playerData.playerid then
                    table.remove(calls[i].units, j)
                    break
                end
            end
            
            -- Notify all relevant job players about the update
            local players = getOnlineJobPlayers(call.jobs)
            for _, playerId in pairs(players) do
                local updatedCalls = {}
                for _, c in ipairs(calls) do
                    if isJobAllowed(playerId, c.jobs) then
                        table.insert(updatedCalls, c)
                    end
                end
                TriggerClientEvent('lih_dispatch:client:openMenu', playerId, updatedCalls)
            end
            break
        end
    end
end)

RegisterNetEvent('lih_dispatch:server:remove', function(uuid)
    for i, call in ipairs(calls) do
        if call.uuid == uuid then
            table.remove(calls, i)
            break
        end
    end
end)

RegisterNetEvent('lih_dispatch:server:removeCall', function(callId)
    local source = source
    
    for i, call in ipairs(calls) do
        if call.id == callId then
            table.remove(calls, i)
            break
        end
    end
end)

-- Callbacks
lib.callback.register('lih_dispatch:callback:getCalls', function(source)
    local filteredCalls = {}
    
    for _, call in ipairs(calls) do
        if isJobAllowed(source, call.jobs) then
            table.insert(filteredCalls, call)
        end
    end
    
    return filteredCalls
end)

lib.callback.register('lih_dispatch:callback:getLatestDispatch', function(source)
    local latestCall = nil
    local latestTime = 0
    
    for _, call in ipairs(calls) do
        if isJobAllowed(source, call.jobs) then
            if call.timestamp > latestTime then
                latestTime = call.timestamp
                latestCall = call
            end
        end
    end
    
    return latestCall
end)

-- Commands (Admin/Debug)
if Config.Debug then
    RegisterCommand('testdispatch', function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        
        local coords = GetEntityCoords(GetPlayerPed(source))
        
        CreateDispatchCall({
            code = '10-31',
            codeName = 'storerobbery',
            message = 'Store Robbery in Progress',
            coords = coords,
            jobs = {'police'},
            gender = 'male',
            alertTime = 5,
            priority = 'high',
        })
    end, true)
    
    RegisterCommand('cleardispatch', function(source, args)
        calls = {}
        print('[lih_dispatch] All calls cleared')
    end, true)
end

-- Auto-cleanup old calls (older than 30 minutes)
CreateThread(function()
    while true do
        Wait(300000) -- Check every 5 minutes
        
        local currentTime = os.time()
        local removedCount = 0
        
        for i = #calls, 1, -1 do
            if (currentTime - calls[i].timestamp) > 1800 then -- 30 minutes
                table.remove(calls, i)
                removedCount = removedCount + 1
            end
        end
        
        if removedCount > 0 then
            print(('[lih_dispatch] Auto-cleanup: Removed %d old calls'):format(removedCount))
        end
    end
end)

print('^2[lih_dispatch]^0 Server started successfully')

ESX.RegisterServerCallback('lih_dispatch:getPlayerName', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb(xPlayer.getName()) -- getName() gibt den DB-Namen zurück
    else
        cb("Unbekannt")
    end
end)