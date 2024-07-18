local QBCore = exports['qb-core']:GetCoreObject()
local BarbEntity = nil
local BarbId = nil
local taserHash = GetHashKey("weapon_stungun")

-------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------

function GetPlayersWithin5M()
    local playersInRange = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)
        if distance <= 5.0 then
            local serverId = GetPlayerServerId(playerId)
            table.insert(playersInRange, serverId)
        end
    end

    return playersInRange
end

-------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------

RegisterNetEvent("ES-Taser:client:GetTased", function()
    SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, true, true, false);
end)

RegisterNetEvent("ES-Taser:client:Reset", function()
    BarbEntity = nil
    BarbId = nil
    QBCore.Functions.Notify("The Barbs Ripped Out", "error")
end)

RegisterNetEvent("ES-Taser:client:PlayAudio", function(audio)
    SendNUIMessage({
        type = "playsound",
        transactionFile = audio
    })
end)

-------------------------------------------------------------------------
-- Pull Loop
-------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if BarbEntity ~= nil then
            sleep = 0
            local ped = PlayerPedId()
            local dist = #(GetEntityCoords(BarbEntity) - GetEntityCoords(ped))
            if dist >= Config.BarbPullLength then
                TriggerServerEvent('ES-Taser:server:BarbPull', BarbId)
                BarbEntity = nil
                BarbId = nil
            end
        end
        Wait(sleep)
    end
end)

-------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------

RegisterCommand("taserSend", function()
    local ped = PlayerPedId()
    local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
    local weapon = GetSelectedPedWeapon(ped)

    if weapon == taserHash then
        local players = GetPlayersWithin5M()
        Wait(50)
        TriggerServerEvent("ES-Taser:server:PlayAudio", players, "taser")
    end

    if IsEntityAPed(entity) then
        if IsPedAPlayer(entity) then
            if weapon == taserHash then
                BarbId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                BarbEntity = entity
            end
        end
    end
end, false)

RegisterCommand("taserReEngage", function()
    if BarbEntity ~= nil and BarbId ~= nil then
        TriggerServerEvent('ES-Taser:server:ReEngage', BarbId)
        QBCore.Functions.Notify("You ReEngaged Your Taser", "success")
        local players = GetPlayersWithin5M()
        TriggerServerEvent("ES-Taser:server:PlayAudio", players, "reactivate")
    end
end, false)

RegisterKeyMapping('taserReEngage', 'Allows Taser To ReEngage', 'keyboard', Config.ReEngageKey)
RegisterKeyMapping('taserSend', 'Trigger For The Taser (Dont Change!!!)', 'mouse_button', 'mouse_left')
