local zone_list = {
    {['x']=499.04376220703,['y']=-1512.9654541016,['z']=28.538991928101,['w']=250.0,['h']=250.0},
    {['x']=-824.62902832031,['y']=-963.63067626953,['z']=12.764931678772,['w']=195.0,['h']=300.0},
    {['x']=168.01901245117,['y']=247.40588378906,['z']=109.15989685059,['w']=375.0,['h']=175.0},
    {['x']=399.90151977539,['y']=-743.51171875,['z']=28.702693939209,['w']=255.0,['h']=225.0},
    {['x']=-89.423370361328,['y']=-1510.9730224609,['z']=28.621269226074,['w']=275.0,['h']=250.0},
    {['x']=-1395.5888671875,['y']=-952.41497802734,['z']=10.599880218506,['w']=100.0,['h']=200.0},
    {['x']=-9.2267608642578,['y']=-1046.4252929688,['z']=28.799871444702,['w']=130.0,['h']=200.0},
    {['x']=-73.489959716797,['y']=-188.14556884766,['z']=57.449371337891,['w']=80.0,['h']=250.0},
    {['x']=369.96319580078,['y']=-1850.2668457031,['z']=21.309028625488,['w']=355.0,['h']=400.0},
    {['x']=-1023.4438476563,['y']=-1223.9415283203,['z']=5.6796216964722,['w']=255.0,['h']=200.0},
    {['x']=165.09051513672,['y']=-937.50079345703,['z']=30.013271331787,['w']=205.0,['h']=350.0},
    {['x']=71.482719421387,['y']=-186.75036621094,['z']=46.088119506836,['w']=195.0,['h']=250.0},
    {['x']=399.75637817383,['y']=-987.83319091797,['z']=28.737812042236,['w']=250.0,['h']=250.0},
    {['x']=913.09802246094,['y']=-1802.1789550781,['z']=30.574312210083,['w']=310.0,['h']=400.0},
    {['x']=775.09802246094,['y']=-2115.1789550781,['z']=30.574312210083,['w']=150.0,['h']=200.0},
    {['x']=515.83959960938,['y']=-1273.8714599609,['z']=28.55891418457,['w']=200.0,['h']=200.0},
    {['x']=-1210.5338134766,['y']=-1453.55078125,['z']=3.9166333675385,['w']=325.0,['h']=250.0},
    {['x']=-1255.2796630859,['y']=-1221.6864013672,['z']=3.3814189434052,['w']=200.0,['h']=200.0},
    {['x']=211.96319580078,['y']=-1512.2668457031,['z']=21.309028625488,['w']=300.0,['h']=250.0},
    {['x']=326.83944702148,['y']=-211.23001098633,['z']=53.591270446777,['w']=300.0,['h']=300.0},
    {['x']=-590.50360107422,['y']=-803.18695068359,['z']=31.204748153687,['w']=255.0,['h']=325.0},
    {['x']=-1263.8226318359,['y']=-1015.3160400391,['z']=7.3518123626709,['w']=155.0,['h']=200.0},
    {['x']=910.39208984375,['y']=-2348.5224609375,['z']=29.11470413208,['w']=290.0,['h']=250.0},
    {['x']=555.26885986328,['y']=102.33749389648,['z']=95.889137268066,['w']=310.0,['h']=310.0},
    {['x']=-1056.0372314453,['y']=-992.09143066406,['z']=1.7085316181183,['w']=250.0,['h']=250.0},
    {['x']=256.38192749023,['y']=-1249.1828613281,['z']=28.870975494385,['w']=300.0,['h']=250.0},
    {['x']=293.59387207031,['y']=45.514373779297,['z']=68.984786987305,['w']=200.0,['h']=200.0},
    {['x']=-1173.0745849609,['y']=-1712.3869628906,['z']=3.4670896530151,['w']=250.0,['h']=250.0},
    {['x']=38.69401550293,['y']=46.922878265381,['z']=69.482566833496,['w']=295.0,['h']=200.0},
    {['x']=3.573616027832,['y']=-1823.6750488281,['z']=20.128913879395,['w']=350.0,['h']=350.0},
    {['x']=962.38635253906,['y']=-2113.7526855469,['z']=29.719253540039,['w']=200.0,['h']=200.0},
}

local temp_blip = nil
local blip_list = {}
local t_bWH = {}
local editMode = false
local colors = {1, 43, 46, 83}
local cindex = 1
local alpha = 200



