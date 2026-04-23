RegisterCommand('su-al', function()
    local itemName = "su"
    local count = 1
    TriggerServerEvent('inventory:addItem', itemName, count)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 289) then 
            
            ExecuteCommand('envanter')
        end
    end
end)
