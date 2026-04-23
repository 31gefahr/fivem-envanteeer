RegisterKeyMapping('envanter', 'Envanter Arayüzünü Aç', 'keyboard', 'F2')


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
