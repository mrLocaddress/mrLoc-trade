local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent("mrLoc-trade:server:performTrade", function(traderIndex, tradeIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)


    local tradeConfig = Config.Traders[traderIndex]
    local tradeDetails = tradeConfig and tradeConfig.trades[tradeIndex] or nil

    if not Player or not tradeConfig or not tradeDetails then
        return
    end


    local hasJobAccess = false
    if #tradeConfig.jobAccess == 0 then
        hasJobAccess = true
    else
        for _, jobName in ipairs(tradeConfig.jobAccess) do
            if Player.PlayerData.job.name == jobName then
                hasJobAccess = true
                break
            end
        end
    end

    if not hasJobAccess then
        TriggerClientEvent('QBCore:Notify', src, "Bu kişi seninle konuşmuyor.", "error")
        return
    end

    local hasRequiredItem = Player.Functions.GetItemByName(tradeDetails.requiredItem)

    if not hasRequiredItem or hasRequiredItem.amount < tradeDetails.requiredAmount then
        TriggerClientEvent('QBCore:Notify', src, "Yanında yeterli malzeme yok.", "error")
        return
    end

    if Player.Functions.RemoveItem(tradeDetails.requiredItem, tradeDetails.requiredAmount) then
        Player.Functions.AddItem(tradeDetails.receivedItem, tradeDetails.receivedAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tradeDetails.requiredItem], "remove")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tradeDetails.receivedItem], "add")
        
        TriggerClientEvent('QBCore:Notify', src, "Takas başarıyla tamamlandı!", "success")
        TriggerClientEvent('mrLoc-trade:client:playAnimation', src)
    else
        TriggerClientEvent('QBCore:Notify', src, "Envanter hatası, takas iptal edildi.", "error")
    end
end)