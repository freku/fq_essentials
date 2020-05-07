local ESXs = nil
local NOCLIP = false
local freecam = exports.freecam
local CFG = exports['fq_essentials']:getCFG()
local msgCFG = CFG.msg.pl

Citizen.CreateThread(function()
    Citizen.Wait(125)
    ESXs = exports['fq_callbacks']:getServerObject()
end)

RegisterNetEvent('fq:onAuth')
AddEventHandler('fq:onAuth', function()
    msgCFG = CFG.msg[exports['fq_login']:getLang()]
end)

RegisterCommand('settime', function(source, args)
    local h = args[1] or 12
    local m = args[2] or 0
    NetworkOverrideClockTime(h, m, 0)
    sendMessage('[o] Time set to: ' .. h .. 'h and ' .. m .. 'm.')
end)

RegisterCommand('setweather', function(source, args)
    local w = 'EXTRASUNNY'
    SetWeatherTypeNow(w)
    SetWeatherTypeNowPersist(w)
    -- causes a client side crash ??? (with args[1] as arguments)
    sendMessage('[o] weather set to: sunny')
end)

RegisterCommand('vanish', function(source, args) -- p: essentials.command.vanish
    ESXs.TriggerServerCallback('fq:checkPermission', function(hasPermission)
        if not hasPermission then
            sendMessage('no permission')
            return
        end

        TriggerServerEvent('fq:vanishPlayer', args)
        TriggerServerEvent('fq:removePlayerFromGang')
        TriggerEvent('fq:setPlayerInfoNull')
        
		-- RequestModel('a_c_crow')
		
		-- while not HasModelLoaded('a_c_crow') do
		-- 	Wait(5)
        -- end
        
        -- SetPlayerModel(PlayerId(), 'a_c_crow')
        -- SetModelAsNoLongerNeeded('a_c_crow')
    end, 'essentials.command.vanish')
end)

RegisterCommand('noclip', function(source, args) -- p: essentials.command.noclip
    ESXs.TriggerServerCallback('fq:checkPermission', function(hasPermission)
        if not hasPermission then
            sendMessage('no permission')
            return
        end

        NOCLIP = not NOCLIP

        local player = GetPlayerPed(-1)
        
        if NOCLIP == true then
            local pos = GetEntityCoords(player)
            FreezeEntityPosition(player, true)
            SetEntityCollision(player, false, false)
            SetEntityVisible(player, false, false)

            freecam:SetEnabled(true)
            freecam:SetPosition(pos.x, pos.y, pos.z)
        else
            -- SetEntityInvincible(player, false);
            FreezeEntityPosition(player, false)
            SetEntityCollision(player, true, true)
            SetEntityVisible(player, true, false)

            freecam:SetEnabled(false)
        end
        sendMessage('^3Noclip: ' .. (NOCLIP and 'on' or 'off'))
    end, 'essentials.command.noclip')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if NOCLIP then
            if IsDisabledControlPressed(0, 73) then -- X
                ExecuteCommand('noclip')
                NOCLIP = false
            end
        end
    end
end)

AddEventHandler('freecam:onFreecamUpdate', function() 
    local position = freecam:GetPosition()
    local rotation = freecam:GetRotation()
    local player = GetPlayerPed(-1)

    if noclipTarget then
        SetEntityCoordsNoOffset(player, position[1], position[2], position[3], false, false, false)
        SetEntityRotation(player, rotation[1], rotation[2], rotation[3], 0, true)
    end
end)

RegisterCommand('god', function(source, args) -- p: essentials.command.god
    ESXs.TriggerServerCallback('fq:checkPermission', function(hasPermission)
        if not hasPermission then
            sendMessage('no permission')
            return
        end

        local switch = args[1] == 'on' and true or (args[1] == 'off' and false or nil)

        if switch then
            SetPlayerInvincible(PlayerId(), switch)
            sendMessage('^3God mode: '..(switch and 'on' or 'off'))
            SetPedCanRagdoll(GetPlayerPed(-1), switch and true or false) -- LUB ODWROTNIE
        else
            sendMessage('^1Usage: /god <on/off>')
        end
    end, 'essentials.command.god')
end)

