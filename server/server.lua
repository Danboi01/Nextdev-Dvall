RegisterCommand(
    Config.commandName,
    function(source, args, rawCommand)
        if Config.restricCommand and not IsPlayerAceAllowed(source, Config.playerace) then
            notify("You don't have permission to use this command!", 5000, "error")
            return
        end

        local messages = {
            {time = 10000, message = "MASS DV in 30s"},
            {time = 10000, message = "MASS DV in 20s"},
            {time = 10000, message = "MASS DV in 10s"},
            {time = 3000, message = "MASS DV in 3s"},
            {time = 2000, message = "MASS DV in 2s"},
            {time = 1000, message = "MASS DV in 1s"}
        }

        if dvactive then
            notify("Mass DV Already in Progress!", 5000, "info")
            return
        end

        dvactive = true

        Citizen.CreateThread(
            function()
                for _, msg in ipairs(messages) do
                    notify(msg.message, 5000, "success")
                    Wait(msg.time)
                end

                local PN = GetPlayerName(source)
                notify("Executed by " .. PN, 5000, "success")

                TriggerClientEvent("elysium:dvall", -1)

                local PID = source
                local discord = getDiscordID(source)

                dvactive = false
            end
        )
    end
)

function notify(text, time, notifytype)
    if Config.notifySystem == 1 then
        -- codem-notify
        TriggerClientEvent("codem-notification", -1, text, time, "info", {})
    elseif Config.notifySystem == 2 then
        -- t-notify
        TriggerClientEvent(
            "t-notify:client:Custom",
            -1,
            {
                style = notifytype,
                message = text,
                duration = time / 1000
            }
        )
    elseif Config.notifySystem == 3 then
        -- okok-notify
        TriggerClientEvent("okokNotify:Alert", -1, "Notification", text, time / 1000, notifytype)
    elseif Config.notifySystem == 4 then
        -- mythic-notify
        TriggerClientEvent(
            "mythic_notify:client:SendAlert",
            -1,
            {
                type = notifytype,
                text = text,
                length = time / 1000
            }
        )
    else
        print("Invalid notification system selected in config.lua.")
    end
end

function getDiscordID(source)
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            return string.gsub(v, "discord:", "")
        end
    end
    return nil
end