RegisterCommand('atemp', function(source, args)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local blip = AddBlipForArea(pos.x, pos.y, pos.z, (args[1] or 200.0)+.0, (args[2] or 200.0)+.0)
    t_bWH.w = (args[1] or 200.0)+.0
    t_bWH.h = (args[2] or 200.0)+.0

    SetBlipAlpha(blip, alpha)
    SetBlipColour(blip, colors[cindex])
    SetBlipRotation(blip, 0.0)
    temp_blip = blip

    cindex = cindex + 1
    if cindex > 4 then 
        cindex = 1 
    end
end)

RegisterCommand('rtemp', function(source, args)
    if args[1] then
        RemoveBlip(args[1])
        blip_list[args[1]] = nil
        -- table.remove(blip_list, args[1])
        return
    end

    RemoveBlip(temp_blip)
    temp_blip = nil
    t_bWH.w = nil
    t_bWH.h = nil
end)

RegisterCommand('save', function(source, args)
    local pos = GetBlipCoords(temp_blip)
    local tab = {['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z, ['w'] = t_bWH.w, ['h'] = t_bWH.h}

    blip_list[temp_blip] = tab
    -- table.insert(blip_list, tab)
end)

RegisterCommand('list', function(source, args)
    local msg
    if args[1] then
        msg = ''
        for i, v in pairs(blip_list) do                                                  -- v.h             v.h
            msg = msg .. "{['x']=" .. v.x .. ",['y']=" .. v.y .. ",['z']="..v.z..",['w']="..v.w..",['h']="..v.h.."},\n"
        end
    else
        msg = json.encode(blip_list)
    end
    TriggerServerEvent('fq:print', msg)
end)

RegisterCommand('em', function(source, args)
    editMode = not editMode
    sendMessage('editmode: ' .. (editMode and 'true' or 'false'))
end)

RegisterCommand('load', function(source, args)
    for i, v in ipairs(zone_list) do 
        local pos = v
        local tab = {['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z, ['w'] = pos.w, ['h'] = pos.h}
        local blip = AddBlipForArea(pos.x, pos.y, pos.z, pos.w, pos.h)
        SetBlipAlpha(blip, alpha)
        SetBlipColour(blip, colors[cindex])
        SetBlipRotation(blip, 0.0)
        blip_list[blip] = tab
        
        local blip2 = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip2, 472)
        SetBlipColour(blip2, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(i)
        EndTextCommandSetBlipName(blip2)
        
        cindex = cindex + 1
        if cindex > 4 then 
            cindex = 1 
        end
    end
end)

RegisterCommand('chw', function(source, args)
    -- local arg1 = tonumber(args[1])
    local arg1 = nil
    local blipid = 8
    local blip = GetFirstBlipInfoId(blipid)
    local pos = GetBlipCoords(blip)
    for i, v in pairs(blip_list) do 
        if math.floor(v.x) == math.floor(pos.x) and math.floor(v.y) == math.floor(pos.y) then
            arg1 = i
            print('found')
            break
        end
    end

    if not arg1 then print('not found!') return end

    temp_blip = arg1
    t_bWH.w = blip_list[temp_blip].w
    t_bWH.h = blip_list[temp_blip].h
    blip_list[temp_blip] = nil
end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)
        if editMode then
            -- local pos = GetBlipCoords(temp_blip)
            -- if IsControlPressed(0, 172) then -- up 
            --     SetBlipCoords(temp_blip, pos.x + 1, pos.y, pos.z)
            -- end
            -- if IsControlPressed(0, 173) then -- down 
            --     SetBlipCoords(temp_blip, pos.x - 1, pos.y, pos.z)
            -- end
            if IsControlPressed(0, 174) then -- left 
                local pos = GetBlipCoords(temp_blip)
                RemoveBlip(temp_blip)
                t_bWH.w = t_bWH.w - 5.0 
                local blip = AddBlipForArea(pos.x, pos.y, pos.z, t_bWH.w, t_bWH.h)
                SetBlipAlpha(blip, alpha)
                SetBlipColour(blip, colors[cindex])
                SetBlipRotation(blip, 0.0)
                temp_blip = blip
                -- SetBlipCoords(temp_blip, pos.x, pos.y + 1, pos.z)
            end
            if IsControlPressed(0, 175) then -- right
                local pos = GetBlipCoords(temp_blip)
                RemoveBlip(temp_blip)
                t_bWH.w = t_bWH.w + 5.0 
                local blip = AddBlipForArea(pos.x, pos.y, pos.z, t_bWH.w, t_bWH.h)
                SetBlipAlpha(blip, alpha)
                SetBlipColour(blip, colors[cindex])
                SetBlipRotation(blip, 0.0)
                temp_blip = blip
                -- SetBlipCoords(temp_blip, pos.x, pos.y - 1, pos.z)
            end
        end
    end
end)

function sendMessage(msg)
    TriggerEvent('chat:addMessage', {
        multiline = true,
        args = { msg }
    })
end