local QBCore = exports['qb-core']:GetCoreObject()
local spawnedNpcs = {}

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function setupNpcs()
    for i, trader in ipairs(Config.Traders) do
        RequestModel(GetHashKey(trader.npcModel))
        while not HasModelLoaded(GetHashKey(trader.npcModel)) do
            Wait(50)
        end

        local npc = CreatePed(4, GetHashKey(trader.npcModel), trader.coords.x, trader.coords.y, trader.coords.z - 1.0, trader.coords.w, false, true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        
        table.insert(spawnedNpcs, {
            entity = npc,
            text = trader.drawText,
            coords = trader.coords
        })

        local targetOptions = {}
        for j, trade in ipairs(trader.trades) do
            table.insert(targetOptions, {
                icon = "fas fa-exchange-alt",
                label = trade.label,
                action = function()
                    TriggerServerEvent("mrLoc-trade:server:performTrade", i, j)
                end,
                canInteract = function()
                    local pData = QBCore.Functions.GetPlayerData()
                    if not pData or not pData.job then return false end
                    if #trader.jobAccess == 0 then return true end
                    for _, jobName in pairs(trader.jobAccess) do
                        if pData.job.name == jobName then return true end
                    end
                    return false
                end
            })
        end

        exports['qb-target']:AddTargetEntity(npc, {
            options = targetOptions,
            distance = 2.5
        })
    end
end

CreateThread(function()
    while not QBCore do
        Wait(100)
        QBCore = exports['qb-core']:GetCoreObject()
    end
    setupNpcs()
end)

CreateThread(function()
    while true do
        local sleep = 1000 -- Varsayılan bekleme süresi
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, npcData in ipairs(spawnedNpcs) do
            if DoesEntityExist(npcData.entity) then
                local distance = #(playerCoords - npcData.coords.xyz)
                
                if distance < 10.0 then
                    sleep = 5 
                    DrawText3D(npcData.coords.x, npcData.coords.y, npcData.coords.z + 1.0, npcData.text)
                end
            end
        end
        Wait(sleep)
    end
end)


RegisterNetEvent('mrLoc-trade:client:playAnimation', function()
    local playerPed = PlayerPedId()
    local animDict = Config.Animation.dict
    local animName = Config.Animation.name
    local duration = Config.Animation.duration

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(50)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, duration, 0, 0, false, false, false)
    Wait(duration)
    ClearPedTasks(playerPed)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, npcData in ipairs(spawnedNpcs) do
            if DoesEntityExist(npcData.entity) then
                DeleteEntity(npcData.entity)
            end
        end
    end
end)