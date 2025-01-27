RegisterCommand(Config.commandName, function(source, args, rawCommand)
    TriggerClientEvent("elysium:dvall", -1)
end, Config.restricCommand)

function notify(text, source, time, notifytype)
    if Config.notifySystem == 1 then
        -- codem-notify
        TriggerClientEvent('codem-notification', -1, text, time, notifytype, {})
    elseif Config.notifySystem == 2 then
        -- t-notify
        TriggerClientEvent('t-notify:client:Custom', -1, {
            style = notifytype,
            message = text,
            duration = time / 1000 -- Convert milliseconds to seconds
        })
    elseif Config.notifySystem == 3 then
        -- okok-notify
        TriggerClientEvent('okokNotify:Alert', -1, "Notification", text, time / 1000, notifytype)
    elseif Config.notifySystem == 4 then
        -- mythic-notify
        TriggerClientEvent('mythic_notify:client:SendAlert', -1, {
            type = notifytype,
            text = text,
            length = time / 1000 -- Convert milliseconds to seconds
        })
    else
        print("Invalid notification system selected in config.lua.")
    end
end

RegisterCommand("dvall", function(source, args, rawCommand)
    -- Notify players about the vehicle clearing process
    notify("A staff team has initiated a clearing of all unoccupied vehicles.", -1, 5000, "info")
    notify("Clearing all unoccupied vehicles in 15 seconds.", -1, 5000, "info")
    
    Citizen.SetTimeout(5000, function()
        notify("Clearing all unoccupied vehicles in 10 seconds.", -1, 5000, "info")
    end)
    
    Citizen.SetTimeout(10000, function()
        notify("Clearing all unoccupied vehicles in 5 seconds.", -1, 5000, "info")
    end)
    
    Citizen.SetTimeout(15000, function()
        notify("All unoccupied vehicles have been deleted!", -1, 5000, "success")
        TriggerClientEvent("elysium:dvall", -1)
    end)
end, Config.restricCommand)
