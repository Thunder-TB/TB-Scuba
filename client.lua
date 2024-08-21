ESX = exports["es_extended"]:getSharedObject()

local isScubaEquipped = false

RegisterNetEvent('tbscuba:start')
AddEventHandler('tbscuba:start', function(gender)
    local playerPed = PlayerPedId()

    if not isScubaEquipped then

        while not HasAnimDictLoaded("clothingtie") do
            RequestAnimDict("clothingtie")
            Citizen.Wait(100)
        end

        TaskPlayAnim(playerPed, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 51, 0, false, false, false)
        Citizen.Wait(1800)

        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 0 then
                if Config.Uniforms.male ~= nil then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
                end
            else
                if Config.Uniforms.female ~= nil then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
                end
            end
        end)

        SetEnableScuba(playerPed, true)
        SetPedMaxTimeUnderwater(playerPed, Config.oxygenLevel)

        isScubaEquipped = true

        Citizen.CreateThread(function()
            while isScubaEquipped do
                Citizen.Wait(0)

                if IsPedSwimmingUnderWater(playerPed) then
                    local oxygenLevel = GetPlayerUnderwaterTimeRemaining(PlayerId())

                    DrawTextOnScreen(0.9, 0.9, 0.3, string.format("Oxygen: %.2f", oxygenLevel))

                    if oxygenLevel <= 0 then
                        ApplyDamageToPed(playerPed, 10, false)
                    end
                end
            end
        end)

    else
        ClearPedTasks(playerPed)
        ResetPedVisibleDamage(playerPed)

        SetEnableScuba(playerPed, false)
        SetPedMaxTimeUnderwater(playerPed, 1.0)

        isScubaEquipped = false

        TriggerEvent('skinchanger:getSkin', function(skin)
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, hasSkin)
                if hasSkin then
                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end
            end)
        end)

    end
end)

function DrawTextOnScreen(x, y, scale, text)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
