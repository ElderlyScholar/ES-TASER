local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("ES-Taser:server:PlayAudio", function(players, audio)
    for k, v in pairs(players) do
        TriggerClientEvent("ES-Taser:client:PlayAudio", v, audio)
    end
end)

RegisterServerEvent('ES-Taser:server:BarbPull', function(BarbId)
    TriggerClientEvent('ES-Taser:client:Reset', source)
    TriggerClientEvent('QBCore:Notify', BarbId, "Ouch The Barbs Ripped Out", "error")
end)

RegisterServerEvent("ES-Taser:server:ReEngage", function(BarbId)
    TriggerClientEvent('ES-Taser:client:GetTased', BarbId)
end)