RegisterCommand('tp', function(source, args) -- p: essentials.command.tp
    ESXs.TriggerServerCallback('fq:checkPermission', function(hasPermission)
        if not hasPermission then
            sendMessage('no permission')
            return
        end
        
        local blipid = 8
        local blip = GetFirstBlipInfoId(blipid)
        local pos = GetBlipCoords(blip)
    
        exports.spawnmanager:freezePlayer(PlayerId(), true)
        SetPedCoordsKeepVehicle(GetPlayerPed(-1), pos.x, pos.y, pos.z)
        RequestCollisionAtCoord(pos.x, pos.y, pos.z)
    
        while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
            Wait(1)
        end
        exports.spawnmanager:freezePlayer(PlayerId(), false)
    
        local ground, z_pos = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z + 999.0, 1)
        SetPedCoordsKeepVehicle(GetPlayerPed(-1), pos.x, pos.y, z_pos)
    end, 'essentials.command.tp')
end)

RegisterCommand('car', function(source, args) -- p: essentials.command.car
    ESXs.TriggerServerCallback('fq:checkPermission', function(hasPermission)
        local carName = args[1] or 'adder' -- elegy

        if not IsModelInCdimage(carName) or not IsModelAVehicle(carName) then
            sendMessage('Error. Not a car.')
            return
        end
        sendMessage('Requesting model...')

        RequestModel(carName)

        while not HasModelLoaded(carName) do
            Wait(500)
        end

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local car = CreateVehicle(carName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

        SetPedIntoVehicle(playerPed, car, -1)
        -- SetVehicleRadioEnabled(car, false)
        -- SetVehRadioStation(car, 'OFF')
        -- SetUserRadioControlEnabled(false)

        SetEntityAsNoLongerNeeded(car)
        -- Entities marked as no longer needed, will be deleted as the engine sees fit.  
        SetModelAsNoLongerNeeded(carName)
        sendMessage('SUCCESS, car spawned!')
    end, 'essentials.command.car')
end)

RegisterCommand('gun', function(source, args) -- p: essentials.command.gun
    ESXs.TriggerServerCallback('fq:checkPermission', function(hasPermission)
        if args[1] == 'list' then
            sendMessage(table.concat(weapon_names, ', '))
        end
        local ped = GetPlayerPed(-1)
        local hash = GetHashKey(args[1] or "WEAPON_ASSAULTRIFLE")
        local ammo = args[2] or 256
        -- SetWeaponAnimationOverride(ped, 'Superfat')
        
        GiveWeaponToPed(ped, hash, ammo, false, true)
        
        sendMessage('[ gun ] Weapon \'' .. hash .. '\' given with ' .. ammo .. ' ammo.')
    end, 'essentials.command.gun')
end)

RegisterCommand('killme', function(source, args) -- p: essentials.command.killme
    local playerPed = GetPlayerPed(source)
    SetEntityHealth(playerPed, 0.0)
end, false)

RegisterCommand('getpos', function(source, args)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local h = GetEntityHeading(GetPlayerPed(-1))
    TriggerServerEvent('fq:print', "['x']="..pos.x..",['y']="..pos.y..",['z']="..pos.z..'\nh: '..h..'\n')
end, false)

RegisterCommand('debug', function(src, args)
    TriggerEvent("hud:enabledebug")
end)

RegisterNetEvent('fq:sendNotification')
AddEventHandler('fq:sendNotification', function(arg1, arg2, format_args)
    local no
    
    if msgCFG[arg1] then
        if msgCFG[arg1][arg2] then
            if format_args and type(format_args) == 'table' then
                sendNotif(string.format(msgCFG[arg1][arg2], table.unpack(format_args)))
            else
                sendNotif(msgCFG[arg1][arg2])
            end
            no = true
        end
    end

    if not no then
        print('something went wrong on fq:printTranslated ' .. arg1 .. ' | ' .. arg2)
    end
end)
-- fq_ess:222 bad #2 argument fromat (no value)
-- fq_ess:231 fq_player:338 fq_gui:65 nil val arg2
RegisterNetEvent('fq:sendLocalMsg')
AddEventHandler('fq:sendLocalMsg', function(msg)
    TriggerEvent('chat:addMessage', {
        multiline = true,
        args = {msg}
    })
end)

RegisterNetEvent('fq:printTranslated')
AddEventHandler('fq:printTranslated', function(arg1, arg2, format_args)
    local no
    
    if msgCFG[arg1] then
        if msgCFG[arg1][arg2] then
            if format_args and type(format_args) == 'table' then
                sendMessage(string.format(msgCFG[arg1][arg2], table.unpack(format_args)))
            else
                sendMessage(msgCFG[arg1][arg2])
            end
            no = true
        end
    end

    if not no then
        print('something went wrong on fq:printTranslated ' .. arg1 .. ' | ' .. arg2)
    end
end)

function sendNotif(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(true, true)
end

function sendMessage(msg)
    TriggerEvent('chat:addMessage', {
        multiline = true,
        args = { msg }
    })
end
