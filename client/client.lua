local QBCore = exports['qb-core']:GetCoreObject()
local ClimbingVectors = {
  up = {
      {vector3(0.0, -0.45, -1.1), 'laddersbase', 'get_on_bottom_front_stand_high'},
      {vector3(0.0, -0.3, -0.7), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.3, -0.3), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.3, 0.1), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.3, 0.5), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.3, 0.9), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.3, 1.3), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.3, 1.7), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.3, 2.1), 'laddersbase', 'climb_up'},
      {vector3(0.0, -0.4, 2.5), 'laddersbase', 'get_off_top_back_stand_left_hand'}
  },

  down = {
      {vector3(0.0, -0.4, 2.5), 'laddersbase', 'get_on_top_front'},
      {vector3(0.0, -0.3, 2.1), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.3, 1.7), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.3, 1.3), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.3, 0.9), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.3, 0.5), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.3, 0.1), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.3, -0.3), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.3, -0.7), 'laddersbase', 'climb_down'},
      {vector3(0.0, -0.45, -1.1), 'laddersbase', 'get_off_bottom_front_stand'}
  }
}

local attachedLadder = false

local models = {
  'prop_byard_ladder01',
}

local function adjustLadder(Ladder)
  QBCore.Functions.Progressbar("adjustLadder", "adjusting ladder", 1000, false, false, {
    disableMovement = true,
    disableCarMovement = true,
    disableMouse = true,
    disableCombat = true,
  }, {
      animDict = "mini@repair",
      anim = "fixing_a_player",
      flags = 49,
  }, {}, {}, function()
    if DoesEntityExist(Ladder) then
      local PlayerPed = PlayerPedId()
      local PlayerRot = GetEntityRotation(PlayerPed)
      local LadderCoords = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 1.0, 0.9)
      SetEntityCoords(Ladder, LadderCoords)
      SetEntityRotation(Ladder, vector3(PlayerRot.x - 10.0, PlayerRot.y, PlayerRot.z))
      ApplyForceToEntity(Ladder, 0.0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
    end
  end, function()
  end)
end

local function LoadThaAnim(dict)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
      Citizen.Wait(0)
  end
  return true
end

local function RemoveLadderFromScene(entity)
  NetworkRegisterEntityAsNetworked(entity)
  Wait(100)
  NetworkRequestControlOfEntity(entity)
  SetEntityAsMissionEntity(entity)
  Wait(100)
  DeleteEntity(entity)
end

local function pickupLadder(Ladder)
  local playerPed = PlayerPedId()
  local hasItem = QBCore.Functions.HasItem('ladder')
  if not hasItem then
    NetworkRequestControlOfEntity(Ladder)
    LoadThaAnim('anim@mp_snowball')
    TaskPlayAnim(playerPed, 'anim@mp_snowball', 'pickup_snowball', 8.0, 8.0, -1, 48, 1, false, false, false)
    TriggerServerEvent('pp2-ladder:server:storeLadder')
    RemoveLadderFromScene(Ladder)
    Wait(1000)
  else
    QBCore.Functions.Notify('You already have a ladder on you.', 'error', 5000)
  end
end

local function climbLadder(Ladder, Direction)
  local PlayerPed = PlayerPedId()
  if not HasAnimDictLoaded('laddersbase') then
    RequestAnimDict('laddersbase')
    while not HasAnimDictLoaded('laddersbase') do Citizen.Wait(100) end
  end

  ClearPedTasksImmediately(PlayerPed)
  FreezeEntityPosition(PlayerPed, true)
  SetEntityCollision(Ladder, false, true)

  for Dir, Pack in pairs(ClimbingVectors) do
      if Direction == Dir then
          for _, Element in pairs(Pack) do
              SetEntityCoordsNoOffset(PlayerPed, GetOffsetFromEntityInWorldCoords(Ladder, Element[1]), false, false, false)
              TaskPlayAnim(PlayerPed, Element[2], Element[3], 2.0, 0.0, -1, 15, 0, false, false, false)

              Citizen.Wait(850)
          end
      end
  end

  if Direction == 'up' then
      SetEntityCoordsNoOffset(PlayerPed, GetOffsetFromEntityInWorldCoords(Ladder, 0.0, 0.5, 4.0), false, false, false)
  elseif Direction == 'down' then
      SetEntityCoordsNoOffset(PlayerPed, GetOffsetFromEntityInWorldCoords(Ladder, 0.0, -1, 0), false, false, false)
  end

  ClearPedTasksImmediately(PlayerPed)
  FreezeEntityPosition(PlayerPed, false)
  SetEntityCollision(Ladder, true, true)

