RegisterKeyMapping('envanter', 'Envanter Arayüzünü Aç', 'keyboard', 'F2')
RegisterKeyMapping('openinv', 'Envanteri Aç', 'keyboard', 'F2')

RegisterCommand('openinv', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local targetInv = "ground" 

    if veh ~= 0 then
        targetInv = "glovebox" 
    else
        local closeVeh = GetClosestVehicle(GetEntityCoords(ped), 3.0, 0, 71)
        if DoesEntityExist(closeVeh) then
           
            SetVehicleDoorOpen(closeVeh, 5, false, false)
            targetInv = "trunk"
        end
    end

   
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = targetInv,
        maxWeight = 100
    })
end)


for i = 1, 5 do
    RegisterKeyMapping('slot_'..i, 'Slot '..i, 'keyboard', tostring(i))
    RegisterCommand('slot_'..i, function()
        TriggerServerEvent('inventory:useHotkey', i)
    end)
end

RegisterCommand('su-al', function()
    local itemName = "su"
    local count = 1
    TriggerServerEvent('inventory:addItem', itemName, count)
end)


RegisterNetEvent('envanter:efektTetikle')
AddEventHandler('envanter:efektTetikle', function(itemName)
    local playerPed = PlayerPedId()

    if itemName == "bandaj" then
        
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MEDIC_TEND_TO_KNOT", 0, true)
        
      
        Citizen.SetTimeout(5000, function()
            ClearPedTasks(playerPed)
            local currentHealth = GetEntityHealth(playerPed)
            SetEntityHealth(playerPed, currentHealth + 20)
            print("Bandaj kullandın, canın yenilendi.")
        end)
        
    elseif itemName == "ekmek" then
        
        print("Yemek yedin, açlığın azaldı.")
       
    end
end)
