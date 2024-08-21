ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterUsableItem('scuba_gear', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('tbscuba:start', source)
end)