end

RegisterNetEvent('pp2-ladder:client:climbLadder', function(args)
  climbLadder(args.entity, 'up')
end)

RegisterNetEvent('pp2-ladder:client:climbDownLadder', function(args)
  climbLadder(args.entity, 'down')
end)

RegisterNetEvent('pp2-ladder:client:adjustLadder', function(args)
  adjustLadder(args.entity)
end)

RegisterNetEvent('pp2-ladder:client:pickupLadder', function(args)
  pickupLadder(args.entity)
end)

RegisterNetEvent('pp2-ladder:client:showLadderOptions', function(entity)
  local ladderMenu = {
    {
      header = 'Climb up',
      icon = "fa-solid fa-arrow-up",
      params = {
        event = 'pp2-ladder:client:climbLadder',
        args = {
          entity = entity
        }
      },
    },
    {
      header = 'Climb down',
      icon = "fa-solid fa-arrow-down",
      params = {
        event = 'pp2-ladder:client:climbDownLadder',
        args = {
          entity = entity
        }
      },
    },
    {
      header = 'Adjust',
      icon = "fa-solid fa-hand",
      params = {
        event = 'pp2-ladder:client:adjustLadder',
        args = {
          entity = entity
        }
      },
    },
    {
      header = 'Pick up',
      icon = "fa-solid fa-download",
      params = {
        event = 'pp2-ladder:client:pickupLadder',
        args = {
          entity = entity
        }
      },
    },
  }
  exports['qb-menu']:openMenu(ladderMenu)
end)

RegisterNetEvent('pp2-ladder:client:spawnLadder', function()
  local PlayerPed = PlayerPedId()
  local Ladder = CreateObjectNoOffset(GetHashKey('prop_byard_ladder01'), GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 1.0, 0.9), true, false, false)
  local PlayerRot = GetEntityRotation(PlayerPed)
  SetEntityRotation(Ladder, vector3(PlayerRot.x - 10.0, PlayerRot.y, PlayerRot.z))
  local LadderNetID = ObjToNet(Ladder)

  SetEntityAsMissionEntity(LadderNetID)
  adjustLadder(Ladder)
end)

exports['qb-target']:AddTargetModel(models, {
	options = {
		{
      label = 'Ladder options',
      targeticon = 'fa-solid fa-route', 
      icon = 'fa-solid fa-play',
      action = function(entity)
        if IsPedAPlayer(entity) then return false end
        TriggerEvent('pp2-ladder:client:showLadderOptions', entity)
      end,
		},
	},
	distance = 2.0,
})

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	while true do
		Wait(100)
		if Config.EnableAttach then
      local hasItem = QBCore.Functions.HasItem('ladder')
      if hasItem and not attachedLadder then
        local Ladder = CreateObjectNoOffset(GetHashKey('prop_byard_ladder01'), GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, -1.0, 0.9), true, false, false)
        AttachEntityToEntity(Ladder, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), 0.50, -0.25, 0.0, 10.0, 90.0, 0.0, false, false, false, false, 2, true)
        attachedLadder = Ladder
      elseif not hasItem and attachedLadder then
        RemoveLadderFromScene(attachedLadder)
        attachedLadder = false
      end
    end
	end
end)
