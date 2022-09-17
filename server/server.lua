local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("ladder", function(source, item)
  local Player = QBCore.Functions.GetPlayer(source)
  if Player.Functions.RemoveItem(item.name, 1, item.slot) then
    TriggerClientEvent('pp2-ladder:client:spawnLadder', source)
  end
end)

RegisterNetEvent('pp2-ladder:server:storeLadder', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('ladder', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['ladder'], 'add')
end)
