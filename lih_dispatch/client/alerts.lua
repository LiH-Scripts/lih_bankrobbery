RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer

    -- Name vom Server holen
    ESX.TriggerServerCallback('lih_dispatch:getPlayerName', function(name)
        print('[Dispatch] PlayerData loaded: ' .. name)
    end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local function CustomAlert(data)
    local coords = data.coords or vec3(0.0, 0.0, 0.0)
    local job = data.job or nil

    -- Fallbacks für Name, Telefonnummer, Geschlecht
    local senderName = data.name or "Unbekannt Person"
    local senderNumber = data.phone_number or "Unbekannt"
    local senderGender = data.gender or "Unbekannt"

    local dispatchData = {
        uuid = data.uuid or uuid(),
        message = data.message or "", -- Title of the alert
        codeName = data.dispatchCode or "NONE",
        code = data.code or '10-80',
        icon = data.icon or 'fas fa-question',
        priority = data.priority or 2,
        coords = coords,
        gender = senderGender,
        street = GetStreetAndZone(coords),
        camId = data.camId or nil,
        color = data.firstColor or nil,
        callsign = data.unit or nil,
        name = senderName,
        phone_number = senderNumber,
        vehicle = data.model or nil,
        plate = data.plate or nil,
        alertTime = data.alertTime or nil,
        doorCount = data.doorCount or nil,
        automaticGunfire = data.automaticGunfire or false,
        alert = {
            radius = data.radius or 0,
            recipientList = job,
            sprite = data.sprite or 1,
            color = data.color or 1,
            scale = data.scale or 0.5,
            length = data.length or 2,
            sound = data.sound or "Lose_1st",
            sound2 = data.sound2 or "GTAO_FM_Events_Soundset",
            offset = data.offset or "false",
            flash = data.flash or "false"
        },
        jobs = { 'leo' },
    }

    -- Debug: Prüfen, ob alle Infos korrekt gesetzt sind
    print("[Dispatch] Name:", dispatchData.name)
    print("[Dispatch] Nummer:", dispatchData.phone_number)
    print("[Dispatch] Geschlecht:", dispatchData.gender)
    print("[Dispatch] Nachricht:", dispatchData.message)

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('CustomAlert', CustomAlert)

local function VehicleTheft(stolenvehicle)
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(stolenvehicle)
	
	if vehicle.name == "NULL" then
		vehicle.name = "Unbekannt"
	end

    local dispatchData = {
        uuid = uuid(),
        message = locale('vehicletheft'),
        codeName = 'vehicletheft',
        code = '10-35',
        icon = 'fas fa-car-burst',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('VehicleTheft', VehicleTheft)

local function Shooting()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('shooting'),
        codeName = 'shooting',
        code = '10-11',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        gender = GetPlayerGender(),
        weapon = GetWeaponName(),
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('Shooting', Shooting)

local function Hunting()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('hunting'),
        codeName = 'hunting',
        code = '10-13',
        icon = 'fas fa-gun',
        priority = 2,
        weapon = GetWeaponName(),
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('Hunting', Hunting)

local function VehicleShooting()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        uuid = uuid(),
        message = locale('vehicleshots'),
        codeName = 'vehicleshots',
        code = '10-60',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        weapon = GetWeaponName(),
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('VehicleShooting', VehicleShooting)

local function SpeedingVehicle()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        uuid = uuid(),
        message = locale('speeding'),
        codeName = 'speeding',
        code = '10-11',
        icon = 'fas fa-car',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('SpeedingVehicle', SpeedingVehicle)

local function Fight()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('melee'),
        codeName = 'fight',
        code = '10-10',
        icon = 'fas fa-hand-fist',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('Fight', Fight)

local function PrisonBreak(jaillocation)
    local coords = jaillocation

    local dispatchData = {
        uuid = uuid(),
        message = locale('prisonbreak'),
        codeName = 'prisonbreak',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'police', 'usms' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('PrisonBreak', PrisonBreak)

local function StoreRobbery(coords)
    -- Falls keine Koordinaten übergeben werden, nutze Spieler-Position
    if not coords then
        coords = GetEntityCoords(cache.ped)
    end

    local dispatchData = {
        uuid = uuid(),
        message = 'Raubüberfall',
        codeName = 'storerobbery',
        code = '10-97',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = {'police'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('StoreRobbery', StoreRobbery)

RegisterNetEvent('lih_dispatch:client:storerobbery', function(coords)
    StoreRobbery(coords)
end)

-- Funktion für ATM-Raub (in separatem Modul/Datei)
local function AtmRobbery(coords)
    if not coords then
        coords = GetEntityCoords(cache.ped)
    end

    local dispatchData = {
        uuid = uuid(),
        message = 'ATM-Überfall',
        codeName = 'atmrobbery',
        code = '10-97',
        icon = 'fas fa-money-bills',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = {'police'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('AtmRobbery', AtmRobbery)

-- Client-Event, um ATM-Raub auszulösen
RegisterNetEvent('lih_dispatch:client:atmrobbery', function(coords)
    AtmRobbery(coords)
end)

local function FleecaBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('fleecabank'),
        codeName = 'bankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('FleecaBankRobbery', FleecaBankRobbery)

local function PaletoBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('paletobank'),
        codeName = 'paletobankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('PaletoBankRobbery', PaletoBankRobbery)

local function BankRobbery(bankname)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = "Bankraub: " ..bankname,
        codeName = 'bankrobbery',
        code = '10-97',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = {'police'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('BankRobbery', BankRobbery)

local function PawnShopRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = "Pawn Shop Alarmanlage",
        codeName = 'pawnshoprobbery',
        code = '10-97',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = {'police'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('PawnShopRobbery', PawnShopRobbery)

local function VangelicoRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = 'Juwelierüberfall',
        codeName = 'vangelicorobbery',
        code = '10-97',
        icon = 'fas fa-gem',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = {'police'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('VangelicoRobbery', VangelicoRobbery)

RegisterNetEvent('lih_dispatch:client:vangelicorobbery', function()
    VangelicoRobbery()
end)

local function Kocher()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = 'Ein Einwohner meldet beißenden Geruch in der Luft',
        codeName = 'kocher',
        code = '10-13',
        icon = 'fas fa-wind',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = {'police'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('Kocher', Kocher)

local function HouseRobbery(hausnummer, pedcoords)

    local dispatchData = {
        uuid = uuid(),
        message = locale('houserobbery'),
        codeName = 'houserobbery',
        code = '10-90',
        icon = 'fas fa-house',
        priority = 2,
        coords = pedcoords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(pedcoords),
        information = "Hausnummer: " ..hausnummer,
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('HouseRobbery', HouseRobbery)

local function LockPick()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('lockpick'),
        codeName = 'lockpick',
        code = '10-90',
        icon = 'fas fa-house',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        information = "Jemand versucht eine Tür aufzuknacken",
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('LockPick', LockPick)

local function YachtHeist()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('yachtheist'),
        codeName = 'yachtheist',
        code = '10-65',
        icon = 'fas fa-house',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('YachtHeist', YachtHeist)

local function DrugSale()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('drugsell'),
        codeName = 'suspicioushandoff',
        code = '10-13',
        icon = 'fas fa-tablets',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('DrugSale', DrugSale)

local function SuspiciousActivity()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('susactivity'),
        codeName = 'susactivity',
        code = '10-66',
        icon = 'fas fa-tablets',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('SuspiciousActivity', SuspiciousActivity)

local function CarJacking(vehicle)
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(vehicle)

    local dispatchData = {
        uuid = uuid(),
        message = locale('carjacking'),
        codeName = 'carjack',
        code = '10-35',
        icon = 'fas fa-car',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('CarJacking', CarJacking)

local function InjuriedPerson(coords, plyrId)
    --local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = 'Medizinischer Notfall | ID: '..tostring(plyrId),
        codeName = 'civdown',
        code = '10-30',
        icon = 'fas fa-face-dizzy',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = {'ambulance', 'fire'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('InjuriedPerson', InjuriedPerson)

local function DeceasedPerson()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('civbled'),
        codeName = 'civdead',
        code = '10-69',
        icon = 'fas fa-skull',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'ambulance' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('DeceasedPerson', DeceasedPerson)

local function OfficerDown()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('officerdown'),
        codeName = 'officerdown',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.name,
        callsign = PlayerData.callsign,
        jobs = { 'ambulance', 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('OfficerDown', OfficerDown)

local function OfficerInDistress(name, job)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = 'Ein Officer hat seinen Notfallknopf gedrückt.',
        codeName = 'officerdistress',
        code = '11-99',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = name,
        callsign = PlayerData.callsign,
        jobs = {'police', 'prison'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('OfficerInDistress', OfficerInDistress)
RegisterNetEvent("lih_dispatch:client:officerpanic", function(name, job) OfficerInDistress(name, job) end)

local function OfficerPanic(name, job)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = 'Ein Officer hat seinen Notfallknopf ausgelöst!',
        codeName = 'officerpanic',
        code = '11-99',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = name,
        jobs = {'police'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('OfficerPanic', OfficerPanic)

local function OfficerInDistressPrison(name)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('officerdistress'),
        codeName = 'officerdistress',
        code = '11-99',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = name,
        jobs = {'prison'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('OfficerInDistress', OfficerInDistressPrison)
RegisterNetEvent("lih_dispatch:client:officerpanic:prison", function(name) OfficerInDistressPrison(name) end)

local function ambulanceDown()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('ambulancedown'),
        codeName = 'ambulancedown',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = name,
        callsign = PlayerData.metadata["callsign"],
        jobs = { 'amr', 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('ambulanceDown', ambulanceDown)

RegisterNetEvent("lih_dispatch:client:ambulancedown", function() ambulanceDown() end)

local function Explosion()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        uuid = uuid(),
        message = locale('explosion'),
        codeName = 'explosion',
        code = '10-80',
        icon = 'fas fa-fire',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'police' }
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('Explosion', Explosion)

-- Handy Dispatch
-- playerInfo: Table vom Server mit name, phone_number, gender usw.
local function Phone911(message, anonymous, job, sendCoords, phoneNumber, uuid, playerInfo)
    local coords = nil
    
    -- Wenn sendCoords true ist, nutze Player-Position, sonst nil
    if sendCoords == true then
        coords = GetEntityCoords(cache.ped)
    elseif type(sendCoords) == 'table' and sendCoords.x and sendCoords.y then
        -- Wenn Koordinaten direkt übergeben werden
        coords = vec3(sendCoords.x, sendCoords.y, sendCoords.z or 0.0)
    end

    -- Name und Nummer korrekt setzen, anonym falls gewünscht
    local senderName = anonymous and locale('anon') or ((playerInfo and playerInfo.name) or 'Unknown')
    local senderNumber = anonymous and locale('hidden_number') or (playerInfo and playerInfo.phone_number or phoneNumber or 'Unbekannt')
    local senderGender = (playerInfo and playerInfo.gender) or 'Unbekannt'
    
    -- Geschlecht konvertieren (m = Männlich, f = Weiblich)
    if senderGender == 'm' then
        senderGender = 'Männlich'
    elseif senderGender == 'f' then
        senderGender = 'Weiblich'
    end

    local dispatchData = {
        uuid = uuid,
        message = anonymous and locale('anon_call') or locale('call'),
        codeName = '911call',
        code = 'Call',
        icon = 'fas fa-phone',
        priority = 2,
        coords = coords,
        name = senderName,
        number = senderNumber,
        gender = senderGender,
        information = message,
        street = coords and GetStreetAndZone(coords) or nil,
        jobs = job
    }

    Wait(1000)
    print('[Dispatch] Received the export with data.')
    print('[Dispatch] Name: ' .. tostring(dispatchData.name))
    print('[Dispatch] Number: ' .. tostring(dispatchData.number))
    print('[Dispatch] Gender: ' .. tostring(dispatchData.gender))
    print('[Dispatch] Message: ' .. tostring(dispatchData.information))
    print('[Dispatch] Coords: ' .. tostring(coords))

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('Phone911', Phone911)


local function RemovePhone911(uuid)
	TriggerServerEvent('lih_dispatch:server:remove', uuid)
end
exports('RemovePhone911', RemovePhone911)

-- Stromausfall Dispatch
local function stromDispatch()
    local coords = GetEntityCoords(cache.ped) 

    local dispatchData = {
        uuid = uuid(),
        message = 'Elektrizitätswerk', 
        codeName = 'strom',
        code = 'STÖRUNG',
        icon = 'fas fa-bolt',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        callsign = PlayerData.callsign, 
        jobs = {'works'}
    }

    TriggerServerEvent('lih_dispatch:server:notify', dispatchData)
end
exports('stromDispatch', stromDispatch)

RegisterCommand('testDispatch', function()
    AtmRobbery()
end)

function uuid()
    math.randomseed(GetGameTimer()) -- Game-Timer als Seed
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v
        if c == 'x' then
            v = math.random(0, 0xf)
        else
            -- y sollte 8, 9, a oder b sein
            v = math.random(8, 11)
        end
        return string.format('%x', v)
    end)
end